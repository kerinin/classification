#! /bin/python

# Compare how well we can predict loss

import numpy as np
from matplotlib.pylab import *
from sklearn.naive_bayes import GaussianNB, MultinomialNB
from data import *
from array_tools import *
from analysis import *

# data sanity check
raw_labels = class_label_array()
label_indices = non_zero_columns(raw_labels)
all_labels = extract_columns(raw_labels, label_indices)

raw_data = feature_array()[:all_labels.shape[0]]
data_indices = non_zero_columns(raw_data)
data = extract_columns(raw_data, data_indices)

# for each class
for j in arange(all_labels.shape[1]):
# for j in [77]:
  labels = all_labels[:,j]
  full_classifier = MultinomialNB()
  full_classifier.fit(data, labels)
  mi = multinomial_mutual_information(full_classifier, labels)
  loss = []

  # for each feature
  for i in arange(mi.shape[0]):
    column_classifier = GaussianNB()
    column = data[:,i].reshape(data.shape[0],1)
    column_classifier.fit(column.astype(int), labels)
    performance = 100 * (column_classifier.predict(column) == labels).sum(0) / data.shape[0]

    loss.append(performance)

  label_true = 100 * labels.sum() / data.shape[0]
  avg_loss = np.average(np.array(loss))
  print "%s: %s / %s" % (j, avg_loss + label_true, avg_loss + 1 - label_true)
  plot(mi, loss, 'o')

xlabel('Mutual Information')
ylabel('Accuracy')
title('Color designates class')
axis('tight')
show()
