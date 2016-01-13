function [U, S, V]=pca_propack(A, c, k)
% PCA_PROPACK - Principal Component Analysis with PROPACK
%   [U, S, V]=PCA_PROPACK(A, C, K) computes the K-factor 
%   Principal Component Analysis of A, i.e. SVD of 
%   A-C*ones(size(A, 2), 1), using the PROPACK package [1].
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
[U, S, V]=pca_propack_p(A, c, k);