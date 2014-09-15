function Y = oneoutofk(y, C)
% ONEOUTOFK One-out-of-K coding
% Converts a class index vector to a one-out-of-K coding matrix
% 
% Usage: 
%   Y = oneoutofk(y, K)
% 
% Input:
%   y   Vector of class indices in (0,1,...,K-1)
%   K   Number of classes
%
% Output:
%   Y   N-by-K binary matrix
%
% Copyright 2011, Mikkel N. Schmidt, Technical University of Denmark

N = length(y);
Y = false(N, C);
for n = 1:N
    Y(n, y(n)+1) = true;
end
