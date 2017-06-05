/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Cip
 */
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 *
 * @author Cip
 */

class Person implements Runnable
{
    Person(String personName)
    {
        mName = personName;
    }
    
    void setOther(Person other)
    {
        mOtherPerson = other;        
    }
    
    boolean sayHello()
    {
        boolean lockedMe = false, lockedOther = false;
        
        try
        {
            lockedMe = mLock.tryLock();
            lockedOther = mOtherPerson.mLock.tryLock();
        }
        finally
        {
            // If not successfull to block both locks, release the ones took
            if (!(lockedMe && lockedOther))
            {
                // These tests are very important - we should release only what we've aquired !
                if (lockedMe) 
                    mLock.unlock();
                
                if (lockedOther)
                    mOtherPerson.mLock.unlock();
            }
        }
        
        return lockedMe & lockedOther;
    }
    
    @Override
    public void run()
    {
        while(!sayHello()) {}   // Try aquire both locks
        System.out.println(mName + " says hello to " + mOtherPerson.mName);
        mLock.unlock();
        mOtherPerson.mLock.unlock();
    }
    
    public Lock mLock = new ReentrantLock();
    Person mOtherPerson;
    String mName;
}

public class Deadlock_solved
{

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) 
    {        
        // TODO code application logic here
        Person a = new Person("A");
        Person b = new Person("B");        
        a.setOther(b);
        b.setOther(a);

        // Serial version
        //a.sayHello();
        //b.sayHello();
        
        // threaded version
        new Thread(a).start();
        new Thread(b).start();
    }    
}
