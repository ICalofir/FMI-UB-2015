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
import service.*;

public class Generator extends UnicastRemoteObject implements IGenerator
{
    Generator() throws RemoteException
    {
        super();
    }  
	
	public MathOp getMyServer() throws RemoteException 
	{
		return new MathOp_Concrete(m_serverCount++);
	}
	
	int m_serverCount = 0;
}
