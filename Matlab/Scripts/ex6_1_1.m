% exercise 6.1.1

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/wine2'))

% Create holdout crossvalidation partition
CV = cvpartition(classNames(y+1), 'Holdout', .5);

% Pruning levels
prune = 0:10;

% Variable for classification error count
Error_train = nan(1,length(prune));
Error_test = nan(1,length(prune));

% Extract training and test set
X_train = X(CV.training, :);
y_train = y(CV.training);
X_test = X(CV.test, :);
y_test = y(CV.test);

% Fit classification tree to training set
T = classregtree(X_train, classNames(y_train+1), ...
    'method', 'classification', ...
    'splitcriterion', 'gdi', ...
    'categorical', [], ...
    'names', attributeNames, ...
    'prune', 'on', ...
    'minparent', 10);

% Compute classification error
for n = 1:length(prune) % For each pruning level
    Error_train(n) = sum(~strcmp(classNames(y_train+1), eval(T, X_train, prune(n))));
    Error_test(n) = sum(~strcmp(classNames(y_test+1), eval(T, X_test, prune(n))));
end

% Plot classification error
mfig('Wine decision tree: Holdout crossvalidation'); clf; hold all;
plot(prune, Error_train/CV.TrainSize);
plot(prune, Error_test/CV.TestSize);
xlabel('Pruning level');
ylabel('Classification error');
legend('Training error', 'Test error');