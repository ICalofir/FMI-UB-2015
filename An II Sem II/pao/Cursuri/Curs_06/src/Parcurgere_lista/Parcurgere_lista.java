package Parcurgere_lista;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;

public class Parcurgere_lista
{

    public static void main(String[] args)
    {
        ArrayList<String> listaOrase = new ArrayList<>(Arrays.asList("București", "Paris", "Londra", "Madrid"));

        //clasic
        for (int i = 0; i < listaOrase.size(); i++)
            System.out.println(listaOrase.get(i));
        System.out.println();
        
        //iterator
        Iterator it = listaOrase.iterator();
        while(it.hasNext())
            System.out.println(it.next());
        System.out.println();
        
        //for extins
        for (String oras : listaOrase)
            System.out.println(oras);
        System.out.println();
        
        //lambda expresii
        listaOrase.forEach((oras) -> System.out.println(oras + " "));
        System.out.println();
    
        //referinta la metoda println
        listaOrase.forEach(System.out::println);
    }
}
