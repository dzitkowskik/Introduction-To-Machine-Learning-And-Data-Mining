function varargout=two_means_1d(A)
% TWO_MEANS_1D - returns the clustering that optimizes the 
% objective function of the k-means algorithm for the input 
% vector.
%   [CUTOFF, CLUSTERS, DISTANCE, OF, MEAN1, MEAN2]=
%   TWO_MEANS_1D(A) returns the cutoff value of the clustering, 
%   the cluster structure, the separation distance, the value 
%   of the objective function and the two mean values.  
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(1, 1, nargin));
if nargout==1, varargout{1}=two_means_1d_p(A); end
if nargout==2, [varargout{1}, varargout{3}]=two_means_1d_p(A); end
if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=two_means_1d_p(A); end
if nargout==4, [varargout{1}, varargout{2}, varargout{3}, varargout{4}]=two_means_1d_p(A); end
if nargout==5, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}]=two_means_1d_p(A); end
if nargout==6, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}]=two_means_1d_p(A); end