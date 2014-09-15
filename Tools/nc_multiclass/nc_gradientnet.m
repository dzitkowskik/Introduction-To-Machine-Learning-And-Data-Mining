function [grad_Wi,grad_Wo] = nc_gradientnet(Wi,Wo,Inputs,Targets)

% NC_GRADIENTNET - Partial derivative of outputs 
%                  w.r.t. weights for all examples (Jacobian)
%
% [grad_Wi,grad_Wo] = nc_gradientnet(Wi,Wo,Inputs,Targets)
%
% Input:
%    Wi      : Matrix with input-to-hidden weights
%    Wo      : Matrix with hidden-to-outputs weights
%    Inputs  : Matrix with examples as rows
%    Targets : Matrix with target values as rows
%
% Outputs:
%    grad_Wi : Matrix with gradient for input weights
%    grad_Wo : Matrix with gradient for output weights
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Determine the number of examples
[exam inp] = size(Inputs);
 
% Calculate hidden and output unit activations
[Vj,yj] = nc_forward(Wi,Wo,Inputs);
    
% Compute the gradient of the net for each example and each output
hidden_part = repmat((1.0-Vj.^2),1,size(Wi,2));
input_part = (kron([Inputs ones(exam,1)],ones(1,size(Wi,1))));
dWo = [Vj ones(exam,1)];
for i = 1:size(Wo,1)

  % The gradient for input-to-hidden weights
  output_part = repmat(Wo(i,1:end-1),exam,size(Wi,2));
  grad_Wi(:,:,i) = hidden_part.*input_part.*output_part;

  % The gradient for hidden-to-output weights
  index_Wo = i:size(Wo,1):length(Wo(:));
  grad_Wo(:,index_Wo,i) = dWo;  

end