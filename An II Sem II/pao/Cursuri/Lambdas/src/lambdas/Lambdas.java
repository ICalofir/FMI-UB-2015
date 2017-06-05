package lambdas;

import java.util.Arrays;
import java.util.function.BiFunction;
import java.util.function.BooleanSupplier;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.function.Supplier;

class Persoana
{

    String nume;
    int varsta;
    double salariu;

    public Persoana(String nume, int varsta, double salariu)
    {
        this.nume = nume;
        this.varsta = varsta;
        this.salariu = salariu;
    }

    Persoana()
    {
        this.nume = "";
        this.varsta = 0;
        this.salariu = 0.0;
    }

    Persoana(String nume, int varsta)
    {
        this.nume = nume;
        this.varsta = varsta;
        this.salariu = 0.0;
    }

    @Override
    public String toString()
    {
        return nume + " " + varsta + " " + salariu;
    }

    public String getNume()
    {
        return nume;
    }

    public int getVarsta()
    {
        return varsta;
    }

    public double getSalariu()
    {
        return salariu;
    }
    
    
}


public class Lambdas
{
    static void afisare(Persoana[] persoane , Predicate<Persoana> criteriu_1, Predicate<Persoana> criteriu_2)
    {
        for(Persoana p:persoane)
            if(criteriu_1.and(criteriu_2).test(p))
                System.out.println(p);
    }
    
    static void afisare(Persoana[] persoane , Predicate<Persoana> criteriu, Consumer<Persoana> prelucrare)
    {
        for(Persoana p:persoane)
            if(criteriu.test(p))
                prelucrare.accept(p);
    }
    
    public static void main(String[] args)
    {
        //Function<Double,Double> sinus = x -> Math.sin(x);
        //Function<Double,Double> sinus = Math::sin;
        //System.out.println(sinus.apply(Math.PI/2));
        
        //BiFunction<String,Integer,String> subsir = (a,b) -> a.substring(b);
        //BiFunction<String,Integer,String> cmp = String::substring;
        //System.out.println(cmp.apply("Lambdas", 3));
        
        Persoana p = new Persoana("Ionescu Ion", 35, 1500.5);
        
        //Supplier<Persoana> pnoua_1 = () -> new Persoana();
        Supplier<Persoana> pnoua_1 = Persoana::new;
        //BiFunction<String,Integer,Persoana> pnoua_2 = (nume,varsta) -> new Persoana(nume,varsta);
        BiFunction<String,Integer,Persoana> pnoua_2 = Persoana::new;
        
        System.out.println(pnoua_2.apply("Popescu Ion", 26));

        /*
        Persoana[] p = new Persoana[5];

        p[0] = new Persoana("Ionescu Ion", 35, 1500.5);
        p[1] = new Persoana("Popescu Mihai", 27, 2000);
        p[2] = new Persoana("Ionescu George", 35, 3500.75);
        p[3] = new Persoana("Bunea Stefan", 35, 2700);
        p[4] = new Persoana("Popescu Alin", 33, 5000.1);
        
        Consumer<Persoana []> sortare = tablou -> Arrays.sort(tablou , (p1, p2) -> p1.varsta - p2.varsta);
        Consumer<Persoana []> afisare = tablou -> {for(Persoana aux : tablou) System.out.println(aux);};
	
        sortare.andThen(afisare).accept(p);
        */
        
        /*
        Predicate<Persoana> criteriu_1 = pers -> pers.varsta > 30;
        Predicate<Persoana> criteriu_2 = pers -> pers.nume.startsWith("I");
        
        Consumer<Persoana> prelucrare_1 = pers -> System.out.println(pers);
        
        Function<Persoana , Double> functie_1 = pers -> pers.salariu * 0.16;
        
        for(Persoana crt:p)
            System.out.println(crt.nume + " " + functie_1.apply(crt));

        //afisare(p , criteriu_1, criteriu_2);
        
        afisare(p , criteriu_1 , prelucrare_1);
        */
        /*
        Arrays.sort(p, (p1, p2) -> p1.nume.compareTo(p2.nume));
        
        System.out.println("Persoanele ordonate descrescator dupa nume:");
        for (Persoana p1 : p)
            System.out.println(p1);
        
        String []t = {"gogu","mimi"};
        Arrays.sort(p, (p1,p2)->p2.varsta - p1.varsta);

        System.out.println();
        System.out.println("Persoanele ordonate dupa varsta:");
        for (Persoana p1 : p)
            System.out.println(p1);

            BiFunction<Integer, Integer,Integer> bi = (x, y) -> {if(x>y) return x; else return y;};
            Consumer<String> c = (s) -> System.out.println(s);
            System.out.println(bi.apply(1, 2));
            c.accept("Test");

        */
    }

}
