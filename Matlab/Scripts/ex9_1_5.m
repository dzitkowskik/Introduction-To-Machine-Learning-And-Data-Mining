% exercise 9.1.5

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/wildfaces'))

[N,M] = size(X);

% Image resolution and number of colors
x = 40; 
y = 40;
c = 3;

%% K-means clustering

% Maximum number of clusters
K = 10;

% Run k-means (This will take a while to run on a large data set)
[i, Xc] = kmeans(X, K, 'Display', 'iter', 'OnlinePhase', 'off');
    

%% Plot results

% Number of images to plot
L = 5;

% Get some random image indices
j = randi(N,L,1);

% Plot centroids
mfig('Centroids'); clf;
n1 = ceil(sqrt(K/2)); n2 = ceil(K/n1);
for k = 1:K
    subplot(n1,n2,k);
    imagesc(reshape(Xc(k,:),x,y,c));
    axis image off;
    colormap(1-gray);
end

% Plot random images and corresponding centroids
mfig('Images'); clf;
for l = 1:L
    subplot(2,L,l);
    imagesc(reshape(X(j(l),:),x,y,c));
    axis image off;
    subplot(2,L,l+L);
    imagesc(reshape(Xc(i(j(l)),:),x,y,c));
    axis image off;
    colormap(1-gray);
end