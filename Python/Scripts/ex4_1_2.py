# Exercise 4.1.2

from pylab import *

# requires data from exercise 4.1.1
from ex4_1_1 import *

figure(figsize=(8,7))
u = np.floor(np.sqrt(M)); v = np.ceil(float(M)/u)
for i in range(M):
    subplot(u,v,i+1)
    hist(X[:,i], color=(0.2, 0.8-i*0.2, 0.4))
    xlabel(attributeNames[i])
    ylim(0,N/2)

show()
