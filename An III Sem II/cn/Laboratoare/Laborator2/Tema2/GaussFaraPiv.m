function x = GaussFaraPiv(A, b)
    A = [A, b];
    n = size(A, 1);
    
    for k = 1:n-1
        p = k;
        while A(p, k) == 0 && p <= n
            p = p + 1;
        end
        if p == n + 1
            fprintf('Sistem incompatibil sau sistem compatibil nedeterminat.');
            break
        end
        
        if p ~= k
            line = A(p, :);
            A(p, :) = A(k, :);
            A(k, :) = line;
        end
        for l = k + 1:n
            ml = A(l, k) / A(k, k);
            A(l, :) = A(l, :) - ml .* A(k, :);
        end
    end
    
    if A(n, n) == 0
        fprintf('Sistem incompatibil sau sistem compatibil nedeterminat.');
    end
    
    x = SubDesc(A(:, 1:n), A(:, n + 1));
end

