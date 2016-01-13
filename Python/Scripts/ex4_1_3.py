# Exercise 4.1.3

from pylab import *

# requires data from exercise 4.1.1
from ex4_1_1 import *

boxplot(X)
xticks(range(1,5),attributeNames)
ylabel('cm')
title('Fisher\'s Iris data set - boxplot')
show()
