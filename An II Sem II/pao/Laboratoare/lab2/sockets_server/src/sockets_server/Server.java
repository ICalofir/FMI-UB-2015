/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sockets_server;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.net.ServerSocket;
import java.io.PrintWriter;

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
    public static void main(String[] args) 
    {
        try 
        {
            ServerSocket listener = new ServerSocket(9090);
            while(true)
            {
                Socket socket = listener.accept();
                
                PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
                out.println(("Message received from server"));
                
                socket.close();
            }           
        }
        catch(Exception e)
        {
            System.out.print(e.getMessage());      
        }
    }    
}
