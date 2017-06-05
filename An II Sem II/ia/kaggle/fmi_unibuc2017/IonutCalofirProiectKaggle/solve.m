%% ML

% Am ales o retea neurala cu un singur hidden layer. Input layerul are 400 de
% neuroni, hidden layerul are 50, iar output layerul are 5. Am folosit functia
% de transfer sigmoidala (logsig). Functia de cost folosita este crossentropy.
% Algoritmul folosit pentru minimizarea functiei de cost este backpropagation.

% Initializez cele 3 layere
input_layer_size  = 400;
hidden_layer_size = 50;
num_labels = 5;

% Incarc datele de train
load('trainData.mat');
X = trainVectors;
y = trainLabels;

% Numarul de exemple
m = size(X, 1);

% Impart setul initial de train in 2 seturi: train si validation. Am ales pentru
% validation sa fie 15%, iar pentru train 75%
validation = floor((15 / 100) * m);
XValidation = X(m - validation + 1 : end, :);
X = X(1 : m - validation, :);
yValidation = y(m - validation + 1 : end, :);
y = y(1 : m - validation, :);

% Setez numarul de iteratii si parametrul folosit pentru regularizare
nrIter = 1000;
lambda = 17;

% Antrenez reteaua
[Theta1 Theta2] = nnTrain(X, y, input_layer_size, hidden_layer_size, num_labels, lambda, nrIter);

% Calculez clasele de iesire pentru cele 3 seturi de date cu reteaua anterior antrenata
pTrain = predict(Theta1, Theta2, X);
pValidation = predict(Theta1, Theta2, XValidation);

fprintf('Acuratetea pe setul de train este: %f\n', mean(double(pTrain == y)) * 100);
fprintf('Acuratetea pe setul de validare este: %f\n', mean(double(pValidation == yValidation)) * 100);
