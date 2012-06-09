#! /bin/python

# Tools for statistical analysis of arrays

import numpy as np
from array_tools import *

# x_y_joint   => [class_value,  feature_value,  probability]
# x_marginal  => [class_value,  1,              probability]
# y_marginal  => [1,            feature_value,  probability]
def multinomial_mutual_information(classifier, labels):
  true_prob           = labels.sum() / float(labels.shape[0])
  false_prob          = 1 - true_prob
  class_probabilities = np.array([true_prob, false_prob])

  class_feature_p     = np.exp( classifier.feature_log_prob_ )
  class_p             = class_probabilities
  feature_p           = np.exp( classifier.class_log_prior_ )
  
  return mutual_information( class_feature_p, class_p.reshape(2,1,1), feature_p.reshape(1, feature_p.shape[0], 1))

# x_y_joint   => [N, M, 1]
# x_marginal  => [N, 1, 1]
# y_marginal  => [1, M, 1]
def mutual_information(x_y_joint, x_marginal, y_marginal):
  return ( x_y_joint * np.log( x_y_joint / ( x_marginal * y_marginal ) ) ).sum(0).sum(0)

def most_informative_feature_indices(classifier, labels, count):
  mutual_information = multinomial_mutual_information(classifier, labels)

  sorted_pairs = sorted( [(i, mutual_information[i]) for i in arange(mutual_information.shape[0])], key=lambda d: d[1] )
  sorted_indices = [pair[0] for pair in sorted_pairs]

  return sorted_indices[-count:]
