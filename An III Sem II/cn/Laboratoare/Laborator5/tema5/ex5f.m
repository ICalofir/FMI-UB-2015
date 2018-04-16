a = [1; 2; 3];
eps = 1e-5;
A = [4, 2, 2; 2, 10, 4; 2, 4, 6];

[xaprox, N, sigma] = MetGaussSeidelRO(A, a, eps, 100);
xaprox
N
sigma