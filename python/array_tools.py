#! /bin/python

# Array manipulation tools not provided by numpy

import numpy as np

# returns the indices of all colums with non-zero sums
def non_zero_columns(array):
  sums = array.sum(0)
  return filter(lambda i: sums[i] > 0, np.arange(array.shape[1]))

# removes column @index from @array and returns both the
# column and the new array
def extract(array, index):
  remaining = np.hstack([array[:,:index], array[:,index+1:]])
  column = array[:,index]

  return (remaining, column)

# returns an array composed of the columns in @array 
# indexed by @indices
def extract_columns(array, indices):
  extracted_rows = []
  indices.sort()

  for i in indices:
    extracted_rows.append(array[:,i])

  return np.array(extracted_rows).T
