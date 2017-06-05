X = [0 1 0 1; 0 0 1 1];
t = [0 1 1 0];
net = patternnet([2]);
net.divideFcn = '';
[net, tr] = train(net, X, t);
net(X)