function C = pddp_extract_centroids(tree_struct, m, k)
% PDDP_EXTRACT_CENTROIDS - returns the cluster centroids of a 
% PDDP clustering result
% 
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(3, 3, nargin));
C = pddp_extract_centroids_p(tree_struct, m, k);