function [E] = calculeazaEroare(X, U)

E = mean((U - X) .^ 2);

end
