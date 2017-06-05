% Initializez cele 3 layere
input_layer_size  = 400;
hidden_layer_size = 50;
num_labels = 5;

% Incarc datele de train
load('trainData.mat');
X = trainVectors;
y = trainLabels;

% Setez numarul de iteratii si parametrul folosit pentru regularizare
nrIter = 1000;
lambda = 17;

% 10-fold cross-validation
[accuracy_k_fold_cv C] = kFoldCV(X, y, input_layer_size, hidden_layer_size, num_labels, lambda, nrIter, 10);
