function [y] = MetDirecta(X, Y, x)
    n = size(X, 2) - 1;
    A = zeros(n + 1, n + 1);
    
    for i = 1:n + 1
        for j = 1:n + 1
            A(i, j) = X(i) ^ (j - 1);
        end
    end
    
    a = A^(-1) * transpose(Y);
    Pn = a(1);
    for i = 2: n + 1
        Pn = Pn + a(i) * x^(i - 1);
    end

    y = Pn;
end

