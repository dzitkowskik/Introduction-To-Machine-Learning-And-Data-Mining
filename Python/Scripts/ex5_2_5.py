# exercise 5.2.5
from pylab import *
import sklearn.linear_model as lm

# requires data from exercise 5.1.4
from ex5_1_5 import *


# Split dataset into features and target vector
alcohol_idx = attributeNames.index('Alcohol')
y = X[:,alcohol_idx]

X_cols = range(0,alcohol_idx) + range(alcohol_idx+1,len(attributeNames))
X_rows = range(0,len(y))
X = X[ix_(X_rows,X_cols)]

# Additional nonlinear attributes
fa_idx = attributeNames.index('Fixed acidity')
va_idx = attributeNames.index('Volatile acidity')
Xfa2 = np.power(X[:,fa_idx],2)
Xva2 = np.power(X[:,va_idx],2)
Xfava = np.multiply(X[:,fa_idx],X[:,va_idx])
X = np.bmat('X, Xfa2, Xva2, Xfava')

# Fit ordinary least squares regression model
model = lm.LinearRegression()
model.fit(X,y)

# Predict alcohol content
y_est = model.predict(X)
residual = y_est-y

# Display plots
figure()

subplot(2,1,1)
plot(y.A, y_est, '.g')
xlabel('Alcohol content (true)'); ylabel('Alcohol content (estimated)')

subplot(4,1,3)
hist(residual,40)

subplot(4,3,10)
plot(Xfa2.A, residual.A, '.r')
xlabel('Fixed Acidity ^2'); ylabel('Residual')

subplot(4,3,11)
plot(Xva2.A, residual.A, '.r')
xlabel('Volatile Acidity ^2'); ylabel('Residual')

subplot(4,3,12)
plot(Xfava.A, residual.A, '.r')
xlabel('Fixed*Volatile Acidity'); ylabel('Residual')

show()
