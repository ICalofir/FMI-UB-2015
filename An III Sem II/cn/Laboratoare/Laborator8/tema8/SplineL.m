function y = SplineL(X, Y, x)
    n = size(X, 2) - 1;
    m = size(x, 2);
    
    a = [];
    b = [];
    
    for j = 1:n
        a(j) = Y(j);
        b(j) = (Y(j + 1) - Y(j)) / (X(j + 1) - X(j));
    end
    
    for i = 1:m
        for j = 1:n
            if (x(i) >= X(j) && x(i) <= X(j + 1))
                S(i) = a(j) + b(j) * (x(i) - X(j));
                break;
            end
        end
    end
    
    y = S;
end