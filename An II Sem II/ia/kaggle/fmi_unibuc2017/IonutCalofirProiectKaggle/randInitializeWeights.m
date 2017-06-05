function W = randInitializeWeights(L_in, L_out)
% Initializeaza matricea de weight-uri cu L_in intrari si L_out iesiri. Va returna
% o matrice de dimensiune (L_out, 1 + L_in), deoarece prima coloana este biasul

W = zeros(L_out, 1 + L_in);

% Initializez weight-urile
epsilon_init = 0.12;
W = rand(L_out, 1 + L_in) * 2 * epsilon_init - epsilon_init;

end
