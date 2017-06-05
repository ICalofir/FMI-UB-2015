/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package service;
import java.rmi.*;
/**
 *
 * @author CPaduraru
 */
public interface MathOp extends Remote
{
    public int add(int a, int b) throws RemoteException;
    public void terminate() throws RemoteException;    
}
