% exercise 9.2.1

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/synth1'));

%% Hierarchical clustering

% Maximum number of clusters
Maxclust = 4;

% Compute hierarchical clustering
Z = linkage(X, 'single', 'euclidean');

% Compute clustering by thresholding the dendrogram
i = cluster(Z, 'Maxclust', Maxclust);

%% Plot results

% Plot dendrogram
mfig('Dendrogram'); clf;
dendrogram(Z);

% Plot data
mfig('Hierarchical'); clf; 
clusterplot(X, y, i);
