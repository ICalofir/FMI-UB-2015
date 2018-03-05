f = @(x) x .^ 3 - 7 .* x .^ 2 + 14 .* x - 6;
df = @(x) 3 .* x .^ 2 - 14 .* x + 14;
ddf = @(x) 6 .* x - 14;
a = 0;
b = 4;

figure;
fplot(f, [0, 4]);
hold on;

% Intervalul [0, 1.5]
a1 = 0;
b1 = 1.5;
x01 = 0;
if f(a1) * f(b1) >= 0 || f(x01) * ddf(x01) <= 0
    error('Interval sau valoare initiala invalide!');
end
x_aprox1 = MetNR(f, df, x01, 1e-3);

% Intervalul [1.5, 3.2]
a1 = 1.5;
b1 = 3.2;
x02 = 2.5;
if f(a1) * f(b1) >= 0 || f(x02) * ddf(x02) <= 0
    error('Interval sau valoare initiala invalide!');
end
x_aprox2 = MetNR(f, df, x02, 1e-3);

% Intervalul [3.2, 4]
a1 = 3.2;
b1 = 4;
x03 = 3.5;
if f(a1) * f(b1) >= 0 || f(x03) * ddf(x03) <= 0
    error('Interval sau valoare initiala invalide!');
end
x_aprox3 = MetNR(f, df, x03, 1e-3);

x_aprox = [x_aprox1, x_aprox2, x_aprox3];
y_aprox = f(x_aprox);
plot(x_aprox, y_aprox, 'x');
x_aprox