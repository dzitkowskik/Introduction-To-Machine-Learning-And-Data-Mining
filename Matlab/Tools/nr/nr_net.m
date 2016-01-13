function [cost,dW] = nr_net(Weights,par)

%NR_NET - Gives the cost and the gradient w.r.t. the weights
%          and is used for optimization with the BFGS algorithm
%
% [cost,dW] = nr_net(Weights,par)
%
% Inputs:
%    Weights : The weight vector
%    par     : Struct varible with other parameters
%
% Output:
%    cost    : The value of the cost function
%    dW      : The gradient of the cost function wrt. the weights
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.


% Reformat the weights
[Wi,Wo] = nr_W2Wio(Weights,par.Ni,par.Nh);

% Compute the cost
cost = nr_cost(Wi,Wo,par.alpha,par.beta,par.x,par.t);

% Compute the gradient
[dWi,dWo] = nr_grad(Wi,Wo,par.alpha,par.beta,par.x,par.t);
dW = [dWi(:);dWo(:)];