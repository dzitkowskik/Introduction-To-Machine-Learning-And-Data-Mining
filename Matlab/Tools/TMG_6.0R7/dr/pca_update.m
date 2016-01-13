function [U, S, V]=pca_update(A, W, H, c, k)
% PCA_UPDATE - Principal Component Analysis of a rank-l 
% updated matrix with MATLAB (eigs)
%   [U, S, V]=PCA_UPDATE(A, W, H, C, K) computes the K-factor 
%   Principal Component Analysis of A - W * H, i.e. SVD of 
%   (A - W * H) - C * ones(size(A, 2), 1), using the svds 
%   function of MATLAB.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(5, 5, nargin));
[U, S, V]=pca_update_p(A, W, H, c, k);