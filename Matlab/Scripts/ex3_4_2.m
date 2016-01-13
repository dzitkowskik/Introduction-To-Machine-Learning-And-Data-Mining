%% exercise 3.4.2

% Digits to include in analysis (to include all, n = 1:10);
n = [1];

%% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/zipdata.mat'));

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

%% Compute mean, standard deviations, and covariance matrix 
mu = mean(X);
s = std(X);
S = cov(X);

%% Generate 10 images with same mean and standard deviation
Xgen = normrnd(repmat(mu,10,1), repmat(s,10,1));

%% Plot images generated using the Normal distribution
mfig('Digits: 1-D Normal');
for k = 1:10
    subplot(2,5,k);
    I = reshape(Xgen(k,:), [16,16])';
    imagesc(I);
    axis image off
end
colormap(1-gray);


%% Generate 10 images with same mean and covariance matrix
Xgen = mvnrnd(mu, S, 10);

%% Plot images generated using the Normal distribution
mfig('Digits: Multivariate Normal');
for k = 1:10
    subplot(2,5,k);
    I = reshape(Xgen(k,:), [16,16])';
    imagesc(I);
    axis image off
end
colormap(1-gray);
