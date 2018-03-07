from utils import *
from shallow_net import ShallowNet

from keras.datasets import cifar10
from keras.datasets import mnist

import numpy as np

def preprocess_dataset(X_train, y_train, X_val, y_val, X_test, y_test):
    X_train = X_train.reshape(y_train.shape[0], -1)
    X_test = X_test.reshape(y_test.shape[0], -1)
    X_val = X_val.reshape(y_val.shape[0], -1)
    X_train = X_train.astype('float32')
    X_test = X_test.astype('float32')
    X_val = X_val.astype('float32')
    y_train = y_train.reshape(y_train.shape[0])
    y_test = y_test.reshape(y_test.shape[0])
    y_val = y_val.reshape(y_val.shape[0])
    mean_image = np.mean(X_train, axis=0)
    X_train -= mean_image
    X_test -= mean_image
    X_val -= mean_image
    return X_train, y_train, X_val, y_val, X_test, y_test

def show_net_weights(net, param_key):
    W1 = net.params[param_key]
    W1 = W1.reshape(32, 32, 3, -1).transpose(3, 0, 1, 2)
    plt.imshow(visualize_grid(W1, padding=3).astype('uint8'))
    plt.gca().axis('off')
    plt.show()

(X_train, y_train), (X_test, y_test) = cifar10.load_data()
X_val = X_train[40000:]
X_train = X_train[:40000]
y_val = y_train[40000:]
y_train = y_train[:40000]

X_train, y_train, X_val, y_val, X_test, y_test = preprocess_dataset(X_train, y_train, X_val, y_val, X_test, y_test)
print('Train data shape: ', X_train.shape)
print('Train labels shape: ', y_train.shape)
print('Val data shape: ', X_val.shape)
print('Val labels shape: ', y_val.shape)
print('Test data shape: ', X_test.shape)
print('Test labels shape: ', y_test.shape)

input_size = 32
input_channels = 3
input_dim = input_channels * input_size * input_size
hidden_dim = 50
num_classes = 10
net = ShallowNet(input_dim, hidden_dim, num_classes)
# Antrenam reteaua
stats = net.train(np.concatenate([X_train, X_test], 0), np.concatenate([y_train, y_test], 0), X_val, y_val,
            num_iters=1000, batch_size=200,
            learning_rate=1e-4, learning_rate_decay=0.95,
            reg=0.25, verbose=True)

# Facem preziceri pe datasetul de test si calculam acuratetea
test_acc = (net.predict(X_val) == y_val).mean()
print('Test accuracy: ', test_acc)

# Plot the loss function and train / validation accuracies
plt.subplot(2, 1, 1)
plt.plot(stats['loss_history'])
plt.title('Loss history')
plt.xlabel('Iteration')
plt.ylabel('Loss')

plt.subplot(2, 1, 2)
plt.plot(stats['train_acc_history'], label='train')
plt.plot(stats['val_acc_history'], label='val')
plt.title('Classification accuracy history')
plt.xlabel('Epoch')
plt.ylabel('Clasification accuracy')
plt.show()

show_net_weights(net, 'fc1_w')

#################################################################################
# TODO: Tunarea hiperparametrilor pe datele de validare.                        #
# Cel mai bun model trebuie stocat in best_net.                                 #
# Hint: Cea mai simpla tunare poate fi o iterare prin mai multe valori ale      #                            #
# parametrilor pentru hidden_dim, learning_rate, l2_reg, etc.  Departajarea     #
# celui mai bun model se poate face dupa acuratete                              #
#################################################################################
hidden_dim_arr = [50, 100, 200]
learning_rate_arr = [1e-3, 1e-4]
reg_arr = [0.003, 0.01, 0.03, 0.1, 0.3, 1]

input_size = 32
input_channels = 3
input_dim = input_channels * input_size * input_size
num_classes = 10

nets = []
for hidden_dim_val in hidden_dim_arr:
    for learning_rate_val in learning_rate_arr:
        for reg_val in reg_arr:
            net = ShallowNet(input_dim, hidden_dim, num_classes)
            # Antrenam reteaua
            stats = net.train(np.concatenate([X_train, X_test], 0), np.concatenate([y_train, y_test], 0), X_val, y_val,
                num_iters=1000, batch_size=200,
                learning_rate=learning_rate_val, learning_rate_decay=0.95,
                reg=reg_val, verbose=True)

            test_acc = (net.predict(X_val) == y_val).mean()
            nets.append((net, test_acc))
            print(test_acc, hidden_dim_val, learning_rate_val, reg_val)
nets.sort(key=lambda v: v[1])
nets.reverse()
#################################################################################
#                               END OF YOUR CODE                                #
#################################################################################

best_net = nets[0][0] # cel mai bun model

# visualize the weights of the best network
show_net_weights(best_net, 'fc1_w')

test_acc = (best_net.predict(X_val) == y_val).mean()
print('Test accuracy: ', test_acc)
