# exercise 3.4.2

from pylab import *
import numpy as np
from scipy.io import loadmat

# Digits to include in analysis (to include all, n = range(10) )
n = [2]

# Number of digits to generate from normal distributions
ngen = 10

# Load Matlab data file to python dict structure
# and extract variables of interest
traindata = loadmat('../Data/zipdata.mat')['traindata']
X = mat(traindata[:,1:])
y = mat(traindata[:,0]).T
N, M = shape(X)
C = len(n)

# Remove digits that are not to be inspected
class_mask = np.zeros(N).astype(bool)
for v in n:
    cmsk = y.A.ravel()==v
    class_mask = class_mask | cmsk
X = X[class_mask,:]
y = y[class_mask,:]
N = shape(X)[0]

mu = X.mean(axis=0)
s = X.std(ddof=1, axis=0)
S = np.cov(X, rowvar=0, ddof=1)

# Generate 10 samples from 1-D normal distribution
Xgen = np.mat(np.random.randn(ngen,256))
for i in range(ngen):
    Xgen[i] = np.multiply(Xgen[i],s) + mu

# Plot images
figure()
for k in range(ngen):
    subplot(2, np.ceil(ngen/2.), k+1)
    I = reshape(Xgen[k,:], (16,16))
    imshow(I, cmap=cm.gray_r);
    xticks([]); yticks([])
    if k==1: title('Digits: 1-D Normal')


# Generate 10 samples from multivariate normal distribution
Xmvgen = np.random.multivariate_normal(mu.tolist()[0], S, ngen)

# Plot images
figure()
for k in range(ngen):
    subplot(2, np.ceil(ngen/2.), k+1)
    I = reshape(Xmvgen[k,:], (16,16))
    imshow(I, cmap=cm.gray_r);
    xticks([]); yticks([])
    if k==1: title('Digits: Multivariate Normal')

show()
