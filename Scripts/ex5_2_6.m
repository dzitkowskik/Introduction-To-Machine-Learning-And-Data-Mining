% exercise 5.2.6

% Load wine data 
ex5_1_5;

% Fit logistic regression model to predict the type of wine
w_est = glmfit(X, y, 'binomial');

% Define a new data object with the attributes given in the text
x = [6.9 1.09 .06 2.1 .0061 12 31 .99 3.5 .44 12];

% Evaluate the logistic regression for the new data object
p = glmval(w_est, x, 'logit')