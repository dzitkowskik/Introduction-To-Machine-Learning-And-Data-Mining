# exercise 5.2.1

from pylab import *
import sklearn.linear_model as lm

# Use dataset as in the previous exercise
N = 100
X = np.mat(range(N)).T
eps_mean, eps_std = 0, 0.1
eps = np.mat(eps_std*np.random.randn(N) + eps_mean).T
w0 = -0.5
w1 = 0.01
y = w0 + w1*X + eps
y_true = y - eps

# Fit ordinary least squares regression model
model = lm.LinearRegression(fit_intercept=True)
model = model.fit(X,y)
# Compute model output:
y_est = model.predict(X)
# Or equivalently:
#y_est = model.intercept_ + X * model.coef_


# Plot original data and the modeli output
f = figure()
f.hold(True)

plot(X.A,y.A,'.')
plot(X.A,y_true.A,'-')
plot(X.A,y_est,'-')
xlabel('X'); ylabel('y')
legend(['Training data', 'Data generator', 'Regression fit (model)'])

show()
