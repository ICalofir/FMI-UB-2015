/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package barrierimpl;

import java.util.Random;

class Barrier
{
    public Barrier(int numThreads) { mNumThreads = numThreads; }
    
    public synchronized int await() throws InterruptedException
    {
        int indexInBarrier = mNumInBarrier;
        mNumInBarrier++;
        
        // All are here, wake them all
        if (mNumInBarrier == mNumThreads)
            notifyAll();
        else 
            wait();
        
        return indexInBarrier;
    }
    
    int mNumInBarrier;
    int mNumThreads;
}

class Defines
{
    static int mNumWorkers = -1;
}

class Worker extends Thread
{
    int mId;
    static Barrier barrier = new Barrier(Defines.mNumWorkers);
    
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

/**
 *
 * @author Cip
 */
public class BarrierImpl 
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
