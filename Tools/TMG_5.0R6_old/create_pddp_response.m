function create_pddp_response(tree_struct, clusters, l, titles)
% CREATE_PDDP_RESPONSE returns an html response for PDDP 
%   CREATE_PDDP_RESPONSE(TREE_STRUCT, CLUSTERS, L, TITLES) 
%   creates a summary html file containing information for 
%   the result of the PDDP algorithm, defined by TREE_STRUCT 
%   and CLUSTERS, when applied to the dataset with document 
%   titles defined in the TITLES cell array. L defines the 
%   maximum number of principal directions used by PDDP. 
%   The result is stored in the "results" directory and 
%   displayed using the default web browser. 
%
% Copyright 2008 Dimitris Zeimpekis, Efstratios Gallopoulos

error(nargchk(4, 4, nargin));
create_pddp_response_p(tree_struct, clusters, l, titles);