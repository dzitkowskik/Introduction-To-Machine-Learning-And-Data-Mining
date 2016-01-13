% exercise 7.1.2

% Load data
ex4_1_1

% Leave-one-out crossvalidation
CV = cvpartition(N, 'Leaveout');
K = CV.NumTestSets;

% K-nearest neighbors parameters
Distance = 'euclidean'; % Distance measure
L = 40; % Maximum number of neighbors

% Variable for classification error
Error = nan(K,L);

for k = 1:K % For each crossvalidation fold
    fprintf('Crossvalidation fold %d/%d\n', k, CV.NumTestSets);

    % Extract training and test set
    X_train = X(CV.training(k), :);
    y_train = y(CV.training(k));
    X_test = X(CV.test(k), :);
    y_test = y(CV.test(k));

    for l = 1:L % For each number of neighbors
        
        % Use knnclassify to find the l nearest neighbors
        y_test_est = knnclassify(X_test, X_train, y_train, l, Distance);
        
        % Compute number of classification errors
        Error(k,l) = sum(y_test~=y_test_est); % Count the number of errors
    end
end

%% Plot the classification error rate
mfig('Error rate');
plot(sum(Error)./sum(CV.TestSize)*100);
xlabel('Number of neighbors');
ylabel('Classification error rate (%)');
