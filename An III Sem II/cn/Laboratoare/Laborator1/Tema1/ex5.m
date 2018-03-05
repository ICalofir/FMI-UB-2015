f = @(x) x .^ 3 - 7 .* x .^ 2 + 14 .* x - 6;
df = @(x) 3 .* x .^ 2 - 14 .* x + 14;

% x0 = 2, f(x0) = 2, df(x0) = -2
% cum x = x0 - (f(x0) / df(x0)), inseamna ca x va fi = 3
% |3 - 2| / |2| = 0.5 > 1e-5
% noul x0 va fi = 3
% f(x0) = 0, df(x0) = -1, inseamna ca x va fi = 3
% |3 - 3| / |3| = 0 < 1e-5
% deci x = 3 va fi solutie
x_aprox = MetNR(f, df, 2, 1e-5);
fprintf('Solutia cand x0 = 2 este: %f\n', x_aprox);

x_aprox = MetNR(f, df, 0, 1e-5);
fprintf('Solutia este: %f\n', x_aprox);