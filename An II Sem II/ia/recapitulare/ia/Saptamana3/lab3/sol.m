n = [10 10^2 10^3 10^4 10^5 10^6 10^7];
c = 10;
eroareMisclasare = zeros(1, size(n, 2));

for i = 1:size(n, 2)
	nn = n(i);

	% punctul A
	[X, Y] = genereazaMultimeAntrenare(nn, c);

	% punctul B
	gstar = aplicaClasificatorBayesian(X, c);

	% punctul C
	eroareMisclasare(i) = calculeazaEroareMisclasare(Y, gstar);
end

eroareTeoretica = 0.305785;
ploteazaEroareMisclasare(n', eroareMisclasare', eroareTeoretica);
