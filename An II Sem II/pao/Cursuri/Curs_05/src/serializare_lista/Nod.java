package serializare_lista;

import java.io.Serializable;

class Nod implements Serializable
{
    Object data;
    Nod next;

    public Nod(Object data)
    {
        this.data = data;
        this.next = null;
    }
 }
