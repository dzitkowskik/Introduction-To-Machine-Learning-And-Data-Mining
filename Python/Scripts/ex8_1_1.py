# exercise 8.1.1

from pylab import *
from scipy.io import loadmat
from sklearn import cross_validation
from sklearn.linear_model import LogisticRegression
from toolbox_02450 import rocplot, confmatplot

# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/wine2.mat')
X = np.matrix(mat_data['X'])
y = np.matrix(mat_data['y'], dtype=int)
attributeNames = [name[0] for name in mat_data['attributeNames'][0]]
classNames = [name[0][0] for name in mat_data['classNames']]
N, M = X.shape
C = len(classNames)

# K-fold crossvalidation
K = 2
CV = cross_validation.StratifiedKFold(y.A.ravel().tolist(),K)

k=0
for train_index, test_index in CV:

    # extract training and test set for current CV fold
    X_train, y_train = X[train_index,:], y[train_index,:]
    X_test, y_test = X[test_index,:], y[test_index,:]

    logit_classifier = LogisticRegression()
    logit_classifier.fit(X_train, y_train.A.ravel())

    y_test_est = np.mat(logit_classifier.predict(X_test)).T
    p = np.mat(logit_classifier.predict_proba(X_test)[:,1]).T

    figure(k)
    rocplot(p, y_test)

    figure(k+1)
    confmatplot(y_test,y_test_est)

    k+=2

show()
