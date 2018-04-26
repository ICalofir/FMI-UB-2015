function ex2_fc(f, a, b, n, met)
    X = linspace(a, b, n + 1);
    Y = f(X);
    x = linspace(a, b, 100);
    Pn = zeros(1, size(x, 2));
    
    for i = 1:size(x, 2)
        if strcmp(met, 'MetDirecta') == 1
            Pn(i) = MetDirecta(X, Y, x(i));
        elseif strcmp(met, 'MetLagrange') == 1
            fprintf('aaaaaa\n')
            Pn(i) = MetLagrange(X, Y, x(i));
        elseif strcmp(met, 'MetN') == 1
            Pn(i) = MetN(X, Y, x(i));
        elseif strcmp(met, 'MetNDD') == 1
            Pn(i) = MetNDD(X, Y, x(i));
        end
    end
    
    figure(1)
    title(met);
    hold on;
    plot(x, Pn, 'Linewidth', 5);
    plot(x, f(x), '--', 'Linewidth', 5);
    plot(X, Y, '*', 'Linewidth', 5);
    hold off;
    
    figure(2)
    title('Eroarea')
    hold on;
    plot(x, f(x) - Pn, 'Linewidth', 5);
    hold off;
end

