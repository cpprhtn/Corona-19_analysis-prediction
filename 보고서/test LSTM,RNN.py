#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Sep 20 12:56:07 2020

@author: cpprhtn
"""



import tensorflow as tf
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.preprocessing import MinMaxScaler

tf.reset_default_graph()
tf.set_random_seed(333)

# Open, High, Low, Volume, Close
xy = pd.read_csv('/Users/cpprhtn/Desktop/git_local/Corona-19_analysis-prediction/보고서/K_data.csv')


del xy['date']
xy = xy.values[1:].astype(np.float)

xy = xy[::-1]  # reverse order (chronically ordered)

# train/test split
seq_length = 7

train_size = int(len(xy) * 0.7)
train_set = xy[0:train_size]
test_set = xy[train_size - seq_length:]  # Index from [train_size - seq_length] to utilize past sequence

# Scale each
min_max = MinMaxScaler()
train_set_scaling = min_max.fit(train_set)
test_set_scaling = min_max.fit(test_set)
train_set = train_set_scaling.transform(train_set)
test_set = test_set_scaling.transform(test_set)

print(train_set)
print('+'*40)
print(test_set)
print('+'*40)

# build datasets
def build_dataset(time_series, seq_length):
    dataX = []
    dataY = []
    for i in range(0, len(time_series) - seq_length):
        _x = time_series[i:i + seq_length, :-1]
        _y = time_series[i + seq_length, [-1]]  # Next close price
        print(_x, "->", _y)
        dataX.append(_x)
        dataY.append(_y)
    return np.array(dataX), np.array(dataY)

trainX, trainY = build_dataset(train_set, seq_length)
testX, testY = build_dataset(test_set, seq_length)

# input place holders
data_dim = 3

X = tf.placeholder(tf.float32, [None, seq_length, data_dim])
Y = tf.placeholder(tf.float32, [None, 1])

hidden_dim = 128
output_dim = 1
learning_rate = 0.01
iterations = 10000
'''
# build a LSTM network
cell = tf.contrib.rnn.BasicLSTMCell(
    num_units=hidden_dim, state_is_tuple=True, activation=tf.nn.relu)
outputs, _states = tf.nn.dynamic_rnn(cell, X, dtype=tf.float32)
Y_pred = tf.contrib.layers.fully_connected(
    outputs[:, -1], output_dim, activation_fn=None)  # We use the last cell's output
'''
# build a BasicRNN network
cell = tf.contrib.rnn.BasicRNNCell(
    num_units=hidden_dim, activation=tf.nn.relu)
outputs, _states = tf.nn.dynamic_rnn(cell, X, dtype=tf.float32)
Y_pred = tf.contrib.layers.fully_connected(
    outputs[:, -1], output_dim, activation_fn=None)  # We use the last cell's output


# cost/loss
loss = tf.reduce_sum(tf.square(Y_pred - Y))  # sum of the squares
# optimizer
optimizer = tf.train.AdamOptimizer(learning_rate)
train = optimizer.minimize(loss)

# RMSE
targets = tf.placeholder(tf.float32, [None, 1])
predictions = tf.placeholder(tf.float32, [None, 1])
rmse = tf.sqrt(tf.reduce_mean(tf.square(targets - predictions)))

keep_prob = tf.placeholder(tf.float32)

with tf.Session() as sess:
    init = tf.global_variables_initializer()
    sess.run(init)

    # Training step
    for i in range(iterations):
        _, step_loss = sess.run([train, loss], feed_dict={
                                X: trainX, Y: trainY})
        print("[step: {}] loss: {}".format(i, step_loss))

    # Test step
    test_predict = sess.run(Y_pred, feed_dict={X: testX})
    rmse_val = sess.run(rmse, feed_dict={
                    targets: testY, predictions: test_predict})
    print("RMSE: {}".format(rmse_val))
    # print(min_max.inverse_transform(test_predict))

    accuracy = tf.reduce_mean(tf.cast(test_predict, tf.float32))
    print('Accuracy:', sess.run(accuracy, feed_dict={
        X: testX, Y: testY, keep_prob: 1}))

    # Plot predictions
    plt.plot(testY, label="True")
    plt.plot(test_predict, label="Prediction")
    plt.xlabel("Date")
    plt.ylabel("Increase")
    plt.title("BasicRNN Prediction", fontsize=20)
    plt.legend()
    plt.show()



# hidden layer -> 128
'''
앞부분은 다운피팅, 뒷부분은 오버피팅 형태,,
깜깜이 감염자? 영향인가;;; 
제공 데이터 문제.
'''


