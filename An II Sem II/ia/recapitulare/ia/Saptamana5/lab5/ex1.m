P = [0 0 1 1; 0 1 0 1];
T = [0 1 1 1];

net = newp(P, T);
Y = net(P)
net = train(net,P,T);
Y = net(P)

plotpv(P, T);
hold on;
plotpc(net.IW{1, 1}, net.b{1});