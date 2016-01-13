function [x,x_test,mean_x,std_x] = nc_normalize_data(x,x_test);

%NC_NORMALIZE_DATA - Normalize the input patterns 
%                    to have mean zero and variance one
%
% [x,x_test,mean_x,std_x] = nc_normalize_data(x,x_test)
% 
% Inputs:
%    x       : The input training patterns
%    x_test  : The input test patterns
%
% Outputs:
%    x       : The normalized input training patterns
%    x_test  : The normalized input test patterns
%    x_mean  : The mean that was subtracted
%    x_std   : The standard deviation for scaling
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Determine the number of examples and dimension
[Ntest,D] = size(x_test);
[N,D] = size(x);

% Compute the standard deviation and mean
std_x = std(x,0,1);
mean_x = mean(x,1);

% Normalize the training input data
x = (x-repmat(mean_x,N,1))./repmat(std_x,N,1);

% Normalize the test input data
x_test = (x_test-repmat(mean_x,Ntest,1))./repmat(std_x,Ntest,1);