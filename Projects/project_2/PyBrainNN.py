import sys
from Data import ClassificationData
from pybrain.tools.shortcuts import buildNetwork
from pybrain.supervised.trainers import BackpropTrainer
from pybrain.structure.modules import SoftmaxLayer
from pybrain.utilities import percentError
from pybrain.tools.validation import CrossValidator
from pybrain.tools.validation import ModuleValidator
from sklearn import cross_validation
import numpy as np


class NeuralNetwork(object):
    def __init__(self, inner_cross=3, min_hu=10, max_hu=30, epochs=200):
        self.inner_cross = inner_cross
        self.min_hu = min_hu
        self.max_hu = max_hu
        self.epochs = epochs

    def __get_best_hu(self, DS):
        X = DS['input']
        y = DS['class']

        hu_number = self.max_hu-self.min_hu+1
        N, M = X.shape
        inner_errors = np.zeros((self.inner_cross, hu_number))

        cv = cross_validation.KFold(N, self.inner_cross, shuffle=True)

        j = 0
        for train_index, test_index in cv:
            X_train = X[train_index, :]
            y_train = y[train_index, :]
            X_test = X[test_index, :]
            y_test = y[test_index, :]

            DS_train, DS_test = ClassificationData.convert_to_DS(
                X_train,
                y_train,
                X_test,
                y_test)

            for i in range(0, hu_number):
                fnn = buildNetwork(
                    DS_train.indim,
                    self.min_hu+i,
                    DS_train.outdim,
                    outclass=SoftmaxLayer,
                    bias=True)

                trainer = BackpropTrainer(
                    fnn,
                    dataset=DS_train,
                    momentum=0.1,
                    verbose=False,
                    weightdecay=0.01)

                trainer.trainEpochs(10)
                inner_errors[j, i] = percentError(
                    trainer.testOnClassData(dataset=DS_test),
                    DS_test['class'])

                print "Inner errors [", j, "] ", inner_errors[j]
            j += 1

        errors = sum(inner_errors, 0) / float(self.inner_cross)

        print "\nNeural network error rates: ", errors, "\n"
        sys.stdout.flush()

        optimal_hu = self.min_hu + errors.argmin()

        print "\nNN best hidden layer neurons = ", optimal_hu, "\n"
        sys.stdout.flush()

        return optimal_hu

    def run(self, fold, X_train, y_train, X_test, y_test):
        DS_train, DS_test = ClassificationData.convert_to_DS(
            X_train,
            y_train,
            X_test,
            y_test)

        NHiddenUnits = self.__get_best_hu(DS_train)
        fnn = buildNetwork(
            DS_train.indim,
            NHiddenUnits,
            DS_train.outdim,
            outclass=SoftmaxLayer,
            bias=True)

        trainer = BackpropTrainer(
            fnn,
            dataset=DS_train,
            momentum=0.1,
            verbose=False,
            weightdecay=0.01)

        trainer.trainEpochs(self.epochs)
        tstresult = percentError(
            trainer.testOnClassData(dataset=DS_test),
            DS_test['class'])

        print "NN fold: %4d" % fold, "; test error: %5.2f%%" % tstresult
        return tstresult / 100.0

    def __call__(self, fold, X_train, y_train, X_test, y_test):
        return self.run(fold, X_train, y_train, X_test, y_test)
