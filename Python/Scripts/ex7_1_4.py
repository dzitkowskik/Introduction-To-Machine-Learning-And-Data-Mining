# exercise 7.1.4

from pylab import *
from scipy.io import loadmat
from sklearn.neighbors import KNeighborsClassifier

# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/wine2.mat')
attributeNames = [name[0] for name in mat_data['attributeNames'][0]]
X = np.matrix(mat_data['X'])

y = X[:,10]
X = X[:,:10]
N, M = X.shape


# Maximum number of neighbors
L=60

# Cross_validation avoided as in previous exercise.
knclassifier = KNeighborsClassifier(n_neighbors=L+1).fit(X, ravel(y))
neighbors = knclassifier.kneighbors(X)
ndist, nid = neighbors[0], neighbors[1]
# Extract continuous values instead of class labels:
nvalue = y[nid].flatten().reshape(N,L+1)

# Use the matrix to compute the mean values of l neighbors (for each l),
# and estimate the test errors.
errors = np.zeros((N,L))
for l in range(1,L+1): 
    y_est = np.mean(nvalue[:,1:l+1],1)
    errors[:,l-1] = np.square((y_est-y).A.ravel())

    
# Plot the least-squares error as function of number of neighbors
figure()
plot(sum(errors,0)/N)
xlabel('Number of neighbors')
ylabel('Least-Squares error (%)')
show()