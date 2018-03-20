eps = 1e-3;
f = @(x) x .^ 3 - 18 .* x - 10;

%a
figure;
fplot(f, [-5, 5])
hold on;

% d
% f' = x^2 - 6 => x = +- 2.44
a = -5;
b = -3;
x0 = MetSecantei(f, a, b, -5, -3, eps)
plot(x0, f(x0), 'x');
hold on;

a = -2;
b = 1;
x0 = MetSecantei(f, a, b, -1.5, 0, eps)
plot(x0, f(x0), 'x');
hold on;

a = 3;
b = 5;
x0 = MetSecantei(f, a, b, 3, 5, eps)
plot(x0, f(x0), 'x');
hold on;

% e
% f'' = x => x = 0
figure;
fplot(f, [-5, 5])
hold on;

a = -5;
b = -3;
x0 = MetPozFalse(f, a, b, eps)
plot(x0, f(x0), 'x');
hold on;

a = -2;
b = -0.1;
x0 = MetPozFalse(f, a, b, eps)
plot(x0, f(x0), 'x');
hold on;

a = 3;
b = 5;
x0 = MetPozFalse(f, a, b, eps)
plot(x0, f(x0), 'x');
hold on;