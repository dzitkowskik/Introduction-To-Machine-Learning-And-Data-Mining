import sys
from pylab import *
import numpy as np
from sklearn.neighbors import KNeighborsClassifier
from sklearn import cross_validation
from sklearn import preprocessing


class KNeighbors(object):
    def __init__(self, max_k=20, internal_cross=4, p=2):
        self.max_k = max_k
        self.internal_cross = internal_cross
        self.p = p

    def __plot(self, y_est, y_test):
        le = preprocessing.LabelEncoder()
        le.fit(ravel(y_train))
        est = le.transform(ravel(y_est))
        actual = le.transform(ravel(y_test))
        figure(0)
        grid(True)
        xlabel("Estimated values")
        ylabel("Actual values")
        plot(est, actual, 'bs', ms=4.0)
        show()

    def __get_best_k(self, X, y):
        n, m = X.shape
        cv = cross_validation.KFold(n, self.internal_cross, shuffle=True)
        inner_errors = np.zeros((self.internal_cross, self.max_k))
        j = 0
        for train_index, test_index in cv:
            X_train = X[train_index, :]
            y_train = y[train_index, :]
            X_test = X[test_index, :]
            y_test = y[test_index, :]
            for l in range(0, self.max_k):
                knclassifier = KNeighborsClassifier(n_neighbors=l+1, p=self.p)
                knclassifier.fit(X_train, ravel(y_train))
                y_est = knclassifier.predict(X_test)
                inner_errors[j, l] = \
                    np.sum(ravel(y_est) != ravel(y_test)) / float(len(X_test))
            j += 1
        errors = sum(inner_errors, 0) / float(self.internal_cross)

        print "KN error rates: ", errors
        sys.stdout.flush()

        return errors.argmin() + 1

    def run(self, fold, X_train, y_train, X_test, y_test):
        best_k = self.__get_best_k(X_train, y_train)
        knclassifier = KNeighborsClassifier(n_neighbors=best_k, p=2)
        knclassifier.fit(X_train, ravel(y_train))
        y_est = knclassifier.predict(X_test)
        # self.__plot(y_est, y_test)
        return np.sum(ravel(y_est) != ravel(y_test)) / float(len(X_test))

    def __call__(self, fold, X_train, y_train, X_test, y_test):
        return self.run(fold, X_train, y_train, X_test, y_test)
