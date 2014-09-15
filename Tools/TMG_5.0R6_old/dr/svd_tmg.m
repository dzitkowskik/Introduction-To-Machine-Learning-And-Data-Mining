function [U, S, V]=svd_tmg(A, k, method)
% SVD_TMG - Singular Value Decomposition
%   [U, S, V]=SVD_TMG(A, K, METHOD) computes the K-factor 
%   truncated Singular Value Decomposition of A using either 
%   the svds function of MATLAB or the PROPACK package [1].
%
%   REFERENCES: 
%   [1] R.M.Larsen, PROPACK: A Software Package for the 
%   Symmetric Eigenvalue Problem and Singular Value Problems 
%   on Lanczos and Lanczos Bidiagonalization 
%   with Partial Reorthogonalization, Stanford University, 
%   http://sun.stanford.edu/~rmunk/PROPACK.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(3, 3, nargin));
[U, S, V]=svd_tmg_p(A, k, method);