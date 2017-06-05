package fire_4_main;

import java.util.Scanner;

class FirDeExecutare implements Runnable
{
    int cnt;
    boolean stop;

    public FirDeExecutare()
    {
        cnt = 0;
        stop = false;
    }

    @Override
    public void run()
    {
        while(!stop)
            System.out.println(++cnt + " ");
    }
    
    public void OprireFir()
    {
        stop = true;
    }
}

public class Fire_Main
{
    public static void main(String[] args)
    {
        String s , aux;
        
        FirDeExecutare ob = new FirDeExecutare();
        Thread fir = new Thread(ob); 

        fir.start();
        
        Scanner in = new Scanner(System.in);
        
        aux = "";
        while ((s = in.next()).compareTo("stop") != 0)
            aux = aux + s + " ";
        
        ob.OprireFir();
        
        System.out.println("Cuvintele citite: " + aux);
    }
}
