# exercise 9.1.3
from pylab import *
from scipy.io import loadmat
from toolbox_02450 import clusterval
from sklearn.cluster import k_means
import sklearn.metrics.cluster as cluster_metrics

# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/synth1.mat')
X = np.matrix(mat_data['X'])
y = np.matrix(mat_data['y'])
attributeNames = [name[0] for name in mat_data['attributeNames'].squeeze()]
classNames = [name[0][0] for name in mat_data['classNames']]
N, M = X.shape
C = len(classNames)


# Maximum number of clusters:
K = 10

# Allocate variables:
Entropy = np.zeros((K,1))
Purity = np.zeros((K,1))
Rand = np.zeros((K,1))
Jaccard = np.zeros((K,1))
OtherMetrics = np.zeros((K,5))

for k in range(K):
    # run K-means clustering:
    #cls = Pycluster.kcluster(X,k+1)[0]
    centroids, cls, inertia = k_means(X,k+1)
    # compute cluster validities:
    Entropy[k], Purity[k], Rand[k], Jaccard[k] = clusterval(y,cls)
    # compute other metrics, implemented in sklearn.metrics package
    OtherMetrics[k,0] = cluster_metrics.supervised.completeness_score(y.A.ravel(),cls)
    OtherMetrics[k,1] = cluster_metrics.supervised.homogeneity_score(y.A.ravel(),cls)
    OtherMetrics[k,2] = cluster_metrics.supervised.mutual_info_score(y.A.ravel(),cls)
    OtherMetrics[k,3] = cluster_metrics.supervised.v_measure_score(y.A.ravel(),cls)
    OtherMetrics[k,4] = cluster_metrics.supervised.adjusted_rand_score(y.A.ravel(),cls)


# Plot results:

figure(1)
title('Cluster validity')
hold(True)
plot(np.arange(K)+1, -Entropy)
plot(np.arange(K)+1, Purity)
plot(np.arange(K)+1, Rand)
plot(np.arange(K)+1, Jaccard)
ylim(-2,1.1)
legend(['Negative Entropy', 'Purity', 'Rand', 'Jaccard'], loc=4)

figure(2)
title('Cluster validity - other metrics')
hold(True)
plot(np.arange(K)+1, OtherMetrics)
legend(['completeness score', 'homogeneity score', 'mutual info score', 'v-measure score', 'adjusted rand score'], loc=4)

show()
