/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package barrierexample;
import java.util.concurrent.*;
import java.util.Random;
/**
 *
 * @author Cip
 */

class Defines
{
    static int mNumWorkers = -1;
}

class Worker extends Thread
{
    int mId;
    static CyclicBarrier barrier = new CyclicBarrier(Defines.mNumWorkers);
    
    Worker(int id) { mId = id; }
    public void run()
    {
        try
        {
            // Simulate a random number of operations
            Random r =  new Random();
            final int numJobs = r.nextInt(5) + 1;
            for (int i = 0 ; i < numJobs; i++)
            {
                System.out.println("Worker " + mId + " running task " + i);
                Thread.sleep((int)(Math.random() * 100));
            }
            
            System.out.println("Worker " + mId + " waiting for barrier");
            // Wait for all Workers to get here
            final int index = barrier.await();
            
            System.out.println("Worker " + mId + " entered " + index + "th in barrier");
            System.out.println("Worker " + mId + " is now finishing work after barrier..");            
        }
        catch(Exception e) {}
    }
}

public class BarrierExample 
{            
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)  throws InterruptedException
    {
        // TODO code application logic here
        Defines.mNumWorkers = 5;
        Worker[] workers = new Worker[Defines.mNumWorkers];
        for (int i = 0; i < Defines.mNumWorkers; i++)
        {
            workers[i] = new Worker(i);
            workers[i].start();
        }
        
        for (int i = 0; i < Defines.mNumWorkers; i++)
            workers[i].join();
    }    
}
