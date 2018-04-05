A = [1, -3, 3; 3, -5, 3;, 6, -6, 4];

% a
lambda = eigs(A' * A);
norm2A = max(sqrt(lambda(:)));
fprintf('Norma 2 a lui A este %.2f.\n', norm2A);

% b
invA = A^(-1);
lambda = eigs(A' * A);
invLambda = eigs(invA' * invA);

k2_b1 = max(sqrt(lambda(:))) * max(sqrt(invLambda(:)));
k2_b2 = max(sqrt(lambda(:))) * max(1 ./ sqrt(lambda(:)));
fprintf('Numarul de conditionare k2_b1 este %.2f.\n', k2_b1);
fprintf('Numarul de conditionare k2_b2 este %.2f.\n', k2_b2);

% c
fprintf('Norma 2 a lui A folosind norm(A, 2) este %.2f.\n', norm(A, 2));
fprintf('Norma de conditionare k2 folosind cond(A, 2) este %.2f.\n', cond(A, 2));