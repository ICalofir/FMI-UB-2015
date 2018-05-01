import cifar10
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
import numpy as np
from sklearn.metrics import confusion_matrix
import time
from datetime import timedelta
import math
import os
import random

cifar10.maybe_download_and_extract()

class_names = cifar10.load_class_names()
images_train, cls_train, labels_train = cifar10.load_training_data()
images_test, cls_test, labels_test = cifar10.load_test_data()

print(images_train.shape)
print(images_test.shape)

# one hot encodings
print(labels_train.shape)
print(labels_test.shape)

# class labels
print(cls_train.shape)
print(cls_test.shape)

print("Train count {}".format(images_train.shape[0]))
print("Test count {}".format(images_test.shape[0]))

cls_ids = np.unique(cls_train)
print("Class labels {}.".format(cls_ids))

n_classes = len(cls_ids)
print("Num classes {}".format(n_classes))

# check data statistics
def get_stats(labels):
    stats = np.zeros(n_classes)
    for e in labels:
        stats[e] += 1
    return stats

# bar_width = 0.
def plot_stats(stats, title):
    plt.figure()
    x = range(n_classes)
    plt.title(title)
    plt.bar(x, stats)

y_train = cls_train
y_test = cls_test

X_train = images_train
X_test = images_test

train_stats = get_stats(y_train)
test_stats = get_stats(y_test)

plot_stats(train_stats, "Training samples/class")
plot_stats(test_stats, "Testing samples/class")

def plot_images(images, cls_true, cls_pred=None, smooth=True):
    assert len(images) == len(cls_true) == 9

    # Create figure with sub-plots.
    fig, axes = plt.subplots(3, 3)

    # Adjust vertical spacing if we need to print ensemble and best-net.
    if cls_pred is None:
        hspace = 0.3
    else:
        hspace = 0.6
    fig.subplots_adjust(hspace=hspace, wspace=0.3)

    for i, ax in enumerate(axes.flat):
        # Interpolation type.
        if smooth:
            interpolation = 'spline16'
        else:
            interpolation = 'nearest'

        # Plot image.
        ax.imshow(images[i, :, :, :],
                  interpolation=interpolation)

        # Name of the true class.
        cls_true_name = class_names[cls_true[i]]

        # Show true and predicted classes.
        if cls_pred is None:
            xlabel = "True: {0}".format(cls_true_name)
        else:
            # Name of the predicted class.
            cls_pred_name = class_names[cls_pred[i]]

            xlabel = "True: {0}\nPred: {1}".format(cls_true_name, cls_pred_name)

        # Show the classes as the label on the x-axis.
        ax.set_xlabel(xlabel)

        # Remove ticks from the plot.
        ax.set_xticks([])
        ax.set_yticks([])

    # Ensure the plot is shown correctly with multiple plots
    # in a single Notebook cell.
    plt.show()

# Get the first images from the test-set.
images = images_test[0:9]

# Get the true classes for those images.
cls_true = cls_test[0:9]

# Plot the images and labels using our helper-function above.
plot_images(images=images, cls_true=cls_true, smooth=False)

num_samples = 10

image_shape = images_train.shape[1:]

img_height, img_width = image_shape[0], image_shape[1]

print("hxw {}x{}".format(img_height, img_width))

slim = tf.contrib.slim
trunc_normal = lambda stddev: tf.truncated_normal_initializer(stddev=stddev)

def cifarnet_arg_scope(weight_decay=0.004, is_training=True):
  """Defines the default cifarnet argument scope.

  Args:
    weight_decay: The weight decay to use for regularizing the model.

  Returns:
    An `arg_scope` to use for the cifarnet model.
  """
  with slim.arg_scope(
      [slim.conv2d],
      weights_initializer=tf.truncated_normal_initializer(stddev=5e-2),
      activation_fn=tf.nn.relu):
    with slim.arg_scope(
        [slim.fully_connected],
        biases_initializer=tf.constant_initializer(0.1),
        weights_initializer=trunc_normal(0.04),
        weights_regularizer=slim.l2_regularizer(weight_decay),
        normalizer_fn=None,
        activation_fn=tf.nn.relu) as sc:
      return sc

def cifarnet_arg_scope_bnorm(weight_decay=0.004, is_training=True):
  """Defines the batch norm cifarnet argument scope.

  Args:
    weight_decay: The weight decay to use for regularizing the model.

  Returns:
       An `arg_scope` to use for the cifarnet model.
  """

  batch_norm_params = {
      'is_training': is_training,
      'center': True,
      'scale': True,
      'decay': 0.997,
      'epsilon': 0.001,
  }

  with slim.arg_scope(
      [slim.conv2d],
      # weights_initializer=tf.truncated_normal_initializer(stddev=5e-2),
      weights_initializer=tf.contrib.layers.xavier_initializer_conv2d(),
      activation_fn=tf.nn.relu6,
      normalizer_fn=slim.batch_norm):
    with slim.arg_scope([slim.batch_norm], **batch_norm_params):
      with slim.arg_scope(
          [slim.fully_connected],
          biases_initializer=tf.constant_initializer(0.1),
          # weights_initializer=trunc_normal(0.04),
          weights_initializer=tf.contrib.layers.xavier_initializer(),
          weights_regularizer=slim.l2_regularizer(weight_decay),

          activation_fn=tf.nn.relu) as sc:

          return sc

def inception_module(net, maps, scope=None, reuse=None):
  conv_1x1_map = maps[0]   # număr feature maps branch 1
  reduce_3x3_map = maps[1] # număr feature maps reduction branch 2
  reduce_5x5_map = maps[2] # număr feature maps reduction branch 3
  conv_3x3_map = maps[3]   # număr feature maps branch 2
  conv_5x5_map = maps[4]   # număr feature maps branch 3
  conv_1x1_4_map = maps[5] # număr feature maps branch 4

  with tf.variable_scope(scope, 'InceptionBlock', [net], reuse=reuse):
    with tf.variable_scope('Branch_1'):
      conv_1x1_1 = slim.conv2d(net, conv_1x1_map, [1, 1],
                                padding='SAME', scope='conv_1x1_1')
    with tf.variable_scope('Branch_2'):
      conv_1x1_2 = slim.conv2d(net, reduce_3x3_map, [1, 1],
                                padding='SAME', scope='conv_1x1_2')
      conv_3x3 = slim.conv2d(conv_1x1_2, conv_3x3_map, [3, 3],
                            padding='SAME', scope='conv_3x3')
    with tf.variable_scope('Branch_3'):
      conv_1x1_3 = slim.conv2d(net, reduce_5x5_map, [1, 1],
                                padding='SAME', scope='conv_1x1_3')
      conv_5x5 = slim.conv2d(conv_1x1_3, conv_5x5_map, [5, 5],
                              padding='SAME', scope='conv_5x5')
    with tf.variable_scope('Branch_4'):
      maxpool = slim.max_pool2d(net, [3, 3],
                                  stride=1, padding='SAME', scope='maxpool')
      conv_1x1_4 = slim.conv2d(maxpool, conv_1x1_4_map, [1, 1],
                                padding='SAME', scope='conv_1x1_4')

    net = tf.concat([conv_1x1_1, conv_3x3, conv_5x5, conv_1x1_4],
                          axis=3, name='inception')

  return net

trunc_normal = lambda stddev: tf.truncated_normal_initializer(stddev=stddev)

def cifarnet_bn(images, num_classes=10, is_training=False,
             dropout_keep_prob=0.5,
             prediction_fn=slim.softmax,
             scope='CifarNet'):

  end_points = {}

  with tf.variable_scope(scope, 'CifarNet', [images]):
    # Stem Network
    # Input: 3x28x28
    # Output: 96x28x28
    net = slim.conv2d(images, 32, [3, 3],
                     padding='SAME', scope='stem_conv1')
    net = slim.conv2d(net,96, [3, 3],
                     padding='SAME', scope='stem_conv2')

    # Inception Module 1
    # Input: 96x28x28
    # Output: 128x28x28
    net = inception_module(net, [32, 96, 16, 64, 16, 16])
    end_points['inception1'] = net

    # Inception Module 2
    # Input: 128x28x28
    # Output: 240x28x28
    net = inception_module(net, [64, 128, 32, 96, 48, 32])
    end_points['inception2'] = net

    # Maxpool
    # Input: 240x28x28
    # Output: 240x14x14
    net = slim.max_pool2d(net, [3, 3],
                             stride=2, padding='SAME', scope='maxpool')

    end_points['maxpool'] = net


    # Inception Module 3
    # Input: 240x14x14
    # Output: 256x14x14
    net = inception_module(net, [96, 96, 16, 104, 24, 32])
    end_points['inception3'] = net

    # Avgpool
    # Input: 256x14x14
    # Output: 256x4x4
    net = slim.avg_pool2d(net, [5, 5],
                             stride=3, padding='SAME', scope='avgpool')
    end_points['avgpool'] = net


    # Flatten:
    # Input: 256x4x4
    # Output: 4096
    net = slim.flatten(net)
    end_points['flatten'] = net

    net = slim.dropout(net, dropout_keep_prob, is_training=is_training,
                       scope='dropout1')

    # FC
    # Input: 4096
    # Output: 10
    logits = slim.fully_connected(net, num_classes,
                                  biases_initializer=tf.zeros_initializer(),
                                  # weights_initializer=trunc_normal(1/50.0),
                                  weights_initializer=tf.contrib.layers.xavier_initializer(),
                                  weights_regularizer=None,
                                  activation_fn=None,
                                  scope='logits')

    end_points['Logits'] = logits
    end_points['Predictions'] = prediction_fn(logits, scope='Predictions')

  return logits, end_points

# parametri de training si input
batch_size = 32
height = 32
width = 32
channels = 3
num_classes = 10
initial_learning_rate = 1e-4

def add_preprocessing(image_input, is_training):
    def _process_image(augment_level, image):
        # Because these operations are not commutative, consider randomizing
        # randomize the order their operation.
        if augment_level > 0:
            image = tf.image.random_brightness(image, max_delta=30)
            image = tf.image.random_contrast(image, lower=0.75, upper=1.25)
        if augment_level > 1:
            image = tf.image.random_saturation(image, lower=0.5, upper=1.6)
            image = tf.image.random_hue(image, max_delta=0.15)
        image = tf.minimum(image, 255.0)
        image = tf.maximum(image, 0)
        return image

    def _preprocess_train(input_tensor):
        input_tensor = tf.image.random_flip_left_right(input_tensor)

        input_tensor = tf.subtract(input_tensor, 0.5)
        input_tensor = tf.multiply(input_tensor, 2.0)

        cropped_input_tensor = tf.random_crop(input_tensor, [28,28,3])

        return cropped_input_tensor

    def _preprocess_test(input_tensor):
        input_tensor = tf.subtract(input_tensor, 0.5)
        input_tensor = tf.multiply(input_tensor, 2.0)

        cropped_input_tensor = input_tensor[2:30,2:30,:]
        return cropped_input_tensor

    preprocessed_input = tf.map_fn(lambda img:
                              tf.cond(
                                tf.equal(
                                    is_training,
                                    tf.constant(True)),
                                lambda: _preprocess_train(img),
                                lambda: _preprocess_test(img)), image_input)

    return preprocessed_input

def add_placeholders():
    # image batch input
    image_input = tf.placeholder(
        tf.float32, [None, height, width, 3],
            name='image_input'
    )

    label_input = tf.placeholder(
            tf.int64, [None],
            name='label_input'
    )
    is_training = tf.placeholder(tf.bool, name='is_training')
    learning_rate = tf.placeholder(tf.float32, shape=[])

    return image_input, label_input, is_training, learning_rate

def random_batch(img, labels, bsize=32):
    # Number of images in the training-set.
    num_images = len(img)

    # Create a random index.
    idx = np.random.choice(num_images,
                           size=bsize,
                           replace=False)

    # Use the random index to select random images and labels.
    x_batch = img[idx, :, :, :]
    y_batch = labels[idx]

    return x_batch, y_batch

x, y = random_batch(X_train, y_train)

def get_batch(imgs, labels, step, bsize=32):
    offset = (step * batch_size) % (labels.shape[0] - batch_size)
    batch_imgs = imgs[offset:(offset + bsize), :, :, :]
    batch_labels = labels[offset:(offset + bsize)]

    return batch_imgs, batch_labels

batch_imgs, batch_labels = get_batch(images_test, cls_test, 2)

print(batch_imgs.shape)
print(batch_labels.shape)

def evaluate():
  bsize = 32
  total_examples = cls_test.shape[0]
  iters = int(total_examples/bsize)


  acc = []
  losses = []

  for i in range(iters):
    x, y = get_batch(images_test, cls_test, i, bsize)

    feed_dict = {

        image_input: x,
        label_input: y,
        is_training: False

    }

    testAcc, testLoss = sess.run([accuracy, loss], feed_dict=feed_dict)
    acc.append(testAcc)
    losses.append(testLoss)
  meanAcc = np.mean(np.asarray(acc))
  meanLoss = np.mean(np.asarray(losses))

  return meanAcc, meanLoss

trainingAccuracyList = []
trainingLossList = []
testAccuracyList = []
testLossList = []
learningRateList = []

tf.reset_default_graph()

g = tf.Graph().as_default()
image_input, label_input, is_training, learning_rate = add_placeholders()
preprocessed_image_input = add_preprocessing(image_input, is_training)

arg_scope = cifarnet_arg_scope_bnorm(is_training=is_training)
with slim.arg_scope(arg_scope):
  logits, end_points = cifarnet_bn(preprocessed_image_input, is_training=is_training)

initial_learning_rate = 1e-3
num_steps = int(50000)
num_examples = images_train.shape[0]
iters = num_examples / batch_size
learning_rate_step = 10000
learning_rate_decay = 0.5

loss = tf.reduce_mean(
  tf.nn.sparse_softmax_cross_entropy_with_logits(labels=label_input, logits=logits))

# accuracy of the trained model, between 0 (worst) and 1 (best)
predictions = end_points['Predictions']

correct_prediction = tf.equal(tf.argmax(predictions, 1), label_input)
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

update_ops = tf.get_collection(tf.GraphKeys.UPDATE_OPS)
with tf.control_dependencies(update_ops):
  # Ensures that we execute the update_ops before performing the train_step
  optimizer = tf.train.AdamOptimizer(learning_rate=learning_rate).minimize(loss)

init = tf.global_variables_initializer()

sess = tf.Session()
# actually initialize our variables
sess.run(init)

running_lr = initial_learning_rate

print("Starting optimization")
print("Batch size {}".format(batch_size))
print("Initial LR {}. LR stepdown itnerval {}. LR deacy factor {}".format(running_lr, learning_rate_step, learning_rate_decay))

for i in range(num_steps):
  x, y = random_batch(X_train, y_train, bsize=batch_size)

  feed_dict = {

      image_input: x,
      label_input: y,
      is_training: True,
      learning_rate : running_lr

  }

  if i % 200 == 0:
      _, trainAcc, trainLoss = sess.run([optimizer, accuracy, loss], feed_dict=feed_dict)

      testAcc, testLoss = evaluate()

      print("Train " + str(i) + ": accuracy:" + str(trainAcc) + " loss: " + str(trainLoss))
      print("Test " + str(i) + ": accuracy:" + str(testAcc) + " loss: " + str(testLoss))

      trainingAccuracyList.append(trainAcc)
      trainingLossList.append(trainLoss)
      testAccuracyList.append(testAcc)
      testLossList.append(testLoss)
      learningRateList.append(running_lr)

  else:
      sess.run([optimizer], feed_dict=feed_dict)


  if  i > 0 and i % learning_rate_step == 0:
      print("Learning reate step down. Old {}. New {}".format(running_lr, running_lr * learning_rate_decay))
      running_lr = running_lr * learning_rate_decay

plt.figure(figsize=(20,8))

# Plot Accuracy
plt.subplot(1,2,1);
plt.plot(trainingAccuracyList, label="Train Acc");
plt.plot(testAccuracyList, label="Test Acc");
plt.title("Accuracy");
plt.legend();

# Plot Loss
plt.subplot(1,2,2);
plt.plot(trainingLossList, label="Train Loss");
plt.plot(testLossList, label="Test Loss");
plt.title("Loss");
plt.legend();

acc, test_loss = evaluate()
print("Test accuracy:" + str(acc) + " loss: " + str(test_loss))

# Save / restore model
vars_to_save = tf.global_variables()
saver = tf.train.Saver(var_list=vars_to_save)

model_name ='./ckpts/cifarnet-batchnorm.ckpt'
saver.save(sess, model_name, global_step=num_steps)
print(vars_to_save)

# test restore works
evaluate()
sess.run(init)
evaluate()
vars_to_restore = tf.global_variables()
saver = tf.train.Saver(var_list=vars_to_restore)
model_to_restore = "{}-{}".format(model_name, num_steps)
saver.restore(sess, model_to_restore)
evaluate()

x, y = get_batch(images_test, cls_test, i)

y = y[:4]
print(y)
print(num_classes)

res = tf.one_hot(indices=y, depth=num_classes)
print(sess.run(res))

# Remember

# predictions = end_points['Predictions']
# correct_prediction = tf.equal(tf.argmax(predictions, 1), label_input)
# accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

# adaugam on nod pentru one hot

labels = tf.one_hot(indices=label_input, depth=num_classes)

accuracy_streamed, update_op_acc = tf.metrics.accuracy(label_input, tf.argmax(predictions, 1))

sess.run(tf.local_variables_initializer())

vars_to_restore = tf.global_variables()
saver = tf.train.Saver(var_list=vars_to_restore)
saver.restore(sess, model_to_restore)

evaluate()

def evaluate_streaming():
  total_examples = cls_test.shape[0]
  num_batches = int(total_examples / batch_size)
  print("Total examples {}".format(total_examples))
  print("Total iters {}".format(num_batches))

  for i in range(num_batches):
    x, y = get_batch(images_test, cls_test, i)

    feed_dict = {

        image_input: x,
        label_input: y,
        is_training: False

    }

    if i % 10 == 0:
      _, test_acc = sess.run([update_op_acc, accuracy_streamed],  feed_dict=feed_dict)
      print("Test " + str(i) + ": accuracy:" + str(test_acc))
    else:
      sess.run([update_op_acc], feed_dict=feed_dict)

  test_acc = sess.run(accuracy_streamed)
  print("Mean Accuracy  {:.2f} %".format(test_acc * 100))

evaluate_streaming()
