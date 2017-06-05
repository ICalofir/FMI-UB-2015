function [gstar] = aplicaClasificatorBayesian(X, c)

gstar = (X ./ (X + c)) > 1/2;

end
