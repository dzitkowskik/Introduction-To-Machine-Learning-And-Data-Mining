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

%% Regularized Linear regression 
% include an additional attribute corresponding to the offset
X=[ones(size(X,1),1) X];
M=M+1;
attributeNames={'Offset', attributeNames{1:end}};
 
% Crossvalidation
% Create crossvalidation partition for evaluation of performance of optimal
% model
K = 5;
CV = cvpartition(N, 'Kfold', K);

% Values of lambda
lambda_tmp=10.^(-5:8);

% Initialize variables
T=length(lambda_tmp);
Error_train = nan(K,1);
Error_test = nan(K,1);
Error_train_rlr = nan(K,1);
Error_test_rlr = nan(K,1);
Error_train_nofeatures = nan(K,1);
Error_test_nofeatures = nan(K,1);
Error_train2 = nan(T,K);
Error_test2 = nan(T,K);
w = nan(M,T,K);
lambda_opt = nan(K,1);
w_rlr = nan(M,K);
w_noreg = nan(M,K);

% For each crossvalidation fold
for k = 1:K
    fprintf('Crossvalidation fold %d/%d\n', k, K);
    
    % Extract the training and test set
    X_train = X(CV.training(k), :);
    y_train = y(CV.training(k));
    X_test = X(CV.test(k), :);
    y_test = y(CV.test(k));

    % Use 10-fold crossvalidation to estimate optimal value of lambda    
    KK = 10;
    CV2 = cvpartition(size(X_train,1), 'Kfold', KK);
    for kk=1:KK
        X_train2 = X_train(CV2.training(kk), :);
        y_train2 = y_train(CV2.training(kk));
        X_test2 = X_train(CV2.test(kk), :);
        y_test2 = y_train(CV2.test(kk));
                        
        Xty2=(X_train2'*y_train2);
        XtX2=X_train2'*X_train2;
        for t=1:length(lambda_tmp)   
            % Learn parameter for current value of lambda for the given
            % inner CV_fold
            w(:,t,kk)=(XtX2+lambda_tmp(t)*eye(M))\Xty2;
            % Evaluate training and test performance
            Error_train2(t,kk) = sum((y_train2-X_train2*w(:,t,kk)).^2);
            Error_test2(t,kk) = sum((y_test2-X_test2*w(:,t,kk)).^2);
        end
    end    
    
    % Display result for cross-validation fold
    mfig(sprintf('(%d) Regularized Solution',k));    
    subplot(1,2,1); % Plot error criterion
    semilogx(lambda_tmp,mean(w,3),'.-');
    legend(attributeNames);
    xlabel('\lambda');
    ylabel('Coefficient Values');
    title('Values of w');
    subplot(1,2,2); % Plot error        
    loglog(lambda_tmp,[sum(Error_train2,2)/sum(CV2.TrainSize) sum(Error_test2,2)/sum(CV2.TestSize)],'.-');   
    legend({'Training Error as function of lambda','Test Error as function of lambda'},'Location','SouthEast');
    % Select optimal value of lambda
    [val,ind_opt]=min(sum(Error_test2,2)/sum(CV2.TestSize));
    lambda_opt(k)=lambda_tmp(ind_opt);    
    title(['Traning and test error, optimal value of lambda=' num2str(lambda_opt(k))]);
    xlabel('\lambda');           
    drawnow;    
    
    % Estimate w for the optimal value of lambda
    Xty=(X_train'*y_train);
    XtX=X_train'*X_train;
    w_rlr(:,k)=(XtX+lambda_opt(k)*eye(M))\Xty;
    
    % evaluate training and test error performance for optimal selected value of
    % lambda
    Error_train_rlr(k) = sum((y_train-X_train*w_rlr(:,k)).^2);
    Error_test_rlr(k) = sum((y_test-X_test*w_rlr(:,k)).^2);
    
    % Compute squared error without regularization
    w_noreg(:,k)=XtX\Xty;
    Error_train(k) = sum((y_train-X_train*w_noreg(:,k)).^2);
    Error_test(k) = sum((y_test-X_test*w_noreg(:,k)).^2);
    
    % Compute squared error without using the input data at all
    Error_train_nofeatures(k) = sum((y_train-mean(y_train)).^2);
    Error_test_nofeatures(k) = sum((y_test-mean(y_train)).^2);
     
end


%%

ww=mean(w_rlr')
mfig('Weights')
bar(ww(2:end))
%axis([0 17 -9.5 7.5])
set(gca,'FontSize',12,'XTick',[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16],'XTickLabel',attributeNames(2:end));
xticklabel_rotate([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16],45,attributeNames(2:end))
ylabel('Weight')

%% Display results
fprintf('\n');
fprintf('Linear regression without feature selection:\n');
fprintf('- Training error: %8.2f\n', sum(Error_train)/sum(CV.TrainSize));
fprintf('- Test error:     %8.2f\n', sum(Error_test)/sum(CV.TestSize));
fprintf('- R^2 train:     %8.2f\n', (sum(Error_train_nofeatures)-sum(Error_train))/sum(Error_train_nofeatures));
fprintf('- R^2 test:     %8.2f\n', (sum(Error_test_nofeatures)-sum(Error_test))/sum(Error_test_nofeatures));
fprintf('Regularized Linear regression:\n');
fprintf('- Training error: %8.2f\n', sum(Error_train_rlr)/sum(CV.TrainSize));
fprintf('- Test error:     %8.2f\n', sum(Error_test_rlr)/sum(CV.TestSize));
fprintf('- R^2 train:     %8.2f\n', (sum(Error_train_nofeatures)-sum(Error_train_rlr))/sum(Error_train_nofeatures));
fprintf('- R^2 test:     %8.2f\n', (sum(Error_test_nofeatures)-sum(Error_test_rlr))/sum(Error_test_nofeatures));
w_mean_and_std=[mean(w_rlr,2) std(w_rlr,[],2)]