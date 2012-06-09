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

def extract_keys(array, indices):
  extracted_rows = []
  indices.sort()

  for i in indices:
    extracted_rows.append(array[:,i])

  return np.array(extracted_rows).T

def most_informative_feature_indices(classifier, labels, count):
  true_prob = labels.sum() / float(labels.shape[0])
  false_prob = 1 - true_prob
  class_probabilities = np.array([true_prob, false_prob])

  mutual_information = (classifier.feature_log_prob_ * log( classifier.feature_log_prob_ / expand_dims( classifier.class_log_prior_ * class_probabilities, 1) )).sum(0)

  sorted_pairs = sorted( [(i, mutual_information[i]) for i in arange(mutual_information.shape[0])], key=lambda d: d[1] )
  sorted_indices = [pair[0] for pair in sorted_pairs]

  return sorted_indices[-count:]

def combined_classify(feature_count):
  results = []
  full_item_train_array = np.loadtxt(os.path.join('classifier_training', 'itembased_prefs.npy'))
  full_item_test_array = np.loadtxt(os.path.join('classifier_testing', 'itembased_prefs.npy'))
  paths = os.listdir('classifier_training')

  for i in arange(full_item_train_array.shape[1]):
  # for i in arange(10):
    class_path = paths[i]
    nb = MultinomialNB()

    feature_train_set = np.loadtxt(os.path.join('classifier_training', class_path, 'class_array.npy'), int)[:full_item_train_array.shape[0],:]
    item_train_subset, item_train_labels = extract(full_item_train_array, i-1)
    full_features = np.hstack([feature_train_set, item_train_subset])
    
    nb.fit(full_features, item_train_labels)
    
    feature_subset = most_informative_feature_indices(nb, item_train_labels, feature_count)
    train_features = extract_keys(full_features, feature_subset)

    newNB = MultinomialNB()
    newNB.fit(train_features, item_train_labels)
    # print list(train_features[:,0])

    feature_test_set = np.loadtxt(os.path.join('classifier_testing', class_path, 'class_array.npy'), int)[:full_item_test_array.shape[0],:]
    item_test_subset, item_test_labels = extract(full_item_test_array, i-1)
    test_features = extract_keys(np.hstack([feature_test_set, item_test_subset]), feature_subset)

    train_predictions = newNB.predict(train_features)
    train_performance_array = ( train_predictions == item_train_labels )

    test_predictions = newNB.predict(test_features)
    test_performance_array = ( test_predictions == item_test_labels )

    percent_true_train =  100 * full_item_train_array[:,i].sum() /        full_item_train_array.shape[0]
    percent_true_test =   100 * full_item_test_array[:,i].sum() /         full_item_test_array.shape[0]
    performance_train =   100 * train_performance_array.sum() / train_performance_array.shape[0]
    performance_test =    100 * test_performance_array.sum() / test_performance_array.shape[0]

    # if i == 0:
      # print "indices: %s" % feature_subset

    # print "%% True: %s/%s, Performance: %s%%/%s%%" % (percent_true_train, percent_true_test, performance_train, performance_test)

    results += [[percent_true_test, performance_test]]

  return results

X = arange(1, 277, 25)
results = []
for feature_count in X:
  print "classifying with %s features" % feature_count
  count_results = np.array(combined_classify(feature_count)).T
  print "accuracy: %s%%" % np.mean(count_results[1,:]) 
  results.append(count_results[1])

results = np.array(results)

for i in arange(results.shape[1]):
  Y = results[:,i]
  plot(X, Y)

axis('tight')
ylim([0,100])
xlabel('Feature Count (top N by Mutual Information)')
ylabel('Classifier Accuracy (%)')
title('Classifier Accuracy by Feature Count')
show()

# data = np.array(combined_classify()).T
# avg = data[1].sum() / 100
# print "Aggregate peformance: %s%%" % avg
# 
# hist(data[1])
# plot([0,100],[0,100], 'k--')
# plot(data[1], data[0], 'o')
# xlabel('Classifier Accuracy')
# ylabel('Classifier % True')
# title('Combined Classifier (%s%% avg accuracy)' % avg)
# 
# show()
