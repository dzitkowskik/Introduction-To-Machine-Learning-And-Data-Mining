# exercise 7.3.2

from pylab import *
from scipy.io import loadmat
import neurolab as nl
from sklearn import cross_validation

# read XOR DATA from matlab datafile
mat_data = loadmat('../Data/xor.mat')
X = np.matrix(mat_data['X'])
y = np.matrix(mat_data['y'])


attributeNames = [name[0] for name in mat_data['attributeNames'].squeeze()]
classNames = [name[0] for name in mat_data['classNames'].squeeze()]
N, M = X.shape
C = len(classNames)

# Parameters for neural network classifier
n_hidden_units = 4      # number of hidden units
n_train = 4             # number of networks trained in each k-fold

# These parameters are usually adjusted to: (1) data specifics, (2) computational constraints
learning_goal = 0.2     # stop criterion 1 (train mse to be reached)
max_epochs = 200        # stop criterion 2 (max epochs in training)

# K-fold CrossValidation (4 folds here to speed up this example)
K = 4
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

    print y_train

    best_train_error = 1e100
    for i in range(n_train):
        # Create randomly initialized network with 2 layers
        ann = nl.net.newff([[0, 1], [0, 1]], [n_hidden_units, 1], [nl.trans.TanSig(),nl.trans.PureLin()])
        # train network
        train_error = ann.train(X_train, y_train, goal=learning_goal, epochs=max_epochs, show=round(max_epochs/8))
        if train_error[-1]<best_train_error:
            bestnet.append(ann)
            best_train_error = train_error[-1]
            error_hist[range(len(train_error)),k] = train_error

    y_est = bestnet[k].sim(X_test)
    y_est = (y_est>.5).astype(int)
    errors[k] = (y_est!=y_test).sum().astype(float)/y_test.shape[0]
    k+=1


# Print the average classification error rate
print('Error rate: {0}%'.format(100*mean(errors)))


# Display the decision boundary for the several crossvalidation folds.
# (create grid of points, compute network output for each point, color-code and plot).
grid_range = [-1, 2, -1, 2]; delta = 0.05; levels = 100
a = arange(grid_range[0],grid_range[1],delta)
b = arange(grid_range[2],grid_range[3],delta)
A, B = meshgrid(a, b)
values = np.zeros(A.shape)

figure(1,figsize=(18,9)); hold(True)
for k in range(4):
    subplot(2,2,k+1)
    cmask = (y==0).A.ravel(); plot(X[cmask,0].A, X[cmask,1].A,'.r')
    cmask = (y==1).A.ravel(); plot(X[cmask,0].A, X[cmask,1].A,'.b')
    title('Model prediction and decision boundary (kfold={0})'.format(k+1))
    xlabel('Feature 1'); ylabel('Feature 2');
    for i in range(len(a)):
        for j in range(len(b)):
            values[i,j] = bestnet[k].sim( np.mat([a[i],b[j]]) )[0,0]
    contour(A, B, values, levels=[.5], colors=['k'], linestyles='dashed')
    contourf(A, B, values, levels=linspace(values.min(),values.max(),levels), cmap=cm.RdBu)
    if k==0: colorbar(); legend(['Class A (y=0)', 'Class B (y=1)'])


# Display exemplary networks learning curve (best network of each fold)
figure(2); hold(True)
bn_id = argmax(error_hist[-1,:])
error_hist[error_hist==0] = learning_goal
for bn_id in range(K):
    plot(error_hist[:,bn_id]);
    xlabel('epoch');
    ylabel('train error (mse)');
    title('Learning curve (best for each CV fold)')

plot(range(max_epochs), [learning_goal]*max_epochs, '-.')


show()
