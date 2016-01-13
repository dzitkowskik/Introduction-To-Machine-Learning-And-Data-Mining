# exercise 11.1.3
from pylab import *
from sklearn.mixture import GMM

# Draw samples from mixture of gaussians (as in exercise 11.1.1)
N = 1000; M = 1
x = np.linspace(-10, 10, 50)
X = np.empty((N,M))
m = np.array([1, 3, 6]); s = np.array([1, .5, 2])
c_sizes = np.random.multinomial(N, [1./3, 1./3, 1./3])
for c_id, c_size in enumerate(c_sizes):
    X[c_sizes.cumsum()[c_id]-c_sizes[c_id]:c_sizes.cumsum()[c_id],:] = np.random.normal(m[c_id], np.sqrt(s[c_id]), (c_size,M))


# x-values to evaluate the KDE
xe = linspace(-10, 10, 100)

# Fit Gaussian Mixture Model to the data
K=3
gmm = GMM(n_components=K).fit(X)
gmm_estimated_density = np.exp(gmm.score_samples(xe)[0])

# Plot kernel density estimate
figure()
subplot(2,1,1)
hist(X,x)
title('Data histogram')
subplot(2,1,2)
plot(xe, gmm_estimated_density)
title('Kernel density estimate')
show()
