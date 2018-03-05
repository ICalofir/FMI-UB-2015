% cautam o functie care sa aiba solutia x = sqrt(3)
f = @(x) x - sqrt(3);

a = 1;
b = 2;

x_aprox = MetBisectie(f, a, b, 1e-5);
fprintf('Solutia este: %f\n', x_aprox);