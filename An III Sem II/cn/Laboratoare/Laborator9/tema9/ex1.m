f = @(x) sin(x);
df = @(x) cos(x);
a = 0;
b = pi;
m = 100;

puncte = linspace(a, b, m + 1);
dy = DerivNum(puncte, f(puncte), 'diferente finite centrale');

% b)
figure(1);
hold on
plot(puncte(2:m), df(puncte(2:m)), 'Linewidth', 2);
plot(puncte(2:m), dy(2:m), '--', 'Linewidth', 2);

% d)
figure(2);
hold on;
plot(puncte(2:m), abs(df(puncte(2:m)) - dy(2:m)), 'Linewidth', 2);