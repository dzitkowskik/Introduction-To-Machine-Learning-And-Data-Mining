% exercise 8.3.2

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/synth1'));

%% Fit one-against-rest models
% Fit logistic regression model to training set
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
fprintf('Error rate: %.0f%%\n', ErrorRate*100);

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

