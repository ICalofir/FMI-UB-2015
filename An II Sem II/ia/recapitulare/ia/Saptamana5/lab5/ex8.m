P = [0 0 2 2 4 4 6 6 3 1 2 1; 0 6 2 4 2 4 0 6 3 1 1 3];
T = [0 0 1 1 1 1 0 0 1 0 0 0];

PP = P;

P = [P; P(1, :) .^ 2; P(2, :) .^ 2];

net = newp(P, T);
net = train(net, P, T);

hold on;
axis([-10 10 -10 10]);
PP = PP';
plot(PP(:, 1), PP(:, 2), 'ro');
plotDecisionBoundary(net.IW{1, 1}, net.b{1});