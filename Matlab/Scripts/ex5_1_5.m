% exercise 5.1.5

% Load the data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/wine'));

% Identify the outliers (see exercise 4.2.1)
idxOutlier = find(X(:,2)>20 | X(:,8)>10 | X(:,11)>200);

% Remove outliers from the data set
X(idxOutlier,:) = [];
y(idxOutlier) = [];
N = N-length(idxOutlier);

% Remove attribute 12, Quality score
X(:,12) = [];
attributeNames(12) = [];
M = size(X,2);