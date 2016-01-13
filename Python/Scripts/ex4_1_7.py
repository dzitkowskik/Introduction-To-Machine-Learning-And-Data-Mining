# Exercise 4.1.7

from pylab import *
from scipy.stats import zscore

# requires data from exercise 4.1.1
from ex4_1_1 import *

X_standarized = zscore(X, ddof=1)

figure()
imshow(X_standarized, interpolation='none', aspect=(4./N), cmap=cm.gray);
xticks(range(4), attributeNames)
xlabel('Attributes')
ylabel('Data objects')
title('Fisher\'s Iris data matrix')
colorbar()

show()
