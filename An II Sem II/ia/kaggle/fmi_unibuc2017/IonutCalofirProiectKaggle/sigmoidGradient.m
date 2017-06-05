function g = sigmoidGradient(z)
% Calculeaza derivata functiei sigmoidale

g = zeros(size(z));
g = sigmoid(z) .* (1 - sigmoid(z));

end
