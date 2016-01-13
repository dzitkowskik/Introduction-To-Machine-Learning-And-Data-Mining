# exercise 2.3.2

from pylab import *
import scipy.linalg as linalg
from scipy.io import loadmat

# Digits to include in analysis (to include all, n = range(10) )
n = [0,1]
# Number of principal components for reconstruction
K = 16
# Digits to visualize
nD = range(6);


# Load Matlab data file to python dict structure
# and extract variables of interest
traindata = loadmat('../Data/zipdata.mat')['traindata']
X = mat(traindata[:,1:])
y = mat(traindata[:,0]).T

N,M = X.shape
C = len(n)

classValues = unique(y.A)
classNames = [str(int(v)) for v in classValues]
classDict = dict(zip(classNames,classValues))


# Select subset of digits classes to be inspected
class_mask = np.zeros(N).astype(bool)
for v in n:
    cmsk = y.A.ravel()==v
    class_mask = class_mask | cmsk
X = X[class_mask,:]
y = y[class_mask,:]
N=X.shape[0]

# Center the data (subtract mean column values)
Xc = X - np.ones((N,1))*X.mean(0)

# PCA by computing SVD of Y
U,S,V = linalg.svd(Xc,full_matrices=False)
U = mat(U)
V = mat(V).T

# Compute variance explained by principal components
rho = (S*S) / (S*S).sum() 

# Project data onto principal component space
Z = Xc * V

# Plot variance explained
figure()
plot(rho,'o-')
title('Variance explained by principal components');
xlabel('Principal component');
ylabel('Variance explained value');


# Plot PCA of the data
f = figure()
f.hold()
title('NanoNose data: PCA')
for c in n:
    # select indices belonging to class c:
    class_mask = y.A.ravel()==c
    plot(array(Z[class_mask,0]), array(Z[class_mask,1]), 'o')
legend(classNames)
xlabel('PC1')
ylabel('PC2')


# Visualize the reconstructed data from the first K principal components
# Select randomly D digits.
figure()
W = Z[:,range(K)] * V[:,range(K)].T
D = len(nD)
for d in range(D):
    digit_ix = np.random.randint(0,N)
    subplot(2, D, d+1)
    I = reshape(X[digit_ix,:], (16,16))
    imshow(I, cmap=cm.gray_r)
    title('Original')
    subplot(2, D, D+d+1)
    I = reshape(W[digit_ix,:]+X.mean(0), (16,16))
    imshow(I, cmap=cm.gray_r)
    title('Reconstr.');
    

# Visualize the pricipal components
figure()
for k in range(K):
    N1 = ceil(sqrt(K)); N2 = ceil(K/N1)
    subplot(N2, N1, k+1)
    I = reshape(V[:,k], (16,16))
    imshow(I, cmap=cm.hot)
    title('PC{0}'.format(k+1));

# output to screen
show()
