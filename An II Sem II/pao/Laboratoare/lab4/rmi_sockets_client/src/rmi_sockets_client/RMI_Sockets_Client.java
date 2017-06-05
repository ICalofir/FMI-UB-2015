/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rmi_sockets_client;
import java.net.Socket;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.util.*;
import java.io.*;

/**
 *
 * @author CPaduraru
 */
class MathOp_client implements MathOp
{
    Socket m_socket;
    DataOutputStream m_output;
    InputStream m_input;
    
    static final int PORT = 1100;
    static final String IP = "localhost";
    
    MathOp_client() throws IOException
    {
        m_socket = new Socket(IP, PORT);
        m_output= new DataOutputStream(m_socket.getOutputStream());
        m_input = m_socket.getInputStream();
    }
    
    public int add(int a, int b)
    {
        try{
            m_output.writeUTF("add");
            m_output.writeInt(a);
            m_output.writeInt(b);
            int result = m_input.read();
            return result;
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
            return -1;
        }
    }
    
    public void terminate()
    {
        try{
            m_output.writeUTF("terminate");
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
    }
}

public class RMI_Sockets_Client 
{

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) 
    {
        // TODO code application logic here
        
        try{
            MathOp_client ob = new MathOp_client();
            Scanner sc = new Scanner(System.in);

            for (;;)
            {
                //to do:
                String request = sc.next();
                if (request.equals("terminate"))
                {
                    ob.terminate();
                    break;
                }
                else
                {
                    int result = ob.add(sc.nextInt(), sc.nextInt());
                    System.out.println("Result is " + result);
                }
               
                break;
            }
        }
        catch(Exception e) { System.out.println(e.getMessage());}
    }
    
}
