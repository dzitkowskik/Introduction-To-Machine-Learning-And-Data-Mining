function [density, log_density]=gausKernelDensity(X,width)

% function to calculate efficiently leave-one-out Gaussian Kernel Density estimate
% Input: 
%   X        N x M data matrix
%   width    variance of the Gaussian kernel
%
% Output: 
%  density        vector of estimated densities
%  log_density    vector of estimated log_densities
%
% Written by Morten Mørup

[N,M]=size(X);

% Calculate squared euclidean distance between data points
% given by ||x_i-x_j||_F^2=||x_i||_F^2-2x_i^Tx_j+||x_i||_F^2 efficiently
x2=sum(X.^2,2);
D=x2(:,ones(1,N))-2*(X*X')+x2(:,ones(1,N))';

% Evaluate densities to each observation
Q=exp(-1/(2*width)*D);
% do not take density generated from the data point itself into account
Q=Q-diag(diag(Q));

sQ=sum(Q,2);
density=1/((N-1)*sqrt(2*pi*width)^M)*sQ;
log_density=-log(N-1)-M/2*log(2*pi*width)+log(sQ);