/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rmi_test_server;
import java.rmi.*;
import java.rmi.registry.*;
import java.util.*;
/**
 *
 * @author Cip
 */
public class RMI_1_Server 
{
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws Exception
    {
        System.setProperty("java.rmi.server.useCodebaseOnly", "false");
        
        // TODO code application logic here
        final int port = 63000;      
        Generator ob = new Generator();
        Registry reg = LocateRegistry.createRegistry(port);
        reg.rebind("MathService", ob);
        System.out.println("Server is bound..");
    }    
}
