import numpy as np
from writeapriorifile import *

#Test: Convert matrix from exercise
titles = [u'a',u'b',u'c',u'd',u'e',u'f',u'g',u'h']
X = np.mat("0 1 0 0 1 1 1 1; 1 1 1 0 0 1 1 1; 0 1 0 1 0 1 0 1; 0 0 1 0 0 1 1 0; 0 1 0 0 0 1 1 0; 0 1 1 0 0 1 1 1");

WriteAprioriFile(X,filename="AprioriFile.txt")
WriteAprioriFile(X,titles=titles,filename="AprioriWithLabels.txt")