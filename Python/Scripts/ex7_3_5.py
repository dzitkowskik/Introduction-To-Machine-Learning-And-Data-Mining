# exercise 7.3.5

from pylab import *
from scipy.io import loadmat
import neurolab as nl
from sklearn import cross_validation
import scipy.linalg as linalg
from scipy import stats

# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/wine2.mat')
attributeNames = [name[0] for name in mat_data['attributeNames'][0]]
X = np.matrix(mat_data['X'])
y = np.matrix(mat_data['y'])
#Downsample: X = X[1:20,:] y = y[1:20,:]

N, M = X.shape
C = 2
# Normalize data
X = stats.zscore(X);

# Parameters for neural network classifier
n_hidden_units = 2     # number of hidden units
n_train = 2             # number of networks trained in each k-fold
learning_goal = 10      # stop criterion 1 (train mse to be reached)
max_epochs = 64         # stop criterion 2 (max epochs in training)
show_error_freq = 3     # frequency of training status updates


# K-fold crossvalidation
K = 3                   # only five folds to speed up this example
CV = cross_validation.KFold(N,K,shuffle=True)

# Variable for classification error
errors = np.zeros(K)
error_hist = np.zeros((max_epochs,K))
bestnet = list()
k=0
for train_index, test_index in CV:
    print('\nCrossvalidation fold: {0}/{1}'.format(k+1,K))

    # extract training and test set for current CV fold
    X_train = X[train_index,:]
    y_train = y[train_index,:]
    X_test = X[test_index,:]
    y_test = y[test_index,:]

    best_train_error = 1e100
    for i in range(n_train):
        print('Training network {0}/{1}...'.format(i+1,n_train))
        # Create randomly initialized network with 2 layers
        ann = nl.net.newff([[-3, 3]]*M, [n_hidden_units, 1], [nl.trans.TanSig(),nl.trans.PureLin()])
        if i==0:
            bestnet.append(ann)
        # train network
        train_error = ann.train(X_train, y_train, goal=learning_goal, epochs=max_epochs, show=show_error_freq)
        if train_error[-1]<best_train_error:
            bestnet[k]=ann
            best_train_error = train_error[-1]
            error_hist[range(len(train_error)),k] = train_error

    print('Best train error: {0}...'.format(best_train_error))
    y_est = bestnet[k].sim(X_test)
    y_est = (y_est>.5).astype(int)
    errors[k] = (y_est!=y_test).sum().astype(float)/y_test.shape[0]
    k+=1


# Print the average classification error rate
print('Error rate: {0}%'.format(100*mean(errors)))


figure();
subplot(2,1,1); bar(range(0,K),errors); title('CV errors');
subplot(2,1,2); plot(error_hist); title('Training error as function of BP iterations');
figure();
subplot(2,1,1); plot(y_est); plot(y_test.A); title('Last CV-fold: est_y vs. test_y');
subplot(2,1,2); plot((y_est-y_test).A); title('Last CV-fold: prediction error (est_y-test_y)'); show()
show()
