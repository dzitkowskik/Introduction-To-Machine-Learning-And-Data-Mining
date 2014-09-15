% exercise 10.1.1

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/synth1'));

%% Gaussian mixture model

% Number of clusters
K = 4;

% Fit model
G = gmdistribution.fit(X, K,'regularize',10e-9);

% Compute clustering
i = cluster(G, X);

%% Extract cluster centers
X_c = G.mu;
Sigma_c=G.Sigma;
%% Plot results

% Plot clustering
mfig('GMM: Clustering'); clf; 
clusterplot(X, y, i, X_c, Sigma_c);
