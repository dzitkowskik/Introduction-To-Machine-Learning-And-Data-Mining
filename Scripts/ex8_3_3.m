% exercise 8.3.3
clear all;
% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/synth1'))

% Parameters for neural network classifier
NHiddenUnits = 2;  % Number of hidden units

%% Fit multiclass neural network to training set
net = nc_main(X_train, y_train+1, X_test, y_test+1, NHiddenUnits);
    
%% Compute results on test data
% Get the predicted output for the test data
Y_test_est = nc_eval(net, X_test);       

% Compute the class index by finding the class with highest probability from the neural
% network
y_test_est = max_idx(Y_test_est);
% Subtract one to have y_test_est between 0 and C-1
y_test_est = y_test_est-1;

% Compute error rate
ErrorRate = sum(y_test~=y_test_est)/N_test;
fprintf('Error rate: %.0f%%\n', ErrorRate*100);

%% Plot results
% Display trained network
mfig('Trained network'); clf;   
displayNetwork(net)

% Display decision boundaries
mfig('Decision Boundaries'); clf;   
dbplot(X_test, y_test, @(X) max_idx(nc_eval(net, X))-1);
xlabel(attributeNames(1));
ylabel(attributeNames(2));

