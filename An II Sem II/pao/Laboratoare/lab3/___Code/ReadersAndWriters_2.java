/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package readersandwriters_2;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.util.concurrent.*;
/**
 *
 * @author Cip
 */

class Database
{
    enum OpType
    {
        WRITE,
        READ,
    };
    
    static Semaphore mGlobalSem = new Semaphore(1, true);
    static Semaphore mWritersSem = new Semaphore(1, true);
    static int mNumWriters = 0;
    
    static void simulateDelay(int maxTime) throws InterruptedException { Thread.sleep((int)(maxTime * Math.random())); }
    
    static void open(OpType op) throws InterruptedException
    {
        if (op == OpType.WRITE)
        {
            mWritersSem.acquire();
            if (mNumWriters == 0)
                mGlobalSem.acquire();
            mNumWriters++;
            mWritersSem.release();
        }
        else     
            mGlobalSem.acquire();
    }
    
    static void close(OpType op) throws InterruptedException
    {
        if (op == OpType.WRITE)
        {
            mWritersSem.acquire();
            mNumWriters--;
            if (mNumWriters == 0)
                mGlobalSem.release();
            mWritersSem.release();            
        }
        else      
            mGlobalSem.release();      
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

public class ReadersAndWriters_2
{
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws InterruptedException
    {
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
    }    
}
