function [x, L] = DescCholesky(A, b)
    n = length(A);
    alfa = A(1, 1);
    
    if alfa <= 0
        fprintf('A nu admite fact. LU');
    end
    
    L(1, 1) = sqrt(A(1, 1));
    for i = 2:n
        L(i, 1) = A(i, 1) / L(1, 1);
    end
    
    for k = 2:n
        sum = 0;
        for s = 1:k - 1
            sum = sum + L(k, s) * L(k, s);
        end
        alfa = A(k, k) - sum;
        
        if alfa <= 0
            fprintf('A nu admite fact. LU');
        end
        
        L(k, k) = sqrt(alfa);
        for i = k + 1:n
            sum = 0;
            for s = 1:k - 1
                sum = sum + L(i, s) * L(k, s);
            end
            L(i, k) = (A(i, k) - sum) / L(k, k);
        end
    end
    
    y = SubAsc(L, b);
    x = SubDesc(L', y);
end

