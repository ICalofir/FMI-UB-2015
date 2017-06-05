/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dinningph;
import java.util.*;
import java.util.concurrent.*;

class Table
{
    static int mNumPh;   // number of people at table
    static Semaphore[] mForks;  // Each fork has a binary semaphore
    
    // Semaphore to control how many are eating
    static Semaphore mEatingControl; 
    
    static void Create(int numPh)
    {
        mNumPh = numPh;
        mForks = new Semaphore[numPh];
        for (int i = 0; i < numPh; i++)
        {
            mForks[i] = new Semaphore(1, true);
        }            
        
        mEatingControl = new Semaphore(numPh - 1, true);
    }
}

class Ph extends Thread
{
    int mId;
    public Ph(int id) { mId = id; }
    
    // Simulates time delay
    void simDelay(int maxTime)throws InterruptedException
    { Thread.sleep((int)(Math.random() * maxTime)); }
    
    public void run()
    {
        final int leftFork = mId;
        final int rightFork = (mId + 1 + Table.mNumPh) % Table.mNumPh;  // circular..
        
        for (int cycle = 0; cycle < 10; cycle++)
        {
            try{
            Table.mEatingControl.acquire();
                System.out.println("Ph " + mId + " is THINKING");
                simDelay(100);
            
                Table.mForks[leftFork].acquire();
                Table.mForks[rightFork].acquire();
                
                System.out.println("Ph " + mId + " is EATING");
                simDelay(100);

                Table.mForks[leftFork].release();
                Table.mForks[rightFork].release();
                System.out.println("Ph " + mId + " FINISHED - EATING");
            Table.mEatingControl.release();            
            }
            catch(Exception e){}
        }
    }
}

/**
 *
 * @author Cip
 */
public class DinningPh 
{

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) 
    {
        // TODO code application logic here
        final int numPh = 5;
        Table.Create(numPh);
        Ph[] people = new Ph[numPh];
        for (int i = 0; i < numPh; i++)
        {
            people[i] = new Ph(i);
            people[i].start();
        }
    }
    
}
