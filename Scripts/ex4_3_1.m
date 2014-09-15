% exercise 4.3.1

% Digits to include in analysis (to include all, n = 1:10);
n = [0 1];

% Number of principal components 
K = 4;


%% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/zipdata.mat'))

% Extract digits
X = traindata(:,2:end);
y = traindata(:,1);
classNames = {'0';'1';'2';'3';'4';'5';'6';'7';'8';'9';'10'};
classLabels = classNames(y+1);

% Remove digits that are not to be inspected
j = ismember(y, n);
X = X(j,:);
classLabels = classLabels(j);
classNames = classNames(n+1);
y = cellfun(@(str) find(strcmp(str, classNames)), classLabels)-1;

% Subtract the mean from the data
Y = bsxfun(@minus, X, mean(X));

% Obtain the PCA solution by calculate the SVD of Y
[U, S, V] = svd(Y, 'econ');

% Compute the projection onto the principal components
Z = U*S;

%% Make a new data set of PC1-PCK, overwriting the old X
X = Z(:,1:K);
attributeNames = arrayfun(@(k) sprintf('PC%d',k), 1:K, 'UniformOutput', false);
[N, M] = size(X);
C = length(classNames);

%% Make some plots
ex4_1_2;
ex4_1_3;
ex4_1_4;
ex4_1_5;
ex4_1_6;
ex4_1_7;