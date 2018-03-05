f = @(x) x .^ 3 - 7 * x .^ 2 + 14 .* x - 6;
a = 0;
b = 4;

figure;
fplot(f, [a, b]);
hold on;

x_aprox1 = MetBisectie(f, 0, 1, 1e-5);
x_aprox2 = MetBisectie(f, 1, 3.2, 1e-5);
x_aprox3 = MetBisectie(f, 3.2, 4, 1e-5);

x_aprox = [x_aprox1, x_aprox2, x_aprox3];
y_aprox = f(x_aprox);

plot(x_aprox, y_aprox, 'x')
x_aprox