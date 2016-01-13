function probs = nc_softmax(phi)

%NC_SOFTMAX - Neural classifier softmax function
%
% probs = nc_softmax(phi)
%
% Input:  
%    phi  : Matrix with values of outputs of the network (NC_FORWARD)
%           
% Output:  
%    probs: Matrix of posterior probabilities. Each row is the
%           are individual class probabilities for a specific example.
% 
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Number of classes
Nc = size(phi,2);

% Compute the class probabilities
exp_phi = exp(phi);
sumexp_phi = sum(exp_phi,2);
probs = exp_phi./repmat(sumexp_phi,1,Nc);
