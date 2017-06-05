/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package barriermerge;

import java.util.Random;
import java.util.concurrent.CyclicBarrier;

class ThreadMinValues extends Thread
{
    public int publishedIndex, publishedValue;
            
    public ThreadMinValues(int numItems, CyclicBarrier sharedBarrier)
    {
        mSharedBarrier = sharedBarrier;
        
        // randomize numItems
        Random rand = new Random();
        mValues = new int[numItems];
        for (int i = 0; i < numItems; i++)
            mValues[i] = rand.nextInt();
    }
    
    public void run()
    {
        while(true)
        {
            publishedIndex = 0;
            publishedValue = mValues[0];
            
            // Find min/max
            for (int i = 1; i < mValues.length; i++)
                if (mValues[i] > publishedValue)
                {
                    publishedValue = mValues[i];
                    publishedIndex = i;
                }
            
            // Barrier - both should publish values before moving
            try { mSharedBarrier.await(); } catch(Exception e) {}

            //System.out.println("Min published value: " + publishedValue);
            
            // Check the published values
            if (publishedValue <= mOtherThread.publishedValue)
                break;
            
            mValues[publishedIndex] = mOtherThread.publishedValue;
                       
            // Barrier - both should wait for the other one to complete switching value
            try { mSharedBarrier.await(); } catch(Exception e) {}
        }
    }
    
    public int[] mValues;
    public ThreadMaxValues mOtherThread;
    private CyclicBarrier mSharedBarrier;
}

class ThreadMaxValues extends Thread
{
    public int publishedIndex, publishedValue;
            
    public ThreadMaxValues(int numItems, CyclicBarrier sharedBarrier)
    {
        mSharedBarrier = sharedBarrier;
        
        // randomize numItems
        Random rand = new Random();
        mValues = new int[numItems];
        for (int i = 0; i < numItems; i++)
            mValues[i] = rand.nextInt();
    }
    
    public void run()
    {
        while(true)
        {
            publishedIndex = 0;
            publishedValue = mValues[0];
            
            // Find min/max
            for (int i = 1; i < mValues.length; i++)
                if (mValues[i] < publishedValue)
                {
                    publishedValue = mValues[i];
                    publishedIndex = i;
                }
            
            // Barrier - both should publish values before moving
            try { mSharedBarrier.await(); } catch(Exception e) {}
            
           // System.out.println("Max published value: " + publishedValue);
                        
            // Check the published values
            if (publishedValue >= mOtherThread.publishedValue)
                break;
            
            mValues[publishedIndex] = mOtherThread.publishedValue;
                       
            // Barrier - both should wait for the other one to complete switching value
            try { mSharedBarrier.await(); } catch(Exception e) {}
        }
    }
    
    public int[] mValues;    
    public ThreadMinValues mOtherThread;    
    private CyclicBarrier mSharedBarrier;
}

/**
 *
 * @author Cip
 */
public class BarrierMerge 
{

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args)  throws InterruptedException
    {
        // Setup threads and barriers
        CyclicBarrier barrier = new CyclicBarrier(2);
        ThreadMinValues minValues = new ThreadMinValues(10, barrier);
        ThreadMaxValues maxValues = new ThreadMaxValues(10, barrier);        
        minValues.mOtherThread = maxValues;
        maxValues.mOtherThread = minValues;
        
        // Print input
        System.out.println("====== INPUT ======");
        System.out.println("Numbers from min thread");
        for (int i = 0; i < minValues.mValues.length; i++)
            System.out.print(minValues.mValues[i] + " ");
        
        System.out.println("\nNumbers from max thread");
        for (int i = 0; i < maxValues.mValues.length; i++)
            System.out.print(maxValues.mValues[i] + " ");
        System.out.println("\n\n\n");

        
        // Run threads
        minValues.start();
        maxValues.start();
        minValues.join();
        maxValues.join();
        
        // Check output
        System.out.println("====== OUTPUT ======");
        System.out.println("Numbers from min thread");
        for (int i = 0; i < minValues.mValues.length; i++)
            System.out.print(minValues.mValues[i] + " ");
        
        System.out.println("\nNumbers from max thread");
        for (int i = 0; i < maxValues.mValues.length; i++)
            System.out.print(maxValues.mValues[i] + " ");
        System.out.println("\n");
    }    
}
