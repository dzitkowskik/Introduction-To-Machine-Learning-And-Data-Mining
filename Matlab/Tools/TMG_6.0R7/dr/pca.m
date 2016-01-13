function [U, S, V]=pca(A, c, k, method)
% PCA - Principal Component Analysis
%   [U, S, V]=PCA(A, C, K, METHOD) computes the K-factor 
%   Principal Component Analysis of A, i.e. SVD of 
%   A-C*ones(size(A, 2), 1), using either the svds function 
%   of MATLAB or the PROPACK package [1].
%
%   REFERENCES: 
%   [1] R.M.Larsen, PROPACK: A Software Package for the 
%   Symmetric Eigenvalue Problem and Singular Value Problems 
%   on Lanczos and Lanczos Bidiagonalization 
%   with Partial Reorthogonalization, Stanford University, 
%   http://sun.stanford.edu/~rmunk/PROPACK.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(4, 4, nargin));
[U, S, V]=pca_p(A, c, k, method);