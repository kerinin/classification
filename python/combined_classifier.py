#! /bin/python

import yaml
import os
import numpy as np
from matplotlib.pylab import *
from sklearn.naive_bayes import GaussianNB, MultinomialNB

def extract(array, index):
  remaining = np.hstack([array[:,:index], array[:,index+1:]])
  column = array[:,index]

  return (remaining, column)

def combined_classify():
  results = []
  full_item_train_array = np.loadtxt(os.path.join('classifier_training', 'itembased_prefs.npy'))
  full_item_test_array = np.loadtxt(os.path.join('classifier_testing', 'itembased_prefs.npy'))
  paths = os.listdir('classifier_training')

  for i in arange(full_item_train_array.shape[1]):
    class_path = paths[i]
    nb = MultinomialNB()

    feature_train_set = np.loadtxt(os.path.join('classifier_training', class_path, 'class_array.npy'), int)[:full_item_train_array.shape[0],:]
    item_train_subset, item_train_labels = extract(full_item_train_array, i-1)
    train_features = np.hstack([feature_train_set, item_train_subset])
    
    nb.fit(train_features, item_train_labels)
    print 100 * (train_features > 0 ).astype(int).sum(0) / train_features.shape[0]

    feature_test_set = np.loadtxt(os.path.join('classifier_testing', class_path, 'class_array.npy'), int)[:full_item_test_array.shape[0],:]
    item_test_subset, item_test_labels = extract(full_item_test_array, i-1)
    test_features = np.hstack([feature_test_set, item_test_subset])

    train_predictions = nb.predict(train_features)
    train_performance_array = ( train_predictions == item_train_labels )

    test_predictions = nb.predict(test_features)
    test_performance_array = ( test_predictions == item_test_labels )

    percent_true_train =  100 * full_item_train_array[:,i].sum() /        full_item_train_array.shape[0]
    percent_true_test =   100 * full_item_test_array[:,i].sum() /         full_item_test_array.shape[0]
    performance_train =   100 * train_performance_array.sum() / full_item_train_array.shape[0]
    performance_test =    100 * test_performance_array.sum() /  full_item_test_array.shape[0]

    print "%% True: %s/%s, Performance: %s%%/%s%%" % (percent_true_train, percent_true_test, performance_train, performance_test)

    results += [[percent_true_test, performance_test]]

  return results

data = np.array(combined_classify()).T
avg = data[1].sum() / 100
print "Aggregate peformance: %s%%" % avg

hist(data[1])
plot([0,100],[0,100], 'k--')
plot(data[1], data[0], 'o')
xlabel('Classifier Accuracy')
ylabel('Classifier % True')
title('Combined Classifier (%s%% avg accuracy)' % avg)

show()
