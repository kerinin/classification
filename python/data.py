#! /bin/python

# Easy access to the data arrays

import os
import numpy as np

def class_label_array():
  return np.loadtxt(os.path.join('classifier_training', 'itembased_prefs.npy'))

def feature_array():
  class_path = os.listdir('classifier_training')[0]
  return np.loadtxt(os.path.join('classifier_training', class_path, 'class_array.npy'), int)
