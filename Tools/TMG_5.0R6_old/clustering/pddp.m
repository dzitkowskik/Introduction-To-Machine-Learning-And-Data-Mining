function varargout=pddp(varargin)
% PDDP - Principal Direction Divisive Partitioning Clustering 
% Algorithm 
%   PDDP clusters a term-document matrix (tdm) using the 
%   Principal Direction Divisive Partitioning clustering 
%   algorithm [1, 2]. 
%   CLUSTERS=PDDP(A, K, L) returns a cluster structure with 
%   K clusters for the tdm A formed using information from 
%   the first L principal components of the tdm. 
%   [CLUSTERS, TREE_STRUCT]=PDDP(A, K, L) returns also the 
%   full PDDP tree, while [CLUSTERS, TREE_STRUCT, S]=PDDP(A, 
%   K, L) returns the objective function of PDDP. 
%   PDDP(A, K, L, SVD_METHOD) defines the method used for the 
%   computation of the PCA (svds - default - or propack), while 
%   PDDP(A, K, L, SVD_METHOD, DSP) defines if results are to be 
%   displayed to the command window (default 1) or not (0). 
%
%   REFERENCES: 
%   [1] D.Boley, Principal Direction Divisive Partitioning, Data 
%   Mining and Knowledge Discovery 2 (1998), no. 4, 325-344.
%   [2] D.Zeimpekis, E.Gallopoulos, PDDP(l): Towards a Flexible 
%   Principal Direction Divisive Partitioning Clustering 
%   Algorithmm, Proc. IEEE ICDM'03 Workshop on Clustering Large 
%   Data Sets (Melbourne, Florida), 2003. 
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(3, 5, nargin));
if nargin==3, 
    if nargout==1, varargout{1}=pddp_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==2, [varargout{1}, varargout{2}]=pddp_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=pddp_p(varargin{1}, varargin{2}, varargin{3}); end
end
if nargin==4, 
    if nargout==1, varargout{1}=pddp_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
    if nargout==2, [varargout{1}, varargout{2}]=pddp_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=pddp_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
end
if nargin==5, 
    if nargout==1, varargout{1}=pddp_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}); end
    if nargout==2, [varargout{1}, varargout{2}]=pddp_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=pddp_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}); end
end