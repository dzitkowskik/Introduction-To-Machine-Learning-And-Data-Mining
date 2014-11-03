clear all
close all
clc
%
%{
%% Load data 

[a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16] = textread('letter-recognition.dat','%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d');

% a17 = a9.^2;
% a18 = a11.^2;
% a19 = a12.^2;
% a20 = a13.^2;
% a21 = a14.^2;
% a22 = a1.*a2;
% a23 = a3.*a4;
% a24 = a6.*a7;
% a25 = a8.*a9;
% a26 = a10.*12;

a17 = a1.^2;
a18 = a2.^2;
a19 = a3.^2;
a20 = a4.^2;
a21 = a5.^2;
a22 = a6.^2;
a23 = a7.^2;
a24 = a8.^2;
a25 = a8.^2;
a26 = a9.^2;
a27 = a10.^2;
a28 = a11.^2;
a29 = a12.^2;
a30 = a13.^2;
a31 = a13.^2;
a32 = a13.^2;

%attribute names
attributeNames = {'x-box' 'y-box' 'width' 'high' 'onpix' 'x-bar' 'y-bar' 'x2bar' 'y2bar' 'xybar' 'x2ybr' 'xy2br' 'x-ege' 'xegvy' 'y-ege' 'yegvx' 'x-box^2' 'y-box^2' 'width^2' 'high^2' 'onpix^2' 'x-bar^2' 'y-bar^2' 'x2bar^2' 'y2bar^2' 'xybar^2' 'x2ybr^2' 'xy2br^2' 'x-ege^2' 'xegvy^2' 'y-ege^2' 'yegvx^2'};

%attributeNames = {'x-box' 'y-box' 'width' 'high' 'onpix' 'x-bar' 'y-bar' 'x2bar' 'y2bar' 'xybar' 'x2ybr' 'xy2br' 'x-ege' 'xegvy' 'y-ege' 'yegvx'};


%class names
%classnames = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'};

%X=[a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16 a17 a18 a19 a20 a21 a22 a23 a24 a25 a26 a27 a28 a29 a30 a31 a32];

%X=[a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16];

%X=[a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16];

y=a0;

X1=[a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16];
X=X1(1:700,:);
y1=a0;
y=a0(1:700);

%}

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

% a1 = X(:,1).^2;
% a2 = X(:,12).^2
% a3 = X(:,3).^2;
% a4= X(:,4).^2;
% a5= X(:,5).^2;
% a6= X(:,6).^2;
% a7= X(:,7).^2;
% a8= X(:,8).^2;
% a9= X(:,9).^2;
% a10= X(:,10).^2;
% a11= X(:,11).^2;
% a12= X(:,12).^2;
% a13= X(:,13).^2;
% a14= X(:,14).^2;
% a15= X(:,15).^2;
% a16= X(:,16).^2;
% 
% %X(:,17:19)=[a1 a2 a3];
% X(:,17:32)=[a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16];
% 
% 
% %attributeNames = {'x-box' 'y-box' 'width' 'high' 'onpix' 'x-bar' 'y-bar' 'x2bar' 'y2bar' 'xybar' 'x2ybr' 'xy2br' 'x-ege' 'xegvy' 'y-ege' 'yegvx' 'xy2br^2' 'yegvx^2' 'width*onpix'};
% attributeNames = {'x-box' 'y-box' 'width' 'high' 'onpix' 'x-bar' 'y-bar' 'x2bar' 'y2bar' 'xybar' 'x2ybr' 'xy2br' 'x-ege' 'xegvy' 'y-ege' 'yegvx' 'x-box^2' 'y-box^2' 'width^2' 'high^2' 'onpix^2' 'x-bar^2' 'y-bar^2' 'x2bar^2' 'y2bar^2' 'xybar^2' 'x2ybr^2' 'xy2br^2' 'x-ege^2' 'xegvy^2' 'y-ege^2' 'yegvx^2'};


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

k=3; % cross-validation fold to inspect
ff=find(Features(k,:));

w=glmfit(X(:,ff), y, 'binomial') 
y_est= glmval(w,X(:,ff),'logit');

for k=1:K
    w1(:,k)=glmfit(X_tr(:,:,k), y_tr(:,k), 'binomial') ;
    y_est1(:,k)= glmval(w1(:,k),X_te(:,:,k),'logit');
end

error(1:K)=0;

for k=1:K
    for i=1:length(y_est1(:,1))
        if ( (y_te(i,k)==0) && (y_est1(i,k)>=0.5) )
            error(k)=error(k)+1;
        else
            if ((y_te(i,k)==1) && (y_est1(i,k)<0.5) )
                error(k)=error(k)+1;
            end
        end
    end
end

ER=100*(error./CV.TestSize)


residual=y-y_est;
mfig(['Residual error vs. Attributes for features selected in cross-validation fold' num2str(k)]); clf;
for k=1:length(ff)
   subplot(2,ceil(length(ff)/2),k);
   plot(X(:,ff(k)),residual,'.');
   xlabel(attributeNames{ff(k)},'FontWeight','bold');
   ylabel('residual error','FontWeight','bold');
end







