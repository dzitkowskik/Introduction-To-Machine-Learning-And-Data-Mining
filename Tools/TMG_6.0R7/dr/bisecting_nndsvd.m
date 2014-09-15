function varargout=bisecting_nndsvd(varargin)
% BISECTING_NNDSVD - a bisecting form of the the Non-Negative Double
% Singular Value Decomposition Method [2]. 
%   BISECTING_NNDSVD applies a bisecting form of the the 
%   Non-Negative Double Singular Value Decomposition Method [2] 
%   using a PDDP-like [2] clustering Method. 
%   [W, H]=BISECTING_NNDSVD(A, k, svd_method) returns a non-negative 
%   rank-k approximation of the input matrix A using svd_method for 
%   the SVD (possible values svds, propack).
%
%   REFERENCES: 
%   [1] D.Boley, Principal Direction Divisive Partitioning, Data 
%   Mining and Knowledge Discovery 2 (1998), no. 4, 325-344.
%   [2] C. Boutsidis and E. Gallopoulos. SVD-based initialization: 
%   A head start on nonnegative matrix factorization.  Pattern 
%   Recognition, Volume 41, Issue 4, Pages 1350-1362, April 2008.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

% Check input
error(nargchk(2, 3, nargin));
if nargin==2, 
    if nargout==1, varargout{1}=bisecting_nndsvd_p(varargin{1}, varargin{2}); end
    if nargout==2, [varargout{1}, varargout{2}]=bisecting_nndsvd_p(varargin{1}, varargin{2}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=bisecting_nndsvd_p(varargin{1}, varargin{2}); end
else, 
    if nargout==1, varargout{1}=bisecting_nndsvd_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==2, [varargout{1}, varargout{2}]=bisecting_nndsvd_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=bisecting_nndsvd_p(varargin{1}, varargin{2}, varargin{3}); end
end