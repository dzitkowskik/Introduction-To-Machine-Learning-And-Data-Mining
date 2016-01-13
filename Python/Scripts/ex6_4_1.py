# exercise 6.2.1

from pylab import *
from scipy.io import loadmat
import sklearn.linear_model as lm
from sklearn import cross_validation, tree
from scipy import stats

# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/wine2.mat')
X = np.matrix(mat_data['X'])
y = np.matrix(mat_data['y'])
attributeNames = [name[0] for name in mat_data['attributeNames'][0]]
classNames = [name[0][0] for name in mat_data['classNames']]
N, M = X.shape
C = len(classNames)

## Crossvalidation
# Create crossvalidation partition for evaluation
K = 10
CV = cross_validation.KFold(N,K,shuffle=True)
#CV = cross_validation.StratifiedKFold(y.A.ravel(),k=K)

# Initialize variables
Error_logreg = np.empty((K,1))
Error_dectree = np.empty((K,1))
n_tested=0

k=0
for train_index, test_index in CV:

    # extract training and test set for current CV fold
    X_train = X[train_index,:]
    y_train = y[train_index,:]
    X_test = X[test_index,:]
    y_test = y[test_index,:]

    # Fit and evaluate Logistic Regression classifier
    model = lm.logistic.LogisticRegression(C=N)
    model = model.fit(X_train, y_train.A.ravel())
    y_logreg = np.mat(model.predict(X_test)).T
    Error_logreg[k] = 100*(y_logreg!=y_test).sum().astype(float)/len(y_test)

    # Fit and evaluate Decision Tree classifier
    model2 = tree.DecisionTreeClassifier()
    model2 = model2.fit(X_train, y_train.A.ravel())
    y_dectree = np.mat(model2.predict(X_test)).T
    Error_dectree[k] = 100*(y_dectree!=y_test).sum().astype(float)/len(y_test)

    k+=1

# Use T-test to check if classifiers are significantly different
[tstatistic, pvalue] = stats.ttest_ind(Error_logreg,Error_dectree)
print pvalue
if pvalue<=0.05:
    print('Classifiers are significantly different. (p={0})'.format(pvalue[0]))
else:
    print('Classifiers are not significantly different (p={0})'.format(pvalue[0]))

# Boxplot to compare classifier error distributions
figure()
boxplot(np.bmat('Error_logreg, Error_dectree'))
xlabel('Logistic Regression   vs.   Decision Tree')
ylabel('Cross-validation error [%]')

show()
