# Exercise 4.1.4

from pylab import *

# requires data from exercise 4.1.1
from ex4_1_1 import *

figure(figsize=(14,7))
for c in range(C):
    subplot(1,C,c+1)
    class_mask = (y==c).A.ravel() # binary mask to extract elements of class c
    # or: class_mask = nonzero(y==c)[0].tolist()[0] # indices of class c

    boxplot(X[class_mask,:])
    #title('Class: {0}'.format(classNames[c]))
    title('Class: '+classNames[c])
    xticks(range(1,len(attributeNames)+1), [a[:7] for a in attributeNames], rotation=45)
    y_up = X.max()+(X.max()-X.min())*0.1; y_down = X.min()-(X.max()-X.min())*0.1
    ylim(y_down, y_up)

show()
