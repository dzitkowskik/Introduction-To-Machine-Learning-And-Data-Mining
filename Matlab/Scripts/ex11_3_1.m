% exercise 11.3.1
clear all;

% Load hand written digits data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/digits'));

% Restrict the data to images of "2"
X = X(y==2,:);
[N,M] = size(X);

%% Gausian Kernel density estimator
% cross-validate kernel width by leave-one-out-cross-validation
% automatically implemented in the script gausKernelDensity
widths=max(var(X))*(2.^[-10:2]); % evaluate for a range of kernel widths
for w=1:length(widths)
   [density,log_density]=gausKernelDensity(X,widths(w));
   logP(w)=sum(log_density);
end
[val,ind]=max(logP);
width=widths(ind);
display(['Optimal kernel width is ' num2str(width)])
% evaluate density for estimated width
density=gausKernelDensity(X,width);

% Sort the densities
[y,i] = sort(density);

% Plot outlier scores
mfig('Gaussian Kernel Density: outlier score'); clf;
bar(y(1:20));

% Plot possible outliers
mfig('Gaussian Kernel Density: Possible outliers'); clf;
for k = 1:20
    subplot(4,5,k);
    imagesc(reshape(X(i(k),:), 16, 16)); 
    title(k);
    colormap(1-gray); 
    axis image off;
end


%% K-nearest neighbor density estimator 

% Number of neighbors
K = 5;

% Find the k nearest neighbors
[idx, D] = knnsearch(X, X, 'K', K+1);

% Compute the density
density = 1./(sum(D(:,2:end),2)/K);

% Sort the densities
[y,i] = sort(density);

% Plot outlier scores
mfig('KNN density: outlier score'); clf;
bar(y(1:20));

% Plot possible outliers
mfig('KNN density: Possible outliers'); clf;
for k = 1:20
    subplot(4,5,k);
    imagesc(reshape(X(i(k),:), 16, 16)); 
    title(k);
    colormap(1-gray); 
    axis image off;
end

%% K-nearest neigbor average relative density
% Compute the average relative density
avg_rel_density=density./(sum(density(idx(:,2:end)),2)/K);

% Sort the densities
[y,i] = sort(avg_rel_density);

% Plot outlier scores
mfig('KNN average relative density: outlier score'); clf;
bar(y(1:20));

% Plot possible outliers
mfig('KNN average relative density: Possible outliers'); clf;
for k = 1:20
    subplot(4,5,k);
    imagesc(reshape(X(i(k),:), 16, 16)); 
    title(k);
    colormap(1-gray); 
    axis image off;
end


%% Distance to 5'th nearest neighbor outlier score

% Neighbor to use
K = 5;

% Find the k nearest neighbors
[i, D] = knnsearch(X, X, 'K', K+1);

% Outlier score
f = D(:,K+1);

% Sort the outlier scores
[y,i] = sort(f, 'descend');

% Plot kernel density estimate outlier scores
mfig('Distance: Outlier score'); clf;
bar(y(1:20));

% Plot possible outliers
mfig('Distance: Possible outliers'); clf;
for k = 1:20
    subplot(4,5,k);
    imagesc(reshape(X(i(k),:), 16, 16)); 
    title(k);
    colormap(1-gray); 
    axis image off;
end


%% Plot of random "normal" digits for comparison

% Plot random digits (the first 20 in the data set)
mfig('Digits'); clf;
for k = 1:20
    subplot(4,5,k);
    imagesc(reshape(X(k,:), 16, 16)); 
    title(k);
    colormap(1-gray); 
    axis image off;
end
