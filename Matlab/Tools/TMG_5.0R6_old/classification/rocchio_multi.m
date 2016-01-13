function labels_as=rocchio_multi(A, clusters, beta, gamma, Q, labels, normalize_docs, thresholds)
% ROCCHIO_MULTI - Rocchio classifier for multi-label collections
%   LABELS_AS=KNN_MULTI(A, CLUSTERS, BETA, GAMMA, Q, LABELS, 
%   NORMALIZED_DOCS, THRESHOLDS) classifies the columns of Q 
%   with the Rocchio classifier using the pre-classified columns 
%   of matrix A with labels LABELS (vector of integers). 
%   THRESHOLDS is a vector of class threshold values. BETA and 
%   GAMMA define the weight of positive and negative examples in
%   the formation of each class centroid. NORMALIZED_DOCS defines 
%   if cosine (1) or euclidean distance (0) similarity measure is 
%   to be used. LABELS_AS contains the assigned labels for the 
%   columns of Q. 
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(8, 8, nargin));
labels_as=rocchio_multi_p(A, clusters, beta, gamma, Q, labels, normalize_docs, thresholds);