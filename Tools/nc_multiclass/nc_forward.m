function [Vj,phi] = nc_forward(Wi,Wo,Inputs)

%NC_FORWARD - Propagate examples forward through network
%             without the softmax
%
% [Vj,phi] = nc_forward(Wi,Wo,Inputs)
%
% Input:
%    Wi     : Matrix with input-to-hidden weights
%    Wo     : Matrix with hidden-to-outputs weights
%    Inputs : Matrix with example inputs as rows
%
% Output:
%    Vj     : Matrix with hidden unit outputs as rows
%    phi    : Matrix with output unit outputs as rows
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Determine the size of the problem
[examples inp] = size(Inputs);  

% Calculate hidden unit outputs for every example
Vj = tanh([Inputs ones(examples,1) ] * Wi');
  
% Calculate (linear) output unit outputs for every example
phi = [Vj ones(examples,1)] * Wo';
