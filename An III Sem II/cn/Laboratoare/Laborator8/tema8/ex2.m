f = @(x) sin(x);
x0 = -pi / 2;
xf = pi / 2;
N = [2, 4, 10];

for i = 1:size(N, 2)
    % b)
    X = linspace(x0, xf,(N(i) + 1));
    Y = f(X);
    x = linspace(x0, xf, 100);

    S = SplineL(X, Y, x);
    
    figure(i);
    hold on;
    plot(x, S, 'Linewidth', 2);
    plot(x, f(x), '--', 'Linewidth', 2);
    plot(X, f(X), 'o', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
end
