function varargout=scut_llsf(A, Q, clusters, labels_tr, labels_te, minf1, l, method, steps, svd_method, clsi_method)
% SCUT_LLSF - implements the Scut thresholding technique from [2] 
% for the Linear Least Squares Fit classifier [3]
%   THRESHOLD=SCUT_LLSF(A, Q, CLUSTERS, K, LABELS_TR, LABELS_TE, 
%   MINF1, L, METHOD, STEPS, SVD_METHOD, CLSI_METHOD) returns 
%   the vector of thresholds for the Linear Least Squares Fit 
%   classifier for the collection [A Q]. A and Q define the 
%   training and test parts of the validation set with labels 
%   LABELS_TR and LABELS_TE respectively. CLUSTERS is  a 
%   structure defining the classes, while MINF1 defines the 
%   minimum F1 value and STEPS defines the number of steps 
%   used during thresholding. 
%   METHOD is the method used for the approximation of the 
%   rank-l truncated SVD, with possible values:
%       - 'clsi': Clustered Latent Semantic Indexing [4].
%       - 'cm': Centroids Method [1].
%       - 'svd': Singular Value Decomosition.
%   SVD_METHOD defines the method used for the computation of 
%   the SVD, while CLSI_METHOD defines the method used for the 
%   determination of the number of factors from each class used 
%   in Clustered Latent Semantic Indexing in case METHOD equals 
%   'clsi'. 
%   [THRESHOLD, F, THRESHOLDS]=SCUT_LLSF(A, Q, CLUSTERS, K, 
%   LABELS_TR, LABELS_TE, MINF1, L, METHOD, STEPS, SVD_METHOD, 
%   CLSI_METHOD) returns also the best F1 value as well as the 
%   matrix of thresholds for each step (row i corresponds to 
%   step i).
%
%   REFERENCES:
%   [1] H. Park, M. Jeon, and J. Rosen. Lower Dimensional 
%   Representation of Text Data Based on Centroids and Least 
%   Squares. BIT Numerical Mathematics, 43(2):427–448, 2003.
%   [2] Y. Yang. A Study of Thresholding Strategies for Text 
%   Categorization. In Proc. 24th ACM SIGIR, pages 137–145, 
%   New York, NY, USA, 2001. ACM Press.
%   [3] Y. Yang and C. Chute. A Linear Least Squares Fit 
%   Mapping Method for Information Retrieval from Natural 
%   Language Texts. In Proc. 14th Conference on Computational 
%   Linguistics, pages 447–453, Morristown, NJ, USA, 1992. 
%   [4] D. Zeimpekis and E. Gallopoulos, "Non-Linear Dimensional 
%   Reduction via Class Representatives for Text Classification".  
%   In Proc. 2006 IEEE International Conference on Data Mining 
%   (ICDM'06), Hong Kong, Dec. 2006.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(11, 11, nargin));
if nargout==1, varargout{1}=scut_llsf_p(A, Q, clusters, labels_tr, labels_te, minf1, l, method, steps, svd_method, clsi_method); end
if nargout==2, [varargout{1}, varargout{2}]=scut_llsf_p(A, Q, clusters, labels_tr, labels_te, minf1, l, method, steps, svd_method, clsi_method); end
if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=scut_llsf_p(A, Q, clusters, labels_tr, labels_te, minf1, l, method, steps, svd_method, clsi_method); end