# exercise 3.3.1

from pylab import *
import numpy as np


# Number of samples
N = 20000

# Mean
mu = 17

# Standard deviation
s = 2

# Number of bins in histogram
nbins = 20

# Generate samples from the Normal distribution
X = np.mat(np.random.normal(mu,s,N)).T
# or equally:
X = np.mat(np.random.randn(N)).T * s + mu

# Plot the samples and histogram
figure(figsize=(12,4))
title('Normal distribution')
subplot(1,2,1)
plot(array(X),'.')
subplot(1,3,3)
hist(X, bins=nbins)

# Generate samples from the Normal distribution
X = np.mat(np.random.normal(mu,s,N)).T

figure(figsize=(12,4))
title('Normal distribution')
subplot(1,2,1)
plot(array(X),'.')
subplot(1,3,3)
hist(X, bins=nbins)

# Generate samples from the Normal distribution
X = np.mat(np.random.normal(mu,s,N)).T

figure(figsize=(12,4))
title('Normal distribution')
subplot(1,2,1)
plot(array(X),'.')
subplot(1,3,3)
hist(X, bins=nbins)

# Generate samples from the Normal distribution
X = np.mat(np.random.normal(mu,s,N)).T

figure(figsize=(12,4))
title('Normal distribution')
subplot(1,2,1)
plot(array(X),'.')
subplot(1,3,3)
hist(X, bins=nbins)
show()
