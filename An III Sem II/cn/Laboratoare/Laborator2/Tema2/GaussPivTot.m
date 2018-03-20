function x = GaussPivTot(A, b)
    A = [A, b];
    n = size(A, 1);

    for k = 1:n - 1
        p = k;
        c = k;
        mp = 0;
        for i = k:n
            for j = k:n
                if abs(A(i, j)) > mp
                    mp = abs(A(i, j));
                    p = i;
                    c = j;
                end
            end
        end
        
        if mp == 0
            fprintf('Sistem incompatibil sau sistem compatibil nedeterminat.');
            break
        end
        
        if p ~= k
            line = A(p, :);
            A(p, :) = A(k, :);
            A(k, :) = line;
        end
        
        if c ~= k
            col = A(:, c);
            A(:, c) = A(:, k);
            A(:, k) = col;
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

