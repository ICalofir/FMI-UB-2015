function x_aprox = MetBisectie(f, a, b, eps)
    if f(a) * f(b) >= 0
        error('Functie invalida!');
    end
    while true
        m = (a + b) / 2;
        if abs(f(m)) < eps
            break
        end
        
        if f(a) * f(m) < 0
            b = m;
        else
            a = m;
        end
    end
    
    x_aprox = m;
end

