#! /bin/python

import yaml
import os
import numpy as np
from matplotlib.pylab import *
from sklearn.naive_bayes import GaussianNB, MultinomialNB

results = []
count = 0

train_array = np.loadtxt(os.path.join('classifier_training', 'itembased_prefs.npy'))
test_array = np.loadtxt(os.path.join('classifier_testing', 'itembased_prefs.npy'))

print train_array.shape
print test_array.shape

def extract(array, index):
  remaining = np.hstack([array[:,:index], array[:,index+1:]])
  column = array[:,index]

  return (remaining, column)

for i in arange(train_array.shape[1]):
  nb = MultinomialNB()

  train_subset, train_labels = extract(train_array, i-1)

  nb.fit(train_subset, train_labels)

  test_subset, test_labels = extract(test_array, i-1)

  train_predictions = nb.predict(train_subset)
  train_performance_array = ( train_predictions == train_labels )

  test_predictions = nb.predict(test_subset)
  test_performance_array = ( test_predictions == test_labels )

  percent_true_train =  100 * train_array[:,i].sum() /        train_array.shape[0]
  percent_true_test =   100 * test_array[:,i].sum() /         test_array.shape[0]
  performance_train =   100 * train_performance_array.sum() / train_array.shape[0]
  performance_test =    100 * test_performance_array.sum() /  test_array.shape[0]

  print "%% True: %s/%s, Performance: %s%%/%s%%" % (percent_true_train, percent_true_test, performance_train, performance_test)

  results += [[percent_true_test, performance_test]]

data = np.array(results).T

hist(data[1])
plot([0,100],[0,100], 'k--')
plot(data[1], data[0], 'o')
xlabel('Classifier Accuracy')
ylabel('Classifier % True')

print data[1].sum()

show()
