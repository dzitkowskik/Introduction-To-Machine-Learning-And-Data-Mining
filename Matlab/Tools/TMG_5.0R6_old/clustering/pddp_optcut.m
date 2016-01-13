function varargout=pddp_optcut(varargin)
% PDDP_OPTCUT - Hybrid Principal Direction Divisive 
% Partitioning Clustering Algorithm and k-means
%   PDDP_OPTCUT clusters a term-document matrix (tdm) using 
%   a combination of the Principal Direction Divisive 
%   Partitioning clustering algorithm [1] and k-means [2]. 
%   CLUSTERS=PDDP_OPTCUT(A, K) returns a cluster structure 
%   with K clusters for the tdm A. 
%   [CLUSTERS, TREE_STRUCT]=PDDP_OPTCUT(A, K) returns also the 
%   full PDDP tree, while [CLUSTERS, TREE_STRUCT, S]=PDDP_OPTCUT(A, 
%   K) returns the objective function of PDDP. 
%   PDDP_OPTCUT(A, K, SVD_METHOD) defines the method used for the 
%   computation of the PCA (svds - default - or propack). 
%   PDDP_OPTCUT(A, K, SVD_METHOD, DSP) defines if results are to be 
%   displayed to the command window (default 1) or not (0). Finally, 
%   PDDP_OPTCUT(A, K, SVD_METHOD, DSP, EPSILON) defines the 
%   termination criterion value for the k-means algorithm. 
%
%   REFERENCES: 
%   [1] D.Boley, Principal Direction Divisive Partitioning, Data 
%   Mining and Knowledge Discovery 2 (1998), no. 4, 325-344.
%   [2] D.Zeimpekis, E.Gallopoulos, k-means Steering of Spectral 
%   Divisive Clustering Algorithms, Proc. of Text Mining Workshop, 
%   Minneapolis, 2007.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(2, 4, nargin));
if nargin==2, 
    if nargout==1, varargout{1}=pddp_optcut_p(varargin{1}, varargin{2}); end
    if nargout==2, [varargout{1}, varargout{2}]=pddp_optcut_p(varargin{1}, varargin{2}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=pddp_optcut_p(varargin{1}, varargin{2}); end
end
if nargin==3, 
    if nargout==1, varargout{1}=pddp_optcut_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==2, [varargout{1}, varargout{2}]=pddp_optcut_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=pddp_optcut_p(varargin{1}, varargin{2}, varargin{3}); end
end
if nargin==4, 
    if nargout==1, varargout{1}=pddp_optcut_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
    if nargout==2, [varargout{1}, varargout{2}]=pddp_optcut_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=pddp_optcut_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
end