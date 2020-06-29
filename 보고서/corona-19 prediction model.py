#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jun 13 22:56:32 2020

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
kor_df = df[143:144]
kor_df.drop(['Province/State', 'Country/Region', 'Lat', 'Long'], axis=1, inplace= True)

kor_t = kor_df.T
kor_t.columns =["confirmed"]


confirmdf = kor_t["confirmed"].values




"""
_______________________________________________________________________________
LSTM Prediction 

장점
    메모리와 결과값 컨트롤 가능
단점
    메모리 덮어씌워질 가능성이 있음
    연산속도 느림
_______________________________________________________________________________

"""

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

'''
#training 70% test 30% 배치10 에폭시 500 LSTM ? ?

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

model.add(LSTM(90,return_sequences=True,input_shape=(3,1)))

model.add(LSTM(30,return_sequences=False))

model.add(Dense(1,activation="linear"))

model.compile(loss='mse',optimizer='rmsprop') #mse = 손실함수

model.summary()
#---------------------------------------------------------------------------
'''

#training 90% test 10% 배치5 에폭시 500 LSTM 90,30

#---------------------------------------------------------------------------

row = int(round(result.shape[0]*0.9))
train = result[:row,:]
#np.random.shuffle(train)

X_train= train[:,:-1]
X_train = np.reshape(X_train, (X_train.shape[0],X_train.shape[1],1))
y_train = train[:,-1]

X_test = result[row:,:-1]
X_test = np.reshape(X_test,(X_test.shape[0],X_test.shape[1],1))
y_test = result[row:,-1]

X_train.shape, X_test.shape



#build a model
model = Sequential() #모델을 순차적으로 정의하는 클래스

model.add(LSTM(90,return_sequences=True,input_shape=(3,1)))

model.add(LSTM(30,return_sequences=False))

model.add(Dense(1,activation="linear"))

model.compile(loss='mse',optimizer='rmsprop') #mse = 손실함수

model.summary()
#---------------------------------------------------------------------------


#training
model.fit(X_train, y_train,
   validation_data=(X_test, y_test),
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

#0.05이내로 편차 : 실 인원 수 60명 이내







cols = df.keys()
confirm = df.loc[:, cols[4]:cols[-1]]
dates = confirm.keys()

days = np.array([i for i in range(len(dates))]).reshape(-1, 1)
kor_cases = np.array(kor_df).reshape(-1, 1)

days_in_future = 10
future_forcast = np.array([i for i in range(len(dates)+days_in_future)]).reshape(-1, 1)


seq_svm = 10
pred_svm = np.array([i for i in range(len(dates)+seq_svm)]).reshape(-1, 1)
#adjusted_dates = pred_svm[:-10]


first = '1/22/2020'
first_data = datetime.datetime.strptime(first, '%m/%d/%Y')
pred_data = []
for i in range(len(pred_svm)):
    pred_data.append((first_data + datetime.timedelta(days=i)).strftime('%m/%d/%Y'))

# slightly modify the data to fit the model better
X_train, X_test, Y_train, Y_test = train_test_split(days[60:], kor_cases[60:], test_size=0.05, shuffle=False) 


"""
_______________________________________________________________________________
SVM Prediction 서포트 벡터 머신

초평면 : N차원을 N-1차원으로 구현

장점
    일반화 오차 낮음
    overfitting 방지
    
단점
    확률 추정치 미제공
    5분할 교차검증 -> 자원소비 큼
    데이터가 많아질수록 연산량 급증
_______________________________________________________________________________

"""


svm_confirmed = SVR(shrinking=True, kernel='poly',gamma=0.01, epsilon=5,degree=3, C=0.1) #degree : 차원수
svm_confirmed.fit(X_train, Y_train)
svm_pred = svm_confirmed.predict(pred_svm)


# check against testing data
svm_test_pred = svm_confirmed.predict(X_test)
plt.plot(Y_test)
plt.plot(svm_test_pred)
plt.legend(['Test Data', 'SVM Predictions'])
plt.title("SVM Prediction (gamma 0.01 epsilon 5 degree 3, C 0.1)")
print('MAE:', mean_absolute_error(svm_test_pred, Y_test))
print('MSE:',mean_squared_error(svm_test_pred, Y_test))
#MAE : 평균제곱값 오차
#MSE : 평균절댓값 오차

""" 
_______________________________________________________________________________
Polynomial Regression Predictions
_______________________________________________________________________________

"""
poly = PolynomialFeatures(degree=4)
poly_X_train_confirmed = poly.fit_transform(X_train)
poly_X_test_confirmed = poly.fit_transform(X_test)
poly_future_forcast = poly.fit_transform(future_forcast)

bayesian_poly = PolynomialFeatures(degree=4)
bayesian_poly_X_train_confirmed = bayesian_poly.fit_transform(X_train)
bayesian_poly_X_test_confirmed = bayesian_poly.fit_transform(X_test)
bayesian_poly_future_forcast = bayesian_poly.fit_transform(future_forcast)

linear_model = LinearRegression(normalize=True, fit_intercept=False)
linear_model.fit(poly_X_train_confirmed, Y_train)
test_linear_pred = linear_model.predict(poly_X_test_confirmed)
linear_pred = linear_model.predict(poly_future_forcast)
print('MAE:', mean_absolute_error(test_linear_pred, Y_test))
print('MSE:',mean_squared_error(test_linear_pred, Y_test))

print(linear_model.coef_) #coef_ 특성의 계수 확인
'''[[ 3.60480682e-05  8.48100767e-04  2.42337669e-02  3.35233742e-01
  -1.04783415e-02  1.40296627e-04 -9.83257279e-07  3.56510317e-09
  -5.30662159e-12]]'''

plt.plot(Y_test)
plt.plot(test_linear_pred)
plt.legend(['Test Data', 'Polynomial Regression Predictions'])
plt.title("Polynomial Regression Prediction (PolynomialFeatures(degree=4))")






"""
_______________________________________________________________________________
Bayesian Ridge Polynomial Predictions
_______________________________________________________________________________

"""

# bayesian ridge polynomial regression
tol = [1e-6, 1e-5, 1e-4, 1e-3, 1e-2]
alpha_1 = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3]
alpha_2 = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3]
lambda_1 = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3]
lambda_2 = [1e-7, 1e-6, 1e-5, 1e-4, 1e-3]
normalize = [True, False]

bayesian_grid = {'tol': tol, 'alpha_1': alpha_1, 'alpha_2' : alpha_2, 'lambda_1': lambda_1, 'lambda_2' : lambda_2, 
                 'normalize' : normalize}

bayesian = BayesianRidge(fit_intercept=False)
bayesian_search = RandomizedSearchCV(bayesian, bayesian_grid, scoring='neg_mean_squared_error', cv=4, return_train_score=True, n_jobs=-1, n_iter=30, verbose=1)
bayesian_search.fit(bayesian_poly_X_train_confirmed, Y_train)

bayesian_search.best_params_

bayesian_confirmed = bayesian_search.best_estimator_
test_bayesian_pred = bayesian_confirmed.predict(bayesian_poly_X_test_confirmed)
bayesian_pred = bayesian_confirmed.predict(bayesian_poly_future_forcast)
print('MAE:', mean_absolute_error(test_bayesian_pred, Y_test))
print('MSE:',mean_squared_error(test_bayesian_pred, Y_test))

plt.plot(Y_test)
plt.plot(test_bayesian_pred)
plt.legend(['Test Data', 'Bayesian Ridge Polynomial Predictions'])
plt.title("Bayesian Ridge Polynomial Predictions")
