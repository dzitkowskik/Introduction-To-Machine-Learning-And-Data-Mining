# exercise 8.3.3 Fit neural network classifiers using softmax output weighting
from pylab import *
from scipy.io import loadmat
import toolbox_02450

from pybrain.datasets            import ClassificationDataSet
from pybrain.tools.shortcuts     import buildNetwork
from pybrain.supervised.trainers import BackpropTrainer
from pybrain.structure.modules   import SoftmaxLayer


# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/synth1.mat')
X = np.matrix(mat_data['X'])
X = X - np.ones((X.shape[0],1)) * mean(X,0)
X_train = np.matrix(mat_data['X_train'])
X_test = np.matrix(mat_data['X_test'])
y = np.matrix(mat_data['y'])
y_train = np.matrix(mat_data['y_train'])
y_test = np.matrix(mat_data['y_test'])
#attributeNames = [name[0] for name in mat_data['attributeNames'].squeeze()]
classNames = [name[0][0] for name in mat_data['classNames']]
N, M = X.shape
C = len(classNames)
NHiddenUnits = 2;
print y_train.shape
#%% convert to ClassificationDataSet format.
def conv2DS(Xv,yv = None) :
    if yv == None :
        yv =  np.asmatrix( np.ones( (Xv.shape[0],1) ) )
        for j in range(len(classNames)) : yv[j] = j

    C = len(unique(yv.flatten().tolist()[0]))
    DS = ClassificationDataSet(M, 1, nb_classes=C)
    for i in range(Xv.shape[0]) : DS.appendLinked(Xv[i,:].tolist()[0], [yv[i].A[0][0]])
    DS._convertToOneOfMany( )
    return DS

DS_train = conv2DS(X_train,y_train)
DS_test = conv2DS(X_test,y_test)

fnn = buildNetwork(DS_train.indim, NHiddenUnits, DS_train.outdim, outclass=SoftmaxLayer,bias=True)
trainer = BackpropTrainer( fnn, dataset=DS_train, momentum=0.1, verbose=True, weightdecay=0.01)
# Train for 100 iterations.
for i in range(50): trainer.trainEpochs( 1 )
ote = fnn.activateOnDataset(DS_test)

ErrorRate = (np.argmax(ote,1) != y_test.T).mean(dtype=float)
print('Error rate (ensemble): {0}%'.format(100*ErrorRate))
figure(1)
def neval(xval):
    return argmax(fnn.activateOnDataset(conv2DS(np.asmatrix(xval)) ),1)

toolbox_02450.dbplotf(X_test,y_test,neval,'auto')
show()
