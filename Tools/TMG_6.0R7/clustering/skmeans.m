function varargout=skmeans(varargin)
% SKMEANS - Spherical k-Means Clustering Algorithm 
%   SKMEANS clusters a term-document matrix using the Spherical 
%   k-means clustering algorithm [1]. CLUSTERS=SKMEANS(A, C, K, 
%   TERMINATION) returns a cluster structure with K clusters 
%   for the term-document matrix A using as initial centroids 
%   the columns of C (initialized randomly when it is empty). 
%   TERMINATION defines the termination method used in spherical 
%   k-means ('epsilon' stops iteration when objective function 
%   increase falls down a user defined threshold - see OPTIONS 
%   input argument - while 'n_iter' stops iteration when a user 
%   defined number of iterations has been reached). 
%   [CLUSTERS, Q]=SKMEANS(A, C, K, TERMINATION) returns also
%   the vector of objective function values for each iteration 
%   and [CLUSTERS, Q, C]=SKMEANS(A, C, K, TERMINATION) returns 
%   the final centroid vectors. 
%   SKMEANS(A, C, K, TERMINATION, OPTIONS) defines optional 
%   parameters: 
%       - OPTIONS.iter: Number of iterations (default 10).
%       - OPTIONS.epsilon: Value for epsilon convergence 
%         criterion (default 1).
%       - OPTIONS.dsp: Displays results (default 1) or not (0) 
%         to the command window.
%
%   REFERENCES: 
%   [1] I. S. Dhillon and D. M. Modha, "Concept Decompositions 
%   for Large Sparse Text Data using Clustering", Machine 
%   Learning, 42:1, pages 143-175, Jan, 2001.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(4, 5, nargin));
if nargin==4, 
    if nargout==1, varargout{1}=skmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
    if nargout==2, [varargout{1}, varargout{2}]=skmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=skmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}); end
else, 
    if nargout==1, varargout{1}=skmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}); end
    if nargout==2, [varargout{1}, varargout{2}]=skmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=skmeans_p(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5}); end
end