function cost = nr_cost(Wi,Wo,alpha,beta,Inputs,Targets)

%NR_COST - Quadratic cost function with quadratic regularization term
% 
% cost = nr_cost(Wi,Wo,alpha,Inputs,Targets)
%
% Inputs:
%    Wi      :  Matrix with input-to-hidden weights
%    Wo      :  Matrix with hidden-to-outputs weights
%    alpha   :  Weight decay parameter
%    beta    :  Noise variance parameter
%    Inputs  :  Matrix with examples as rows
%    Targets :  Matrix with target values as rows
%
% Output:
%    cost    : Value of augmented quadratic cost function
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.

% Calculate network outputs for all examples
[Vj,yj] = nr_forward(Wi,Wo,Inputs);
     
% Calculate the deviations from desired outputs 
ej = Targets - yj;
     
% Calculate the sum of squared errors
cost = 0.5 * beta * sum(sum(ej .^ 2));

% Add the regularization term
cost = cost + 0.5 * alpha*(sum(sum(Wi.^2)) + sum(sum(Wo.^2)));