# exercise 2.4.1

from pylab import *
import scipy.linalg as linalg
from scipy.io import loadmat
from sklearn.neighbors import KNeighborsClassifier


# Number of principal components to use for classification,
# i.e. the reduced dimensionality
K = [8,10,15,20,30,40,50,60,100,150]

# Load Matlab data file and extract training set and test set
mat_data = loadmat('../Data/zipdata.mat')
X = mat(mat_data['traindata'][:,1:])
y = mat(mat_data['traindata'][:,0]).T
Xtest = mat(mat_data['testdata'][:,1:])
ytest = mat(mat_data['testdata'][:,0]).T
N,M = X.shape
Ntest = shape(Xtest)[0]

# Subtract the mean from the data
Y = X - ones((N,1))*X.mean(0)
Ytest = Xtest - ones((Ntest,1))*X.mean(0)

# Obtain the PCA solution  by calculate the SVD of Y
U,S,V = linalg.svd(Y,full_matrices=False)
V = mat(V).T


# Repeat classification for different values of K
error_rates = []
for k in K:
    # Project data onto principal component space,
    Z = Y * V[:,:k]
    Ztest = Ytest * V[:,:k]

    # Classify data with knn classifier
    knn_classifier = KNeighborsClassifier(n_neighbors=1)
    knn_classifier.fit(Z,ravel(y))
    y_estimated = knn_classifier.predict(Ztest)

    # Compute classification error rates
    y_estimated = matrix(y_estimated).T
    er = (sum(ytest!=y_estimated)/float(len(ytest)))*100
    error_rates.append(er)
    print 'K={0}: Error rate: {1:.1f}%'.format(k, er)

# Visualize error rates vs. number of principal components considered
figure()
plot(K,error_rates,'o-')
xlabel('Number of principal components K')
ylabel('Error rate [%]')
show()