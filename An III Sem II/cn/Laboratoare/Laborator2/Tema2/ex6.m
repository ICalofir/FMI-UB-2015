% b
A = [0, 1, 1; 2, 1, 5; 4, 2, 1];
b = [3; 5; 1];
x_I = GaussFaraPiv(A, b)
X_II = GaussPivPart(A, b)
X_III = GaussPivTot(A, b)

A = [0, 1, -2; 1, -1, 1; 1, 0, -1];
b = [4; 6; 2];
x_I = GaussFaraPiv(A, b)
X_II = GaussPivPart(A, b)
X_III = GaussPivTot(A, b)

% c
eps = 10^(-20);
A = [eps * 1, 1; 1, 1];
b = [1; 2];
x_I = GaussFaraPiv(A, b)
X_II = GaussPivPart(A, b)

C = 10^20;
A = [2, 2 * C * 1; 1, 1];
b = [2 * C; 2];
X_II = GaussPivPart(A, b)
X_III = GaussPivTot(A, b)