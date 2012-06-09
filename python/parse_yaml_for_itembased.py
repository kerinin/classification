#! /bin/python

import yaml
import os
import numpy as np

count = 0
for base_path in ['classifier_training', 'classifier_testing']:
  preferences = {}
  for class_path in os.listdir(base_path):
    for klass in ['true', 'false']:
      file_path = os.path.join(base_path, class_path, '%s.yaml' % klass )

      if os.path.exists(file_path):
        print "reading %s" % file_path
        examples_raw = open(file_path).read().replace('---','') 

        # print "parsing YAML"
        examples_dict = yaml.load(examples_raw)

        # print "constructing array"
        users = np.array(examples_dict.keys())

        # print "appending"
        for user in users:
          preferences.setdefault(user, [])
          preferences[user] += [1 if klass == 'true' else 0]

  preferences_data = []
  base_size = len(preferences.values()[0])
  for values in preferences.values():
    if len(values) == base_size:
      preferences_data += [values]

  preferences_array = np.array(preferences_data)
  np.savetxt(os.path.join(base_path, 'itembased_prefs.npy'), preferences_array, '%1i')
