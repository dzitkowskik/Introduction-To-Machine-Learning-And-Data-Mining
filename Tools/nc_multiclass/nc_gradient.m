function [dWi,dWo] = nc_gradient(Wi,Wo,alpha,beta,Inputs,Targets)

%NC_GRADIENT   Neural classifier gradient of the cost function 
%              with respect to the weights
%
% [dWi,dWo] = nc_gradient(Wi,Wo,alpha,beta,Inputs,Targets)
%
% Input:
%    Wi      : Matrix with input-to-hidden weights
%    Wo      : Matrix with hidden-to-outputs weights
%    alpha   : Weight decay parameter
%    beta    : Estimated scaled outlier probability
%    Inputs  : Matrix with examples as rows
%    Targets : Matrix with target values as rows
%
% Output:
%    dWi     : Matrix with gradient for input weights
%    dWo     : Matrix with gradient for output weights
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Determine the number of examples, classes and hidden units
[exam inp] = size(Inputs);
Nc = size(Wo,1);
Nh = size(Wi,1);
 
% Calculate hidden and output unit activations
[Vj,yj] = nc_forward(Wi,Wo,Inputs);
    
% Apply softmax
yj = nc_softmax(yj);

% Create indices in matrix for outputs corresp. to the correct class
indx = (Targets-1)*exam + (1:exam)';
  
% Subtract target value (=1) from correct class probabilities
yj(indx) = yj(indx) - 1;

% Hidden unit deltas
delta_h =(1.0 - Vj.^2) .* (yj * Wo(:,1:Nh));
  
% Partial derivatives for the output weights
dWo = yj' * [Vj ones(exam,1)];

% Partial derivatives for the input weights
dWi = delta_h' * [Inputs ones(exam,1)];
  
% Add derivatives of the regularization term
dWi = (dWi + alpha * Wi);
dWo = (dWo + alpha * Wo);
