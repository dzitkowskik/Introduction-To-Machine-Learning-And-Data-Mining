# exercise 3.3.4

import numpy as np

# Number of samples
N = 1000

# Mean
mu = np.array([13, 17])

# Covariance matrix
S = np.matrix('4 3; 3 9')

# Generate samples from the Normal distribution
X = np.random.multivariate_normal(mu, S, N)

print X
