import sys
from pylab import *
import numpy as np
from sklearn.pipeline import Pipeline
from sklearn.feature_selection import RFECV
from sklearn.svm import LinearSVC
from sklearn.naive_bayes import MultinomialNB
from sklearn.cross_validation import StratifiedKFold
from sklearn import preprocessing
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2


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
