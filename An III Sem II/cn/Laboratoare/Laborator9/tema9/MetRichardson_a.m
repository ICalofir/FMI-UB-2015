function df = MetRichardson_a(f, x, h, n)
    for i = 1:n
        Q(i, 1) = (f(x + h / (2^(i - 1))) - f(x)) / (h / 2^(i - 1));
    end
    
    for i = 2:n
        for j = 2:i
            Q(i, j) = Q(i, j - 1) + 1 / (2^(j - 1) - 1) * (Q(i, j - 1) - Q(i - 1, j - 1)); 
        end
    end
    
    df = Q(n, n);
end

