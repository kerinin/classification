#! /bin/python

import numpy as np
from matplotlib.pylab import *

from bayes_classifier import bayes_classify
from combined_classifier import combined_classify
from itembased_classifier import itembased_classify

ax1 = subplot(311)
data = np.array(bayes_classify()).T
avg = data[1].sum() / 100
hist(data[1])
plot([0,100],[0,100], 'k--')
plot(data[1], data[0], 'x')
ylabel('Classifier % True')
title('Bayes Classifier (%s%% avg accuracy)' % avg)
setp( ax1.get_xticklabels(), visible=False)

ax2 = subplot(312, sharex = ax1)
data = np.array(itembased_classify()).T
avg = data[1].sum() / 100
hist(data[1])
plot([0,100],[0,100], 'k--')
plot(data[1], data[0], 'x')
ylabel('Classifier % True')
title('Itembased Classifier (%s%% avg accuracy)' % avg)
setp( ax2.get_xticklabels(), visible=False)

subplot(313, sharex = ax1)
data = np.array(combined_classify()).T
avg = data[1].sum() / 100
hist(data[1])
plot([0,100],[0,100], 'k--')
plot(data[1], data[0], 'x')
xlabel('Classifier Accuracy (%)')
ylabel('Classifier % True')
title('Combined Classifier (%s%% avg accuracy)' % avg)

show()
