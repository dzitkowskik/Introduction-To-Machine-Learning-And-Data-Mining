function [Wi,Wo] = nc_winit(Ni,Nh,No)

%NC_WINIT - Initialize weights in the network with 
%           a Gaussian distribution N(0,1/alpha)
%
% [Wi,Wo] = NR_WINIT(Ni,Nh,No)
%
% Input:
%    Ni    : Number of input neurons
%    Nh    : Number of hidden neurons
%    No    : Number of output neurons
%
% Output:
%    Wi    : Input-to-hidden initial weights
%    Wo    : Hidden-to-output initial weights
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.
  
Wi = randn(Nh,Ni+1)/sqrt(Ni);
Wo = randn(No,Nh+1)/sqrt(Ni);
