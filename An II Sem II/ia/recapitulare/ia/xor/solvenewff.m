X = [0 1 0 1; 0 0 1 1];
t = [0 1 1 0; 0 1 1 0];
net = newff(minmax(X), [2 2], {'logsig', 'logsig'});
[net, tr] = train(net, X, t);
net(X)