function [A, n_cols, col_inds]=col_rearrange(A, clusters)
% COL_REARRANGE - reorders a matrix using a clustering result
%   [A, N_COLS, COL_INDS]=COL_REARRANGE(A, CLUSTERS) reorders 
%   the columns of matrix A using the clustering result represented 
%   by the structure CLUSTERS. N_COLS stores the last column index 
%   for each column block, while COL_INDS containes the permuted 
%   column indices.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));
[A, n_cols, col_inds]=col_rearrange_p(A, clusters);