function varargout=block_nndsvd(A, clusters, l, func, alpha_val, svd_method)
% BLOCK_NNDSVD - computes a non-negative rank-L approximation 
% of the input matrix using the Clustered Latent Semantic 
% Indexing Method [2] and the Non-Negative Double Singular 
% Value Decomposition Method [1].
%   [X, Y]=BLOCK_NNDSVD(A, CLUSTERS, L, FUNC, ALPHA_VAL, 
%   SVD_METHOD) computes a non-negative rank-L approximation 
%   X*Y of the input matrix A with the Clustered Latent 
%   Semantic Indexing Method [2], and the Non-Negative Double 
%   Singular Value Decomposition Method [1], 
%   using the cluster structure information from CLUSTERS [3].
%   FUNC denotes the method used for the selection of the 
%   number of factors from each cluster. Possible values for 
%   FUNC:
%       - 'f': Selection using a heuristic method from [2] 
%         (see KS_SELECTION). 
%       - 'f1': Same as 'f' but use at least one factor 
%         from each cluster. 
%       - 'equal': Use the same number of factors from 
%         each cluster. 
%   ALPHA_VAL is a value in [0, 1] used in the number of 
%   factors selection heuristic [2]. Finally, SVD_METHOD 
%   defines the method used for the computation of the SVD 
%   (svds or propack).
%
%   REFERENCES: 
%   [1] C. Boutsidis and E. Gallopoulos. SVD-based 
%   initialization: A head start on nonnegative matrix 
%   factorization.  Pattern Recognition, Volume 41, 
%   Issue 4, Pages 1350-1362, April 2008.
%   [2] D. Zeimpekis and E. Gallopoulos. CLSI: A Flexible 
%   Approximation Scheme from Clustered Term-Document 
%   Matrices. In Proc. 5th SIAM International Conference 
%   on Data Mining, pages 631–635, Newport Beach, California, 
%   2005.
%   [3] D. Zeimpekis and E. Gallopoulos. Document Clustering 
%   using NMF based on Spectral Information. In Proc. Text Mining 
%   Workshop 2008 held in conjunction with the 8th SIAM 
%   International Conference on Data Mining, Atlanta, 2008. 
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(6, 6, nargin));
if nargout==1, varargout{1}=block_nndsvd_p(A, clusters, l, func, alpha_val, svd_method); end
if nargout==2, [varargout{1}, varargout{2}]=block_nndsvd_p(A, clusters, l, func, alpha_val, svd_method); end
if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=block_nndsvd_p(A, clusters, l, func, alpha_val, svd_method); end