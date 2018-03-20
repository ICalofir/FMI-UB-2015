function [x, Q, R] = DescQR(A, b)
    n = length(A);
    sum = 0;
    for i = 1:n
        sum = sum + A(i, 1) * A(i, 1);
    end
    R(1, 1) = sqrt(sum);
    
    for i = 1:n
        Q(i, 1) = A(i, 1) / R(1, 1);
    end
    
    for j = 2:n
        sum = 0;
        for s = 1:n
            sum = sum + Q(s, 1) * A(s, j);
        end
        R(1, j) = sum;
    end
    
    for k = 2:n
        sum = 0;
        for i = 1:n
            sum = sum + A(i, k) * A(i, k);
        end
        R(k, k) = sum;
        sum = 0;
        for s = 1:k - 1
            sum = sum + R(s, k) * R(s, k);
        end
        R(k, k) = sqrt(R(k, k) - sum);
        
        for i = 1:n
            sum = 0;
            for s = 1:k - 1
                sum = sum + Q(i, s) * R(s, k);
            end
            Q(i, k) = (A(i, k) - sum) / R(k, k);
        end
        
        for j = k + 1:n
            sum = 0;
            for s = 1:n
                sum = sum + Q(s, k) * A(s, j);
            end
            R(k, j) = sum;
        end
    end
    
    x = SubDesc(R, Q' * b);
end