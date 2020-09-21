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


df = pd.read_csv('/Users/cpprhtn/Desktop/git_local/Corona-19_analysis-prediction/보고서/K_data.csv')


del df['date']
df = df.values[1:].astype(np.float)

df = df[::-1]  # 역순으로


seq_length = 7
# train/test split
train_size = int(len(df) * 0.7)
train_set = df[0:train_size]
test_set = df[train_size - seq_length:]  # Index from [train_size - seq_length] to utilize past sequence

#Scaling
scaler = MinMaxScaler()
train_set_scaling = scaler.fit(train_set)
test_set_scaling = scaler.fit(test_set)
train_set = train_set_scaling.transform(train_set)
test_set = test_set_scaling.transform(test_set)

# build datasets
def build_dataset(time_series, seq_length):
    X_data = []
    y_data = []
    for i in range(0, len(time_series) - seq_length):
        _x = time_series[i:i + seq_length, :-1]
        _y = time_series[i + seq_length, [-1]] 
        print(_x, "->", _y)
        X_data.append(_x)
        y_data.append(_y)
    return np.array(X_data), np.array(y_data)

X_tarin, y_train = build_dataset(train_set, seq_length)
X_test, y_test = build_dataset(test_set, seq_length)

# input place holders
data_dim = 3

X = tf.placeholder(tf.float32, [None, seq_length, data_dim])
Y = tf.placeholder(tf.float32, [None, 1])

hidden_dim = 32
output_dim = 1
learning_rate = 0.01
iterations = 10000
'''
#BasicLSTM
cell = tf.contrib.rnn.BasicLSTMCell(num_units=hidden_dim, state_is_tuple=True, activation=tf.nn.relu)
outputs, _states = tf.nn.dynamic_rnn(cell, X, dtype=tf.float32)
Y_pred = tf.contrib.layers.fully_connected(outputs[:, -1], output_dim, activation_fn=None)


#LSTM
cell = tf.contrib.rnn.LSTMCell(num_units=hidden_dim, state_is_tuple=True, activation=tf.nn.relu)
outputs, _states = tf.nn.dynamic_rnn(cell, X, dtype=tf.float32)
Y_pred = tf.contrib.layers.fully_connected(outputs[:, -1], output_dim, activation_fn=None)
'''
#BasicRNN
cell = tf.contrib.rnn.BasicRNNCell(num_units=hidden_dim, activation=tf.nn.relu)
outputs, _states = tf.nn.dynamic_rnn(cell, X, dtype=tf.float32)
Y_pred = tf.contrib.layers.fully_connected(outputs[:, -1], output_dim, activation_fn=None)



#cost/loss
loss = tf.reduce_sum(tf.square(Y_pred - Y))  # sum of the squares
#optimizer
optimizer = tf.train.AdamOptimizer(learning_rate)
train = optimizer.minimize(loss)

#RMSE
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
                                X: X_tarin, Y: y_train})
        print("[step: {}] loss: {}".format(i, step_loss))

    # Test step
    test_predict = sess.run(Y_pred, feed_dict={X: X_test})
    rmse_val = sess.run(rmse, feed_dict={
                    targets: y_test, predictions: test_predict})
    print("RMSE: {}".format(rmse_val))

    accuracy = tf.reduce_mean(tf.cast(test_predict, tf.float32))
    print('Accuracy:', sess.run(accuracy, feed_dict={
        X: X_test, Y: y_test, keep_prob: 1}))

    # Plot predictions
    plt.plot(y_test, label="True")
    plt.plot(test_predict, label="Prediction")
    plt.xlabel("Date")
    plt.ylabel("Increase")
    plt.title("BasicRNN Prediction", fontsize=20)
    plt.legend()
    plt.show()



# hidden layer -> 128
    
#BasicRNN
'''
앞부분은 다운피팅, 뒷부분은 오버피팅 형태,,
깜깜이 감염자? 영향인가;;; 
제공 데이터 문제.
'''

#BasicLSTM, LSTM
'''
BasicLSTM_RMSE: 0.36206287145614624
처음 끝은 잘 나온듯;
중간부분에서 True 값은 크게 증가(사랑 제일교회발 확진)
반대로 Prediction 값은 감소

음,, 
'''




# hidden layer -> 64

#BasicLSTM
'''
RMSE: 0.6035501956939697

오버피팅.

증감폭이 큼
'''

#LSTM
'''
RMSE: 0.2377423197031021

처음엔 다운피팅 끝에는 오버피팅 경향
'''

#BasicRNN
'''
RMSE: 0.2378769814968109

낫 베드
'''



# hidden layer -> 32

#BasicRNN
'''
RMSE: 0.25204241275787354

25~30구간이 문제
'''




