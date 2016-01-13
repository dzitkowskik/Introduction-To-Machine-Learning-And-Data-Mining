# exercise 7.1.3

from pylab import *
from scipy.io import loadmat
from sklearn.neighbors import KNeighborsClassifier

# requires data from exercise 4.1.1
from ex4_1_1 import *

# Maximum number of neighbors
L=40


# Cross-validation not necessary. Instead, compute matrix of nearest neighbor
# distances between each pair of data points ..
knclassifier = KNeighborsClassifier(n_neighbors=L+1).fit(X, ravel(y))
neighbors = knclassifier.kneighbors(X)
# .. and extract matrix where each row contains class labels of subsequent neighbours
# (sorted by distance)
ndist, nid = neighbors[0], neighbors[1]
nclass = y[nid].flatten().reshape(N,L+1)

# Use the above matrix to compute the class labels of majority of neighbors
# (for each number of neighbors l), and estimate the test errors.
errors = np.zeros(L)
nclass_count = np.zeros((N,C))
for l in range(1,L+1):
    for c in range(C):
        nclass_count[:,c] = sum(nclass[:,1:l+1]==c,1).A.ravel()
    y_est = np.argmax(nclass_count,1);
    errors[l-1] = (y_est!=y.A.ravel()).sum()


# Plot the classification error rate
figure(1)
plot(100*errors/N)
xlabel('Number of neighbors')
ylabel('Classification error rate (%)')

figure(2)
imshow(nclass, cmap='binary', interpolation='None'); xlabel("k'th neighbor"); ylabel('data point'); title("Neighbors class matrix");

show()
