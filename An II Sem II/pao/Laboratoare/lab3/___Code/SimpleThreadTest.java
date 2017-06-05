/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package SimpleThreadTest;

import java.lang.Thread;
import java.lang.Runnable;

class MyObject implements Runnable
{
    MyObject(int myID) { mID = myID; }
    
    public void run ()  // This will be executed when thread starts
    {
        System.out.println("Running thread " + mID);
    }
    
    private int mID;
}

class Consumer extends Thread
{
    Consumer(int consumerID) { mID = consumerID; }
    
    public void run()
    {
        System.out.println("Consumer " + mID);
    }
    
    private int mID;
}

/**
 *
 * @author Cip
 */
public class SimpleThreadTest 
{
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) 
    {
        final int numThreads = 10;
        Thread[] runnableThreads = new Thread[numThreads];
        for (int i = 0; i < numThreads; i++)
        {
            runnableThreads[i] = new Thread(new MyObject(i));
            runnableThreads[i].setPriority(numThreads-i); // Optional! try inverse of this
            runnableThreads[i].start();
        }
        
        for (int i = 0 ; i < numThreads; i++)
        {
            // Uncomment this if you want to interrupt a thread when executing: runnableThreads[i].interrupt();;
            try 
            {
                runnableThreads[i].join();
            }
            catch(Exception e) { System.out.println(e.getMessage()); }
        }
        
        ////////////////////
        Consumer consumer1 = new Consumer(1);
        consumer1.start();
        
        Consumer consumer2 = new Consumer(2);
        consumer2.start();
        
        try 
        {
            consumer1.join();
            consumer2.join();
        }
        catch(Exception e) { System.out.println(e.getMessage()); }
    }
}
