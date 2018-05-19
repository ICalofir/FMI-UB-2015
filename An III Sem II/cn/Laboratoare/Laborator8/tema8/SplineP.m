function y = SplineP(X, Y, fpa, x)
    n = size(X, 2) - 1;
    m = size(x, 2);
    
    a = [];
    b = [];
    c = [];
    h = [];
    
    for j = 1:n
        a(j) = Y(j);
        h(j) = X(j + 1) - X(j);
    end
    
    b(1) = fpa;
    for j = 1:n - 1
        b(j + 1) = (2 / h(j)) * (Y(j + 1) - Y(j)) - b(j);
    end
    
    for j = 1:n
        c(j) = (1 / (h(j)^2)) * (Y(j + 1) - Y(j) - h(j) * b(j));
    end
    
    for i = 1:m
        for j = 1:n
            if (x(i) >= X(j) && x(i) <= X(j + 1))
                S(i) = a(j) + b(j) * (x(i) - X(j)) + c(j) * (x(i) - X(j))^2; 
                break;
            end
        end
    end
    
    y = S;
end