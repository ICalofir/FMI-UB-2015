function x_aprox = MetNR(f, df, x0, eps)
    while true
        x = x0 - (f(x0) / df(x0));
        if abs(x - x0) / abs(x0) < eps
            break
        end
        x0 = x;
    end
    x_aprox = x;
end

