# exercise 6.2.1

from pylab import *
from scipy.io import loadmat
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import confusion_matrix


# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/synth1.mat')
X = np.matrix(mat_data['X'])
X_train = np.matrix(mat_data['X_train'])
X_test = np.matrix(mat_data['X_test'])
y = np.matrix(mat_data['y'])
y_train = np.matrix(mat_data['y_train'])
y_test = np.matrix(mat_data['y_test'])
attributeNames = [name[0] for name in mat_data['attributeNames'].squeeze()]
classNames = [name[0][0] for name in mat_data['classNames']]
N, M = X.shape
C = len(classNames)


# Plot the training data points (color-coded) and test data points.
figure(1);
hold(True);
styles = ['.b', '.r', '.g', '.y']
for c in range(C):
    class_mask = (y_train==c).A.ravel()
    plot(X_train[class_mask,0].A, X_train[class_mask,1].A, styles[c])


# K-nearest neighbors
K=5

# Distance metric (corresponds to 2nd norm, euclidean distance).
# You can set dist=1 to obtain manhattan distance (cityblock distance).
dist=2

#V = np.cov(X_train, y_train)
print X_train

# Fit classifier and classify the test points
knclassifier = KNeighborsClassifier(n_neighbors=K, p=dist);
knclassifier.fit(X_train, y_train);
y_est = knclassifier.predict(X_test);


# Plot the classfication results
styles = ['ob', 'or', 'og', 'oy']
for c in range(C):
    class_mask = (y_est==c)
    plot(X_test[class_mask,0].A, X_test[class_mask,1].A, styles[c], markersize=10)
    plot(X_test[class_mask,0].A, X_test[class_mask,1].A, 'kx', markersize=8)
title('Synthetic data classification - KNN');

# Compute and plot confusion matrix
cm = confusion_matrix(y_test.A.ravel(), y_est);
accuracy = 100*cm.diagonal().sum()/cm.sum(); error_rate = 100-accuracy;
figure(2);
imshow(cm, cmap='binary', interpolation='None');
colorbar()
xticks(range(C)); yticks(range(C));
xlabel('Predicted class'); ylabel('Actual class');
title('Confusion matrix (Accuracy: {0}%, Error Rate: {1}%)'.format(accuracy, error_rate));

show()
