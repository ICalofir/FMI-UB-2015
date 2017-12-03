import os
import numpy as np
import matplotlib.pyplot as plt

def unpickle(file):
    import pickle
    with open(file, 'rb') as fo:
        dict = pickle.load(fo, encoding='bytes')
    return dict

label_names = unpickle('../data/cifar-10-batches-py/batches.meta')
for label_name in label_names[b'label_names']:
    dir_name = label_name.decode('utf-8')
    directory_path = '../data/' + dir_name
    if not os.path.exists(directory_path):
        os.makedirs(directory_path)

nr = [0 for _ in range(10)]
for j in range(1, 6):
    data_name = '../data/cifar-10-batches-py/data_batch_' + str(j)
    data = unpickle(data_name)
    for i in range(len(data[b'labels'])):
        label = data[b'labels'][i]
        label_name = label_names[b'label_names'][label].decode('utf-8')

        nr[label] += 1

        img = np.empty((32, 32, 3), dtype=np.uint8)
        img[:, :, 0] = np.reshape(data[b'data'][i][:1024], (-1, 32))
        img[:, :, 1] = np.reshape(data[b'data'][i][1024:2048], (-1, 32))
        img[:, :, 2] = np.reshape(data[b'data'][i][2048:3072], (-1, 32))

        plt.imsave('../data/' + label_name + '/' + label_name + '_' + str(nr[label]) + '.png', img)
