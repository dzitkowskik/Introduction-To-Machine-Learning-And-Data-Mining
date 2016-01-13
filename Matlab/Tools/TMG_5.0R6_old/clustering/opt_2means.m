function [clusters, s]=opt_2means(A, x)
% OPT_2MEANS - a special case of k-means for k=2
%   OPT_2MEANS(A, X) returns the clustering that optimizes the 
%   objective function of the k-means algorithm based on the 
%   ordering of vector X.
%   [CLUSTERS, S]=OPT_2MEANS(A, X) returns the cluster 
%   structure as well as the value of the objective function. 
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));
[clusters, s]=opt_2means_p(A, x);