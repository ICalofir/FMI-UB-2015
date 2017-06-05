import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.net.ServerSocket;
import java.io.PrintWriter;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import javax.swing.JOptionPane;

/**
 *
 * @author Cip
 */
public class Server 
{

    /**
     * @param args the command line arguments
     */
    
    public static void ProcessClientSocket(Socket clientSocket)
    {
        try 
        {
            ObjectOutputStream streamToClient = new ObjectOutputStream(clientSocket.getOutputStream());
            ObjectInputStream streamFromClient = new ObjectInputStream(clientSocket.getInputStream()); 
            
            boolean stillConnected = true;
            while(stillConnected)
            {                
                Message msg = (Message) streamFromClient.readObject();
                TaskResult res = new TaskResult();
                switch(msg.mType)
                {
                    case MSG_DISCONNECT:
                    {
                        System.out.println("client got disconnected..");                        
                        stillConnected = false;
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
                    streamToClient.writeObject(res);
            }            
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }               
    }
    
    public static void main(String[] args) 
    {
        try 
        {
            ServerSocket listener = new ServerSocket(9090);
            while(true)
            {
                Socket socket = listener.accept();
                
                // TODO: notice that we can support only one client at a time...in the next app we'll use threads to solve this
                ProcessClientSocket(socket);
                socket.close();
            }           
        }
        catch(Exception e)
        {
            System.out.print(e.getMessage());      
        }
    }    
}
