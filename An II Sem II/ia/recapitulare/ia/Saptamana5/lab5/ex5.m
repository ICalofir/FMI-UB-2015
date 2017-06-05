P = [2 1 -2 -1; 2 -2 2 1];
T = [0 1 0 1];

net = newp(P, T);
net.trainParam.epochs = 1;
net = train(net, P, T);

hold on;
plotpv(P, T);
plotpc(net.IW{1, 1}, net.b{1});

net = newp(P, T);
net.trainParam.epochs = 4;
net = train(net, P, T);
figure;
hold on;
plotpv(P, T);
plotpc(net.IW{1, 1}, net.b{1});