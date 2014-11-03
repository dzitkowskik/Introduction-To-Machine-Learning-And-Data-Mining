clear all
close all
clc
%%
% Load Matlab data file and extract variables of interest
mat_data = load('../project1/letter.mat')
%%
%X = mat_data.X;
A = mat_data.A; %%ordered dataset (from A to Z)
classNames = mat_data.classnames;
classlabel = mat_data.classlabel;
attributeNames = mat_data.attributeNames;
cont = mat_data.cont;

% consider a subset with letter A=0 and C=1
% creation of the sub-set of data-set
X=[A(1:cont(1),:) ; A(cont(1)+cont(2)+1:cont(1)+cont(2)+cont(3),:)];
y1(1:cont(1))=0;
y1(cont(1)+1:cont(1)+cont(3))=1;
y=y1';

[N,M]=size(X);

%% Linear regression criterion function

% This anonymous function takes as input a training and a test set. 
%  1. It fits a generalized linear model on the training set using glmfit.
%  2. It estimates the output of the test set using glmval.
%  3. It computes the sum of squared error.
funLinreg = @(X_train, y_train, X_test, y_test) ...
    sum((y_test-glmval(glmfit(X_train, y_train,'binomial'), ...
    X_test, 'logit')).^2);

%% Crossvalidation
% Create crossvalidation partition for evaluation
K = 5;
CV = cvpartition(N, 'Kfold', K);

% Parameters for neural network classifier
NHiddenUnits = 1;  % Number of hidden units
NTrain = 1; % Number of re-trains of neural network

% Variable for classification error
Error_train_nn = nan(K,1);
Error_test_nn = nan(K,1);
bestnet=cell(K,1);

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
    
    y_te(:,k) = y(CV.test(k));
    y_tr(:,k) = y(CV.training(k));
    X_tr(:,:,k) = X(CV.training(k), :);
    X_te(:,:,k) = X(CV.test(k), :);
    
    w_est = glmfit(X_train, y_train, 'binomial');
    y_est = glmval(w_est, X_test, 'logit');
    Error_LogReg(k) = sum(y_test~=(y_est>.5));
     
    
%     % Compute squared error without using the input data at all
%     Error_train_nofeatures(k) = sum((y_train-mean(y_train)).^2);
%     Error_test_nofeatures(k) = sum((y_test-mean(y_train)).^2);
%     % Compute squared error without feature subset selection
%     Error_train(k) = funLinreg(X_train, y_train, X_train, y_train);
%     Error_test(k) = funLinreg(X_train, y_train, X_test, y_test);            
    
    %% Fit neural network to training set
    MSEBest = inf;
    for t = 1:NTrain
        netwrk = nr_main(X_train, y_train, X_test, y_test, NHiddenUnits);
        if netwrk.mse_train(end)<MSEBest, bestnet{k} = netwrk; MSEBest=netwrk.mse_train(end); 
            MSEBest=netwrk.mse_train(end); 
        end
    end
    
    % Predict model on test and training data    
    y_train_est_nn = bestnet{k}.t_pred_train;    
    y_test_est_nn = bestnet{k}.t_pred_test; 
    
    y_tr_est_nn(:,k)= y_train_est_nn;
    y_te_est_nn(:,k)= y_test_est_nn;
    
    % Compute least squares error
    Error_train_nn(k) = sum((y_train-y_train_est_nn).^2);
    Error_test_nn(k) = sum((y_test-y_test_est_nn).^2);   
    
    
    
    nn=sum(y_train)/length(y_train);
    nn= round((10^0).*nn)./10^0;
    Error_ap(k)=sum(y_test~=nn);
end

% %% Display results
% fprintf('\n');
% fprintf('Linear regression without feature selection:\n');
% fprintf('- Training error: %8.2f\n', sum(Error_train)/sum(CV.TrainSize));
% fprintf('- Test error:     %8.2f\n', sum(Error_test)/sum(CV.TestSize));
% fprintf('- R^2 train:     %8.2f\n', (sum(Error_train_nofeatures)-sum(Error_train))/sum(Error_train_nofeatures));
% fprintf('- R^2 test:     %8.2f\n', (sum(Error_test_nofeatures)-sum(Error_test))/sum(Error_test_nofeatures));
% 
% fprintf('\n');
% fprintf('Neural network regression without feature selection:\n');
% fprintf('- Training error: %8.2f\n', sum(Error_train_nn)/sum(CV.TrainSize));
% fprintf('- Test error:     %8.2f\n', sum(Error_test_nn)/sum(CV.TestSize));
% fprintf('- R^2 train:     %8.2f\n', (sum(Error_train_nofeatures)-sum(Error_train_nn))/sum(Error_train_nofeatures));
% fprintf('- R^2 test:     %8.2f\n', (sum(Error_test_nofeatures)-sum(Error_test_nn))/sum(Error_test_nofeatures));
% 


error(1:K)=0;
for k=1:K
    for i=1:length(y_test_est_nn)
        if ( (y_te(i,k)==0) && (y_te_est_nn(i,k)>=0.5) )
            error(k)=error(k)+1;
        else
            if ((y_te(i,k)==1) && (y_te_est_nn(i,k)<0.5) )
                error(k)=error(k)+1;
            end
        end
    end
end

Error_LogReg
Error_nn=error
Error_ap
%% Determine if classifiers are significantly different
mfig('Error rates 1');
boxplot([Error_LogReg./CV.TestSize; Error_nn./CV.TestSize]'*100, ...
    'labels', {'Logistic regression', 'ANN'});
ylabel('Error rate (%)');

if ttest(Error_LogReg, Error_nn)
    disp('Classifiers are significantly different');
else
    disp('Classifiers are NOT significantly different');
end



mfig('Error rates 2');
boxplot([Error_LogReg./CV.TestSize; Error_ap./CV.TestSize]'*100, ...
    'labels', {'Logistic regression', 'Predict Average'});
ylabel('Error rate (%)');

if ttest(Error_LogReg, Error_ap)
    disp('Classifiers are significantly different');
else
    disp('Classifiers are NOT significantly different');
end

mfig('Error rates 3');
boxplot([Error_nn./CV.TestSize ; Error_ap./CV.TestSize ]'*100, ...
    'labels', {'ANN', 'Predict Average'});
ylabel('Error rate (%)');

if ttest(Error_nn , Error_ap)
    disp('Classifiers are significantly different');
else
    disp('Classifiers are NOT significantly different');
end

ER_lr=(sum(Error_LogReg./CV.TestSize)*100)/K
ER_nn=(sum(Error_nn./CV.TestSize)*100)/K
ER_ap=(sum(Error_ap./CV.TestSize)*100)/K
