function clusters=make_clusters_multi(labels)
% MAKE_CLUSTERS_MULTI - auxiliary function for the classification 
% algorithms
%   CLUSTERS=MAKE_CLUSTERS_MULTI(LABELS) forms the cluster 
%   structure of a multi-label collection with document 
%   classes defined by LABELS (cell array of vectors of 
%   integers).
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(1, 1, nargin));
clusters=make_clusters_multi_p(labels);