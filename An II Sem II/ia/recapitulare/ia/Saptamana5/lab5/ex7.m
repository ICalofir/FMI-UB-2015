P = [0 0 1 1; 0 1 0 1];
T = [0 1 1 0];

hold on;
plotpv(P, T);

net = newp(P, T);
net.trainParam.epochs = 6;
net = train(net, P, T);

plotpc(net.IW{1, 1}, net.b{1});