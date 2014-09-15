function clusters=make_clusters_single(labels)
% MAKE_CLUSTERS_SINGLE - auxiliary function for the classification 
% algorithms
%   CLUSTERS=MAKE_CLUSTERS_SINGLE(LABELS) forms the cluster 
%   structure of a single-label collection with document classes 
%   defined by LABELS (vector of integers).
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(1, 1, nargin));
clusters=make_clusters_single_p(labels);