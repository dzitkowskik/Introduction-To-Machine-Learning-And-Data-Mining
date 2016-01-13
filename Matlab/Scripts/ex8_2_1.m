% exercise 8.2.1

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/synth5'))

%% Fit model using bootstrap aggregation (bagging)

% Number of rounds of bagging
L = 100;

% Variable for model parameters
w_est = nan(M+1, L);

% Weights for selecting samples in each bootstrap
weights = ones(N,1)/N;

% For each round of bagging
for l = 1:L
    % Choose data objects by random sampling with replacement 
    i = discreternd(weights, N);

    % Extract training set
    X_train = X(i, :);
    y_train = y(i);

    % Fit logistic regression model to training data and save result
    w_est(:,l) = glmfit(X_train, y_train, 'binomial');
end

% Evaluate the logistic regression on the training data
p = glmval(w_est, X, 'logit');

% Estimated value of class labels (using 0.5 as threshold) by majority voting
y_est = sum(p>.5,2)>L/2; 

% Compute error rate
ErrorRate = sum(y~=y_est)/N;
fprintf('Error rate: %.0f%%\n', ErrorRate*100);

%% Plot decision boundary
mfig('Decision boundary'); clf;
dbplot(X, y, @(X) sum(glmval(w_est, X, 'logit'),2));
xlabel(attributeNames(1)); ylabel(attributeNames(2));
legend(classNames);