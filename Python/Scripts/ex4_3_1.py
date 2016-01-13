# exercise 4.3.1

from pylab import *
import scipy.linalg as linalg
from scipy.io import loadmat

# Digits to include in analysis (to include all, n = range(10) )
n = [0,1,2]
# Number of principal components to be analysed
K = 4

# Load Matlab data file to python dict structure
# and extract variables of interest
traindata = loadmat('../Data/zipdata.mat')['traindata']
X = mat(traindata[:,1:])
y = mat(traindata[:,0]).T

# Extract remaining information
classValues = sorted(unique(y.A))
classNames = [str(int(v)) for v in classValues]
classDict = dict(zip(classNames,classValues))
attributeNames = ['p{0}'.format(no) for no in range(1,257)]
N = shape(X)[0]
M = shape(X)[1]
C = len(n)

# Remove digits that are not to be inspected
class_mask = np.zeros(N).astype(bool)
for v in n:
    cmsk = y.A.ravel()==v
    class_mask = class_mask | cmsk
X = X[class_mask,:]
y = y[class_mask,:]
N = shape(X)[0]


# Center the data (subtract mean value from data)
Xc = X - np.ones((N,1))*X.mean(0)

# PCA by computing SVD of Y
U,S,V = linalg.svd(Xc,full_matrices=False)
V = mat(V).T
U = mat(U)

# Project data onto principal component space
Z = Xc * V

# Replace X, attributeNames, and M
X = Z[:,:K]
attributeNames = ['PC{0}'.format(no) for no in range(1,K+1)]
M = K
X = array(X)
# Now we will use the same plots as in exercises 4.1.2-4.1.7
# to visualize data projected on principal component space:

# Histograms of data projected on K principal components
figure(figsize=(8,7))
u = np.floor(np.sqrt(M)); v = np.ceil(float(M)/u)
for i in range(M):
    subplot(u,v,i+1)
    hist(X[:,i], color=(0.2, 0.8, 0.4))
    xlabel(attributeNames[i])
    ylim(0,N/2)

# Boxplot of data projected on K principal components
figure(figsize=(8,7))
boxplot(X)
xticks(range(1,5),attributeNames)
ylabel('')
title('Handwritten digits PCA - boxplot')

# Boxplots of data projected on K principal components, by class label.
figure(figsize=(14,7))
for c in range(C):
    subplot(1,C,c+1)
    class_mask = (y==c).A.ravel() # binary mask to extract elements of class c
    boxplot(X[class_mask,:])
    title('Class: '+classNames[c])
    xticks(range(1,len(attributeNames)+1), [a[:7] for a in attributeNames], rotation=45)
    y_up = X.max()+(X.max()-X.min())*0.1; y_down = X.min()-(X.max()-X.min())*0.1
    ylim(y_down, y_up)

# Plot scatter plots for each pair of K principal component projections.
figure(figsize=(12,10))
hold(True)
for m1 in range(M):
    for m2 in range(M):
        subplot(M, M, m1*M + m2 + 1)
        for c in range(C):
            class_mask = (y==c).A.ravel()
            plot(X[class_mask,m2], X[class_mask,m1], '.')
            if m1==M-1: xlabel(attributeNames[m2]);
            else: xticks([]);
            if m2==0: ylabel(attributeNames[m1]);
            else: yticks([]);
legend(classNames)

# 3-dimensional scatter plot of selected principal component projections
from mpl_toolkits.mplot3d import Axes3D
ind = [0, 1, 2] # Indices of the PC projections to plot
colors = ['blue', 'green', 'red']
f = figure()
hold(True)
ax = f.add_subplot(111, projection='3d')
#X = matrix(X)
for c in range(C):
    class_mask = (y==c).A.ravel()
    s = ax.scatter(X[class_mask,ind[0]], X[class_mask,ind[1]], X[class_mask,ind[2]], c=colors[c])

ax.view_init(30, 220)
ax.set_xlabel(attributeNames[ind[0]])
ax.set_ylabel(attributeNames[ind[1]])
ax.set_zlabel(attributeNames[ind[2]])


# Matrix plot of data projected on K principal components space
from scipy.stats import zscore
X_standarized = array(zscore(X, ddof=1))
sorting_indices=sorted(range(len(y)),key=lambda x:y[x])
figure()
imshow(X_standarized[sorting_indices,:], interpolation='none', aspect=(4./N), cmap=cm.gray);
xticks(range(4), attributeNames)
xlabel('Attributes')
ylabel('Data objects')
title('Fisher\'s Iris data matrix')
colorbar()
