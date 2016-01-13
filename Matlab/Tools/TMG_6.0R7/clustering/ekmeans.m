function varargout=ekmeans(varargin)
% EKMEANS - Euclidean k-Means Clustering Algorithm 
%   EKMEANS clusters a term-document matrix using the standard 
%   k-means clustering algorithm. CLUSTERS=EKMEANS(A, C, K, 
%   TERMINATION) returns a cluster structure with K clusters 
%   for the term-document matrix A using as initial centroids 
%   the columns of C (initialized randomly when it is empty). 
%   TERMINATION defines the termination method used in k-means 
%   ('epsilon' stops iteration when objective function decrease 
%   falls down a user defined threshold - see OPTIONS input 
%   argument - while 'n_iter' stops iteration when a user 
%   defined number of iterations has been reached). 
%   [CLUSTERS, Q]=EKMEANS(A, C, K, TERMINATION) returns also
%   the vector of objective function values for each iteration 
%   and [CLUSTERS, Q, C]=EKMEANS(A, C, K, TERMINATION) returns 
%   the final centroid vectors. 
%   EKMEANS(A, C, K, TERMINATION, OPTIONS) defines optional 
%   parameters: 
%       - OPTIONS.iter: Number of iterations (default 10).
%       - OPTIONS.epsilon: Value for epsilon convergence 
%         criterion (default 1).
%       - OPTIONS.dsp: Displays results (default 1) or 
%         not (0) to the command window.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(4, 5, nargin));
if nargin==4, 
    if nargout==1, varargout{1}=ekmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
    if nargout==2, [varargout{1}, varargout{2}]=ekmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=ekmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
else, 
    if nargout==1, varargout{1}=ekmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}); end
    if nargout==2, [varargout{1}, varargout{2}]=ekmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=ekmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}); end
end