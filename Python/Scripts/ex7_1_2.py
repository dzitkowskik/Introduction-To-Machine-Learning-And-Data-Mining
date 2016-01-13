# exercise 7.1.2

from pylab import *
from scipy.io import loadmat
from sklearn.neighbors import KNeighborsClassifier
from sklearn import cross_validation

# requires data from exercise 4.1.1
from ex4_1_1 import *

# Maximum number of neighbors
L=40

CV = cross_validation.LeaveOneOut(N)
errors = np.zeros((N,L))
i=0
for train_index, test_index in CV:
    print('Crossvalidation fold: {0}/{1}'.format(i+1,N))

    # extract training and test set for current CV fold
    X_train = X[train_index,:]
    y_train = y[train_index,:]
    X_test = X[test_index,:]
    y_test = y[test_index,:]

    # Fit classifier and classify the test points (consider 1 to 40 neighbors)
    for l in range(1,L+1):
        knclassifier = KNeighborsClassifier(n_neighbors=l);
        knclassifier.fit(X_train, ravel(y_train));
        y_est = knclassifier.predict(X_test);
        errors[i,l-1] = np.sum(y_est[0]!=y_test[0,0])

    i+=1

# Plot the classification error rate
figure()
plot(100*sum(errors,0)/N)
xlabel('Number of neighbors')
ylabel('Classification error rate (%)')
show()
