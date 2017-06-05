import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.net.ServerSocket;
import java.io.PrintWriter;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import javax.swing.JOptionPane;
import java.util.ArrayList;
import java.util.Scanner;
/**
 *
 * @author Cip
 */
 // This class keeps the connection logic between server and client
class ClientHandler extends Thread
{
    private Socket              mClientSocket;
    
    public ObjectInputStream    mStreamFromClient;
    public ObjectOutputStream   mStreamToClient;        
    public String               mIPAddress;


    public ClientHandler(Socket socket)
    {
        mClientSocket   = socket;

        try
        {
            mStreamFromClient   = new ObjectInputStream(mClientSocket.getInputStream());
            mStreamToClient     = new ObjectOutputStream(mClientSocket.getOutputStream()); 
            mStreamToClient.flush(); // Good to call this 
            
            mIPAddress          = socket.getInetAddress().getHostAddress();
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }                
    }
        
    public void run()
    {
        try 
        {
            boolean stillConnected = true;
            while(stillConnected)
            {                
                Message msg = (Message) mStreamFromClient.readObject();
                TaskResult res = new TaskResult();
                switch(msg.mType)
                {
                    case MSG_DISCONNECT:
                    {
                        System.out.println("client got disconnected..");                        
                        stillConnected = false;
                        mClientSocket.close();
                        
                        Server.removeClient(this);
                    }
                    break;
                    case MSG_ADD:
                    {                                               
                        System.out.println("client requested add, sending result back..");
                        
                        res.mResult = 0;
                        for (int i = 0; i < msg.mN; i++)
                            res.mResult += msg.mNumbers[i];                                                
                    }
                    break;
                    case MSG_MUL:
                    {
                        System.out.println("client requested mul, sending result back..");
                        
                        res.mResult = 1;
                        for (int i = 0; i < msg.mN; i++)
                            res.mResult *= msg.mNumbers[i];
                    }
                    break;
                    case MSG_POW:
                    {
                        System.out.println("client requested pow, sending result back..");
                                
                        res.mResult = (int)Math.pow((double)msg.mA, (double)msg.mB);
                    }
                    break;
                }                      
                
                if (msg.mType != Message.MsgType.MSG_DISCONNECT)
                    mStreamToClient.writeObject(res);
            }            
            
        }
        catch(Exception e) { System.out.println(e.getMessage()); }
    }    
}

class ServerConsole extends Thread
{
    public void run()
    {
        Scanner scan = new Scanner(System.in);
        
        while(true)
        {
            String commandStr = scan.nextLine();
            if (commandStr.compareTo("showClients") == 0)
            {
                System.out.println("Num clients connected = " + Server.mClientsList.size());
                for (ClientHandler ch : Server.mClientsList)
                {
                    System.out.print(ch.mIPAddress + " ");
                }
            }
        }
    }
}

public class Server 
{
    /**
     * @param args the command line arguments
     */      
    public static ServerSocket              mServerSocket;
    public static ArrayList<ClientHandler>  mClientsList;
            
    public static void main(String[] args) 
    {
        try 
        {
            mServerSocket   = new ServerSocket(9090);
            mClientsList    = new ArrayList<ClientHandler>();
            
            ServerConsole sc = new ServerConsole();
            sc.start();
            
            while(true)
            {
                Socket socket = mServerSocket.accept();
                ClientHandler ch = new ClientHandler(socket);
                addClient(ch);
                ch.start();
                
            }           
        }
        catch(Exception e)
        {
            System.out.print(e.getMessage());      
        }
    }    
    
    // Basic sync. One other way is to have an active object
    public synchronized static void removeClient(ClientHandler ch) 
    {
        mClientsList.remove(ch);
    }
    
    public synchronized static void addClient(ClientHandler ch)
    {
        mClientsList.add(ch);
    }
}
