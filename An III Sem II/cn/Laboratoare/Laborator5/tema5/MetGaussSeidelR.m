function [xaprox, N] = MetGaussSeidelR(A, a, eps, sigma)
    xaprox = NaN;
    N = NaN;
    n = size(A, 1);
    
    k = 0;
    x = zeros(n, 1);
    x_prev = zeros(n, 1);
    L = tril(A, -1);
    D = diag(diag(A));
    R = triu(A, 1);
    
    B = ((sigma * L + D)^(-1)) * ((1 - sigma) * D - sigma * R);
    b = ((sigma * L + D)^(-1)) * sigma * a;
    q = sum(dot(A * B, B));
    
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

