function [D] = euclidian_dist(X, Y)

    Y = Y';
    D = 2 * X * Y;
    
    for i = 1:size(D, 1)
        for j = 1:size(D, 2)
            D(i, j) = sum(X(i, :) .^ 2) + sum(Y(:, j) .^ 2) - D(i, j);
        end
    end

end

