% exercise 8.2.3

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/synth7'))

%% Fit model using bootstrap aggregation (bagging)

% Number of rounds of bagging
L = 100;

% Fit classification trees using the TreeBagger function
B = TreeBagger(L, X, classNames(y+1));

% Make predictions for the whole data set. The predict function outputs a
% cell array of strings, so y_est can be computed by comparing the returned
% strings using the strcmp function to the name of the second class. This
% will give a 0 for "Class 1" and a 1 for "Class 2".
y_est = strcmp(predict(B, X), classNames(2));

% Compute error rate
ErrorRate = sum(y~=y_est)/N;
fprintf('Error rate: %.0f%%\n', ErrorRate*100);

%% Plot decision boundary
mfig('Decision boundary'); clf;
dbplot(X, y, @(X) strcmp(predict(B, X), classNames(2)));
xlabel(attributeNames(1)); ylabel(attributeNames(2));
legend(classNames);