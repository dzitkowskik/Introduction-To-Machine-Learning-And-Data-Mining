# exercise 5.2.1

from pylab import *
import numpy as np
import sklearn.linear_model as lm

# Parameters
Kd = 5  # no of terms for data generator
Km = 5  # no of terms for regression model
N = 50  # no of data objects to train a model
Xe =  np.mat(linspace(-2,2,1000)).T # X values to visualize true data and model
eps_mean, eps_std = 0, 0.5          # noise parameters

# Generate dataset (with noise)
X = np.mat(linspace(-2,2,N)).T
Xd = np.power(X, range(1,Kd+1))
eps = np.mat(eps_std*np.random.randn(N) + eps_mean).T
w = np.mat( -np.power(-.9, range(1,Kd+2)) ).T
y = w[0,0] + Xd * w[1:,:] + eps

# True data generator (assuming no noise)
Xde = np.power(Xe, range(1,Kd+1))
y_true = w[0,0] + Xde * w[1:,:]


# Fit ordinary least squares regression model
Xm = np.power(X, range(1,Km+1))
model = lm.LinearRegression()
model = model.fit(Xm,y)

# Predict values
Xme = np.power(Xe, range(1,Km+1))
y_est = model.predict(Xme)

# Plot original data and the model output
f = figure()
f.hold(True)
plot(X.A,y.A,'.')
plot(Xe.A,y_true.A,'-')
plot(Xe.A,y_est,'-')
xlabel('X'); ylabel('y'); ylim(-2,8)
legend(['Training data', 'Data generator K={0}'.format(Kd), 'Regression fit (model) K={0}'.format(Km)])

show()
