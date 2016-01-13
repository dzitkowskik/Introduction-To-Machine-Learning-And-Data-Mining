# exercise 3.3.2

from pylab import *

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
# figure()
# title('Normal distribution')
# subplot(1,2,1)
# plot(array(X),'x')
# subplot(1,2,2)
# hist(X, bins=nbins)

# Compute empirical mean and standard deviation
mu_ = X.mean()
s_ = X.std(ddof=1)

print "Theoretical mean: ", mu
print "Theoretical std.dev.: ", s
print "Empirical mean: ", mu_
print "Empirical std.dev.: ", s_

# show()
