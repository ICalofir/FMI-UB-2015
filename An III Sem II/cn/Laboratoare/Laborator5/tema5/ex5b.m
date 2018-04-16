a = [1; 2; 3];
eps = 1e-5;

A = [0.2, 0.01, 0; 0, 1, 0.04; 0, 0.02, 1];
B = [4, 1, 2; 0, 3, 1; 2, 4, 8];

[xaproxA, NA] = MetJacobi(A, a, eps);
[xaproxB, NB] = MetJacobiDDL(B, a, eps);

xaproxA
fprintf('N A este %.2f.\n', NA);
xaproxB
fprintf('N B este %.2f.\n', NB);