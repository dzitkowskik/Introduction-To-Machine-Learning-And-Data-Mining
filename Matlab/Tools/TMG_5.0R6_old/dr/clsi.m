function varargout=clsi(A, clusters, l, func, alpha_val, svd_method)
% CLSI - computes a rank-L approximation of the input matrix 
% using the Clustered Latent Semantic Indexing Method [1]
%   [X, Y]=CLSI(A, CLUSTERS, L, FUNC, ALPHA_VAL, SVD_METHOD) 
%   computes the rank-L approximation X*Y of the input matrix 
%   A with the Clustered Latent Semantic Indexing Method [1], 
%   using the cluster structure information from CLUSTERS.
%   FUNC denotes the method used for the selection of the 
%   number of factors from each cluster. Possible values for 
%   FUNC:
%       - 'f': Selection using a heuristic method from [1] 
%         (see KS_SELECTION). 
%       - 'f1': Same as 'f' but use at least one factor 
%         from each cluster. 
%       - 'equal': Use the same number of factors from 
%         each cluster. 
%   ALPHA_VAL is a value in [0, 1] used in the number of 
%   factors selection heuristic [1]. Finally, SVD_METHOD 
%   defines the method used for the computation of the SVD 
%   (svds or propack).
%
%   REFERENCES: 
%   [1] D. Zeimpekis and E. Gallopoulos. CLSI: A Flexible 
%   Approximation Scheme from Clustered Term-Document Matrices. 
%   In Proc. 5th SIAM International Conference on Data Mining, 
%   pages 631–635, Newport Beach, California, 2005.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(6, 6, nargin));
if nargout==1, varargout{1}=clsi_p(A, clusters, l, func, alpha_val, svd_method); end
if nargout==2, [varargout{1}, varargout{2}]=clsi_p(A, clusters, l, func, alpha_val, svd_method); end
if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=clsi_p(A, clusters, l, func, alpha_val, svd_method); end
if nargout==4, [varargout{1}, varargout{2}, varargout{3}, varargout{4}]=clsi_p(A, clusters, l, func, alpha_val, svd_method); end
if nargout==5, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}]=clsi_p(A, clusters, l, func, alpha_val, svd_method); end