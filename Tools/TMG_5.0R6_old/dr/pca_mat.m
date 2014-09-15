function [U, S, V]=pca_mat(A, c, k)
% PCA_MAT - Principal Component Analysis with MATLAB (svds)
%   [U, S, V]=PCA_MAT(A, C, K) computes the K-factor Principal 
%   Component Analysis of A, i.e. SVD of A-C*ones(size(A, 2), 
%   1), using the svds function of MATLAB.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(3, 3, nargin));
[U, S, V]=pca_mat_p(A, c, k);