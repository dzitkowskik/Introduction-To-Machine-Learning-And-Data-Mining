% exercise 7.3.6

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/wine2'))

% predict alcohol content
y=X(:,11);
X(:,11)=[];

% K-fold crossvalidation
K = 10;
CV = cvpartition(N,'Kfold', K);

% Parameters for neural network classifier
NHiddenUnits = 10;  % Number of hidden units
NTrain = 1; % Number of re-trains of neural network

% Variable for classification error
Error_train = nan(K,1);
Error_test = nan(K,1);
Error_train_nofeatures = nan(K,1);
Error_test_nofeatures = nan(K,1);
bestnet=cell(K,1);

for k = 1:K % For each crossvalidation fold
    fprintf('Crossvalidation fold %d/%d\n', k, CV.NumTestSets);

    % Extract training and test set
    X_train = X(CV.training(k), :);
    y_train = y(CV.training(k));
    X_test = X(CV.test(k), :);
    y_test = y(CV.test(k));

    % Fit neural network to training set
    MSEBest = inf;
    for t = 1:NTrain
        netwrk = nr_main(X_train, y_train, X_test, y_test, NHiddenUnits);
        if netwrk.mse_train(end)<MSEBest, bestnet{k} = netwrk; MSEBest=netwrk.mse_train(end); MSEBest=netwrk.mse_train(end); end
    end
    
    % Predict model on test and training data    
    y_train_est = bestnet{k}.t_pred_train;    
    y_test_est = bestnet{k}.t_pred_test;        
    
    % Compute least squares error
    Error_train(k) = sum((y_train-y_train_est).^2);
    Error_test(k) = sum((y_test-y_test_est).^2); 
        
    % Compute least squares error when predicting output to be mean of
    % training data
    Error_train_nofeatures(k) = sum((y_train-mean(y_train)).^2);
    Error_test_nofeatures(k) = sum((y_test-mean(y_train)).^2);            
end

% Print the least squares errors
%% Display results
fprintf('\n');
fprintf('Neural network regression without feature selection:\n');
fprintf('- Training error: %8.2f\n', sum(Error_train)/sum(CV.TrainSize));
fprintf('- Test error:     %8.2f\n', sum(Error_test)/sum(CV.TestSize));
fprintf('- R^2 train:     %8.2f\n', (sum(Error_train_nofeatures)-sum(Error_train))/sum(Error_train_nofeatures));
fprintf('- R^2 test:     %8.2f\n', (sum(Error_test_nofeatures)-sum(Error_test))/sum(Error_test_nofeatures));


% Display the trained network 
mfig('Trained Network');
k=1; % cross-validation fold
displayNetwork(bestnet{k});

% Display the decition boundary 
if size(X_train,2)==2 % Works only for problems with two attributes
	mfig('Decision Boundary');
	displayDecisionFunctionNetwork(X_train, y_train, X_test, y_test, bestnet{k});
end