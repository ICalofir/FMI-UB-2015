% Incarc datele de test
load testData.mat

Id = (1 : size(testVectors, 1))';
Prediction = predict(Theta1, Theta2, testVectors);

tabelSol = table(Id, Prediction);
writetable(tabelSol, 'TestSubmissionFinal.csv');
