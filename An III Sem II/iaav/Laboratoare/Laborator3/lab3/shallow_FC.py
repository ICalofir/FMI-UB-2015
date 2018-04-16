import tensorflow as tf
from tensorflow.examples.tutorials.mnist import input_data as mnist_data

import matplotlib.pyplot as plt
import seaborn as sns
sns.set()

# Download images and labels into mnist
mnist = mnist_data.read_data_sets('data', one_hot=True, reshape=False,
                                  validation_size=0)

batchSize = None
imgHeight = 28
imgWidth = 28
numOfColors = 1
flatSize = imgHeight * imgWidth * numOfColors
numberOfClasses = 10

X_img = tf.placeholder(tf.float32, [batchSize, imgHeight, imgWidth, numOfColors],
                       name='X_img')
X_vec = tf.reshape(X_img, [-1, 784], name='X_vec')

W = tf.Variable(tf.zeros([flatSize, numberOfClasses]), name='Weights')
b = tf.Variable(tf.zeros([numberOfClasses]), name='Biases')

init = tf.global_variables_initializer()

Y_Pred_Prob = tf.nn.softmax(tf.matmul(X_vec, W) + b, name='softmax')
Y_True_Prob = tf.placeholder(tf.float32, [None, 10], name='Y_true')

cross_entropy_loss = -tf.reduce_sum(Y_True_Prob * tf.log(Y_Pred_Prob),
                                    name='Loss_Cross_Entropy')

Y_Pred_Class = tf.argmax(Y_Pred_Prob, 1, name='Y_Pred_Class')
Y_True_Class = tf.argmax(Y_True_Prob, 1, name='Y_True_Class')

is_correct = tf.equal(Y_Pred_Class, Y_True_Class, name='calcCorrect')

accuracy = tf.reduce_mean(tf.cast(is_correct, tf.float32), name='calcAcc')

alpha = 0.003
optimizer = tf.train.GradientDescentOptimizer(alpha, name='optimizer')
trainStep = optimizer.minimize(cross_entropy_loss, name='trainStep')

numberOfBatches = 10000
batchSize = 100

trainingAccuracyList = []
trainingLossList = []
testAccuracyList = []
testLossList = []

with tf.Session() as sess:
  # init variables
  sess.run(init)

  for i in range(numberOfBatches):
    batch_X, batch_Y = mnist.train.next_batch(batchSize)

    train_data = {X_img: batch_X, Y_True_Prob: batch_Y}

    sess.run(trainStep, feed_dict=train_data)

    trainAcc, trainLoss = sess.run([accuracy, cross_entropy_loss],
                                   feed_dict=train_data)

    if i % 100 == 0:
      test_data = {X_img: mnist.test.images, Y_True_Prob: mnist.test.labels}
      testAcc,testLoss = sess.run([accuracy, cross_entropy_loss], feed_dict=test_data)
      print("Train " + str(i) + ": accuracy:" + str(trainAcc) + " loss: " + str(trainLoss))
      print("Test " + str(i) + ": accuracy:" + str(testAcc) + " loss: " + str(testLoss))

      trainingAccuracyList.append(trainAcc)
      trainingLossList.append(trainLoss)
      testAccuracyList.append(testAcc)
      testLossList.append(testLoss)

plt.figure(figsize=(10, 5))

# Plot Accuracy
plt.subplot(1, 2, 1);
plt.plot(trainingAccuracyList, label="Train Acc");
plt.plot(testAccuracyList, label="Test Acc");
plt.title("Accuracy");
plt.legend();

# Plot Loss
plt.subplot(1, 2, 2);
plt.plot(trainingLossList, label="Test Loss");
plt.plot(testLossList, label="Test Loss");
plt.title("Loss");
plt.legend();

plt.show()
