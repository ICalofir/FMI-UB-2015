function [xaprox, N, sigmaO] = MetJacobiRO(A, a, eps, p)
    xaprox = NaN;
    N = NaN;
    sigma = NaN;
    
    for s = 1:p - 1
        sigma(s) = (2 * s) / (norm(A, inf) * p);
        [xaproxS, NS] = MetJacobiR(A, a, eps, sigma(s));
        V(s) = NS;
    end
    
    [val, ind] = min(V);
    sig = (2 * ind) / (norm(A, inf) * p);
    
    [xaproxO, NO] = MetJacobiR(A, a, eps, sig);
    
    xaprox = xaproxO;
    N = NO;
    sigmaO = sig;
end