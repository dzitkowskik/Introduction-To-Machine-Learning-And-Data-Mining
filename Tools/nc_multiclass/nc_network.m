function [err,grad] = nc_network(W,par)

%NC_NETWORK - Information for the bfgs algorithm
%             computes the cost and partial derivative
%             of the cost function w.r.t. the weights
%
% [err,grad] = nc_network(W,par)
%
% Input:
%    W    : The weight vector
%    par  : Struct variable with a number of parameters
%
% Output:
%    err  : The value of the cost function
%    grad : The gradient of the weights                              
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Change the weight format from vector to 2xMatrices
[Wi,Wo] = nc_W2Wio(W,par.Ni,par.Nh,par.No);

% Compute the value of the costfunction
err = nc_cost(Wi,Wo,par.alpha,par.beta,par.x,par.t);

% Evaluate the gradient
[dWi,dWo] = nc_gradient(Wi,Wo,par.alpha,par.beta,par.x,par.t);
grad = [dWi(:);dWo(:)];
