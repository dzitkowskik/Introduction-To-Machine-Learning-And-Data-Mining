function [Wi,Wo] = nc_W2Wio(W,Ni,Nh,No)

%NC_W2WIO - Change the weight format from vector to 2xMatrices
%
% [Wi,Wo] = nr_W2Wio(Weights,Ni,Nh,No)
%
% Inputs:
%    Weights : The weight vector
%    Ni      : Number of inputs
%    Nh      : Number of hidden units
%    No      : Number of outputs
%
% Outputs:
%    Wi      : Matrix with input-to-hidden weights
%    Wo      : Matrix with hidden-to-outputs weights
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.

Wi = reshape(W(1:(Ni+1)*Nh),Nh,Ni+1);
Wo = reshape(W((Ni+1)*Nh+1:end),No,Nh+1);
