% exercise 9.1.1

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/synth1'));

%% K-means clustering

% Number of clusters
K = 4;

% Run k-means
[i, Xc] = kmeans(X, K);

%% Plot results

% Plot data
mfig('K-means'); clf; 
clusterplot(X, y, i, Xc);
