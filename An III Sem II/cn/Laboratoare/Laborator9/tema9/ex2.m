f = @(x) sin(x);
df = @(x) cos(x);
ddf = @(x) -sin(x);

a = 0;
b = pi;
N = [4, 6, 8];
m = 100;

for i = 1:size(N, 2)
    puncte = linspace(a, b, m);
    for j = 1:size(puncte, 2)
        dy(j) = MetRichardson_a(f, puncte(j), 1, N(i));
        d2y(j) = MetRichardson_d(f, puncte(j), 1, N(i) - 1);
    end
    
    % b)
    figure(4 * i - 3);
    hold on;
    plot(puncte, df(puncte), 'Linewidth', 2);
    plot(puncte, dy, '--', 'Linewidth', 2);
    
    % c)
    figure(4 * i - 2);
    hold on;
    plot(puncte, abs(df(puncte) - dy), 'Linewidth', 2);
    
    % e)
    figure(4 * i - 1);
    hold on;
    plot(puncte, ddf(puncte), 'Linewidth', 2);
    plot(puncte, d2y, '--', 'Linewidth', 2);

    figure(4 * i);
    hold on;
    plot(puncte, abs(ddf(puncte) - d2y), 'Linewidth', 2);
end