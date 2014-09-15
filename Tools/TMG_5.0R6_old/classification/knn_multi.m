function labels_as=knn_multi(A, Q, k, labels, normalize_docs, thresholds)
% KNN_MULTI - k-Nearest Neighboors classifier for multi-label 
% collections
%   LABELS_AS=KNN_MULTI(A, Q, K, LABELS, NORMALIZED_DOCS, 
%   THRESHOLDS) classifies the columns of Q with the K-Nearest 
%   Neighboors classifier using the pre-classified columns of 
%   matrix A with labels LABELS (cell array of vectors of 
%   integers). THRESHOLDS is a vector of class threshold 
%   values. NORMALIZED_DOCS defines if cosine (1) or euclidean 
%   distance (0) similarity measure is to be used. LABELS_AS 
%   contains the assigned labels for the columns of Q. 
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(6, 6, nargin));
labels_as=knn_multi_p(A, Q, k, labels, normalize_docs, thresholds);