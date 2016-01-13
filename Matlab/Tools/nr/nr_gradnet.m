function J = nr_gradnet(Wi,Wo,Inputs)

%NR_GRADNET - Calculate the Jacobian matrix for the network 
%
% J = nr_gradnet(Wi,Wo,Inputs) 
%
% Inputs:
%   Wi     : Matrix with input-to-hidden weights
%   Wo     : Matrix with hidden-to-outputs weights
%   Inputs : Matrix with examples as rows
%
% Output:
%   J      : The Jacobian with weights as rows
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.

% Determine the number of examples, hidden units and inputs
N = size(Inputs,1);
[Nh,Ni] = size(Wi);

% Calculate hidden and output unit activations
[Vj,yj] = nr_forward(Wi,Wo,Inputs);
      
% Partial derivatives for the output weights
dWo = [Vj ones(N,1)]';

% Partial derivatives for the input weights
dWi = (kron([Inputs ones(N,1)]',ones(Nh,1))).* ... 
      (repmat((1-Vj.^2)'.*repmat(Wo(:,1:end-1)',1,N),Ni,1));

% Make the Jacobian matrix
J = [dWi;dWo];
