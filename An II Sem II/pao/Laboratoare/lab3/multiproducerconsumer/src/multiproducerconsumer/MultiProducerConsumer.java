/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package multiproducerconsumer;

import java.util.concurrent.locks.*;

/**
 *
 * @author Cip
 */
    class MySharedQueue 
    {
        final Lock mLock = new ReentrantLock();
        final Condition mCondFull = mLock.newCondition();
        final Condition mCondEmpty = mLock.newCondition();

        static final int g_queueMaxLength = 10;
        int mQueueIdx = 0;  // next index to fill data in
        int mQueueNum = 0;
        final Integer[] mQueue = new Integer[g_queueMaxLength];

        public void add(int threadId /*used for debug purposes*/, Integer I) throws InterruptedException
        {           
            mLock.lock();
            
            try
            {
                // Is queue full ? wait for signal
                while (mQueueNum  == g_queueMaxLength)
                {
                    System.out.println("ThreadId " + threadId + " is waiting on add");
                    mCondFull.await();

                    //mLock.lock();
                }

                System.out.println("ThreadId " + threadId + " is adding " +  I.intValue());
                                
                mQueue[mQueueIdx++] = I;
                mQueueNum++;
                if (mQueueIdx == g_queueMaxLength) 
                    mQueueIdx = 0;

                mCondEmpty.signal();
            }
            finally 
            {  
                mLock.unlock(); 
            }
        }
        
        public Integer take(int threadId) throws InterruptedException
        {
            mLock.lock();
            try
            {
                while(mQueueNum == 0)
                {
                  System.out.println("ThreadId " + threadId + " is waiting on take");
                  mCondEmpty.await();                    
                }
                
                // mLock.unlock();
                final Integer I = mQueue[mQueueIdx++];
                System.out.println("ThreadId " + threadId + " is taking " +  I.intValue());
                                
                if (mQueueIdx == g_queueMaxLength)               
                    mQueueIdx = 0;
                
                mQueueNum--;
                mCondFull.signal();
                return I;
            }
            finally { mLock.unlock();}            
        }
    }

class Producer extends Thread
{
    int mId;
    MySharedQueue mQueue;
    
    Producer(int id, MySharedQueue q) { mId = id; mQueue = q; }
    
    public void run()
    {
        final int start = mId * 10;
        final int end = start + 10;
        try
        {
            for (int i = start; i < end; i++)
                mQueue.add(mId, i);
        }
        catch(InterruptedException e) {}
    }    
}

class Consumer extends Thread
{
    int mId;
    MySharedQueue mQueue;
    
    Consumer(int id, MySharedQueue q) { mId = id; mQueue = q; }

    public void run()
    {
        try
        {
            for (int i = 0; i < 10; i++)
                mQueue.take(mId);
        }
        catch(InterruptedException e) {}
    }
}

public class MultiProducerConsumer 
{
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) 
    {
        // TODO code application logic here
        MySharedQueue sharedQueue = new MySharedQueue();
        final int numProducers = 3;
        final int numConsumers = 3;
        Producer[] P = new Producer[numProducers];
        Consumer[] C = new Consumer[numConsumers];

        for (int i = 0; i < numProducers; i++) {
            P[i] = new Producer(i, sharedQueue);
            P[i].start();
        }

        for (int i = 0; i < numConsumers; i++) {
            C[i] = new Consumer(i, sharedQueue);
            C[i].start();
        }
    }

}
