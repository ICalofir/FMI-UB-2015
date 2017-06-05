/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package racestuff;

class Counter
{
    private int mValue;
    
    Counter() { mValue = 0; }
    
    public synchronized void Increase() { mValue++; }
    public synchronized void Decrease() { mValue--; }   
    public synchronized int getValue() { return mValue;}
}

/*
class Counter
{
    private int mValue;
    private Object mMutex = new Object();
    
    Counter() { mValue = 0; }
    
    public void Increase() 
    { 
        synchronized(mMutex)
        {
            mValue++; 
        }
        
        // Can do other operations here if we don't need syncronization for them...
    }
    public void Decrease() 
    { 
        synchronized(mMutex)
        {
            mValue--; 
        } 
    }   
    public int getValue() { return mValue;}
}
*/

class IncreaseThread extends Thread
{
    public IncreaseThread(Counter c, int iters) { mCounter = c; mIters = iters;}
    public void run()
    {
        for (int i = 0; i < mIters; i++)
            mCounter.Increase();
    }
    
    private Counter mCounter;
    private int mIters;
}

class DecreaseThread extends Thread
{
    public DecreaseThread(Counter c, int iters) { mCounter = c; mIters = iters;}
    public void run()
    {
        for (int i = 0; i < mIters; i++)
            mCounter.Decrease();
    }
    
    private Counter mCounter;
    private int mIters;
}

/**
 *
 * @author Cip
 */
public class RaceStuff 
{
    
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) 
    {
        Counter c = new Counter();
        
        IncreaseThread it = new IncreaseThread(c, 1000000);
        DecreaseThread dt = new DecreaseThread(c, 1000000);
        
        it.start();
        dt.start();
        try {
        it.join();
        dt.join();
        }
        catch(Exception e) {System.out.println(e.getMessage());}
            
        System.out.println(c.getValue()); // Should be 0, right ?:)
    }
}
