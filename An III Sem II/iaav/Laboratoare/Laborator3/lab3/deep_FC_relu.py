import tensorflow as tf
from tensorflow.examples.tutorials.mnist import input_data as mnist_data
import math
import pickle

import matplotlib.pyplot as plt
import seaborn as sns
sns.set()

# Download images and labels into mnist.test (10K images+labels) and mnist.train (60K images+labels)
mnist = mnist_data.read_data_sets("data", one_hot=True, reshape=False, validation_size=0)

probKeep = tf.placeholder(tf.float32, name="Prob_Keep")

PROBKEEP = 0.75

batchSize = None;       # put None for right now as we dont know yet

imgHeight = 28
imgWidth = 28
numOfColors = 1         # gray scale images

flatSize = imgHeight*imgWidth*numOfColors   # 728

numberOfClasses = 10    # 10 classes: 0-9

# Size of each layer:
sizeLayerOne = 200
sizeLayerTwo = 100
sizeLayerThree = 60
sizeLayerFour = 30
sizeLayerFive = numberOfClasses       # the final layer is the output layer

# Input Data
X_img = tf.placeholder(tf.float32, [batchSize, imgHeight, imgWidth, numOfColors], name="X_img")
X_vec = tf.reshape(X_img, [-1, 784], name="X_vec")

Y_True = tf.placeholder(tf.float32, [batchSize, 10])

learningRate = tf.placeholder(tf.float32)

with tf.name_scope("Layer_1"):
  # Weights
  W1 = tf.Variable(tf.truncated_normal([flatSize, sizeLayerOne], stddev=0.1), name="Weights")

  # Biases
  b1 = tf.Variable(tf.zeros([sizeLayerOne]), name="Biases")

  # ReLu Activation
  Y1 = tf.nn.relu(tf.matmul(X_vec, W1) + b1, name="Activation")

  # Dropout
  Y1_Dropout = tf.nn.dropout(Y1, probKeep)

with tf.name_scope("Layer_2"):
  # Weights
  W2 = tf.Variable(tf.truncated_normal([sizeLayerOne, sizeLayerTwo], stddev=0.1), name="Weights")

  # Biases
  b2 = tf.Variable(tf.zeros([sizeLayerTwo]), name="Biases")

  # ReLu Activation - Working on previous layers Dropout
  Y2 = tf.nn.relu(tf.matmul(Y1_Dropout, W2) + b2, name="Activation")

  # Dropout
  Y2_Dropout = tf.nn.dropout(Y2, probKeep)

with tf.name_scope("Layer_3"):
  # Weights
  W3 = tf.Variable(tf.truncated_normal([sizeLayerTwo, sizeLayerThree], stddev=0.1), name="Weights")

  # Biases
  b3 = tf.Variable(tf.zeros([sizeLayerThree]), name="Biases")

  # ReLu Activation - Working on previous layers Dropout
  Y3 = tf.nn.relu(tf.matmul(Y2_Dropout, W3) + b3, name="Activation")

  # Dropout
  Y3_Dropout = tf.nn.dropout(Y3, probKeep)

with tf.name_scope("Layer_4"):
  # Weights
  W4 = tf.Variable(tf.truncated_normal([sizeLayerThree, sizeLayerFour], stddev=0.1), name="Weights")

  # Biases
  b4 = tf.Variable(tf.zeros([sizeLayerFour]), name="Biases")

  # ReLu Activation - Working on previous layers Dropout
  Y4 = tf.nn.relu(tf.matmul(Y3_Dropout, W4) + b4, name="Activation")

  # Dropout
  Y4_Dropout = tf.nn.dropout(Y4, probKeep)

with tf.name_scope("Output_Layer"):
  # Weights
  W5 = tf.Variable(tf.truncated_normal([sizeLayerFour, sizeLayerFive], stddev=0.1), name="Weights")

  # Biases
  b5 = tf.Variable(tf.zeros([sizeLayerFive]), name="Biases")

  # Output logits - Working on previous layers Dropout
  Y_logits = tf.matmul(Y4_Dropout, W5) + b5

  # Softmax Activation
  Y_Pred = tf.nn.softmax(Y_logits, name="Activation")

cross_entropy = tf.nn.softmax_cross_entropy_with_logits_v2(logits=Y_logits, labels=Y_True)
cross_entropy = tf.reduce_mean(cross_entropy)*100

# accuracy of the trained model, between 0 (worst) and 1 (best)
correct_prediction = tf.equal(tf.argmax(Y_Pred, 1), tf.argmax(Y_True, 1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

# training step
trainStep = tf.train.AdamOptimizer(learningRate).minimize(cross_entropy)

numberOfBatches = 10000+1
batchSize = 100

trainingAccuracyList = []
trainingLossList = []
testAccuracyList = []
testLossList = []

maxLearningRate = 0.003
minLearningRate = 0.0001
decaySpeed = 2000.0   # 0.003-0.0001-2000=>0.9826 done in 5000 iterations

init = tf.global_variables_initializer()
with tf.Session() as sess:
  # actually initialize our variables
  sess.run(init)

  # batch-minimization loop
  for i in range(numberOfBatches):
    # get this batches data
    batch_X, batch_Y = mnist.train.next_batch(batchSize)

    # calculate new learning rate for this batch:
    learning_Rate = minLearningRate + (maxLearningRate - minLearningRate) * math.exp(-i/decaySpeed)

    # setup this batches input dictionary
    #     - including the new learning rate
    #     - and the dropout/probKeep value
    train_data = {X_img: batch_X, Y_True: batch_Y, learningRate: learning_Rate, probKeep: PROBKEEP}

    # run the training step on this batch
    sess.run(trainStep, feed_dict=train_data)

    # check our accuracy on training and test data
    # while resetting dropout!
    if i%100 == 0:
      # compute our success on the training data
      train_data_to_test_on = {X_img: batch_X, Y_True: batch_Y, learningRate: learning_Rate, probKeep: 1.0}
      trainAcc, trainLoss = sess.run([accuracy, cross_entropy], feed_dict=train_data_to_test_on)

      # compute our success on the test data
      test_data = {X_img: mnist.test.images, Y_True: mnist.test.labels, probKeep: 1.0}
      testAcc,testLoss = sess.run([accuracy, cross_entropy], feed_dict=test_data)
      print("Train " + str(i) + ": accuracy:" + str(trainAcc) + " loss: " + str(trainLoss))
      print("Test " + str(i) + ": accuracy:" + str(testAcc) + " loss: " + str(testLoss))

      trainingAccuracyList.append(trainAcc)
      trainingLossList.append(trainLoss)
      testAccuracyList.append(testAcc)
      testLossList.append(testLoss)

      print("Batch number: ",i, "lr: ", learning_Rate, "Test Loss: ", testLoss)

plt.figure(figsize=(20,8))

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

plt.figure(figsize=(20,8))

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
with open("mnist-2.2-results.txt", "wb") as fp:   #Pickling
  pickle.dump(resultsDic, fp)

with open("mnist-2.0-results.txt", "rb") as fp:
  mnist21_resultsDic = pickle.load(fp)

plt.figure(figsize=(20,8))

# Plot Accuracy
plt.subplot(1,2,1);
plt.plot(trainingAccuracyList, label="Train Acc");
plt.plot(testAccuracyList, label="Test Acc");

plt.plot(mnist21_resultsDic["trainAcc"], label="2.1 - Train Acc");
plt.plot(mnist21_resultsDic["testAcc"], label="2.1 - Test Acc");

plt.title("Comparing Accuracy");
plt.legend();

# Plot Loss
plt.subplot(1,2,2);
plt.plot(trainingLossList, label="Test Loss");
plt.plot(testLossList, label="Test Loss");

plt.plot(mnist21_resultsDic["trainLoss"], label="2.1 - Train Loss");
plt.plot(mnist21_resultsDic["testLoss"], label="2.1 - Test Loss");

plt.title("Loss");
plt.legend();

plt.show()

tailLength = -90

plt.figure(figsize=(20,8))

# Plot Accuracy
plt.subplot(1,2,1);
plt.plot(trainingAccuracyList[tailLength:], label="Train Acc");
plt.plot(testAccuracyList[tailLength:], label="Test Acc");

plt.plot(mnist21_resultsDic["trainAcc"][tailLength:], label="2.1 - Train Acc", alpha=0.3, linestyle=':');
plt.plot(mnist21_resultsDic["testAcc"][tailLength:], label="2.1 - Test Acc", alpha=0.3, linestyle=':');

plt.title("Comparing Accuracy");
plt.legend();

# Plot Loss
plt.subplot(1,2,2);
plt.plot(trainingLossList[tailLength:], label="Test Loss");
plt.plot(testLossList[tailLength:], label="Test Loss", linewidth=5);

plt.plot(mnist21_resultsDic["trainLoss"][tailLength:], label="2.1 - Train Loss", alpha=0.3, linestyle=':');
plt.plot(mnist21_resultsDic["testLoss"][tailLength:], label="2.1 - Test Loss", alpha=0.3, linestyle=':');

plt.title("Loss");
plt.legend();

plt.show()
