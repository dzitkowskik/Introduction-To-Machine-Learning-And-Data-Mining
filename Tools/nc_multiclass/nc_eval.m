function y = nc_eval(netwrk, x)

%NR_EVAL - Compute output of neural network
%
% y = nr_eval(netwrk, x)
%
% Input:
%    netwrk : Neural network, struct variable returned from nr_main
%    x      : Matrix with example inputs as rows
%
% Output:
%    y      : Vector with output unit outputs as rows
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.
% Mikkel N. Schmidt and Morten Mørup 2011, Tehcnical Unviersit of Denmark

% Determine the number of examples and dimension
[N,D] = size(x);

% Normalize the training input data
x = (x-repmat(netwrk.mean_x,N,1))./repmat(netwrk.std_x,N,1);

% Forward
[dummy, y] = nc_forward(netwrk.Wi, netwrk.Wo, x);
y=nc_softmax(y);