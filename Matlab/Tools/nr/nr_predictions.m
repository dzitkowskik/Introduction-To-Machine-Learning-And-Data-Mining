function [t_pred,var_pred] = nr_predictions(Wi,Wo,par,x_test)

%NR_PREDICTIONS - Make predictions and estimate variance of the predictions
%
% [t_pred,t_var] = nr_predictions(Wi,Wo,par,Inputs)
%
% Inputs:
%   Wi     : Matrix with input-to-hidden weights
%   Wo     : Matrix with hidden-to-outputs weights
%   par    : Struct variable with other parameters
%   Inputs : Matrix with examples as rows
%
% Output:
%   t_pred : Target predictions from Inputs
%   t_var  : Variance of the predictions
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.

% Make the weight vector
Weights = [Wi(:);Wo(:)];

% Compute the inverse Hessian
invH = nr_gnhessian(Weights,par);

% Make predicions with the network
[dummy,t_pred] = nr_forward(Wi,Wo,x_test);

% Compute the Jacobian of the network
J = nr_gradnet(Wi,Wo,x_test);

% Compute errorbars on the prediction
var_pred = 1/par.beta + diag(J'*invH*J);