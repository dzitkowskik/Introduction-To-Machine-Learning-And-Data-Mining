function Poutlier = nc_outlier_probs(Wi,Wo,beta,Inputs,Targets)

%NC_OUTLIER_PROBS - Compute the estimated outlier probability 
%                   of the training set
%
% Poutlier = nc_outlier_probs(Wi,Wo,beta,Inputs,Targets)
% 
% Inputs:
%    Wi       : The input-to-hidden weight matrix
%    Wo       : The hidden-to-output weight matrix
%    beta     : The estimated scaled outlier probability
%    Inputs   : The input data matrix
%    Targets  : The target labels
%
% Output:
%    Poutlier : The outlier probability of the training set where an example
%               with a outlier value higher that 0.5 is considered an outlier
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Determine the number of classes
Nc = size(Wo,1);

% Calculate the estimated posterior for all examples and classes
[Vj,yj] = nc_forward(Wi,Wo,Inputs);
Targets_est = nc_softmax(yj);

% Find the class probability without outlier probability
N = length(Targets);
index = (Targets-1)*N+(1:N)';
P0 = Targets_est(index);

% Compute the estimated outlier probability for each training example
Poutlier = beta*(1-P0)./(P0*(1-beta*Nc)+beta);