function [U, S, V]=svd_update(A, X, Y, k)
% SVD_UPDATE - Singular Value Decomposition of a 
% rank-l update matrix with MATLAB (eigs)
%   [U, S, V]=SVD_UPDATE(A, X, Y, K) computes the 
%   K-factor SVD of A-X*Y, using the eigs function of MATLAB.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(4, 4, nargin));
[U, S, V]=svd_update_p(A, X, Y, k);