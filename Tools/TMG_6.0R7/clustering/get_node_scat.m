function varargout=get_node_scat(tree_struct, splitted)
% GET_NODE_SCAT - returns the PDDP node with the maximum scatter 
% value (see PDDP)
%   [MAX_SCAT_IND, M_SCAT]=GET_NODE_SCAT(TREE_STRUCT, SPLITTED) 
%   returns the node index and the scatter value of the PDDP 
%   tree defined by TREE_STRUCT. SPLITTED is a vector that 
%   determines the active nodes. 
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));
if nargout==1, varargout{1}=get_node_scat_p(tree_struct, splitted); else, [varargout{1}, varargout{2}]=get_node_scat_p(tree_struct, splitted); end