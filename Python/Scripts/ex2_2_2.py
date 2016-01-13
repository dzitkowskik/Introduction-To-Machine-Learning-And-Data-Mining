# exercise 2.2.2
# (requires data structures from ex. 2.2.1)
from ex2_2_1 import *

from pylab import *

# Data attributes to be plotted
i = 0
j = 1

##
# Make a simple plot of the i'th attribute against the j'th attribute
# Notice that X is of matrix type and need to be cast to array. 
figure()
X = array(X)
plot(X[:,i], X[:,j], 'o');

# %%
# Make another more fancy plot that includes legend, class labels, 
# attribute names, and a title.
f = figure()
f.hold()
title('NanoNose data')

for c in range(C):
    # select indices belonging to class c:
    class_mask = y.A.ravel()==c
    plot(X[class_mask,i], X[class_mask,j], 'o')

legend(classNames)
xlabel(attributeNames[i])
ylabel(attributeNames[j])

# Output result to screen
show()