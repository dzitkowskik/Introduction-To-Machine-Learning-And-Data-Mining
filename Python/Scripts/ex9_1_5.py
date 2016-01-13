# exercise 9_1_5
from pylab import *
from scipy.io import loadmat
from sklearn.cluster import k_means


# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/digits.mat')
X = np.matrix(mat_data['X'])
N, M = X.shape
print X.shape
# Image resolution and number of colors
x = 16
y = 16
c = 1


# Number of clusters:
K = 20

# Number of repetitions with different initial centroid seeds
S = 1

# Run k-means clustering:
centroids, cls, inertia = k_means(X, K, verbose=True, max_iter=100, n_init=S)


# Plot results:

# Plot centroids
figure(1)
n1 = np.ceil(np.sqrt(K/2)); n2 = np.ceil(np.float(K)/n1);
for k in range(K):
    subplot(n1,n2,k+1)
    imshow(np.reshape(centroids[k,:],(c,x,y)).T.squeeze(),interpolation='None',cmap=cm.binary)
    xticks([]); yticks([])
    if k==np.floor((n2-1)/2): title('Centroids')

# Plot few randomly selected faces and their nearest centroids
L = 5       # number of images to plot
j = np.random.randint(0, N, L)
figure(2)
for l in range(L):
    subplot(2,L,l+1)
    imshow(np.resize(X[j[l],:],(c,x,y)).T.squeeze(),interpolation='None',cmap=cm.binary)
    xticks([]); yticks([])
    if l==np.floor((L-1)/2): title('Randomly selected faces and their centroids')
    subplot(2,L,L+l+1)
    imshow(np.resize(centroids[cls[j[l]],:],(c,x,y)).T.squeeze(),interpolation='None',cmap=cm.binary)
    xticks([]); yticks([])

show()
