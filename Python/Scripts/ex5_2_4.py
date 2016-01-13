# exercise 5.2.4
from pylab import *
import sklearn.linear_model as lm

# requires wine data from exercise 5.1.5
from ex5_1_5 import *

# Split dataset into features and target vector
alcohol_idx = attributeNames.index('Alcohol')
y = X[:,alcohol_idx]

X_cols = range(0,alcohol_idx) + range(alcohol_idx+1,len(attributeNames))
X_rows = range(0,len(y))
X = X[ix_(X_rows,X_cols)]

# Fit ordinary least squares regression model
model = lm.LinearRegression()
model.fit(X,y)

# Predict alcohol content
y_est = model.predict(X)
residual = y_est-y

# Display scatter plot
figure()
subplot(2,1,1)
plot(y.A, y_est, '.')
xlabel('Alcohol content (true)'); ylabel('Alcohol content (estimated)');
subplot(2,1,2)
hist(residual,40)

show()
