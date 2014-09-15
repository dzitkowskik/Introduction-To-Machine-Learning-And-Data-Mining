function create_kmeans_response(varargin)
% CREATE_KMEANS_RESPONSE returns an html response for k-means 
%   CREATE_KMEANS_RESPONSE(CLUSTERS, TITLES) creates a summary 
%   html file containing information for the result of the 
%   k-means algorithm, defined by CLUSTERS, when applied to 
%   the dataset with document titles defined in the TITLES 
%   cell array. 
%   CREATE_KMEANS_RESPONSE(CLUSTERS, TITLES, VARIANT) defines 
%   additionaly the k-means variant (possible values 'k-means' 
%   and 'skmeans'). The result is stored in the "results" 
%   directory and displayed using the default web browser. 
%
% Copyright 2008 Dimitris Zeimpekis, Efstratios Gallopoulos

error(nargchk(2, 3, nargin));
if nargin==2, create_kmeans_response_p(varargin{1}, varargin{2}); else, create_kmeans_response_p(varargin{1}, varargin{2}, varargin{3}); end