%% exercise 2.4.1

% Number of principal components to use, i.e. the reduced dimensionality
K = 10; 

%% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/zipdata.mat'));

% Extract digits (training set)
X = traindata(:,2:end);
y = traindata(:,1);

% Extract digits (test set)
Xtest = testdata(:,2:end);
ytest = testdata(:,1);

% Subtract the mean from the data
Y = bsxfun(@minus, X, mean(X));
Ytest = bsxfun(@minus, Xtest, mean(X));

% Obtain the PCA solution by calculate the SVD of Y
[U, S, V] = svd(Y, 'econ');

% Compute the projection onto the principal components
Z = Y*V(:,1:K);
Ztest = Ytest*V(:,1:K);

% Classify digits using a K-nearest neighbour classifier
yest = knnclassify(Ztest, Z, y);
errorRate = nnz(ytest~=yest)/length(ytest);

% Display results
fprintf('Error rate %.1f%%\n',errorRate*100);
