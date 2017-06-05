P = [0 0 0 0.5 0.5 0.5 1 1; 0 0.5 1 0 0.5 1 0 0.5];
T = [1 1 1 1 0 0 0 0];

%P = [2 1 -2 -1; 2 -2 2 1];
%T = [0 1 0 1];

hold on;
plotpv(P, T);

W = [zeros(501, 1) zeros(501, 1)];
B = zeros(501, 1);

x = 1:1:501;
y = zeros(1, 501);
for i = 2:501
    a = hardlim(W(i - 1, :) * P(:, mod(i - 2, size(T, 2)) + 1) + B(i - 1));
    e = T(mod(i - 2, size(T, 2)) + 1) - a;
    W(i, :) = W(i - 1, :) + e * P(:, mod(i - 2, size(T, 2)) + 1)';
    B(i) = B(i - 1) + e;
    
    y(i) = dot(W(i - 1, :), W(i, :)) / (norm(W(i - 1, :)) * norm(W(i, :)));
end

plotpc(W(113, :), B(113));

figure;
plot(x, y);

%net = newp(P, T);
%net.trainParam.epochs = 500;
%net = train(net, P, T);

%plotpc(net.IW{1, 1}, net.b{1});