# exercise 2.1.5

import numpy as np
import scipy.linalg as linalg
from similarity import similarity
from tmgsimple import TmgSimple


# Generate text matrix with help of simple class TmgSimple
tm = TmgSimple(filename='../Data/textDocs.txt', stopwords_filename='../Data/stopWords.txt', stem=True)

# Extract variables representing data
X = np.mat(tm.get_matrix(sort=True))
attributeNames = tm.get_words(sort=True)

# Query vector
q = np.matrix([0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0])


# Method 1 ('for' loop - slow)
N = np.shape(X)[0]; # get the number of data objects
sim = np.zeros((N,1)) # allocate a vector for the similarity
for i in range(N):
    x = X[i,:] # Get the i'th data object (here: document)
    sim[i] = q/linalg.norm(q) * x.T/linalg.norm(x) # Compute cosine similarity

# Method 2 (one line of code with no iterations - faster)
sim = (q*X.T).T / (np.sqrt(np.power(X,2).sum(axis=1)) * np.sqrt(np.power(q,2).sum(axis=1)))

# Method 3 (use the "similarity" function)
sim = similarity(X, q, 'cos');


# Display the result
print('Query vector:\n {0}\n'.format(q))
print('Similarity results:\n {0}'.format(sim))
