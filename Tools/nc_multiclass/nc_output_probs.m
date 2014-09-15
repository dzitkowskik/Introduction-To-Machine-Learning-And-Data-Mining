function [p_est,Targets_est] = nc_output_probs(Wi,Wo,beta,Inputs)

%NC_OUTPUT_PROBS - Compute estimated class probabilities with  
%                  outlier probabilities and estimate the target labels
%
% [p_est,Targets_est] = nc_output_probs(Wi,Wo,beta,Inputs)
%
% Inputs:
%   Wi          : The input-to-hidden weight matrix
%   Wo          : The hidden-to-output weight matrix
%   beta        : The estimated scaled outlier probability
%   Inputs      : The input data matrix
%
% Output:
%   p_est       : The estimated condiational class probability
%   Targets_est : The estimated target labels
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Calculate the estimated posterior for all examples and classes 
% without outlier probability
[Vj,yj] = nc_forward(Wi,Wo,Inputs);
p_est_beta0 = nc_softmax(yj);

% Calculate the estimated posterior for all examples and classes 
% with outlier probability
Nc = size(Wo,1);
p_est = p_est_beta0*(1-beta*Nc)+beta;

% Compute the estimated target label
[d,Targets_est] = max(p_est,[],2);
