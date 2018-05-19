function xaprox = MetJacobiDDL(A, a, eps)
    xaprox = NaN;
    
    n = size(A, 1);

    for i = 1:n
        sum = 0;
        for j = 1:n
            if i == j
                continue
            end
            sum = sum + abs(A(i, j));
        end
        if abs(A(i, i)) <= sum
            fprintf('Matr. nu este diag. pe linii.\n');
            return
        end
    end
    
    x = zeros(n, 1);
    x_prev = zeros(n, 1);
    k = 0;
    D = diag(diag(A));
    B = eye(n) - (D^(-1)) * A;
    b = (D^(-1)) * a;
    q = norm(B, inf);
    
    while 1
        k = k + 1;
        x = B * x_prev + b;
        
        cond = ((q^k) / (1 - q)) * norm(x - x_prev, inf);
        if cond < eps
            break
        end
        
        x_prev = x;
    end
    
    xaprox = x;
end