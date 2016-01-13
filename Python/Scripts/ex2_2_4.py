# exercise 2.2.4
# (requires data structures from ex. 2.2.1 and 2.2.3)
from ex2_2_1 import *

from pylab import *

# Subtract mean value from data
Y = X - np.ones((N,1))*X.mean(0)

# PCA by computing SVD of Y
U,S,V = linalg.svd(Y,full_matrices=False)
V = mat(V).T

# Project the centered data onto principal component space
Z = Y * V


# Indices of the principal components to be plotted
i = 0
j = 1

# Plot PCA of the data
f = figure()
f.hold()
title('NanoNose data: PCA')
Z = array(Z)
for c in range(C):
    # select indices belonging to class c:
    class_mask = y.A.ravel()==c
    plot(Z[class_mask,i], Z[class_mask,j], 'o')
legend(classNames)
xlabel('PC{0}'.format(i+1))
ylabel('PC{0}'.format(j+1))

# Output result to screen
show()