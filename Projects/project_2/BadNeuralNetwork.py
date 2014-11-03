import sys
from pylab import *
import numpy as np
import neurolab as nl
import random
from sklearn import preprocessing
from sklearn import cross_validation


class BadNeuralNetwork(object):
    def __init__(self, internal_cross=2, layers=1, n_train=6, sample_size=800):
        self.layers = layers
        self.internal_cross = internal_cross
        self.n_train = n_train
        self.sample_size = sample_size

    def __get_best_NN(self, X, y):
        X, y = get_a_subset(X, y, self.sample_size)
        n = X.shape[0]
        le = preprocessing.LabelEncoder()
        le.fit_transform(ravel(y))
        y = np.matrix(le.transform(ravel(y))).T
        cv = cross_validation.KFold(n, self.internal_cross, shuffle=True)
        # Create n_train random neural networks
        ann = {}
        n_units = [26, 1]
        for i in range(self.n_train):
            ann[i] = nl.net.newff([[0.0, 15.0]]*17, n_units)

        # Use internal cross validation on that networks
        j = 0
        inner_errors = np.zeros((self.internal_cross, self.n_train))
        for train_index, test_index in cv:
            X_train = X[train_index, :]
            y_train = (y[train_index, :] / 12.5) - 1.0
            X_test = X[test_index, :]
            y_test = y[test_index, :]
            n_tests = float(y_test.shape[0])

            for i in range(self.n_train):
                train_error = ann[i].train(
                    X_train,
                    y_train,
                    goal=0.0001,
                    epochs=400,
                    show=20)
                # print "Train error ", j, " ", i, " = ", train_error[-1]
                # sys.stdout.flush()
                result = ravel(ann[i].sim(X_test))
                y_est = map((lambda x: int(round((x + 1.0) * 12.5))), result)
                # print ravel(y_est)
                # print ravel(y_test)
                test_error = (ravel(y_est) != ravel(y_test)).sum() / n_tests
                inner_errors[j, i] = test_error
                print "Test error ", j, " ", i, " = ", test_error
                # sys.stdout.flush()
            j += 1
        print "Inner errors", inner_errors
        errors = sum(inner_errors, 0) / float(self.internal_cross)
        print "Errors ", errors
        sys.stdout.flush()
        return ann[errors.argmin()], le

    def run(self, fold, X_train, y_train, X_test, y_test):
        best_nn, le = self.__get_best_NN(X_train, y_train)
        y_train_new = np.matrix(le.transform(ravel(y_train))).T
        y_train_new /= 12.5
        y_train_new -= 1
        best_nn.train(
            X_train,
            y_train_new,
            goal=0.0001,
            epochs=800,
            show=10)

        y = le.transform(ravel(y_test))
        result = best_nn.sim(X_test)
        y_est = map((lambda x: int(round(x*25.0))), result)
        test_error = (ravel(y_est) != ravel(y)).sum()/float(X_test.shape[0])
        print "NN test error: ", test_error
        sys.stdout.flush()

    def __call__(self, fold, X_train, y_train, X_test, y_test):
        return self.run(fold, X_train, y_train, X_test, y_test)
