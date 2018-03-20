function output = MetPozFalse(f, a, b, eps)
    x = (a * f(b) - b * f(a)) / (f(b) - f(a));
    while true
        if f(x) == 0
            break;
        end
        if f(a) * f(x) < 0
            b = x;
            new_x = (a * f(b) - b * f(a)) / (f(b) - f(a));
        else
            a = x;
            new_x = (a * f(b) - b * f(a)) / (f(b) - f(a));
        end
        if (abs(new_x - x) / abs(x)) < eps
            break;
        end
        x = new_x;
    end
    output = x;
end

