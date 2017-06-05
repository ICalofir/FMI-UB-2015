/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package histogram;

import java.util.Random;
import java.lang.Thread;
import java.util.concurrent.atomic.*;

class Worker extends Thread
{
    Worker(int[] numbersArrRef, int start, int end, int numBuckets, int maxNum, AtomicInteger[] histogram)
    { 
        mMaxNum = maxNum;
        mNumbersArrRef = numbersArrRef;
        mStart = start;
        mEnd = end;              
        mNumBuckets = numBuckets;
        
        g_Histogram = histogram;
    }
    
    public void run()
    {
        for (int i = mStart; i <= mEnd; i++)
        {
            int histId = (int)(((float)mNumbersArrRef[i] / mMaxNum) * mNumBuckets);
            if (histId >= mNumBuckets) 
                histId = mNumBuckets - 1;
            
            g_Histogram[histId].incrementAndGet();
        }
    }
    
    AtomicInteger[] g_Histogram;
            
    private int mMaxNum;            // Maximum number in array
    private int mNumBuckets;        // number of buckets
    
    private int[] mNumbersArrRef;
    private int mStart;
    private int mEnd;
}

/**
 *
 * @author Cip
 */
public class Histogram 
{

    /**
     * @param args the command line arguments
     */
    static final int M = 100000;    // interval size [0,M)
    static final int N = 1000000;   // number of items to generate
    static final int K = 10;        // num buckets
    static final int P = 4;         // num worker threads
       
    public static void main(String[] args) 
    {
        // Generate an array pf numbers
        Random r = new Random();
        int[] numbers = new int[N];
        for (int i = 0; i < N; i++)
            numbers[i] = r.nextInt(M);

        // Generate histogram
        AtomicInteger[] g_Histogram = new AtomicInteger[K];
        for (int i = 0; i < K; i++)
            g_Histogram[i] = new AtomicInteger();

                
        Worker[] workers = new Worker[P];
        int chunkBegin = 0;
        int itemsPerWorker = N / P; // could compute this better if not dividing
        for (int i = 0; i < P; i++)
        {
            int chunkEnd = i == (P-1) ? N-1 : chunkBegin + itemsPerWorker - 1;
            workers[i] = new Worker(numbers, chunkBegin, chunkEnd, K, M, g_Histogram);
            workers[i].start();
            
            chunkBegin = chunkEnd;
        }
        
        // It could be more efficient if we would process a chunck on this thread instead of just waiting
        // But don't forget that because this main thread will sleep so processors will be busy with workers !
        try{
        for (int i = 0; i < P; i++)
            workers[i].join(); }
        catch(Exception e) {System.out.println(e.getMessage());}

        for (int i = 0; i < K; i++)
            System.out.println("Bucket " + i + ": " + g_Histogram[i]);        
    }    
}

