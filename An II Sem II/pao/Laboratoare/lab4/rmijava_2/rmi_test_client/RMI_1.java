/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rmi_test_client;
import java.rmi.*;
import java.util.*;
import java.net.*;
import java.rmi.registry.*;
import service.*;
/**
 *
 * @author Cip
 */
public class RMI_1 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws Exception
    {
        Scanner sc = new Scanner(System.in);
        final String IP = "localhost"; //sc.next();
        final int port = 63000;
		Registry registry = LocateRegistry.getRegistry(IP, port);
        IGenerator srv = (IGenerator) registry.lookup("MathService");
		MathOp op = srv.getMyServer();
        
        for (;;)
        {
            //to do:
            String request = sc.next();
            if (request.equals("terminate"))
            {
                try { op.terminate();}
                catch(Exception e) { System.out.println(e.getMessage()); }
                break;
            }
            else
            {
                try {int result = op.add(sc.nextInt(), sc.nextInt());
                     System.out.println("Result is " + result); }
                catch(Exception e) { System.out.println(e.getMessage()); }
            }
        }
    }
    
}
