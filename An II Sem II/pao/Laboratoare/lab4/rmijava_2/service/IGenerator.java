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
public interface IGenerator extends Remote
{
    public MathOp getMyServer() throws RemoteException;
}
