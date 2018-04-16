a = [1; 2; 3];
eps = 1e-5;
A = [4, 2, 2; 2, 10, 4; 2, 4, 6];
%A = [0.2, 0.01, 0; 0, 1, 0.04; 0, 0.02, 1];
p = [10, 20, 50];
sigma = [];
V = [];

figure
for i = 1:size(p, 2)
    for s = 1:p(i) - 1
        sigma(s) = (2 * s) / (norm(A, inf) * p(i));
        [xaproxS, NS] = MetGaussSeidelR(A, a, eps, sigma(s));
        V(s) = NS;
    end
    
    subplot(2, 3, i)
    plot(sigma, V)
end

r = max(eigs(abs(A)));
sigma = [];
V = [];
for i = 1:size(p, 2)
    for s = 1:p(i) - 1
        sigma(s) = (2 * s) / (r * p(i));
        [xaproxS, NS] = MetGaussSeidelR(A, a, eps, sigma(s));
        V(s) = NS;
    end
    
    subplot(2, 3, i + size(p, 2))      
    plot(sigma, V)
end