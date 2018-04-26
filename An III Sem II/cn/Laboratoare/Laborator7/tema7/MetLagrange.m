function [y] = MetLagrange(X, Y, x)
    n = size(X, 2) - 1;
    k = n + 1;
    L = zeros(k, 1);
    
    for i = 1:k
        prod = 1;
        for j = 1:n + 1
            if i == j
                continue
            end
            
            prod = prod * ((x - X(j)) / (X(i) - X(j)));
        end
        L(i) = prod;
    end
    
    y = 0;
    for i = 1:n + 1
        y = y + L(i) * Y(i);
    end
end

