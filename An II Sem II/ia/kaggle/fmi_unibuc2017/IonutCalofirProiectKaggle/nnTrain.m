function [Theta1 Theta2] = nnTrain(X, y, input_layer_size, hidden_layer_size, num_labels, lambda, nrIter)

% Initializez cele 2 matrici de weight-uri cu o valoare random
initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

% Transform cele 2 matrici intr-un vector
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

% Setez numarul de iteratii si parametrul folosit pentru regularizare
options = optimset('MaxIter', nrIter);

% Modific functia nnCostFunction sa primeasca doar un parametru, vectorul de weight-uri
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

% Antrenez reteaua neurala, minimizand functia de cost cu ajutorul functiei din MATLAB fmincg.
% Aceasta functie primeste ca parametrii o functie care returneaza valoarea functiei de cost
% si derivatele partiale si mai primeste si vectorul initial de weight-uri. Ea va intoarce un vector
% cu weight-uri care minimizeaza functia de cost.
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% Transform inapoi din vectorul de weight-uri in cele 2 matrici
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

end

