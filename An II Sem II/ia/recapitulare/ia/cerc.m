function cerc(n, radius)
    r = radius * sqrt(rand(n, 1));
    theta = 2 * pi * rand(n, 1);
    x = r .* cos(theta) + 0;
    y = r .* sin(theta) + 0;
    
    plot(x, y, 'r+');
    axis([-5 5 -5 5]);
end