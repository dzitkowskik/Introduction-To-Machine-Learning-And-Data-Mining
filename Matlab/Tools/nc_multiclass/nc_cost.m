function cost = nc_cost(Wi,Wo,alpha,beta,Inputs,Targets) 

%NC_COST - Neural classifier costfunction with regularization
%   
% cost = nc_cost(Wi,Wo,alpha,Inputs,Targets)
%
% Input:
%    Wi      : Matrix with input-to-hidden weights
%    Wo      : Matrix with hidden-to-outputs weights
%    alpha:  : Weight decay parameter
%    Inputs  : Matrix with examples as rows
%    Targets : Matrix with target values as rows
%
% Output:
%    cost    : Value of regularized negative log-likelihood cost function
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Get the number of classes
Nc = size(Wo,1);

% Calculate the estimated posterior for all examples and classes
[Vj,yj] = nc_forward(Wi,Wo,Inputs);
Targets_est = nc_softmax(yj);

% Modify with outlier probability
Targets_est = Targets_est*(1-beta*Nc)+beta;

% Determine the number of classes and examples
N = length(Targets);

% Convert the Target variable to 1-of-c coded
Targets_true = zeros(N,Nc);
index = (Targets-1)*N+(1:N)';
Targets_true(index) = ones(N,1);
  
% Compute the likelihood error
cost = -sum(sum(Targets_true.*log(Targets_est)));

% Add the regularization term to give the error
cost = cost + 0.5*alpha*(sum(sum(Wi.^2)) + sum(sum(Wo.^2))); 
