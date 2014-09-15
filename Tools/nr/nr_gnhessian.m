function invH = nr_gnhessian(Weights,par)

%NR_GNHESSIAN - Compute the inverse Gauss-Newton Hessian matrix
%
% invH = nr_gnhessian(Weights,par)
%
% Inputs:
%    Weights : The weight vector
%    par     : Struct varible with other network parameters
%
% Output:
%    invH    : The inverse Gauss-Newton Hessian matrix
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.

% Reformat the weights
[Wi,Wo] = nr_W2Wio(Weights,par.Ni,par.Nh);

% Determine the number of examples and weights
N = length(par.t);
W = length(Weights);

% Compute the Jacobian
J = nr_gradnet(Wi,Wo,par.x);

% Evaluate the inverse Hessian
invH = inv(par.beta*J*J'+par.alpha*eye(W));