import tensorflow as tf
from tensorflow.examples.tutorials.mnist import input_data as mnist_data
import pickle

import matplotlib.pyplot as plt
import seaborn as sns
sns.set()

mnist = mnist_data.read_data_sets("data", one_hot=True, reshape=False, validation_size=0)

batchSize = None

imgHeight = 28
imgWidth = 28
numOfColors = 1

flatSize = imgHeight * imgWidth * numOfColors

numberOfClasses = 10

sizeLayerOne = 200
sizeLayerTwo = 100
sizeLayerThree = 60
sizeLayerFour = 30
sizeLayerFive = numberOfClasses

X_img = tf.placeholder(tf.float32, [batchSize, imgHeight, imgWidth, numOfColors],
                       name='X_img')
X_vec = tf.reshape(X_img, [-1, 784], name='X_vec')

Y_True = tf.placeholder(tf.float32, [batchSize, numberOfClasses])

with tf.name_scope('Layer_1'):
  W1 = tf.Variable(tf.truncated_normal([flatSize, sizeLayerOne], stddev=0.1),
                   name='W1')
  b1 = tf.Variable(tf.zeros([sizeLayerOne]), name='b1')

  Y1 = tf.nn.sigmoid(tf.matmul(X_vec, W1) + b1, 'A1')

with tf.name_scope('Layer_2'):
  W2 = tf.Variable(tf.truncated_normal([sizeLayerOne, sizeLayerTwo], stddev=0.1),
                   name='W2')
  b2 = tf.Variable(tf.zeros([sizeLayerTwo]), name='b2')

  Y2 = tf.nn.sigmoid(tf.matmul(Y1, W2) + b2, 'A2')

with tf.name_scope('Layer_3'):
  W3 = tf.Variable(tf.truncated_normal([sizeLayerTwo, sizeLayerThree], stddev=0.1),
                   name='W3')
  b3 = tf.Variable(tf.zeros([sizeLayerThree]), name='b3')

  Y3 = tf.nn.sigmoid(tf.matmul(Y2, W3) + b3, 'A3')

with tf.name_scope('Layer_4'):
  W4 = tf.Variable(tf.truncated_normal([sizeLayerThree, sizeLayerFour], stddev=0.1),
                   name='W4')
  b4 = tf.Variable(tf.zeros([sizeLayerFour]), name='b4')

  Y4 = tf.nn.sigmoid(tf.matmul(Y3, W4) + b4, 'A4')

with tf.name_scope("Output_Layer"):
    # Weights
    W5 = tf.Variable(tf.truncated_normal([sizeLayerFour, sizeLayerFive], stddev=0.1), name="Weights")

    # Biases
    b5 = tf.Variable(tf.zeros([sizeLayerFive]), name="Biases")

    # Output logits
    Y_logits = tf.matmul(Y4, W5) + b5

    # Softmax Activation
    Y_Pred = tf.nn.softmax(Y_logits, name="Activation")

cross_entropy = tf.nn.softmax_cross_entropy_with_logits_v2(logits=Y_logits,
                                                           labels=Y_True)
cross_entropy = tf.reduce_mean(cross_entropy) * 100

correct_prediction = tf.equal(tf.argmax(Y_Pred, 1), tf.argmax(Y_True, 1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

learning_rate = 0.003
trainStep = tf.train.AdamOptimizer(learning_rate).minimize(cross_entropy)

numberOfBatches = 10000
batchSize = 100

trainingAccuracyList = []
trainingLossList = []
testAccuracyList = []
testLossList = []

init = tf.global_variables_initializer()
with tf.Session() as sess:
  # actually initialize our variables
  sess.run(init)

  # batch-minimization loop
  for i in range(numberOfBatches):
    # get this batches data
    batch_X, batch_Y = mnist.train.next_batch(batchSize)

    # setup this batches input dictionary
    train_data = {X_img: batch_X, Y_True: batch_Y}

    # run the training step on this batch
    sess.run(trainStep, feed_dict=train_data)

    # compute this batches success on the training data
    trainAcc, trainLoss = sess.run([accuracy, cross_entropy], feed_dict=train_data)

    if i%100 == 0:
      # compute our success on the test data
      test_data = {X_img: mnist.test.images, Y_True: mnist.test.labels}
      testAcc,testLoss = sess.run([accuracy, cross_entropy], feed_dict=test_data)
      print("Train " + str(i) + ": accuracy:" + str(trainAcc) + " loss: " + str(trainLoss))
      print("Test " + str(i) + ": accuracy:" + str(testAcc) + " loss: " + str(testLoss))

      trainingAccuracyList.append(trainAcc)
      trainingLossList.append(trainLoss)
      testAccuracyList.append(testAcc)
      testLossList.append(testLoss)

      print("Batch number: ", i)

plt.figure(figsize=(10,5))

# Plot Accuracy
plt.subplot(1,2,1);
plt.plot(trainingAccuracyList, label="Train Acc");
plt.plot(testAccuracyList, label="Test Acc");
plt.title("Accuracy");
plt.legend();

# Plot Loss
plt.subplot(1,2,2);
plt.plot(trainingLossList, label="Test Loss");
plt.plot(testLossList, label="Test Loss");
plt.title("Loss");
plt.legend();

plt.show()


tailLength = -90

plt.figure(figsize=(10,5))

# Plot Accuracy
plt.subplot(1,2,1);
plt.plot(trainingAccuracyList[tailLength:], label="Train Acc");
plt.plot(testAccuracyList[tailLength:], label="Test Acc");
plt.title("Accuracy");
plt.legend();

# Plot Loss
plt.subplot(1,2,2);
plt.plot(trainingLossList[tailLength:], label="Test Loss");
plt.plot(testLossList[tailLength:], label="Test Loss");
plt.title("Loss");
plt.legend();

plt.show()

resultsDic = {"trainAcc": trainingAccuracyList, "trainLoss": trainingLossList, "testAcc": testAccuracyList, "testLoss": testLossList}
with open("mnist-2.0-results.txt", "wb") as fp:   #Pickling
    pickle.dump(resultsDic, fp)
