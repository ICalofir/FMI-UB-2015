function I = Integrare(f, a, b, m, metoda)
    I = 0;
    switch metoda
        case 'dreptunghi'
            x = linspace(a, b, 2 * m + 1);
            for k = 1:m
                I = I + f(x(2 * k)) * (x(2 * k + 1) - x(2 * k - 1));
            end
        case 'trapez'
            x = linspace(a, b, m + 1);
            for k = 1:m
                I = I + (f(x(k)) + f(x(k + 1))) / 2 * (x(k + 1) - x(k)); 
            end
        case 'Simpson'
            x = linspace(a, b, 2 * m + 1);
            for k = 1:m
                I = I + 1 / 3 * f(x(2 * k - 1)) + 4 / 3 * f(x(2 * k)) + 1 / 3 * f(x(2 * k + 1));
            end
            I = I * (x(2 * k + 1) - x(2 * k - 1)) / 2;
        otherwise
            x = linspace(a, b, 3 * m + 1);
            h = x(2) - x(1);
            for k = 1:m
                I = I + f(x(3 * k - 2)) + 3 * f(x(3 * k - 1)) + 3 * f(x(3 * k)) + f(x(3 * k + 1)); 
            end
            I = I * (3 * h / 8);
    end
end