function labels_as=knn_single(A, Q, k, labels, normalize_docs)
% KNN_SINGLE - k-Nearest Neighboors classifier for single-label 
% collections
%   LABELS_AS=KNN_SINGLE(A, Q, K, LABELS, NORMALIZED_DOCS) 
%   classifies the columns of Q with the K-Nearest Neighboors 
%   classifier using the pre-classified columns of matrix A 
%   with labels LABELS (vector of integers). NORMALIZED_DOCS 
%   defines if cosine (1) or euclidean distance (0) similarity 
%   measure is to be used. LABELS_AS contains the assigned 
%   labels for the columns of Q. 
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(5, 5, nargin));
labels_as=knn_single_p(A, Q, k, labels, normalize_docs);