function [C, err] = conf_mat(X, T)

    C = zeros(size(X, 2), size(X, 2));
    for i = 1:size(X, 1)
        posT = find(T(i, :));
        posX = find(X(i, :));
        C(posT, posX) = C(posT, posX) + 1;
    end

    err = (sum(C(:)) - sum(diag(C))) / sum(C(:));
    
end

