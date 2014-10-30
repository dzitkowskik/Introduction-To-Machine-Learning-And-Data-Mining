import numpy as np
import random
from scipy.io import loadmat
from pybrain.datasets import ClassificationDataSet
from sklearn import preprocessing
import string


class ClassificationData(object):
    def __init__(self, file_path='letter.mat', sample_size=5000, ds_prop=0.25):
        self.mat_data = loadmat('letter.mat')
        self.y = np.matrix(self.mat_data['classlabel'].T)
        self.X = np.matrix(self.mat_data['X'])
        self.attributeNames = [
            n[0] for n in self.mat_data['attributeNames'][0]]

        print "Number of observations: ", sample_size

        # Add offset attribute
        self.X = np.concatenate((np.ones((self.X.shape[0], 1)), self.X), 1)
        self.attributeNames = [u'Offset']+self.attributeNames

        # get a subset
        subset = random.sample(xrange(self.X.shape[0]), sample_size)

        self.X = self.X[subset, :]
        self.y = self.y[subset, :]

        self.N, self.M = self.X.shape

        self.DS = ClassificationData.conv2DS(self.X, self.y.T)
        self.DS_train, self.DS_test = self.DS.splitWithProportion(ds_prop)
        self.DS_train._convertToOneOfMany()
        self.DS_test._convertToOneOfMany()

    def __get_a_subset(self, X, y, sample_size):
        subset = random.sample(xrange(X.shape[0]), sample_size)
        return X[subset, :], y[subset, :]

    @staticmethod
    def conv2DS(Xv, yv=None, labels=string.ascii_uppercase):
        N, M = Xv.shape
        if yv is None:
            yv = np.asmatrix(np.ones((Xv.shape[0], 1)))
            for j in range(len(classNames)):
                yv[j] = j

        le = preprocessing.LabelEncoder()
        y_asnumbers = le.fit_transform(np.ravel(yv))

        C = len(np.unique(np.ravel(yv)))
        DS = ClassificationDataSet(
            M,
            1,
            nb_classes=C,
            class_labels=labels)
        for i in range(Xv.shape[0]):
            DS.appendLinked(Xv[i, :], y_asnumbers[i])
        return DS

    @staticmethod
    def convert_to_DS(X_train, y_train, X_test, y_test):
        DS_train = ClassificationData.conv2DS(X_train, y_train)
        DS_test = ClassificationData.conv2DS(X_test, y_test)
        DS_train._convertToOneOfMany()
        DS_test._convertToOneOfMany()
        return DS_train, DS_test
