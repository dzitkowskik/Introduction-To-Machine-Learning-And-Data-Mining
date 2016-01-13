# exercise 4.2.1

from pylab import *
import numpy as np
from scipy.io import loadmat
from scipy.stats import zscore

# Load Matlab data file and extract variables of interest
mat_data = loadmat('../Data/wine.mat')
X = np.matrix(mat_data['X'])
y = np.matrix(mat_data['y'])
C = mat_data['C'][0,0]
M = mat_data['M'][0,0]
N = mat_data['N'][0,0]

attributeNames = [name[0][0] for name in mat_data['attributeNames']]
classNames = [cls[0] for cls in mat_data['classNames'][0]]

# The histograms show that there are a few very extreme values in these
# three attributes. To identify these values as outliers, we must use our
# knowledge about the data set and the attributes. Say we expect volatide
# acidity to be around 0-2 g/dm^3, density to be close to 1 g/cm^3, and
# alcohol percentage to be somewhere between 5-20 % vol. Then we can safely
# identify the following outliers, which are a factor of 10 greater than
# the largest we expect.
outlier_mask = (X[:,1]>20).A.ravel() | (X[:,7]>10).A.ravel() | (X[:,10]>200).A.ravel()
valid_mask = np.logical_not(outlier_mask)

# Finally we will remove these from the data set
X = X[valid_mask,:]
y = y[valid_mask,:]
N = len(y)
Xnorm = zscore(X, ddof=1)

#fromAtr = 1
#toAtr = len(attributeNames)+1

#fromAtr = 1
#toAtr = len(attributeNames)+1

#figure()
#
#for c in range(C):
#    #subplot(1,C,c+1)
#    class_mask = (y==c).A.ravel() # binary mask to extract elements of class c
#    # or: class_mask = nonzero(y==c)[0].tolist()[0] # indices of class c
#
#    bp=boxplot(Xnorm[class_mask,:])
#    if (c==1):
#        setp(bp['boxes'], color='black')
#        setp(bp['whiskers'], color='black')
#        setp(bp['fliers'], color='black')
#    else:
#        setp(bp['boxes'], color='red')
#        setp(bp['whiskers'], color='red')
#        setp(bp['fliers'], color='red')
#
#
#    #title('Class: {0}'.format(classNames[c]))
#    title('Class: '+classNames[c])
#    xticks(range(1,len(attributeNames)+1), [a[:7] for a in attributeNames], rotation=45)
#    y_up = Xnorm.max()+(Xnorm.max()-Xnorm.min())*0.1
#    y_down = Xnorm.min()-(Xnorm.max()-Xnorm.min())*0.1
#    ylim(y_down, y_up)
#
#show()
#


Attributes = [1,4,5,6]
NumAtr = len(Attributes)

figure(figsize=(12,12))
hold(True)
X = array(X)
for m1 in range(NumAtr):
    for m2 in range(NumAtr):
        subplot(NumAtr, NumAtr, m1*NumAtr + m2 + 1)
        for c in range(C):
            class_mask = (y==c).A.ravel()
            plot(X[class_mask,Attributes[m2]], X[class_mask,Attributes[m1]], '.')
            if m1==M-1:
                xlabel(attributeNames[Attributes[m2]])
            else:
                xticks([])
            if m2==0:
                ylabel(attributeNames[Attributes[m1]])
            else:
                yticks([])
            #ylim(0,X.max()*1.1)
            #xlim(0,X.max()*1.1)
legend(classNames)

show()
