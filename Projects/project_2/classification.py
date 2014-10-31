import sys
from pylab import *
from Data import ClassificationData
from multiprocessing import Pool
from NaiveBayes import NaiveBayes
from NNearestNeighbors import KNeighbors
from PyBrainNN import NeuralNetwork
import numpy as np
from sklearn import cross_validation


def main():
    np.set_printoptions(edgeitems=7)
    data = ClassificationData()
    K = 4  # K-fold crossvalidation
    N = 3  # number of classification algorithms
    CV = cross_validation.KFold(data.N, K, shuffle=True)
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
