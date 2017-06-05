/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rmi_test_server;

/**
 *
 * @author Cip
 */

import java.rmi.*; 
import java.rmi.server.*;

public class MathOp_Concrete extends UnicastRemoteObject implements service.MathOp
{
    MathOp_Concrete(int ID) throws RemoteException
    {
        super();
		
		m_ID = ID;
    }  
    
    public int add(int a, int b) { return a + b;}
    public void terminate() 
	{ 
		System.out.println("Client " + m_ID + " will disconnect");
	}
	
	int m_ID;	// Needed just for debug ! Check terminate function
}
