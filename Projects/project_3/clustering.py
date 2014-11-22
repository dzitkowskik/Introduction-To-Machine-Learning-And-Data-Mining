import string
import numpy as np
from data import ClusteringData
from pylab import *
from multiprocessing import Pool
from sklearn import mixture
from sklearn import cross_validation
from sklearn import metrics
from sklearn import preprocessing


class GmmClustering(object):
    def __init__(
            self,
            verbose=False,
            inner_folds=8,
            min_n_comp=20,
            max_n_comp=30,
            score_metric=metrics.adjusted_mutual_info_score):
                self.inner_folds = inner_folds
                self.min_n_comp = min_n_comp
                self.max_n_comp = max_n_comp
                self.score_metric = score_metric

    # Since we have class labels for the training data, we can
    # initialize the GMM parameters in a supervised manner.
    # g.means_ = self.__get_means(X_train, y_train, n_comp)
    def __get_means(self, X, y, n_comp):
        means = [X[y == i].mean(axis=0) for i in xrange(n_comp)]
        return np.array(means).squeeze()

    def find_n_components(self, X, y, le):
        N, M = X.shape
        cv = cross_validation.KFold(N, self.inner_folds, shuffle=True)
        comp_count = self.max_n_comp - self.min_n_comp + 1
        inner_scores = np.zeros((self.inner_folds, comp_count))
        classes_count = len(le.classes_)

        j = 0
        for train_index, test_index in cv:
            X_train = X[train_index, :]
            y_train = le.transform(ravel(y[train_index, :]))
            X_test = X[test_index, :]
            y_test = le.transform(ravel(y[test_index, :]))

            for n_comp in range(self.min_n_comp, self.max_n_comp + 1):
                g = mixture.GMM(n_components=n_comp)
                g.fit(X_train)
                results = g.predict(X_test)

                # Since we have class labels for the training data, we can
                # initialize the GMM parameters in a supervised manner.
                # if n_comp == classes_count:
                #     g.means_ = self.__get_means(X_train, y_train, n_comp)

                inner_score_index = n_comp - self.min_n_comp
                score = self.score_metric(y_test, results)
                inner_scores[j, inner_score_index] = score
            j += 1

        scores = inner_scores.mean(axis=0)
        print "Scores: ", scores
        optimal_n_component = self.min_n_comp + scores.argmax()
        print "Optimal number of components: ", optimal_n_component
        return optimal_n_component

    def run(self, fold, X_train, y_train, X_test, y_test):
        le = preprocessing.LabelEncoder()
        le.fit(list(string.ascii_uppercase))
        n_comp = self.find_n_components(X_train, y_train, le)
        g = mixture.GMM(n_components=n_comp)
        g.fit(X_train)
        results = g.predict(X_test)
        y_test = le.transform(ravel(y_test))
        score = self.score_metric(y_test, results)
        print "GMM clustering fold ", fold, " score: ", score
        return score

    def __call__(self, fold, X_train, y_train, X_test, y_test):
        return self.run(fold, X_train, y_train, X_test, y_test)


def main():
    data = ClusteringData()
    K = 10  # K-fold crossvalidation
    N = 1  # number of clustering algorithms
    CV = cross_validation.KFold(data.N, K, shuffle=True)
    gmm_clustering = GmmClustering()
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
            gmm_clustering,
            args=(i, X_train, y_train, X_test, y_test)
            )
        i += 1

    av = {}
    for no in range(0, N):
        errors[no] = map((lambda x: responses[x, no].get()), range(0, K))
        av[no] = np.average(errors[no])
        print "Alg ", no, " scores: \n\t", errors[no], "\naverage: ", av[no]

    pool.close()
    pool.join()
    return


if __name__ == '__main__':
    main()
