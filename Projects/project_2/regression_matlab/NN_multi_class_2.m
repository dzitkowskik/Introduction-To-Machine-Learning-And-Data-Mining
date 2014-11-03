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

C=26;

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


% Parameters for neural network classifier
NHiddenUnits = 2;  % Number of hidden units

%% Fit one-against-rest models
% Allocate variable for trained networks
net = cell(C,1);

% Fit neural network to training set
for c = 1:C
    net{c} = nr_main(X_train, y_train==c-1, X_test, y_test==c-1, NHiddenUnits);
end
    
%% Compute results on test data
% Allocate variable for test results
Y_test_est = nan(N_test, C);

% For each one-against-rest classifier
for c = 1:C 
    % Get the predicted output for the test data
    Y_test_est(:,c) = nr_eval(net{c}, X_test);       
end

% Compute the class index by finding the maximum output from the neural
% network
[y_, y_test_est] = max(Y_test_est, [], 2);
% Subtract one to have y_test_est between 0 and C-1
y_test_est = y_test_est-1;

% Compute error rate
ErrorRate = sum(y_test~=y_test_est)/N_test;
fprintf('Error rate: %.0f%%\n', ErrorRate*100);

%% Plot results
% Display decision boundaries
mfig('Decision boundaries for each trained classifier'); clf;
for c = 1:C
    subplot(1,C+1,c);
    dbplot(X_test, y_test==c-1, @(X) nr_eval(net{c}, X));
    xlabel(attributeNames(1));
    ylabel(attributeNames(2));
end
linkax grid

mfig('Decision boundaries for classifiers'); clf;
dbplot(X_test, y_test, @(X) max_idx(nr_eval(net,X))-1);
xlabel(attributeNames(1));
ylabel(attributeNames(2));