function [Wi,Wo] = nr_winit(Ni,Nh)

%NR_WINIT - Initialize weights in the network with 
%           a uniform distribution
%
% [Wi,Wo] = NR_WINIT(Ni,Nh)
%
% Input:
%    Ni : Number of input neurons
%    Nh : Number of hidden neurons
%
% Output:
%    Wi : Input-to-hidden initial weights
%    Wo : Hidden-to-output initial weights       
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.
  
Wi = randn(Nh,Ni+1)/sqrt(Ni);
Wo = randn(1,Nh+1)/sqrt(Ni);
