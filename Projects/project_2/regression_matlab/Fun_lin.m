function x = Fun_lin(X_train, y_train, X_test, y_test)
%% Fit one-against-rest models
% Fit logistic regression model to training set
C=26;
w_est=NaN(16+1,C);
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

x= sum((y_test-y_test_est).^2);