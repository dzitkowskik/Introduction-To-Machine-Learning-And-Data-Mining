%% exercise 3.4.1

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

%% Plot result
mfig('Digits: Mean and std'); clf;
subplot(1,2,1);
I = reshape(mu, [16,16])';
imagesc(I);
axis image off
title('Mean');
subplot(1,2,2);
I = reshape(s, [16,16])';
imagesc(I);
axis image off
title('Standard deviation');
colormap(1-gray);
