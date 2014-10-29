import sys
from pylab import *
import numpy as np
from scipy.io import loadmat
import random
from sklearn import cross_validation
from sklearn import preprocessing
import neurolab as nl


class Data(object):
    def __init__(self, sample_size=2000):
        self.mat_data = loadmat('letter.mat')
        self.y = np.matrix(self.mat_data['classlabel'].T)
        self.X = np.matrix(self.mat_data['X'])
        self.attributeNames = [
            n[0] for n in self.mat_data['attributeNames'][0]]

        print "Number of observations: ", sample_size

        # Add offset attribute
        self.X = np.concatenate((np.ones((self.X.shape[0], 1)), self.X), 1)
        self.attributeNames = [u'Offset']+self.attributeNames

        #get a subset
        subset = random.sample(xrange(self.X.shape[0]), sample_size)

        self.X = self.X[subset,:]
        self.y = self.y[subset,:]

        self.N, self.M = self.X.shape
        self.M = self.M+1


def main():
    np.set_printoptions(edgeitems=8)
    data = Data()
    N, M = data.N, data.M

    # Parameters for neural network classifier
    n_units = [26, 1]     # number of layer units
    n_train = 15           # number of networks trained in each k-fold

    # These parameters are usually adjusted to: (1) data specifics, (2) computational constraints
    learning_goal = 0.0001     # stop criterion 1 (train mse to be reached)
    max_epochs = 800        # stop criterion 2 (max epochs in training)

    # K-fold CrossValidation (4 folds here to speed up this example)
    K = 2
    CV = cross_validation.KFold(N,K,shuffle=True)

    # Variable for classification error
    errors = np.zeros(K)
    error_hist = np.zeros((max_epochs,K))
    bestnet = list()

    print "Starting NN training ", n_units

    k=0
    for train_index, test_index in CV:
        print('\nCrossvalidation fold: {0}/{1}'.format(k+1,K))

        # extract training and test set for current CV fold
        X_train = data.X[train_index,:]
        y_train = data.y[train_index,:]
        X_test = data.X[test_index,:]
        y_test = data.y[test_index,:]

        le = preprocessing.LabelEncoder()
        le.fit_transform(ravel(y_train))

        best_train_error = 1e100
        for i in range(n_train):
            ann = nl.net.newff([[0.0, 15.0]]*17, n_units)
            y = (np.matrix(le.transform(ravel(y_train))).T / 12.5) - 1.0

            train_error = ann.train(X_train, y, goal=learning_goal, epochs=max_epochs, show=round(max_epochs/50))

            if train_error[-1]<best_train_error:
                bestnet.append(ann)
                best_train_error = train_error[-1]
                error_hist[range(len(train_error)),k] = train_error

        result = map((lambda x: int(round((x + 1.0) * 12.5))), ravel(bestnet[k].sim(X_test)))
        y_est = le.inverse_transform(result)
        e = (ravel(y_est) != ravel(y_test)).sum().astype(float)/y_test.shape[0]
        print e
        errors[k] = e
        k+=1

    bestnet[-1].save('bestnet.net')


    # Print the average classification error rate
    print('Error rate: {0}%'.format(100*mean(errors)))



if __name__ == '__main__':
    main()
