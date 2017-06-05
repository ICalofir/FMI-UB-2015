% a
mu0 = [1 0];
sig0 = [1 -.4; -.4 .5];
mu1 = [0 1];
sig1 = [.5 .3; .3 .5];

x = -5:.2:5;
y = -5:.2:5;
[X, Y] = meshgrid(x, y);
% mvnpdf - multivariate normal probability density function, gaussian distribution 2d
Z0 = mvnpdf([X(:) Y(:)], mu0, sig0);
Z0 = reshape(Z0, length(x), length(y));
Z1 = mvnpdf([X(:) Y(:)], mu1, sig1);
Z1 = reshape(Z1, length(x), length(y));

% integrala dubla
IZ0 = trapz(y, trapz(x, Z0, 2));
IZ1 = trapz(y, trapz(x, Z1, 2));

hold on;
surf(X, Y, Z0);
surf(X, Y, Z1);
figure;
hold on;
contour(X, Y, Z0);
contour(X, Y, Z1);

% b
p = .25;
Z = p * Z1 + (1 - p) * Z0;

IZ = trapz(y, trapz(x, Z, 2));

figure;
surf(X, Y, Z);
figure;
contour(X, Y, Z);

% c
% eta = (p * Z1) / (p * Z1 + (1 - p) * Z0); % seminar 21.03.2017
eta = p * Z1 - (1 - p) * Z0; % dar asta e formula folosita de prof, de ce???
L_star = trapz(y, trapz(x, min(p * Z1, (1 - p) * Z0)));

figure;
surfc(X, Y, eta);
figure;
contour(X, Y, eta, [0 0], 'ShowText', 'on'); % contour la eta(x) = 0; (Z = 0)

% d
N = 100; % nr de puncte
N1 = p * N; % cate puncte din cele N sunt din clasa 1
N0 = N - N1; % puncte din clasa 0
% puncte random cu distributie gaussiana
P0 = mvnrnd(mu0, sig0, N0);
P1 = mvnrnd(mu1, sig1, N1);
figure;
hold on;
plot(P0(:, 1), P0(:, 2), 'ro');
plot(P1(:, 1), P1(:, 2), 'bo');

% e
y0 = zeros(N0, 1); % ??
y1 = ones(N1, 1); % ??
XR = [P0; P1]; % ??
YR = [y0; y1]; % ??
LDiscr = fitcdiscr(XR, YR); % ??
LDcoeff = struct2cell(LDiscr.Coeffs(1, 2)); % ??
g_LD=[X(:), Y(:)] * LDcoeff{3, 1} + LDcoeff{2, 1}; % ??
g_LD = reshape(g_LD, length(x), length(y));
title('Theoret. Bayes and estim. Linear Discrim decisions curves');
contour(X, Y, g_LD, [0 0], 'ShowText', 'on'); % culoare si grosime diferita de eta
contour(X, Y, eta, [0 0], 'ShowText', 'on');

% f
[labelLD, PosteriorLD, CostLD] = predict(LDiscr, XR);
% Matricea de confuzie
figure
plotconfusion(YR', labelLD', 'Regression')
[cR, cmR, indR, perR] = confusion(YR', labelLD');
% Curba ROC
figure
plotroc(YR', labelLD')
title('Regression ROC Curve')
[tprR, fprR, thresholdsR] = roc(YR', labelLD');

% g
NBDiscr = fitcnb(XR, YR); % estimeaza Naive Bayes
[labelNB, PosteriorNB, CostND]=predict(NBDiscr, XR);
% Matricea de confuzie
figure
plotconfusion(YR', labelNB', 'Bayes')
[cB, cmB, indB, perB] = confusion(YR', labelNB');
% Curba ROC
figure
plotroc(YR', labelNB')
title('Bayes ROC Curve')
[tprB, fprB, thresholdsB] = roc(YR', labelNB');