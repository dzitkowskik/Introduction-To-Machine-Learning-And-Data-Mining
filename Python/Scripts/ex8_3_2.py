# exercise 8.3.2 Fit neural network classifiers.
from pylab import *
from scipy.io import loadmat
from toolbox_02450 import dbplot,dbplotf
from sklearn.linear_model import LogisticRegression
import neurolab as nl

# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/synth1.mat')
X = np.matrix(mat_data['X'])
X = X - np.ones((X.shape[0],1)) * mean(X,0)
X_train = np.matrix(mat_data['X_train'])
X_test = np.matrix(mat_data['X_test'])
y = np.matrix(mat_data['y'])
y_train = np.matrix(mat_data['y_train'])
y_test = np.matrix(mat_data['y_test'])
attributeNames = [name[0] for name in mat_data['attributeNames'].squeeze()]
classNames = [name[0][0] for name in mat_data['classNames']]
N, M = X.shape
C = len(classNames)
NHiddenUnits = 4;
# These parameters are usually adjusted to: (1) data specifics, (2) computational constraints
learning_goal = 0.01     # stop criterion 1 (train mse to be reached)
max_epochs = 300      # stop criterion 2 (max epochs in training)

# Fit and plot one-vs-rest NN classifiers
y_test_est = np.mat(np.zeros((y_test.shape[0],C)))
nets = []
for c in range(C):
    ann = nl.net.newff([[X[:,0].min(),X[:,0].max()], [X[:,1].min(),X[:,1].max()]], [NHiddenUnits, 1], [nl.trans.TanSig(),nl.trans.PureLin()])
    train_error = ann.train(X_train, (y_train == c), goal=learning_goal, epochs=max_epochs, show=round(max_epochs/8))
    nets.append(ann)
    y_test_est[:,c] = ann.sim(X_test)
    figure(c+1)
    dbplotf(X_test,(y_test==c).astype(int), lambda x : ann.sim(x), 'auto')

# Plot descision boundary for ensemble of neural networks
figure(C+1)
def neval(xval):
    return np.argmax(hstack([n.sim(xval) for n in nets] ),1)

dbplotf(X_test,y_test,neval,'auto')
show()
# Compute error rate
ErrorRate = (np.argmax(y_test_est,1) != y_test).mean(dtype=float)
print('Error rate (ensemble): {0}%'.format(100*ErrorRate))
