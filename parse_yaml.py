#! /bin/python

import yaml
import os
import numpy as np

for base_path in ['classifier_training', 'classifier_testing']:
  for class_path in os.listdir(base_path):
    if os.path.exists(os.path.join(base_path, class_path, 'label_array.npy')):
      print "Skipping %s" % class_path
      continue
    
    classes = []
    labels = []

    for klass in ['true', 'false']:
      file_path = os.path.join(base_path, class_path, '%s.yaml' % klass )

      if os.path.exists(file_path):
        # print "reading %s" % file_path
        examples_raw = open(file_path).read().replace('---','') 

        # print "parsing YAML"
        examples_dict = yaml.load(examples_raw)

        # print "constructing array"
        examples = np.array(examples_dict.values())

        # print "appending"
        classes.append(examples)
        labels += ([klass] * examples.shape[0])

    # print "creating class/label arrays"
    class_array = np.vstack(classes)
    label_array = np.array( [1 if label == 'true' else 0 for label in labels] )
    print class_array.shape
    print label_array.shape
    
    print "Saving %s" % class_path
    np.savetxt(os.path.join(base_path, class_path, 'class_array.npy'), class_array, '%3i')
    np.savetxt(os.path.join(base_path, class_path, 'label_array.npy'), label_array, '%1i')
