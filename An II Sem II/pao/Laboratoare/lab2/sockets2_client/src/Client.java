/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.io.Console;
import java.util.Scanner;

import javax.swing.JOptionPane;

/**
 *
 * @author Cip
 */
public class Client 
{
    // Returning null if message format is incorrect
    public static Message parseMessage(String msgText)
    {
        final String[] tokens = msgText.split(" ");
        Message msg = new Message();
        
        if (tokens[0].compareTo("disconnect") == 0) { msg.mType = Message.MsgType.MSG_DISCONNECT; }
        else if (tokens[0].compareTo("add") == 0 || tokens[0].compareTo("mul") == 0)
        {
            msg.mType = tokens[0].compareTo("add") == 0 ? Message.MsgType.MSG_ADD : Message.MsgType.MSG_MUL;
            
            final int N = Integer.parseInt(tokens[1]);
            msg.mN = N;
            msg.mNumbers = new int[N];
            
            for (int i = 0; i < N; i++)
                msg.mNumbers[i] = Integer.parseInt(tokens[i + 2]);                    
        }
        else if (tokens[0].compareTo("pow") == 0)
        {
            msg.mType = Message.MsgType.MSG_POW;
            msg.mA = Integer.parseInt(tokens[1]);
            msg.mB = Integer.parseInt(tokens[2]);
        }
        
        return msg;
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) 
    {
        try
        {
            String serverAddress = "localhost"; //JOptionPane.showInputDialog("enter IP " + "(running on port 9090");
            Socket clientSocket = new Socket(serverAddress, 9090);
            
            ObjectOutputStream streamToServer = new ObjectOutputStream(clientSocket.getOutputStream());
            ObjectInputStream streamFromServer = new ObjectInputStream(clientSocket.getInputStream());

            Scanner scan = new Scanner(System.in);
            while(true)
            {
                // Read a message from client
                String msgText = scan.nextLine();
                Message msg = parseMessage(msgText);
                
                if (msg.mType == Message.MsgType.MSG_INVALID)
                {
                    System.out.println("Incorrect message format, try again");
                }
                else
                {                   
                    // Writting message to server
                    streamToServer.writeObject(msg);
                    if (msg.mType == Message.MsgType.MSG_DISCONNECT)    // Normally we should wait for disconnect confirm for server but this is fine too.
                        break;
                    
                    // Waiting for his answer
                    // NOTICE that we can't get any request from client console before we receive the answer :(
                    // In the next app we'll use threads to fix this !
                    
                    TaskResult result = (TaskResult) streamFromServer.readObject();
                    System.out.println("Result is " + result.mResult);
                }
            }
            
                       
            //JOptionPane.showMessageDialog(null, answer);
        }
        catch (Exception e)
        {
            System.out.println(e.getMessage());
        }
    }    
}
