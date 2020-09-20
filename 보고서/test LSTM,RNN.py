#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Sep 20 12:56:07 2020

@author: cpprhtn
"""



'''
This script shows how to predict stock prices using a basic RNN
'''
import tensorflow as tf
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.preprocessing import MinMaxScaler

tf.set_random_seed(777)

