net = newp([-2 2; -2 2], 1);

net.IW{1, 1} = [-1 1];
net.b{1} = 1;

plotpv([1 2 1 0; 1 2 -1 0], [1 1 0 1]);
plotpc(net.IW{1, 1}, net.b{1});