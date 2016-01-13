%% exercise 2.3.2

% Digits to include in analysis (to include all, n = 1:10);
n = [0 1];

% Number of principal components for reconstruction
K = 12;

% Digits to visualize
nD = 1:5;

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

% Subtract the mean from the data
Y = bsxfun(@minus, X, mean(X));

% Obtain the PCA solution by calculate the SVD of Y
[U, S, V] = svd(Y, 'econ');

% Compute the projection onto the principal components
Z = U*S;

% Compute variance explained
rho = diag(S).^2./sum(diag(S).^2);

%% Plot variance explained
mfig('Digits: Var. explained'); clf;
plot(rho, 'o-');
title('Variance explained by principal components');
xlabel('Principal component');
ylabel('Variance explained value');

%% Plot PCA of data
mfig('Digits: PCA'); clf; hold all; 
C = length(classNames);
for c = 0:C-1
    plot(Z(y==c,1), Z(y==c,2), 'o');
end
legend(classNames);
xlabel('PC 1');
ylabel('PC 2');
title('PCA of digits data');

%% Visualize the reconstructed data from the firts K principal components
mfig('Digits: Reconstruction'); clf;
W = Z(:,1:K)*V(:,1:K)';
D = length(nD);
for d = 1:D
    subplot(2,D,d);
    I = reshape(X(nD(d),:), [16,16])';
    imagesc(I);
    axis image off
    title('Original');
    subplot(2,D,d+D);
    I = reshape(W(nD(d),:)+mean(X), [16,16])';
    imagesc(I);
    axis image off
    title('Reconstructed');
end
colormap(1-gray);

%% Visualize the pricipal components
mfig('Digits: Principal components'); clf;
for k = 1:K
    N1 = ceil(sqrt(K)); N2 = ceil(K/N1);
    subplot(N2, N1, k);
    W = U(:,k)*V(:,k)';
    I = reshape(W(k,:), [16,16])';
    imagesc(I);
    colormap(hot);
    axis image off
    title(sprintf('PC %d',k));
end
