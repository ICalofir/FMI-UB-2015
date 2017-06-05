/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rmi_sockets_server;
import java.net.Socket;
import java.net.ServerSocket;
import java.io.*;

class MathOp_Server implements MathOp
{
    public int add(int a, int b)
    {
        return (a + b);        
    }
    
    public void terminate() {}
}

/**
 *
 * @author CPaduraru
 */
public class RMI_Sockets_Server 
{
    static final int PORT = 1100;
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) 
    {      
        try{
            ServerSocket serverSocket = new ServerSocket(PORT);
            Socket clientSocket = serverSocket.accept();

            DataInputStream inputStream = new DataInputStream(clientSocket.getInputStream());
            OutputStream outputStream = clientSocket.getOutputStream();
            MathOp_Server serverOb = new MathOp_Server();
            do
            {
                String method = inputStream.readUTF();
                if (method.equals("add"))
                {
                    final int paramA = inputStream.readInt();
                    final int paramB = inputStream.readInt();
                    final int result = serverOb.add(paramA, paramB);
                    outputStream.write(result);
                }
                else if (method.equals("terminate"))
                {
                    break;
                }
            }while(true);        
            
            inputStream.close();
            outputStream.close();
            clientSocket.close();
            serverSocket.close();
        }
        catch(Exception e) { System.out.println(e.getMessage()); }         
        
    }
    
}
