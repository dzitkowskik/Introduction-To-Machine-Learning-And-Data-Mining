% exercise 8.1.1

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/wine2'))

%% Crossvalidation
% Create crossvalidation partition for evaluation
% using stratification and 50 pct. split between training and test 
CV = cvpartition(classNames(y+1), 'Holdout', .5);

% Extract the training and test set
X_train = X(CV.training, :);
y_train = y(CV.training);
X_test = X(CV.test, :);
y_test = y(CV.test);

%% Fit model
% Fit logistic regression model to training data to predict the type of wine
w_est = glmfit(X_train, y_train, 'binomial');

% Evaluate the logistic regression on the test data
p = glmval(w_est, X_test, 'logit');

%% Plot receiver operating characteristic (ROC) curve
mfig('ROC'); clf;
rocplot(p, y_test);

% We'll plot a confusion matrix as well
mfig('Confusion matrix'); clf;
y_test_est = p>.5;
confmatplot(classNames(y_test+1), classNames(y_test_est+1));


