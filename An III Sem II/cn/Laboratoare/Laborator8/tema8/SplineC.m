function y = SplineC(X, Y, fpa, fpb, x)
    n = size(X, 2) - 1;
    m = size(x, 2);
    
    a = [];
    b = [];
    c = [];
    d = [];
    h = [];
    
    for j = 1:n
        a(j) = Y(j);
        h(j) = X(j + 1) - X(j);
    end
    
    B = zeros(n + 1, n + 1);
    B(1, 1) = 1;
    B(n + 1, n + 1) = 1;
    for j = 2:n
        B(j, j-1:j+1) = [1, 4, 1];
    end
    pas = (X(n + 1) - X(1)) / n;
    bb = zeros(n + 1, 1);
    bb(1) = fpa;
    bb(n + 1) = fpb;
    for j = 2:n
        bb(j) = (3 / pas) * (Y(j + 1) - Y(j - 1));
    end
    
    b = MetJacobiDDL(B, bb, 1e-5);
    
    for j = 1:n
        c(j) = (3 / h(j)^2) * (Y(j + 1) - Y(j)) - (b(j + 1) + 2 * b(j)) / h(j);
        d(j) = (-2 / h(j)^3) * (Y(j + 1) - Y(j)) + (1 / h(j)^2) * (b(j + 1) + b(j));
    end
    
    for i = 1:m
        for j = 1:n
            if (x(i) >= X(j) && x(i) <= X(j + 1))
                S(i) = a(j) + b(j) * (x(i) - X(j)) + c(j) * (x(i) - X(j))^2 + d(j) * (x(i) - X(j))^3; 
                break;
            end
        end
    end
    
    y = S;
end

