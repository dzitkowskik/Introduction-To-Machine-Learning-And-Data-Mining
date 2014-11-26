import numpy as np
import random
from scipy.io import loadmat
import string
from sklearn import preprocessing
from sklearn.decomposition import PCA


class ClusteringData(object):
    def __init__(self, file_path='letter.mat', sample_size=500):
        self.mat_data = loadmat('letter.mat')
        self.y = np.matrix(self.mat_data['classlabel'].T)
        self.X = np.matrix(self.mat_data['X'])
        self.attributeNames = [
            n[0] for n in self.mat_data['attributeNames'][0]]

        print "Number of observations: ", sample_size

        # get a subset
        if sample_size != 0:
            subset = random.sample(xrange(self.X.shape[0]), sample_size)
            self.X = self.X[subset, :]
            self.y = self.y[subset, :]

        self.N, self.M = self.X.shape

    @staticmethod
    def get_label_encoder():
        labels = list(string.ascii_uppercase)
        le = preprocessing.LabelEncoder()
        le.fit(labels)
        return le

    def transform_by_pca(self, n_comp):
        reduced_data = PCA(n_components=n_comp).fit_transform(self.X)
        self.X = reduced_data
        self.N, self.M = self.X.shape
