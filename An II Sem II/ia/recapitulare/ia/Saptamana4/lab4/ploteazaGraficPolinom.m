function ploteazaGraficPolinom(P)

X = 0:0.001:1;
Y = polyval(P, X);
plot(X, Y);

end
