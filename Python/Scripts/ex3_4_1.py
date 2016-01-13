# exercise 3.4.1

from pylab import *
import scipy.linalg as linalg
from scipy.io import loadmat

# Digits to include in analysis (to include all: n = range(10))
n = [1]

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

figure()
subplot(1,2,1)
I = reshape(mu, (16,16))
imshow(I, cmap=cm.gray_r)
title('Mean')
xticks([]); yticks([])
subplot(1,2,2)
I = reshape(s, (16,16))
imshow(I, cmap=cm.gray_r)
title('Standard deviation')
xticks([]); yticks([])

show()
