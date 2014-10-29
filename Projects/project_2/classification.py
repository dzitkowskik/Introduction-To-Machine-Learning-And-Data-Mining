import sys
from pylab import *
import numpy as np
from scipy.io import loadmat
from sklearn.neighbors import KNeighborsClassifier
from sklearn import cross_validation
from multiprocessing import Pool
from sklearn.pipeline import Pipeline
from sklearn.feature_selection import RFECV
from sklearn.svm import LinearSVC
from sklearn.naive_bayes import MultinomialNB
from sklearn.cross_validation import StratifiedKFold
from sklearn import preprocessing
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2
import neurolab as nl
import random


def get_a_subset(X, y, sample_size):
    subset = random.sample(xrange(X.shape[0]), sample_size)
    return X[subset, :], y[subset, :]


class Data(object):
    def __init__(self):
        self.mat_data = loadmat('letter.mat')
        self.y = np.matrix(self.mat_data['classlabel'].T)
        self.X = np.matrix(self.mat_data['X'])
        self.attributeNames = [
            n[0] for n in self.mat_data['attributeNames'][0]]
        self.N, self.M = self.X.shape

        # Add offset attribute
        self.X = np.concatenate((np.ones((self.X.shape[0], 1)), self.X), 1)
        self.attributeNames = [u'Offset']+self.attributeNames
        self.M = self.M+1


class KNeighbors(object):
    def __init__(self, max_k=8, internal_cross=4, p=2):
        self.max_k = max_k
        self.internal_cross = internal_cross
        self.p = p

    def __get_best_k(self, X, y):
        n, m = X.shape
        cv = cross_validation.KFold(n, self.internal_cross)
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

        print "error rates: ", errors
        sys.stdout.flush()

        return errors.argmin() + 1

    def run(self, fold, X_train, y_train, X_test, y_test):
        best_k = self.__get_best_k(X_train, y_train)
        knclassifier = KNeighborsClassifier(n_neighbors=best_k, p=2)
        knclassifier.fit(X_train, ravel(y_train))
        y_est = knclassifier.predict(X_test)

        print "KNeighbors fold ", fold, " done!"
        sys.stdout.flush()

        return np.sum(ravel(y_est) != ravel(y_test)) / float(len(X_test))

    def __call__(self, fold, X_train, y_train, X_test, y_test):
        return self.run(fold, X_train, y_train, X_test, y_test)


class NaiveBayes(object):
    def __init__(self, alpha=1.0, est_prior=True, internal_cross=5):
        self.alpha = alpha
        self.est_prior = est_prior
        self.internal_cross = internal_cross

    def run(self, fold, X_train, y_train, X_test, y_test):
        nb_classifier = MultinomialNB(
            alpha=self.alpha,
            fit_prior=self.est_prior)
        le = preprocessing.LabelEncoder()
        y = le.fit_transform(ravel(y_train))

        feature_selector = RFECV(
            estimator=nb_classifier,
            step=1,
            cv=StratifiedKFold(ravel(y), self.internal_cross),
            scoring='accuracy'
            )

        classifier = Pipeline([
            ('feature_selection', feature_selector),
            ('classification', nb_classifier)
            ])

        classifier.fit(X_train, y)
        result = classifier.predict(X_test)
        y_est = le.inverse_transform(result)

        error_sum = np.sum(ravel(y_est) != ravel(y_test))
        return error_sum / float(len(X_test))

    def __call__(self, fold, X_train, y_train, X_test, y_test):
        return self.run(fold, X_train, y_train, X_test, y_test)


class NeuralNetwork(object):
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
        cv = cross_validation.KFold(n, self.internal_cross)
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
        print y_train_new
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


def main():
    np.set_printoptions(edgeitems=7)
    data = Data()
    K = 2  # K-fold crossvalidation
    N = 3  # number of classification algorithms
    CV = cross_validation.KFold(data.N, K)
    k_neighbours = KNeighbors()
    naive_bayes = NaiveBayes()
    nn = NeuralNetwork()
    errors = np.zeros((N, K))
    pool = Pool(K*N)
    responses = {}
    i = 0
    for train_index, test_index in CV:
        X_train = data.X[train_index, :]
        y_train = data.y[train_index, :]
        X_test = data.X[test_index, :]
        y_test = data.y[test_index, :]

        nn.run(i, X_train, y_train, X_test, y_test)
        exit()

        responses[i, 0] = pool.apply_async(
            k_neighbours,
            args=(i, X_train, y_train, X_test, y_test)
            )
        responses[i, 1] = pool.apply_async(
            naive_bayes,
            args=(i, X_train, y_train, X_test, y_test)
            )
        responses[i, 2] = pool.apply_async(
            nn,
            args=(i, X_train, y_train, X_test, y_test)
            )
        i += 1
    errors[0] = map((lambda x: responses[x, 0].get()), range(0, K))
    errors[1] = map((lambda x: responses[x, 1].get()), range(0, K))
    errors[2] = map((lambda x: responses[x, 2].get()), range(0, K))
    a0 = np.average(errors[0])
    a1 = np.average(errors[1])
    a2 = np.average(errors[2])
    print "k-neighbours error rates: \n\t", errors[0], "\naverage: ", a0
    print "naive bayes error rates: \n\t", errors[1], "\naverage: ", a1
    print "Neural network error rates: \n\t", errors[2], "\naverage: ", a2
    pool.close()
    pool.join()
    return


if __name__ == '__main__':
    main()
