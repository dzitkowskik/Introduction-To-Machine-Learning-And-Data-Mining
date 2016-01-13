# exercise 3.2.1

from pylab import *
from scipy.io import loadmat
from similarity import similarity

# Image to use as query
i = 888

# Similarity: 'SMC', 'Jaccard', 'ExtendedJaccard', 'Cosine', 'Correlation'
similarity_measure = 'Correlation'

# Load the CBCL face database
# Load Matlab data file to python dict structure
X = loadmat('../Data/wildfaces_grayscale.mat')['X']
N, M = shape(X)


# Search the face database for similar faces
# Index of all other images than i
noti = range(0,i) + range(i+1,N)
# Compute similarity between image i and all others
sim = similarity(X[i,:], X[noti,:], similarity_measure)
sim = sim.tolist()[0]
# Tuples of sorted similarities and their indices
sim_to_index = sorted(zip(sim,noti))


# Visualize query image and 5 most/least similar images
figure(figsize=(12,8))
subplot(3,1,1)

img_hw = int(sqrt(len(X[0])))
imshow(np.reshape(X[i],(img_hw,img_hw)).T, cmap=cm.gray)
xticks([]); yticks([])
title('Query image')
ylabel('image #{0}'.format(i))


for ms in range(5):

    # 5 most similar images found
    subplot(3,5,6+ms)
    im_id = sim_to_index[-ms-1][1]
    im_sim = sim_to_index[-ms-1][0]
    imshow(np.reshape(X[im_id],(img_hw,img_hw)).T, cmap=cm.gray)
    xlabel('sim={0:.3f}'.format(im_sim))
    ylabel('image #{0}'.format(im_id))
    xticks([]); yticks([])
    if ms==2: title('Most similar images')

    # 5 least similar images found
    subplot(3,5,11+ms)
    im_id = sim_to_index[ms][1]
    im_sim = sim_to_index[ms][0]
    imshow(np.reshape(X[im_id],(img_hw,img_hw)).T, cmap=cm.gray)
    xlabel('sim={0:.3f}'.format(im_sim))
    ylabel('image #{0}'.format(im_id))
    xticks([]); yticks([])
    if ms==2: title('Least similar images')

show()
