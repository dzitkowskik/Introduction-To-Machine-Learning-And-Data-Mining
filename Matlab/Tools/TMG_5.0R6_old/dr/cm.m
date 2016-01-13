function [X, Y]=cm(A, clusters)
% CM - computes a rank-L approximation of the input matrix 
% using the Centroids Method [1]
%   [X, Y]=CM(A, CLUSTERS) computes the rank-K approximation 
%   X*Y of the input matrix A with the Centroids Method [1], 
%   using the cluster structure information from CLUSTERS.
%
%   REFERENCES: 
%   [1] H. Park, M. Jeon, and J. Rosen. Lower Dimensional Representation
%   of Text Data Based on Centroids and Least Squares.
%   BIT Numerical Mathematics, 43(2):427–448, 2003.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));
[X, Y]=cm_p(A, clusters);