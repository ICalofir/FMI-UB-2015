f1 = @(x) exp(x) - 2;
f2 = @(x) cos(exp(x) - 2);
a = 0.5;
b = 1.5;

figure;
fplot(f1, [a, b]);
hold on;
fplot(f2, [a, b]);

f = @(x) f1(x) - f2(x);
x_aprox = MetBisectie(f, a, b, 1e-5);
fprintf('Solutia este: %f\n', x_aprox);