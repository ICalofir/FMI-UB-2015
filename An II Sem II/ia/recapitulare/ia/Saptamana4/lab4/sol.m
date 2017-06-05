load exempleAntrenare;
xTrain = exempleAntrenare(:, 1);
uTrain = exempleAntrenare(:, 2);

load exempleTest;
xTest = exempleTest(:, 1);
uTest = exempleTest(:, 2);

grad = 9;
eroareAntrenare = zeros(grad, 1);
eroareTeste = zeros(grad, 1);
for i = 0:grad
	P = gasestePolinomOptim(xTrain, uTrain, i);
	figure;
	hold on;
	ploteazaExemple(xTrain, uTrain);
	ploteazaGraficPolinom(P);
	axis([0 1 -1.5 1.5]);
	legend('Datele de intrare', 'Graficul polinomului');

	yTrain = polyval(P, xTrain);
	eroareAntrenare(i + 1) = calculeazaEroare(yTrain, uTrain);

	yTest = polyval(P, xTest);
	eroareTeste(i + 1) = calculeazaEroare(yTest, uTest);
end

figure;
hold on;
gradPolinom = 0:1:9;
plot(gradPolinom, eroareAntrenare, 'r');
plot(gradPolinom, eroareTeste, 'g');
legend('eroare antrenare', 'eroare test');

% h
S1 = exempleAntrenare(1:7, :);
S2 = exempleAntrenare(8:end, :);

xTrain = S1(:, 1);
uTrain = S1(:, 2);

xTest = S2(:, 1);
uTest = S2(:, 2);

grad = 9;
errMin = 0;
gradMin = grad + 1;
for i = 0:grad
	P = gasestePolinomOptim(xTrain, uTrain, i);

	yTest = polyval(P, xTest);
	err = calculeazaEroare(yTest, uTest);

	if (gradMin == grad + 1)
		gradMin = i;
		errMin = err;
	end
	if (err < errMin)
		gradMin = i;
		errMin = err;
	end
end

gradMin
