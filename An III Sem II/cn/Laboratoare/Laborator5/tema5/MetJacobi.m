function [xaprox, N] = MetJacobi(A, a, eps)
    xaprox = NaN;
    N = NaN;

    n = size(A, 1);
    q = norm(eye(n) - A);
    if q >= 1
        fprintf('Metoda Jacobi nu asigura conv.\n');
        return
    end
    
    q
    
    x = zeros(n, 1);
    x_prev = zeros(n, 1);
    k = 0;
    B = eye(n) - A;
    b = a;
    
    while 1
        k = k + 1;
        x = B * x_prev + b;
        
        cond = ((q^k) / (1 - q)) * norm(x - x_prev);
        if cond < eps
            break
        end
        
        x_prev = x;
    end
    
    xaprox = x;
    N = k;
end