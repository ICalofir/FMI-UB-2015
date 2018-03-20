function output = MetSecantei(f, a, b, x0, x1, eps)
    x(1) = x0;
    x(2) = x1;
    k = 2;
    while (abs(x(k) - x(k - 1)) / abs(x(k - 1))) >= eps
        k = k + 1;
        x(k) = (x(k - 2) * f(x(k - 1)) - x(k - 1) * f(x(k - 2))) / (f(x(k - 1)) - f(x(k - 2)));
        if (x(k) < a) || (x(k) > b)
            fprintf('Introduceti alte valori pentru x0 si x1\n');
            break
        end
    end
    output = x(k);
end