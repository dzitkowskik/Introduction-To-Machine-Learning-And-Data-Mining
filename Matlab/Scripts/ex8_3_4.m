% exercise 8.3.4
clear all;
% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/synth1'))

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
fprintf('Error rate: %.0f%%\n', ErrorRate*100);

%% Plot results
% Display decision boundaries
mfig('Decision Boundaries'); clf;   
dbplot(X_test, y_test, @(X) max_idx(mnrval(W_est,X))-1);
xlabel(attributeNames(1));
ylabel(attributeNames(2));

