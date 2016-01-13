function rate = nc_err_frac(Wi,Wo,beta,Inputs, Targets) 

%NC_ERR_FRAC - Neural classifier fraction of misclassified examples
%
% rate = nc_err_frac(Wi,Wo,Inputs,Targets)
%
% Input:
%    Wi      : Matrix with input-to-hidden weights
%    Wo      : Matrix with hidden-to-outputs weights
%    Inputs  : Matrix with examples as rows
%    Targets : Matrix with target values as rows
%
% Output:
%    rate    : The fraction of misclassified examples
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Determine the number of examples and classes
N = size(Inputs,1);
Nc = size(Wo,1);
  
% Calculate the class probabilities without outlier probability
[Vj,probs] = nc_forward(Wi,Wo,Inputs);
probs = nc_softmax(probs);
  
% Use the outlier probability model
probs = probs*(1-beta*Nc) + beta;

% Choose maxima as target classes
[v t_est] = max(probs,[],2);

% Compute the misclassification rate
rate = sum(Targets ~= t_est)/N;
