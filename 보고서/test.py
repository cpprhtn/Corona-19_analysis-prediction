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
kor_df = df[143:144]
kor_df.drop(['Province/State', 'Country/Region', 'Lat', 'Long'], axis=1, inplace= True)

kor_t = kor_df.T
kor_t.columns =["confirmed"]


confirmdf = kor_t["confirmed"].values

X_train, X_test, Y_train, Y_test = train_test_split(days[60:], kor_cases[60:], test_size=0.05, shuffle=False) 