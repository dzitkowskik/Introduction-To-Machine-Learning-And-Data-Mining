% exercise 6.2.1

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/body'))

%% Linear regression criterion function

% This anonymous function takes as input a training and a test set. 
%  1. It fits a generalized linear model on the training set using glmfit.
%  2. It estimates the output of the test set using glmval.
%  3. It computes the sum of squared error.
funLinreg = @(X_train, y_train, X_test, y_test) ...
    sum((y_test-glmval(glmfit(X_train, y_train), ...
    X_test, 'identity')).^2);

%% Crossvalidation
% Create crossvalidation partition for evaluation
K = 5;
CV = cvpartition(N, 'Kfold', K);

% Initialize variables
Features = nan(K,M);
Error_train = nan(K,1);
Error_test = nan(K,1);
Error_train_fs = nan(K,1);
Error_test_fs = nan(K,1);
Error_train_nofeatures = nan(K,1);
Error_test_nofeatures = nan(K,1);

% For each crossvalidation fold
for k = 1:K
    fprintf('Crossvalidation fold %d/%d\n', k, K);
    
    % Extract the training and test set
    X_train = X(CV.training(k), :);
    y_train = y(CV.training(k));
    X_test = X(CV.test(k), :);
    y_test = y(CV.test(k));

    % Use 10-fold crossvalidation for sequential feature selection
    [F, H] = sequentialfs(funLinreg, X_train, y_train);
    
    % Save the selected features
    Features(k,:) = F;    
    
    % Compute squared error without using the input data at all
    Error_train_nofeatures(k) = sum((y_train-mean(y_train)).^2);
    Error_test_nofeatures(k) = sum((y_test-mean(y_train)).^2);
    % Compute squared error without feature subset selection
    Error_train(k) = funLinreg(X_train, y_train, X_train, y_train);
    Error_test(k) = funLinreg(X_train, y_train, X_test, y_test);
    % Compute squared error with feature subset selection
    Error_train_fs(k) = funLinreg(X_train(:,F), y_train, X_train(:,F), y_train);
    Error_test_fs(k) = funLinreg(X_train(:,F), y_train, X_test(:,F), y_test);            
    
    % Show variable selection history
    mfig(sprintf('(%d) Feature selection',k));
    I = size(H.In,1); % Number of iterations    
    subplot(1,2,1); % Plot error criterion
    plot(H.Crit);
    xlabel('Iteration');
    ylabel('Squared error (crossvalidation)');
    title('Value of error criterion');
    xlim([0 I]);
    subplot(1,2,2); % Plot feature selection sequence
    bmplot(attributeNames, 1:I, H.In');
    title('Attributes selected');
    xlabel('Iteration');
    drawnow;    
end

%% Display results
fprintf('\n');
fprintf('Linear regression without feature selection:\n');
fprintf('- Training error: %8.2f\n', sum(Error_train)/sum(CV.TrainSize));
fprintf('- Test error:     %8.2f\n', sum(Error_test)/sum(CV.TestSize));
fprintf('- R^2 train:     %8.2f\n', (sum(Error_train_nofeatures)-sum(Error_train))/sum(Error_train_nofeatures));
fprintf('- R^2 test:     %8.2f\n', (sum(Error_test_nofeatures)-sum(Error_test))/sum(Error_test_nofeatures));
fprintf('Linear regression with sequential feature selection:\n');
fprintf('- Training error: %8.2f\n', sum(Error_train_fs)/sum(CV.TrainSize));
fprintf('- Test error:     %8.2f\n', sum(Error_test_fs)/sum(CV.TestSize));
fprintf('- R^2 train:     %8.2f\n', (sum(Error_train_nofeatures)-sum(Error_train_fs))/sum(Error_train_nofeatures));
fprintf('- R^2 test:     %8.2f\n', (sum(Error_test_nofeatures)-sum(Error_test_fs))/sum(Error_test_nofeatures));

% Show the selected features
mfig('Attributes'); clf;
bmplot(attributeNames, 1:K, Features');
xlabel('Crossvalidation fold');
ylabel('Attribute');
title('Attributes selected');

% Inspect selected feature coefficients effect on the entire dataset and
% plot the fitted modeld residual error as function of each attribute to
% inspect for systematic structure in the residual
k=1; % cross-validation fold to inspect
ff=find(Features(k,:));
w=glmfit(X(:,ff), y) 

y_est= glmval(w,X(:,ff),'identity');
residual=y-y_est;
mfig(['Residual error vs. Attributes for features selected in cross-validation fold' num2str(k)]); clf;
for k=1:length(ff)
   subplot(2,ceil(length(ff)/2),k);
   plot(X(:,ff(k)),residual,'.');
   xlabel(attributeNames{ff(k)},'FontWeight','bold');
   ylabel('residual error','FontWeight','bold');
end




