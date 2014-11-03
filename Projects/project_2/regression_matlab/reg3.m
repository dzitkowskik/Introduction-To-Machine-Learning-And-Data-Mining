clear; close all; clc;
%%
% Load Matlab data file and extract variables of interest
mat_data = load('../project2/letter_reg.mat')
%%
X1 = mat_data.X;
classNames = mat_data.classNames;
classlabel = mat_data.classlabel;
attributeNames = mat_data.attributeNames;
y1 = mat_data.y;


X=X1(1:1000,:);
y=y1(1:1000,:);


C=26;
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

%% Fit multinomial regression model
Y_train=oneoutofk(y_train,C);
Y_test=oneoutofk(y_test,C);

W_est = mnrfit(X_train, Y_train);
    
%% Compute results on test data
% Get the predicted output for the test data
Y_test_est = mnrval(W_est, X_test);       

% Compute the class index by finding the class with highest probability from the multinomial regression model
[y_, y_test_est] = max(Y_test_est, [], 2);
% Subtract one to have y_test_est between 0 and C-1
y_test_est = y_test_est-1;

% Compute error rate
ErrorRate = sum(y_test~=y_test_est)/N_test;
ErrorRate
fprintf('Error rate: %.0f%%\n', ErrorRate*100);

%% Plot results
% Display decision boundaries
mfig('Decision Boundaries'); clf;   
dbplot(X_test, y_test, @(X) max_idx(mnrval(W_est,X))-1);
xlabel(attributeNames(1));
ylabel(attributeNames(2));