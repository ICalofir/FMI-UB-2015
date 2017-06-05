net = newp([-1 1;-1 1],1);
net.inputweights{1,1}.initFcn = 'rands';
net.biases{1}.initFcn = 'rands';