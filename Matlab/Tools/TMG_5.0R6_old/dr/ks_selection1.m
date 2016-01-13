function n_st=ks_selection1(A, n_cols, alpha_val, l)
% KS_SELECTION1 - implements the heuristic method from [2] for 
% the selection of the number of factors from each cluster used 
% in the Clustered Latent Semantic Indexing method [1]. The 
% number of factors from each cluster is at least 1. 
%   N_ST=KS_SELECTION1(A, N_COLS, ALPHA_VAL, L) returns in N_ST 
%   a vector of integers denoting the number of factors 
%   (sum equals L) selected from each cluster of the tdm A. 
%   N_COLS is a vector containing the last column index for 
%   each column block, while ALPHA_VAL is a value in [0, 1]. 
%
%   REFERENCES: 
%   [1] D. Zeimpekis and E. Gallopoulos. CLSI: A Flexible 
%   Approximation Scheme from Clustered Term-Document Matrices. 
%   In Proc. 5th SIAM International Conference on Data Mining, 
%   pages 631–635, Newport Beach, California, 2005.
%   [2] D. Zeimpekis and E. Gallopoulos, "Linear and Non-Linear 
%   Dimensional Reduction via Class Representatives for Text 
%   Classification", In Proc. of the 2006 IEEE International 
%   Conference on Data Mining, pp. 1172-1177, December 2006, 
%   Hong Kong. 
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(4, 4, nargin));
n_st=ks_selection1_p(A, n_cols, alpha_val, l);