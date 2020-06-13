#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun 13 22:56:32 2020

@author: cpprhtn
"""


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers import LSTM, Dropout, Dense, Activation
import datetime

data = pd.read_csv("Kor_coda.csv")
testdf = data[30:]
confirmdf = data["confirm"].values
#create windows
seq_len = 3
sequence_lenght = seq_len+1

result=[]

for index in range(len(confirmdf)-sequence_lenght):
    result.append(confirmdf[index: index + sequence_lenght])
    
#normalize data
normalized_data = []
for window in result:
    normalized_window = [((float(p)/float(window[0]))-1) for p in window]
    normalized_data.append(normalized_window)
    
    
result = np.array(normalized_data)


#training 70% test 30% 배치10 에폭시 500

#---------------------------------------------------------------------------
row = int(round(result.shape[0]*0.7))
train = result[:row,:]
#np.random.shuffle(train)

x_train= train[:,:-1]
x_train = np.reshape(x_train, (x_train.shape[0],x_train.shape[1],1))
y_train = train[:,-1]

x_test = result[row:,:-1]
x_test = np.reshape(x_test,(x_test.shape[0],x_test.shape[1],1))
y_test = result[row:,-1]

x_train.shape, x_test.shape


#build a model
model = Sequential() #모델을 순차적으로 정의하는 클래스

model.add(LSTM(200,return_sequences=True,input_shape=(3,1)))

model.add(LSTM(50,return_sequences=False))

model.add(Dense(1,activation="linear"))

model.compile(loss='mse',optimizer='rmsprop') #mse = 손실함수

model.summary()
#---------------------------------------------------------------------------


#training 90% test 10% 배치10 에폭시 500 LSTM 90,30
'''
#---------------------------------------------------------------------------

row = int(round(result.shape[0]*0.9))
train = result[:row,:]
#np.random.shuffle(train)

x_train= train[:,:-1]
x_train = np.reshape(x_train, (x_train.shape[0],x_train.shape[1],1))
y_train = train[:,-1]

x_test = result[row:,:-1]
x_test = np.reshape(x_test,(x_test.shape[0],x_test.shape[1],1))
y_test = result[row:,-1]

x_train.shape, x_test.shape



#build a model
model = Sequential() #모델을 순차적으로 정의하는 클래스

model.add(LSTM(90,return_sequences=True,input_shape=(3,1)))

model.add(LSTM(30,return_sequences=False))

model.add(Dense(1,activation="linear"))

model.compile(loss='mse',optimizer='rmsprop') #mse = 손실함수

model.summary()
#---------------------------------------------------------------------------
'''
#training
model.fit(x_train, y_train,
   validation_data=(x_test, y_test),
   batch_size=10,
   epochs=500)

#prediction
pred = model.predict(x_test)


fig = plt.figure(facecolor = "white")
ax = fig.add_subplot(111)
ax.plot(y_test, label="True")
ax.plot(pred, label="Prediction")
ax.set_title("Covid-19 Prediction Model")
ax.legend()
plt.show()

#0.05이내로 편차 : 실 인원 수 60명 이내