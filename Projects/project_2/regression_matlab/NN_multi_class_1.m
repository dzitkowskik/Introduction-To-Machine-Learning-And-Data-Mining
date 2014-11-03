clear; close all; clc;
%%
% Load Matlab data file and extract variables of interest
mat_data = load('../project2/letter_reg.mat')
%%
X = mat_data.X;
classNames = mat_data.classNames;
classlabel = mat_data.classlabel;
attributeNames = mat_data.attributeNames;
y = mat_data.y;

[N,M]=size(X);


%%
% Create crossvalidation partition for evaluation
K = 3;
CV = cvpartition(N, 'Kfold', K);

% Extract the training and test set
 k=1;
    X_train = X(CV.training(k), :);
    y_train = y(CV.training(k));
    X_test = X(CV.test(k), :);
    y_test = y(CV.test(k));
    
[N_test, p] = size(X_test);
[N_train, q] = size(X_train);

%% Fit one-against-rest models
% Fit logistic regression model to training set
C=26;
w_est=NaN(M+1,C);
for c = 1:C
    w_est(:,c) = glmfit(X_train, y_train==c-1, 'binomial');
end
    
%% Compute results on test data
% For each one-against-rest classifier
Y_test_est = glmval(w_est, X_test, 'logit');

% Compute the class index by finding the maximum output from the logistic
% regression models
y_test_est=max_idx(Y_test_est);
% Subtract one to have y_test_est between 0 and C-1
y_test_est = y_test_est-1;

% Compute error rate
ErrorRate = sum(y_test~=y_test_est)/N_test;
e = average_predictor_error_rate(y_train, y_test)
fprintf('Error rate: %.0f%%\n', ErrorRate*100);
fprintf('Error rate: %.0f%%\n', e*100);

%% Plot results
% Display decision boundaries
mfig('Decision boundaries for each trained classifier'); clf;
for c = 1:C
    subplot(1,C,c);
    dbplot(X_test, y_test==c-1, @(X) glmval(w_est(:,c),X,'logit'));
    xlabel(attributeNames(1));
    ylabel(attributeNames(2));    
end
linkax grid

mfig('Decision boundaries for classifiers'); clf;
dbplot(X_test, y_test, @(X) max_idx(glmval(w_est,X,'logit'))-1);
xlabel(attributeNames(1));
ylabel(attributeNames(2));

