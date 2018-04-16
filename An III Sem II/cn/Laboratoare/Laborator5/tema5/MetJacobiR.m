function [xaprox, N] = MetJacobiR(A, a, eps, sigma)
    xaprox = NaN;
    N = NaN;
    n = size(A, 1);

    B = eye(n) - sigma * A;
    b = sigma * a;
    
    x = zeros(n, 1);
    x_prev = zeros(n, 1);
    k = 0;
    
    while 1
        k = k + 1;
        x = B * x_prev + b;
        
        cond = dot(A * (x - x_prev), (x - x_prev)) / dot(A * x_prev, x_prev);
        if cond < eps
            break
        end
        
        x_prev = x;
    end
    
    xaprox = x;
    N = k;
end