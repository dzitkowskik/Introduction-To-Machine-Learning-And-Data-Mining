function [par,g] = nr_hyperparameters(Weights,par)

%NR_HYPERPARAMETERS - Update the hyperparameters alpha and beta
%
% [par,gamma] = nr_hyperparameters(Weights,par)
%
% Inputs:
%   Weights : The weight vector
%   par     : Struct varible with other network parameters
%
% Output:
%   par     : Struct varible with the updated
%             hyperparameters
%   gamma   : The number of well determined weights
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.

% Determine the number of weights and examples
W = length(Weights);
N = length(par.t);

% Compute the inverse Hessian
invH = nr_gnhessian(Weights,par);

% Compute the gamma
g = W - par.alpha*trace(invH);

% Update the alpha
par.alpha = g/(Weights'*Weights);

% Reformat the weights
[Wi,Wo] = nr_W2Wio(Weights,par.Ni,par.Nh);

% Update the beta
E_D = nr_cost(Wi,Wo,0,1,par.x,par.t);
par.beta = (N-g)/(2*E_D);
