# exercise 8.2.2


from pylab import *
from scipy.io import loadmat
from toolbox_02450 import dbplot, dbprobplot, bootstrap
from bin_classifier_ensemble import BinClassifierEnsemble
from sklearn.linear_model import LogisticRegression

# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/synth5.mat')
X = np.matrix(mat_data['X'])
y = np.matrix(mat_data['y'])
attributeNames = [name[0] for name in mat_data['attributeNames'].squeeze()]
classNames = [name[0][0] for name in mat_data['classNames']]
N, M = X.shape
C = len(classNames)


# Fit model using bootstrap aggregation (boosting, AdaBoost):

# Number of rounds of bagging
L = 100

# Weights for selecting samples in each bootstrap
weights = np.ones((N,1),dtype=float)/N

# Storage of trained log.reg. classifiers fitted in each bootstrap
logits = [0]*L
alpha = np.ones( (L,1) )
votes = np.zeros((N,1))
epsi = 0
y_all = np.zeros((N,L))
y = y > 0.5
# For each round of bagging
for l in range(L):
    while True : 
        # Extract training set by random sampling with replacement from X and y
        while True : 
            # not a thing of beauty, however log.reg. fails if presented with less than two classes. 
            X_train, y_train = bootstrap(X, y, N, weights) 
            if not (all(y_train==0) or all(y_train == 1)) : break      
        
        # Fit logistic regression model to training data and save result
        # turn off regularization with C. 
        logit_classifier = LogisticRegression(C=100000000)
    
        logit_classifier.fit(X_train, y_train.A.ravel()  )
        logits[l] = logit_classifier
        y_est = np.mat(logit_classifier.predict(X)).T > 0.5
        
        y_all[:,l] = 1.0 * y_est.ravel()
        v  = matrix(y_est != y,dtype=float)
        ErrorRate = multiply(weights,v).sum()/N
        epsi = ErrorRate
        if epsi > 0.5 : 
            weights = np.ones( (N,1), dtype=float)/N
            print "resetting weights..."
        else : 
            alphai = 0.5 * log( (1-epsi)/epsi)
            weights[y_est == y] = weights[y_est == y] * exp( -alphai )
            weights[y_est != y] = weights[y_est != y] * exp(  alphai )
            
            weights = weights / sum(weights)
            break;
            
    votes = votes + y_est
    alpha[l] = alphai
    print('Error rate: {0}%'.format(ErrorRate*100))    
    
# Estimated value of class labels (using 0.5 as threshold) by majority voting
alpha = mat(alpha)/sum(alpha)
y_est_ensemble = mat(y_all) * alpha > 0.5

#y_est_ensemble = votes > (L/2)
#y_est_ensemble = mat(y_all) * mat(alpha) - (1-mat(y_all)) * mat(alpha) > 0
ErrorRateEnsemble = sum(y_est_ensemble != y)/N

# Compute error rate
#ErrorRate = (y!=y_est_ensemble).sum(dtype=float)/N
print('Error rate for ensemble classifier: {:.1f}%'.format(ErrorRateEnsemble*100))

ce = BinClassifierEnsemble(logits)
figure(1); dbprobplot(ce, X, y, 'auto', resolution=200)
figure(2); dbplot(ce, X, y, 'auto', resolution=200)
figure(3); plot(alpha.A)

show()