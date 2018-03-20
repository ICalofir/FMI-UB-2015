function x = SubAsc(A, b)
    n = length(A);
    x(1) = b(1) / A(1, 1);
    for k = 2:n
        sum = 0;
        for j = 1:k-1
            sum = sum + A(k, j) * x(j);
        end
        x(k) = (1 / A(k, k)) * (b(k) - sum);
    end
end