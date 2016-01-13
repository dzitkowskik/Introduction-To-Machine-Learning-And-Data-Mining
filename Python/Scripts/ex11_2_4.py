# exercise 11.2.4
from pylab import *
from sklearn.neighbors import NearestNeighbors

# Draw samples from mixture of gaussians (as in exercise 11.1.1)
N = 1000; M = 1
x = np.linspace(-10, 10, 50)
X = np.empty((N,M))
m = np.array([1, 3, 6]); s = np.array([1, .5, 2])
c_sizes = np.random.multinomial(N, [1./3, 1./3, 1./3])
for c_id, c_size in enumerate(c_sizes):
    X[c_sizes.cumsum()[c_id]-c_sizes[c_id]:c_sizes.cumsum()[c_id],:] = np.random.normal(m[c_id], np.sqrt(s[c_id]), (c_size,M))

# Neighbor to use
K = 5

# Find the k nearest neighbors
knn = NearestNeighbors(n_neighbors=K).fit(X)
D, i = knn.kneighbors(X)

# Outlier score
score = D[:,K-1]

# Sort the scores
i = score.argsort()
score = score[i[::-1]]

# Display the index of the lowest density data object
print('Top outlier score: {0} for data object: {1}'.format(score[0],i[0]))

# Plot k-neighbor estimate of outlier score (distances)
figure()
bar(range(20),score[:20])
title('Distance: Outlier score')
show()

