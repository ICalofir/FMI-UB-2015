/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package readersandwriters_4;

import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.Semaphore;
import java.util.concurrent.locks.*;

class WaitingEntity    
{
    Database.OpType mType;
    Semaphore mSemaphore;
        
    public WaitingEntity(Database.OpType type)
    {
        mType = type;
        mSemaphore = new Semaphore(0); // Start with this empty 
    }
    //int mId; // Id of the thread requestign access
}

class Database extends Thread
{
    enum OpType
    {
        WRITE,
        READ,
    };
          
    static int mNumWriters = 0;
    static int mNumReaders = 0;    
    static Lock mInternalLock = new ReentrantLock(true);    // could use an already implemented concurrent to avoid this syncronization
    static LinkedList<WaitingEntity> mWaitingQueue = new LinkedList<WaitingEntity>();
    boolean mTerminationSignaled = false;
    
    static Condition noWritersCondition = mInternalLock.newCondition();
    static Condition noReadersAndWritersCondition = mInternalLock.newCondition();
    
    static void simulateDelay(int maxTime) throws InterruptedException { Thread.sleep((int)(maxTime * Math.random())); }
    
    static void open(OpType op) throws InterruptedException
    {
        WaitingEntity waitingEntity = new WaitingEntity(op);
        
        mInternalLock.lock();
        mWaitingQueue.add(waitingEntity);
        mInternalLock.unlock();        
        
        // Block here until DB will give us access
        waitingEntity.mSemaphore.acquire();
    }
    
    static void close(OpType op) throws InterruptedException
    {
        mInternalLock.lock();
        if (op == OpType.READ)
            mNumReaders--;
        else
            mNumWriters--;

         if (mNumWriters == 0 && mNumReaders == 0)
             noReadersAndWritersCondition.signal();
         if (mNumWriters == 0)
             noWritersCondition.signal();
        
        mInternalLock.unlock();
    }       
    
    public void run()
    {
        while(true)
        {
            if (mTerminationSignaled) // A way to terminate a thread..
                break;
            
            Database.mInternalLock.lock();
            
            if (Database.mWaitingQueue.isEmpty())
            {                
                Database.mInternalLock.unlock();
                try { Thread.sleep(1);}catch(Exception e) {}  
                continue;
            }
            
            WaitingEntity waitingEntity = Database.mWaitingQueue.peekFirst();
            
            if (waitingEntity.mType == OpType.READ) 
            {
                // We must have 0 writers to execute this
                
                while(mNumWriters > 0) // while, just to be safe :)
                {
                    try{ noWritersCondition.await(); } catch(Exception e) {}                
                }
                
                waitingEntity = Database.mWaitingQueue.removeFirst();
                mNumReaders++;
                waitingEntity.mSemaphore.release(); // Let him run now
            }
            else if (waitingEntity.mType == OpType.WRITE)
            {
                // We must have 0 writers and 0 readers to execute this
                while (mNumWriters > 0 || mNumReaders > 0)
                {
                    try{ noReadersAndWritersCondition.await(); } catch(Exception e) {}                                    
                }
                                
                waitingEntity = Database.mWaitingQueue.removeFirst();
                mNumWriters++;
                waitingEntity.mSemaphore.release(); // Let him run now
            }
            
            Database.mInternalLock.unlock();            
        }
    }
    
    public void terminateDB()
    {
        mTerminationSignaled = true;
    }
}

class Reader extends Thread
{
    int mId;    
    public Reader(int id) { mId = id; }
    public void run()
    {
        try
        {
            for (int k = 0; k < 5; k++)
            {
                Database.simulateDelay(100);
                
                System.out.println("READER " + mId + " is trying to open ");
                Database.open(Database.OpType.READ);
                // Simulate work..
                System.out.println("READER " + mId + " is reading...");
                Database.simulateDelay(200);
                System.out.println("READER " + mId + " finished");
                Database.close(Database.OpType.READ);
            }
        }
        catch (Exception e) {}
    }
}

class Writer extends Thread
{
    int mId;    
    public Writer(int id) { mId = id; }
    public void run()
    {
        try
        {
            for (int k = 0; k < 5; k++)
            {
                Database.simulateDelay(20);
                
                System.out.println("WRITER " + mId + " is trying to open ");
                Database.open(Database.OpType.WRITE);
                // Simulate work..
                System.out.println("WRITER " + mId + " is writing..");
                Database.simulateDelay(200);
                System.out.println("WRITER " + mId + " finished writing");
                Database.close(Database.OpType.WRITE);
            }
        }
        catch (Exception e) {}
    }
}
/**
 *
 * @author Cip
 */
public class ReadersAndWriters_4 
{
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws InterruptedException
    {
        // Simulate DB as a running thread...
        Database db = new Database();
        db.start();
        
        final int numReaders = 5;
        final int numWriters = 3;
        Reader[] readers = new Reader[numReaders];
        Writer[] writers = new Writer[numWriters];
        
        for (int i = 0; i < numReaders; i++) readers[i] = new Reader(i);
        for (int i = 0; i < numWriters; i++) writers[i] = new Writer(i);
        for (int i = 0; i < numReaders; i++) readers[i].start();
        for (int i = 0; i < numWriters; i++) writers[i].start();
        
        for (int i = 0; i < numReaders; i++) readers[i].join();
        for (int i = 0; i < numWriters; i++) writers[i].join();
        
        db.terminateDB();
        db.interrupt();
    }    
}
