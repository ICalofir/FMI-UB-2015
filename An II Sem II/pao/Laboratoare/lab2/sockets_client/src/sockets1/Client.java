/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sockets1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;

import javax.swing.JOptionPane;

/**
 *
 * @author Cip
 */
public class Client 
{

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) 
    {
        try
        {
            String serverAddress = JOptionPane.showInputDialog("enter IP " + "(running on port 9090");
            Socket s = new Socket(serverAddress, 9090);
            BufferedReader input = new BufferedReader(new InputStreamReader(s.getInputStream()));
            String answer = input.readLine();
            JOptionPane.showMessageDialog(null, answer);
        }
        catch (Exception e)
        {
            System.out.println(e.getMessage());
        }
    }
    
}
