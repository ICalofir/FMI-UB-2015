function [P] = gasestePolinomOptim(X, Y, grad)

P = polyfit(X, Y, grad);

end
