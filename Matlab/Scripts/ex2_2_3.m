%% exercise 2.2.3

% Subtract the mean from the data
Y = bsxfun(@minus, X, mean(X));

% Obtain the PCA solution by calculate the SVD of Y
[U, S, V] = svd(Y);

% Compute variance explained
rho = diag(S).^2./sum(diag(S).^2);

% Plot variance explained
mfig('NanoNose: Var. explained'); clf;
plot(rho, 'o-');
title('Variance explained by principal components');
xlabel('Principal component');
ylabel('Variance explained value');

