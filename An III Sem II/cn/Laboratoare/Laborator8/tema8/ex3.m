f = @(x) sin(x);
fp = @(x) cos(x);

x0 = -pi / 2;
xf = pi / 2;
N = [2, 4, 10];

for i = 1:size(N, 2)
    % b)
    X = linspace(x0, xf,(N(i) + 1));
    Y = f(X);
    x = linspace(x0, xf, 100);
    fpa = fp(X(1));

    S = SplineP(X, Y, fpa, x);
    
    figure(2 * i - 1);
    hold on;
    plot(x, S, 'Linewidth', 2);
    plot(x, f(x), '--', 'Linewidth', 2);
    plot(X, f(X), 'o', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
    
    % c)
    Sp = diff(S) ./ diff(x);
    
    figure(2 * i);
    hold on;
    plot(x(1:size(x, 2) - 1), Sp, 'Linewidth', 2);
    
    df = diff(f(x)) ./ diff(x);
    plot(x(1:size(x, 2) - 1), df, '--', 'Linewidth', 2);
end