package lambdas;

//interfata care contine antetul unei functii generice

@FunctionalInterface
interface FunctieGenerica
{
    double functie(double x);
}

//clasa in care implementam mecanismul de callback pentru a calcula o suma
class Suma
{
    private Suma()
    {
    }
        
    public static double CalculeazaSuma(FunctieGenerica fg , int n)
    {
        double s = 0;
        
        for(int i = 1; i <= n; i++)
            s = s + fg.functie(i);
            
        return s;
    }
}

public class CallBack
{
    public static void main(String[] args)
    {
        FunctieGenerica f = x -> x;
        System.out.println("Suma 1: " + Suma.CalculeazaSuma(f , 10));
        
        System.out.println("Suma 2: " + Suma.CalculeazaSuma(x -> 1/x , 10));
        
        System.out.println("Suma 3: " + Suma.CalculeazaSuma(x -> Math.tan(x) , 10));
        
        System.out.println("Suma 3: " + Suma.CalculeazaSuma(Math::tan , 10));
    }
}