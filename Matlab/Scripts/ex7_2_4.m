% exercise 7.2.4

% Load data
ex7_2_3;

% K-fold crossvalidation
K = 10;
CV = cvpartition(y, 'Kfold', K);

% Parameters for naive Bayes classifier
Distribution = 'mvmn';
Prior = 'uniform';

% Variable for classification error
Error = nan(K,1);


for k = 1:K % For each crossvalidation fold
    fprintf('Crossvalidation fold %d/%d\n', k, CV.NumTestSets);

    % Extract training and test set
    X_train = X(CV.training(k), :);
    y_train = y(CV.training(k));
    X_test = X(CV.test(k), :);
    y_test = y(CV.test(k));

    % Fit naive Bayes classifier to training set
    NB = NaiveBayes.fit(X_train, y_train, 'Distribution', Distribution, 'Prior', Prior);
    
    % Predict model on test data    
    y_test_est = predict(NB, X_test);
    
    % Compute error rate
    Error(k) = sum(y_test~=y_test_est); % Count the number of errors
end

% Print the error rate
fprintf('Error rate: %.1f%%\n', sum(Error)./sum(CV.TestSize)*100);