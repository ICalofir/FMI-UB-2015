package externalizare;

import java.io.Externalizable;
import java.io.IOException;
import java.io.ObjectInput;
import java.io.ObjectOutput;
import java.util.Arrays;

public class Student implements Externalizable
{
    private static final long serialVersionUID = 1L;
    
    public static String facultate;
    
    String nume;
    int grupa , note[];
    double medie;

    public Student(String nume ,  int grupa , int note[],String facultate) 
//    public Student(String nume , int grupa , int note[]) 
    {
        this.nume = nume;
        this.facultate = facultate;
        this.grupa = grupa;
        
        this.note = Arrays.copyOf(note, note.length);
               
        calculeazaMedie();
    }
    
    public Student() 
    {
    }
    
    public void calculeazaMedie()
    {
        double aux = 0;
        int n = note.length;
        
        for(int i = 0; i < n; i++)
            aux = aux + note[i];
        
        medie = aux / n;
    }
        
    @Override
    public String toString()
    {
        return nume + "," + facultate + "," + grupa + "," + medie;
    }

    @Override
    public void writeExternal(ObjectOutput out) throws IOException
    {
        out.writeUTF(facultate);
        out.writeUTF(nume);
        out.writeInt(grupa);
        out.writeDouble(2*medie+3);
        out.writeObject(note);
    }

    @Override
    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException
    {
        facultate = in.readUTF();
        nume = in.readUTF();
        grupa = in.readInt();
        medie = in.readDouble();
        medie = (medie - 3)/2;
        note = (int [])in.readObject();
    }
}

