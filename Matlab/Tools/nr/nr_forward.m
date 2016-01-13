function [Vj,yj] = nr_forward(Wi,Wo,Inputs)

%NR_FORWARD - Propagate example forward through the network
%
% [Vj,yj] = nr_forward(Wi,Wo,Inputs)
%
% Input:
%    Wi     : Matrix with input-to-hidden weights
%    Wo     : Matrix with hidden-to-outputs weights
%    Inputs : Matrix with example inputs as rows
%
% Output:
%    Vj     : Matrix with hidden unit outputs as rows
%    yj     : Vector with output unit outputs as rows
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.

% Determine the size of the problem
[examples inp] = size(Inputs);  

% Calculate hidden unit outputs for every example
Vj = tanh([Inputs ones(examples,1) ] * Wi');
  
% Calculate (linear) output unit outputs for every example
yj = [Vj ones(examples,1)] * Wo';