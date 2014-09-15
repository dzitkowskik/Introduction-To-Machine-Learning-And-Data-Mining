function [Wi,Wo] = nr_W2Wio(Weights,Ni,Nh)

%NR_W2WIO - Change the weight format from vector to 2xMatrices
%
% [Wi,Wo] = nr_W2Wio(Weights,Ni,Nh)
%
% Inputs:
%   Weights : The weight vector
%   Ni      : Number of inputs
%   Nh      : Number of hidden units
%
% Outputs:
%    Wi     : Matrix with input-to-hidden weights
%    Wo     : Matrix with hidden-to-outputs weights
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.

Wi = reshape(Weights(1:(Ni+1)*Nh),Nh,Ni+1);
Wo = reshape(Weights((Ni+1)*Nh+1:end),1,Nh+1);
