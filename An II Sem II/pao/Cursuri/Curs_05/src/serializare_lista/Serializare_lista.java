package serializare_lista;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;

public class Serializare_lista
{

    public static void main(String[] args)
    {
        Nod prim, ultim;

        prim = ultim = null;

        for (int i = 1; i <= 10; i++)
        {
            Nod aux = new Nod(i);

            if (prim == null)
                prim = ultim = aux;
            else
            {
                ultim.next = aux;
                ultim = aux;
            }
        }

        System.out.println("Lista:");

        Nod aux = prim;
        while (aux != null)
        {
            System.out.print(aux.data + " ");
            aux = aux.next;
        }

        //pentru lista circulara
        /*
        ultim.next = prim;

        System.out.println("Lista serializata:");
        Nod aux = prim;
        do
        {
            System.out.print(aux.data + " ");
            aux = aux.next;
        }
        while(aux != prim);
        */

        try (ObjectOutputStream fout = new ObjectOutputStream(new FileOutputStream("lista.ser")))
        {
            fout.writeObject(prim);
        }
        catch (IOException ex)
        {
            System.out.println(ex);
        }
    }
}
