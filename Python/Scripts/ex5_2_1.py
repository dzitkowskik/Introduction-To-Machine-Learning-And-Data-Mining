# exercise 5.2.1

from pylab import *
import numpy as np

# Number of data objects
N = 100

# Attribute values
X = np.mat(range(N)).T

# Noise
eps_mean, eps_std = 0, 0.1
eps = np.mat(eps_std*np.random.randn(N) + eps_mean).T

# Model parameters
w0 = -0.5
w1 = 0.01

# Outputs
y = w0 + w1*X + eps

# Make a scatter plot
figure()
plot(X.A,y.A,'o')
xlabel('X'); ylabel('y')

show()
