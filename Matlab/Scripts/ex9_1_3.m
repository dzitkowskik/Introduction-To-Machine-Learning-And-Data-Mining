% exercise 9.1.3

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/synth1'));

%% K-means clustering

% Maximum number of clusters
K = 10;

% Allocate variables
Entropy = nan(K,1);
Purity = nan(K,1);
Rand = nan(K,1);
Jaccard = nan(K,1);

for k = 1:K
    % Run k-means
    [i, Xc] = kmeans(X, k);
    
    % Compute cluster validities
    [Entropy(k), Purity(k), Rand(k), Jaccard(k)] = clusterval(y, i);
end

%% Plot results

mfig('Cluster validity'); clf; hold all;
plot(1:K, -Entropy);
plot(1:K, Purity);
plot(1:K, Rand);
plot(1:K, Jaccard);
legend({'Negative Entropy', 'Purity', 'Rand', 'Jaccard'});