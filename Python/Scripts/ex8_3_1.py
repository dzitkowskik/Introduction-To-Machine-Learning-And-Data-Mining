# exercise 8.3.1

from pylab import *
from scipy.io import loadmat
from toolbox_02450 import dbplot
from sklearn.linear_model import LogisticRegression

# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/synth4.mat')
X = np.matrix(mat_data['X'])
X_train = np.matrix(mat_data['X_train'])
X_test = np.matrix(mat_data['X_test'])
y = np.matrix(mat_data['y'])
y_train = np.matrix(mat_data['y_train'])
y_test = np.matrix(mat_data['y_test'])
attributeNames = [name[0] for name in mat_data['attributeNames'].squeeze()]
classNames = [name[0][0] for name in mat_data['classNames']]
N, M = X.shape
C = len(classNames)

# Fit and plot one-vs-rest classifiers
y_test_est = np.mat(np.zeros((y_test.shape[0],C)))
for c in range(C):
    logit_classifier = LogisticRegression()
    logit_classifier.fit(X_train,ravel((y_train==c).astype(int)))
    y_test_est[:,c] = np.mat(logit_classifier.predict(X_test)).T
    figure(c+1)
    dbplot(logit_classifier,X_test,(y_test==c).astype(int),'auto')

# Plot results for multinomial fit (softmax)
figure(C+1)
logit_classifier = LogisticRegression()
logit_classifier.fit(X_train,ravel(y_train))
dbplot(logit_classifier,X_test,y_test,'auto')

# Compute error rate
y_test_ensemble = np.mat(logit_classifier.predict(X_test)).T
ErrorRate = (y_test!=y_test_ensemble).sum(dtype=float)/y_test.shape[0]
show()
print('Error rate (ensemble): {0}%'.format(100*ErrorRate))

