# exercise 6.1.1

from pylab import *
from scipy.io import loadmat
from sklearn import cross_validation, tree

# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/wine2.mat')
X = np.matrix(mat_data['X'])
y = np.matrix(mat_data['y'], dtype=int)
attributeNames = [name[0] for name in mat_data['attributeNames'][0]]
classNames = [name[0][0] for name in mat_data['classNames']]
N, M = X.shape
C = len(classNames)

# Tree complexity parameter - constraint on maximum depth
tc = np.arange(2, 21, 1)

# Simple holdout-set crossvalidation
test_proportion = 0.5
X_train, X_test, y_train, y_test = cross_validation.train_test_split(X,y,test_size=test_proportion)

# Initialize variables
Error_train = np.empty((len(tc),1))
Error_test = np.empty((len(tc),1))

for i, t in enumerate(tc):
    # Fit decision tree classifier, Gini split criterion, different pruning levels
    dtc = tree.DecisionTreeClassifier(criterion='gini', max_depth=t)
    dtc = dtc.fit(X_train,y_train.ravel())

    # Evaluate classifier's misclassification rate over train/test data
    y_est_test = dtc.predict(X_test)
    y_est_train = dtc.predict(X_train)
    misclass_rate_test = sum(np.abs(np.mat(y_est_test).T - y_test)) / float(len(y_est_test))
    misclass_rate_train = sum(np.abs(np.mat(y_est_train).T - y_train)) / float(len(y_est_train))
    Error_test[i], Error_train[i] = misclass_rate_test, misclass_rate_train

f = figure(); f.hold(True)
plot(tc, Error_train)
plot(tc, Error_test)
xlabel('Model complexity (max tree depth)')
ylabel('Error (misclassification rate)')
legend(['Error_train','Error_test'])

show()
