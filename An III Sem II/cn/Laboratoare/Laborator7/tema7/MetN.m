function [y] = MetN(X, Y, x)
    n = size(X, 2) - 1;
    k = n + 1;
    C = zeros(k, 1);
    
    A = zeros(k, k);
    for i = 1:k
        for j = 1:k
            if (j == 1)
                A(i, j) = 1;
            else
                prod = 1;
                for l = 1:j - 1
                    prod = prod * (X(i) - X(l));
                end
                A(i, j) = prod;
            end
        end
    end
    
    C(1) = Y(1);
    for i = 2:k
        sum = Y(i);
        for j = 1:i - 1
            sum = sum - (C(j) * A(i, j));
        end
        C(i) = sum / A(i, i);
    end
    
    y = C(1);
    for i = 2:n + 1
       prod = 1;
       for j = 1:i - 1
           prod = prod * (x - X(j)); 
       end
       prod = C(i) * prod;
       y = y + prod;
    end
end

