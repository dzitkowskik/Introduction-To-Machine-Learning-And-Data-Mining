% exercise 6.1.2

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/wine2'))

% Number of folds for crossvalidation
K = 10;

% Create holdout crossvalidation partition
CV = cvpartition(classNames(y+1), 'Kfold', K);

% Pruning levels
prune = 0:10;

% Variable for classification error
Error_train = nan(K,length(prune));
Error_test = nan(K,length(prune));

for k = 1:K
    fprintf('Crossvalidation fold %d/%d\n', k, K);

    % Extract training and test set
    X_train = X(CV.training(k), :);
    y_train = y(CV.training(k));
    X_test = X(CV.test(k), :);
    y_test = y(CV.test(k));

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
        Error_train(k,n) = sum(~strcmp(classNames(y_train+1), eval(T, X_train, prune(n))));
        Error_test(k,n) = sum(~strcmp(classNames(y_test+1), eval(T, X_test, prune(n))));
    end    
end
    
% Plot classification error
mfig('Wine decision tree: K-fold crossvalidatoin'); clf; hold all;
plot(prune, sum(Error_train)/sum(CV.TrainSize));
plot(prune, sum(Error_test)/sum(CV.TestSize));
xlabel('Pruning level');
ylabel('Classification error');
legend('Training error', 'Test error');