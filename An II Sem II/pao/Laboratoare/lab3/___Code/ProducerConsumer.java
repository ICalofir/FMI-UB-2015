package ProducerConsumer;
import java.util.concurrent.*;
import java.util.Random;
import java.util.List;
import java.util.ArrayList;

class Producer implements Runnable
{
   private final List<Integer> taskQueue;
   private final int           MAX_CAPACITY;
   Random rng = new Random();
 
   public Producer(List<Integer> sharedQueue, int size)
   {
      this.taskQueue = sharedQueue;
      this.MAX_CAPACITY = size;
   }
 
   @Override
   public void run()
   {
      int counter = 0;
      while (true)
      {
         try
         {
            produce(counter++);
         } 
         catch (InterruptedException ex)
         {
            ex.printStackTrace();
         }
      }
   }
 
   private void produce(int i) throws InterruptedException
   {
      synchronized (taskQueue)
      {
         while (taskQueue.size() == MAX_CAPACITY)
         {
            System.out.println("Queue is full " + Thread.currentThread().getName() + " is waiting , size: " + taskQueue.size());
            taskQueue.wait();
         }
         
		 // simulating a production
         Thread.sleep(rng.nextInt() % 1000 + 100);
         taskQueue.add(i);
		 // --
		 
         System.out.println("Produced: " + i);
         taskQueue.notifyAll();
      }
   }
}

class Consumer implements Runnable
{
   private final List<Integer> taskQueue;
   Random rng = new Random();
 
   public Consumer(List<Integer> sharedQueue)
   {
      this.taskQueue = sharedQueue;
   }
 
   @Override
   public void run()
   {
      while (true)
      {
         try
         {
            consume();
         } catch (InterruptedException ex)
         {
            ex.printStackTrace();
         }
      }
   }
 
   private void consume() throws InterruptedException
   {
      synchronized (taskQueue)
      {
         while (taskQueue.isEmpty())
         {
            System.out.println("Queue is empty " + Thread.currentThread().getName() + " is waiting , size: " + taskQueue.size());
            taskQueue.wait();
         }
		 
		 // simulating consume
         Thread.sleep(rng.nextInt() % 1000 + 100);	 
         int i = (Integer) taskQueue.remove(0);
		 // -----
		 
         System.out.println("Consumed: " + i);
         taskQueue.notifyAll();
      }
   }
}

public class ProducerConsumer
{
   public static void main(String[] args)
   {
      List<Integer> taskQueue = new ArrayList<Integer>(); // If not using a synchronized list we can't use more than one consumer !
      int MAX_CAPACITY = 5;
      Thread tProducer = new Thread(new Producer(taskQueue, MAX_CAPACITY), "Producer");
      Thread tConsumer = new Thread(new Consumer(taskQueue), "Consumer");
      tProducer.start();
      tConsumer.start();
   }
}


