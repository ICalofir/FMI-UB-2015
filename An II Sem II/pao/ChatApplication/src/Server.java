import java.io.*;
import java.net.*;
import java.util.*;

public class Server {
	private static class ConnectionData {
		private Socket socket;
		private String username;
		private Scanner input;
		private PrintWriter output;
		private String message;
		private Communication communication;
		private Connection chattingUser;
		
		public Socket getSocket() {
			return this.socket;
		}
		
		public String getUsername() {
			return this.username;
		}
		
		public Scanner getInput() {
			return this.input;
		}
		
		public PrintWriter getOutput() {
			return this.output;
		}
		
		public String getMessage() {
			return this.message;
		}
		
		public Communication getCommunication() {
			return this.communication;
		}
		
		public Connection getChattingUser() {
			return this.chattingUser;
		}
		
		public void setChattingUser(Connection chattingUser) {
			this.chattingUser = chattingUser;
		}
		
		public void setMessage(String message) {
			this.message = message;
		}
		
		public void setUsername(String username) {
			this.username = username;
		}
		
		public void sendMessage(PrintWriter output, String message) {
			this.communication.sendMessage(output, message);
		}
		
		ConnectionData(Socket socket) throws Exception {
			this.socket = socket;
			this.input = new Scanner(this.socket.getInputStream());
			this.output = new PrintWriter(this.socket.getOutputStream());
			this.username = null;
			this.communication = Communication.getInstance();
		}
	}
	
	private static class Connection implements Runnable {
		private ConnectionData connectionData;
		
		public Connection(Socket socket) throws Exception {
			this.connectionData = new ConnectionData(socket);
		}
		
		private void addUser() throws Exception {
			while (true) {
				String tempUsername = this.connectionData.getInput().nextLine();
				
				Boolean ok = true;
				for (Connection con : Server.connections) {
					if (con.connectionData.getUsername() != null && con.connectionData.getUsername().equals(tempUsername)) {
						ok = false;
						break;
					}
				}
				
				if (ok == true) {
					this.connectionData.setMessage(this.connectionData.getCommunication().encodeJSON(Communication.CommunicationType.SUCCESS.name(), null));
					this.connectionData.sendMessage(this.connectionData.getOutput(), this.connectionData.getMessage());
					this.connectionData.setUsername(tempUsername);
					break;
				} else {
					this.connectionData.setMessage(this.connectionData.getCommunication().encodeJSON(Communication.CommunicationType.FAIL.name(), null));
					this.connectionData.sendMessage(this.connectionData.getOutput(), this.connectionData.getMessage());
				}
			}
		}
		
		public void run() {
			try {
				this.addUser();
				
				System.out.println("Client connected from: " + this.connectionData.getSocket().getLocalAddress().getHostName() + ".");
				
				while (true) {
					if (!this.connectionData.getInput().hasNextLine()) { // client has disconnected
						for (Connection conn : Server.connections) {
							if (conn.connectionData.getChattingUser() != null && conn.connectionData.getChattingUser().connectionData.getUsername().equals(this.connectionData.getUsername())) {
								conn.connectionData.setChattingUser(null);
								PrintWriter tempOutput = new PrintWriter(conn.connectionData.getSocket().getOutputStream());
								this.connectionData.sendMessage(tempOutput, this.connectionData.getUsername() + " has disconnected.");
								break;
							}
						}
						
						Boolean connected = false;
						for (Connection conn : Server.connections) {
							if (conn.connectionData.getUsername().equals(this.connectionData.getUsername())) {
								connected = true;
							}
						}
						
						if (connected) {
							System.out.println("Client disconnected from: " + this.connectionData.getSocket().getLocalAddress().getHostName() + ".");
							this.connectionData.getSocket().close();
							Server.connections.remove(this);
						}
			
						break;
					}
					
					this.connectionData.setMessage(this.connectionData.getInput().nextLine());
					this.connectionData.getCommunication().decodeJSON(this.connectionData.getMessage());
					
					if (this.connectionData.getCommunication().Type.equals(Communication.CommunicationType.WHISPER_USER.name())) {
						Boolean found = false;
						for (Connection con : Server.connections) {
							if (!con.connectionData.getUsername().equals(this.connectionData.getUsername()) && con.connectionData.getUsername().equals(this.connectionData.getCommunication().Content)) {
								found = true;
								this.connectionData.setChattingUser(con);
								this.connectionData.sendMessage(this.connectionData.getOutput(), "You are now connected with " + con.connectionData.getUsername());
								break;
							}
						}
						if (!found) {
							this.connectionData.sendMessage(this.connectionData.getOutput(), "User " + this.connectionData.getCommunication().Content + " not found.");
						}
					} else if (this.connectionData.getCommunication().Type.equals(Communication.CommunicationType.ANNOUNCEMENT.name())) {
						for (Connection conn : Server.connections) {
							if (conn.connectionData.getUsername().equals(this.connectionData.getUsername())) {
								continue;
							}
							PrintWriter tempOutput = new PrintWriter(conn.connectionData.getSocket().getOutputStream());
							this.connectionData.sendMessage(tempOutput, this.connectionData.getUsername() + ": " + this.connectionData.getCommunication().Content);
						}
					} else if (this.connectionData.getCommunication().Type.equals(Communication.CommunicationType.SHOW_CONNECTED_USERS.name())) {
						for (Connection conn : Server.connections) {
							this.connectionData.sendMessage(this.connectionData.getOutput(), conn.connectionData.getUsername());
						}
					} else if (this.connectionData.getCommunication().Type.equals(Communication.CommunicationType.MAIN_MENU.name())) {
						this.connectionData.setChattingUser(null);
						this.connectionData.sendMessage(this.connectionData.getOutput(), "You are now to main menu.");
					} else if (this.connectionData.getCommunication().Type.equals(Communication.CommunicationType.TEXT.name())) {
						if (this.connectionData.getChattingUser() != null) {
							PrintWriter tempOutput = new PrintWriter(this.connectionData.getChattingUser().connectionData.getSocket().getOutputStream());
							this.connectionData.sendMessage(tempOutput, this.connectionData.getUsername() + ": " + this.connectionData.getCommunication().Content);
						} else {
							this.connectionData.sendMessage(this.connectionData.getOutput(), "Invalid option!");
						}
					} else if (this.connectionData.getCommunication().Type.equals(Communication.CommunicationType.EXIT.name())) {
						for (Connection conn : Server.connections) {
							if (conn.connectionData.getChattingUser() != null && conn.connectionData.getChattingUser().connectionData.getUsername().equals(this.connectionData.getUsername())) {
								conn.connectionData.setChattingUser(null);
								PrintWriter tempOutput = new PrintWriter(conn.connectionData.getSocket().getOutputStream());
								this.connectionData.sendMessage(tempOutput, this.connectionData.getUsername() + " has disconnected.");
								break;
							}
						}
						
						System.out.println("Client disconnected from: " + this.connectionData.getSocket().getLocalAddress().getHostName() + ".");
						this.connectionData.getSocket().close();
						Server.connections.remove(this);
					}
				}
				
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
	}
	
	private static ServerSocket serverSocket;
	private static Socket socket;
	private static ArrayList<Connection> connections = new ArrayList<Connection>();
	public static void main(String[] args) throws Exception {
		try {
			serverSocket = new ServerSocket(8000);
			System.out.println("Server started.");
			
			while(true) {
				socket = serverSocket.accept();
				Connection connection = new Connection(socket);
				connections.add(connection);
				
				Thread thread = new Thread(connection);
				thread.start();
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}
}
