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

tf.set_random_seed(777)


# train Parameters
seq_length = 7
data_dim = 3
hidden_dim = 15
output_dim = 1
learning_rate = 0.01
iterations = 10000





# Open, High, Low, Volume, Close
xy = pd.read_csv('test_kk.csv')

del xy['date']
xy = xy.values[1:].astype(np.float)

xy = xy[::-1]  # reverse order (chronically ordered)

# train/test split
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
X = tf.placeholder(tf.float32, [None, seq_length, data_dim])
Y = tf.placeholder(tf.float32, [None, 1])



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
'''
