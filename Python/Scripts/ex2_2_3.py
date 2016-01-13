# exercise 2.2.3
# (requires data structures from ex. 2.2.1)
from ex2_2_1 import *

from pylab import *
import scipy.linalg as linalg


# Subtract mean value from data
Y = X - np.ones((N,1))*X.mean(0)

# PCA by computing SVD of Y
U,S,V = linalg.svd(Y,full_matrices=False)

# Compute variance explained by principal components
rho = (S*S) / (S*S).sum() 

# Plot variance explained
figure()
plot(range(1,len(rho)+1),rho,'o-')
title('Variance explained by principal components');
xlabel('Principal component');
ylabel('Variance explained');
show()
