import string
import numpy as np
from data import ClusteringData
from pylab import *
import matplotlib.pyplot as plt
from multiprocessing import Pool, Lock
from sklearn import mixture
from sklearn import cross_validation
from sklearn import metrics
from sklearn import preprocessing
from scipy.cluster.hierarchy import linkage, fcluster, dendrogram
from itertools import product


def clusterplot_2D(X, clusterid, centroids=None, y=None, covars=None):

    X = np.asarray(X)
    cls = np.asarray(clusterid)

    if y is None:
        y = np.zeros((X.shape[0], 1))
    else:
        y = np.asarray(y)

    if centroids is not None:
        cent_x = centroids.shape[0]
        centroids = np.asarray(centroids)
    else:
        cent_x = 0

    K = np.size(np.unique(cls))
    C = np.size(np.unique(y))
    ncolors = np.max([C, K, cent_x])

    # plot data points color-coded by class, cluster markers and centroids
    hold(True)
    colors = [0]*ncolors

    for color in range(ncolors):
        colors[color] = cm.jet.__call__(color*255/(ncolors-1))[:3]

    for i, cs in enumerate(np.unique(y)):
        plt.plot(
            X[(y == cs).ravel(), 0],
            X[(y == cs).ravel(), 1],
            'o',
            markeredgecolor='k',
            markerfacecolor=colors[i],
            markersize=6,
            zorder=2)

    for i, cr in enumerate(np.unique(cls)):
        plt.plot(
            X[(cls == cr).ravel(), 0],
            X[(cls == cr).ravel(), 1],
            'o',
            markersize=12,
            markeredgecolor=colors[i],
            markerfacecolor=None,
            markeredgewidth=3,
            zorder=1)

    if centroids is not None:
        for cd in range(centroids.shape[0]):
            plt.plot(
                centroids[cd, 0],
                centroids[cd, 1],
                '*',
                markersize=22,
                markeredgecolor='k',
                markerfacecolor=colors[cd],
                markeredgewidth=2,
                zorder=3)

    # plot cluster shapes:
    if covars is not None:
        for cd in range(centroids.shape[0]):
            x1, x2 = gauss_2d(centroids[cd], covars[cd, :, :])
            plt.plot(x1, x2, '-', color=colors[cd], linewidth=3, zorder=5)

    # create legend
    legend_items = np.unique(y).tolist() \
        + np.unique(cls).tolist() \
        + np.unique(cls).tolist()

    for i in range(len(legend_items)):
        if i < C:
            legend_items[i] = 'Class: {0}'.format(legend_items[i])
        elif i < C + K:
            legend_items[i] = 'Cluster: {0}'.format(legend_items[i])
        else:
            legend_items[i] = 'Centroid: {0}'.format(legend_items[i])

    plt.legend(legend_items, numpoints=1, markerscale=.75, prop={'size': 9})


class GmmClustering(object):
    def __init__(
            self,
            verbose=True,
            inner_folds=3,
            min_n_comp=20,
            max_n_comp=30,
            score_metric=metrics.adjusted_mutual_info_score):
        self.verbose = verbose
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

    def find_n_components(self, X, y):
        N, M = X.shape
        cv = cross_validation.KFold(N, self.inner_folds, shuffle=True)
        comp_count = self.max_n_comp - self.min_n_comp + 1
        inner_scores = np.zeros((self.inner_folds, comp_count))

        j = 0
        for train_index, test_index in cv:
            X_train = X[train_index, :]
            y_train = y[train_index, :]
            X_test = X[test_index, :]
            y_test = y[test_index, :]

            for n_comp in range(self.min_n_comp, self.max_n_comp + 1):
                g = mixture.GMM(n_components=n_comp)
                g.fit(X_train)
                results = g.predict(X_test)
                inner_score_index = n_comp - self.min_n_comp
                score = self.score_metric(ravel(y_test), results)
                inner_scores[j, inner_score_index] = score
            j += 1

        scores = inner_scores.mean(axis=0)
        optimal_n_component = self.min_n_comp + scores.argmax()
        if self.verbose:
            print "Scores: ", scores
            print "Optimal number of components: ", optimal_n_component
        return optimal_n_component

    def __plot_2D(self, data, gmm, results, y_test):
        # Step size of the mesh. Decrease to increase the quality of the VQ.
        h = .02     # point in the mesh [x_min, m_max]x[y_min, y_max].
        centroids = gmm.means_

        # Plot the decision boundary. For that, we will assign a color to each
        x_min, x_max = data[:, 0].min(), data[:, 0].max()
        y_min, y_max = data[:, 1].min(), data[:, 1].max()
        x_range = np.arange(x_min, x_max, h)
        y_range = np.arange(y_min, y_max, h)
        xx, yy = np.meshgrid(x_range, y_range)

        # Obtain labels for each point in mesh. Use last trained model.
        Z = gmm.predict(np.c_[xx.ravel(), yy.ravel()])

        # Put the result into a color plot
        Z = Z.reshape(xx.shape)

        plt.figure()
        plt.clf()
        plt.subplot(121)
        plt.imshow(Z, interpolation='nearest',
                   extent=(xx.min(), xx.max(), yy.min(), yy.max()),
                   cmap=plt.cm.Paired,
                   aspect='auto', origin='lower')

        plt.plot(data[:, 0], data[:, 1], 'k.', markersize=3)

        # Plot the centroids as a white X
        plt.scatter(centroids[:, 0], centroids[:, 1],
                    marker='x', s=169, linewidths=3,
                    color='w', zorder=10)

        plt.title('GMM clustering on the letters dataset (PCA-reduced data)\n'
                  'Centroids are marked with white cross')
        plt.xlim(x_min, x_max)
        plt.ylim(y_min, y_max)
        plt.xticks(())
        plt.yticks(())

        plt.subplot(122)
        clusterplot_2D(data, results, centroids, y_test)

        plt.show()

    def run(self, fold, X_train, y_train, X_test, y_test):
        le = ClusteringData.get_label_encoder()
        y_train = le.transform(ravel(y_train))
        y_test = le.transform(ravel(y_test))

        n_comp = self.find_n_components(X_train, y_train)

        g = mixture.GMM(n_components=n_comp)
        g.fit(X_train)
        results = g.predict(X_test)
        score = self.score_metric(y_test, results)

        if self.verbose:
            print "GMM clustering fold ", fold, " score: ", score
            # print "Centroids: \n", g.means_
            if X_train.shape[1] == 2:
                lock.acquire()
                self.__plot_2D(X_test, g, results, y_test)
                lock.release()
        return score

    def __call__(self, fold, X_train, y_train, X_test, y_test):
        return self.run(fold, X_train, y_train, X_test, y_test)


class HierarchicalClustering(object):
    def __init__(
            self,
            cutoff=26,
            score_metric=metrics.adjusted_mutual_info_score,
            verbose=True,
            max_display_levels=6):
        self.cutoff = cutoff
        self.score_metric = score_metric
        self.verbose = verbose
        self.max_display_levels = max_display_levels
        self.available_metrics = [
            'euclidean',
            'minkowski',
            'cityblock',
            'seuclidean',
            'cosine',
            'sqeuclidean',
            'hamming',
            'jaccard',
            'chebyshev',
            'canberra',
            'braycurtis',
            'mahalanobis',
            'kulsinski',
            'sokalsneath']
        self.available_methods = [
            'single',
            'ward',
            'complete',
            'average',
            'weighted',
            'centroid',
            'median']
        self.available_criterions = [
            'inconsistent',
            'distance',
            'maxclust',
            'monocrit',
            'maxclust_monocrit']

    def get_best_linkage_options(self, X, y):
        options = list(product(self.available_methods, self.available_metrics))
        scores = np.zeros(len(options))

        i = 0
        for method, metric in options:
            try:
                z = linkage(X, method=method, metric=metric)
                results = fcluster(z, criterion='maxclust', t=self.cutoff)
                scores[i] = self.score_metric(y, results)
            except:
                scores[i] = 0
            i += 1

        optimal_options = options[scores.argmax()]
        if self.verbose:
            # print "Scores: ", scores
            print "Optimal options (method, metric): ", optimal_options
        return optimal_options

    def plot(self, X, y, z, result):
        plt.figure()
        plt.clf()
        plt.subplot(121)
        clusterplot_2D(X, result.reshape(result.shape[0], 1), y=y)

        # Display dendrogram
        plt.subplot(122)
        dendrogram(z, truncate_mode='level', p=self.max_display_levels)
        plt.show()

    def run(self, fold, X_train, y_train, X_test, y_test):
        le = ClusteringData.get_label_encoder()
        y_train = le.transform(ravel(y_train))
        y_test = le.transform(ravel(y_test))

        method, metric = self.get_best_linkage_options(X_train, y_train)
        z = linkage(X_test, method=method, metric=metric)

        results = fcluster(z, criterion='maxclust', t=self.cutoff)
        score = self.score_metric(y_test, results)

        if self.verbose:
            print "Hierarchical clustering fold ", fold, " score: ", score
            lock.acquire()
            self.plot(X_test, y_test, z, results)
            lock.release()

        return score

    def __call__(self, fold, X_train, y_train, X_test, y_test):
        return self.run(fold, X_train, y_train, X_test, y_test)


def clustering(reduce=False, async_mode=True):
    data = ClusteringData()
    if reduce:
        print "Data reduced by PCA with 2 dim!"
        data.transform_by_pca(2)
    K = 10  # K-fold crossvalidation
    N = 2  # number of clustering algorithms
    CV = cross_validation.KFold(data.N, K, shuffle=True)
    gmm_clustering = GmmClustering(verbose=False)
    hier_clustering = HierarchicalClustering(verbose=False)
    alg_names = ['GMM', 'Hierarchical']
    errors = np.zeros((N, K))
    pool = Pool(K*N)
    responses = {}

    i = 0
    for train_index, test_index in CV:
        X_train = data.X[train_index, :]
        y_train = data.y[train_index, :]
        X_test = data.X[test_index, :]
        y_test = data.y[test_index, :]

        if async_mode:
            responses[i, 0] = pool.apply_async(
                gmm_clustering,
                args=(i, X_train, y_train, X_test, y_test)
                )
            responses[i, 1] = pool.apply_async(
                hier_clustering,
                args=(i, X_train, y_train, X_test, y_test)
                )
        else:
            responses[i, 0] = \
                gmm_clustering.run(0, X_train, y_train, X_test, y_test)
            responses[i, 1] = \
                hier_clustering.run(0, X_train, y_train, X_test, y_test)

        i += 1

    av = {}
    for no in range(0, N):
        if async_mode:
            errors[no] = map((lambda x: responses[x, no].get()), range(0, K))
        else:
            errors[no] = map((lambda x: responses[x, no]), range(0, K))
        av[no] = np.average(errors[no])
        print alg_names[no], " clustering scores: \n\t", \
            errors[no], "\naverage: ", av[no]

    pool.close()
    pool.join()
    return


if __name__ == '__main__':
    lock = Lock()
    clustering()
