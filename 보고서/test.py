#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Sep 12 22:58:45 2020

@author: cpprhtn
"""



import pandas as pd
import numpy as np
import datetime
import matplotlib.pyplot as plt
from keras.models import Sequential
from keras.layers import LSTM, Dropout, Dense, Activation
from sklearn.linear_model import LinearRegression, BayesianRidge
from sklearn.model_selection import RandomizedSearchCV, train_test_split
from sklearn.svm import SVR
from sklearn.preprocessing import PolynomialFeatures
from sklearn.tree import DecisionTreeRegressor
from sklearn.metrics import mean_squared_error, mean_absolute_error
from matplotlib import rc
rc('font', family='AppleGothic')

#전처리
df = pd.read_csv('https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv')
kor_df = df[155:156]
kor_df.drop(['Province/State', 'Country/Region', 'Lat', 'Long'], axis=1, inplace= True)

kor_t = kor_df.T
kor_t.columns =["confirmed"]


confirmdf = kor_t["confirmed"].values

kor_1 = kor_t[:180]

kor_2 = kor_t[180:]


number_of_features = 100

X_train, X_test = train_test_split(kor_1, test_size=0.25, shuffle=False)  
y_train, y_test = train_test_split(kor_2, test_size=0.25, shuffle=False) 


model = Sequential() 

model.add(Dense(units=16, activation="relu", input_shape=(number_of_features))

model.add(Dense(units=1, activation="sigmoid"))

model.add(Dense(1,activation="linear"))

model.compile(loss='mse',optimizer='rmsprop',metrics=["accuracy"])

model.summary()

X_test = X_train
y_test = y_train
model.fit(X_train[1], y_train[1],
   validation_data=(X_test[1], y_test[1]),
   batch_size=5,
   epochs=500)

#prediction
pred = model.predict(X_test)


fig = plt.figure(facecolor = "white")
ax = fig.add_subplot(111)
ax.plot(y_test, label="True")
ax.plot(pred, label="Prediction")
ax.set_title("Covid-19 Prediction Model (훈련 90% 테스트 10% batch 5 epochs 500 LSTM 90)")
ax.legend()
plt.show()





svm_confirmed = SVR(shrinking=True, kernel='poly',gamma=0.01, epsilon=5,degree=3, C=0.1) #degree : 차원수
svm_confirmed.fit(X_train, y_train)
svm_pred = svm_confirmed.predict(pred_svm)


# check against testing data
svm_test_pred = svm_confirmed.predict(X_test)
plt.plot(y_test)
plt.plot(svm_test_pred)
plt.legend(['Test Data', 'SVM Predictions'])
plt.title("SVM Prediction (gamma 0.01 epsilon 5 degree 3, C 0.1)")
print('MAE:', mean_absolute_error(svm_test_pred, y_test))
print('MSE:',mean_squared_error(svm_test_pred, y_test))





