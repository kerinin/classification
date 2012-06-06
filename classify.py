#! /bin/python

import yaml
import os
import numpy as np
from matplotlib.pylab import *
from sklearn.naive_bayes import GaussianNB, MultinomialNB

results = []
count = 0

for class_path in os.listdir('classifier_training'):
  if os.path.isdir(os.path.join('classifier_training', class_path)):
    nb = MultinomialNB()
    
    class_array = np.loadtxt(os.path.join('classifier_training', class_path, 'class_array.npy'), int)
    label_array = np.loadtxt(os.path.join('classifier_training', class_path, 'label_array.npy'), bool)
    
    nb.fit(class_array, label_array)

    test_features = np.loadtxt(os.path.join('classifier_testing', class_path, 'class_array.npy'), int)
    test_classes = np.loadtxt(os.path.join('classifier_testing', class_path, 'label_array.npy'), bool)

    train_predicted = nb.predict(class_array)
    train_performance_array = ( train_predicted == label_array )

    test_predicted = nb.predict(test_features)
    test_performance_array = ( test_predicted == test_classes )

    percent_true_train = 100 * label_array.sum() / label_array.shape[0]
    percent_true_test = 100 * test_classes.sum() / test_classes.shape[0]
    performance_train = 100 * train_performance_array.sum() / train_performance_array.shape[0]
    performance_test = 100 * test_performance_array.sum() / test_performance_array.shape[0]

    print "%% True: %s/%s, Performance: %s%%/%s%%" % (percent_true_train, percent_true_test, performance_train, performance_test)

    results += [[percent_true_test, performance_test]]

data = np.array(results).T
avg = data[1].sum() / 100
print "Aggregate peformance: %s%%" % avg

hist(data[1])
plot([0,100],[0,100], 'k--')
plot(data[1], data[0], 'o')
xlabel('Classifier Accuracy')
ylabel('Classifier % True')
title('Bayes Classifier (%s%% avg accuracy)' % avg)

show()
