function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
% Aceasta functie returneaza valoarea functiei de cost si derivatele partiale
% pentru o retea neurala cu 1 hidden layer.

% Transform inapoi din vectorul de weight-uri in cele 2 matrici
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Numarul de exemple
m = size(X, 1);

J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% Fac o propagare forward pentru a calcula valoarea functiei de cost

% Adaug vectorului de etichete num_labels coloane, fiecare coloana reprezentand
% o clasa, iar apoi pun 1 pe pozitia clasei indicate de y si 0 in rest
I = eye(num_labels);
y = I(y, :);

% ai - activarea fiecarui neuron din layerul i
a1 = [ones(m, 1), X];

z2 = a1 * Theta1';
a2 = sigmoid(z2);
a2 = [ones(m, 1), a2];

z3 = a2 * Theta2';
a3 = sigmoid(z3);

costf = -y .* log(a3) - (1 - y) .* log(1 - a3);
J = (1 / m) * sum(sum(costf));

% Aplic regularizarea pentru functia de cost folosindu-ma de parametrul lambda

Theta1WithoutBias = Theta1(:, 2 : end);
Theta2WithoutBias = Theta2(:, 2 : end);
J = J + (lambda / (2 * m)) * (sum(sum(Theta1WithoutBias .^ 2)) + sum(sum(Theta2WithoutBias .^ 2)));

% Algoritmul backpropagation

DELTA1 = zeros(size(Theta1));
DELTA2 = zeros(size(Theta2));

for t = 1 : m
                 x = X(t, :);
                 a1 = [1, x];

                 z2 = a1 * Theta1';
                 a2 = sigmoid(z2);
                 a2 = [1, a2];

                 z3 = a2 * Theta2';
                 a3 = sigmoid(z3);

                 yy = y(t, :);

                 delta3 = a3 - yy;
                 delta2 = (delta3 * Theta2) .* sigmoidGradient([1, z2]);

                 DELTA1 = DELTA1 + delta2(2 : end)' * a1;
                 DELTA2 = DELTA2 + delta3' * a2;
end

Theta1_grad = (1 / m) * DELTA1;
Theta2_grad = (1 / m) * DELTA2;

% Aplic regularizarea pentru derivatele partiale

Theta1_grad(:, 2 : input_layer_size + 1) = Theta1_grad(:, 2 : input_layer_size + 1) + (lambda / m) * Theta1(:, 2 : input_layer_size + 1);
Theta2_grad(:, 2 : hidden_layer_size + 1) = Theta2_grad(:, 2 : hidden_layer_size + 1) + (lambda / m) * Theta2(:, 2 : hidden_layer_size + 1);

% Transform cele 2 matrici intr-un vector
grad = [Theta1_grad(:) ; Theta2_grad(:)];

end
