package serializare_lista;

import java.io.FileInputStream;
import java.io.ObjectInputStream;

public class Deserializare_lista
{

    public static void main(String[] args)
    {
        try (ObjectInputStream fin = new ObjectInputStream(new FileInputStream("lista.ser")))
        {
            Nod prim_nou = (Nod) fin.readObject();

            System.out.println("Lista deserializata:");
            Nod aux = prim_nou;
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
            System.out.println();
        }
        catch (Exception ex)
        {
            System.out.println(ex);
        }
    }
}
