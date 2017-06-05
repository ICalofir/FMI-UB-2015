function [X, Y] = genereazaMultimeAntrenare(n, c)

X = rand(n, 1) * 4 * c;

p = X ./ (X + c);
Y = rand(n, 1) < p;

end
