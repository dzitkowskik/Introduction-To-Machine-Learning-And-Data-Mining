# exercise 5.1.4

import numpy as np
from scipy.io import loadmat

# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/wine.mat')
X = np.matrix(mat_data['X'])
y = np.matrix(mat_data['y'])
C = mat_data['C'][0,0]
M = mat_data['M'][0,0]
N = mat_data['N'][0,0]
#attributeNames = [name[0] for name in mat_data['attributeNames'][0]
#classNames = [name[0][0] for name in mat_data['classNames'][0]]

attributeNames = [i[0][0] for i in mat_data['attributeNames']]
classNames = [j[0] for i in mat_data['classNames'] for j in i]


# Remove outliers
outlier_mask = (X[:,1]>20).A.ravel() | (X[:,7]>10).A.ravel() | (X[:,10]>200).A.ravel()
valid_mask = np.logical_not(outlier_mask)
X = X[valid_mask,:]
y = y[valid_mask,:]
# Remove attribute 12 (Quality score)
X = X[:,0:11]
attributeNames = attributeNames[0:11]
# Update N and M
N, M = X.shape
