function [A, n_rows, n_cols, row_inds, col_inds]=block_diagonalize(A, clusters)
% BLOCK_DIAGONALIZE - reorders a matrix heuristically using a 
% clustering result
%   [A, N_ROWS, N_COLS, ROW_INDS, COL_INDS]=BLOCK_DIAGONALIZE(A, 
%   CLUSTERS) reorders matrix A using the clustering result 
%   represented by the structure CLUSTERS. N_ROWS and N_COLS 
%   store the last row and column index for each row and column 
%   block resprectively, while ROW_INDS and COL_INDS contain the 
%   permuted row and column indices.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));
[A, n_rows, n_cols, row_inds, col_inds]=block_diagonalize_p(A, clusters);