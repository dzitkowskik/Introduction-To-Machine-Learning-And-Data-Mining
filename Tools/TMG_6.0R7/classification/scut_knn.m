function varargout=scut_knn(A, Q, k, labels_tr, labels_te, minf1, normalize, steps)
% SCUT_KNN - implements the Scut thresholding technique from [1] 
% for the k-Nearest Neighboors classifier
%   THRESHOLD=SCUT_KNN(A, Q, K, LABELS_TR, LABELS_TE, MINF1, 
%   NORMALIZE, STEPS) returns the vector of thresholds for 
%   the k-Nearest Neighboors classifier for the collection 
%   [A Q]. A and Q define the training and test parts of
%   the validation set with labels LABELS_TR and LABELS_TE 
%   respectively. MINF1 defines the minimum F1 value and 
%   NORMALIZE defines if cosine (1) or euclidean distance (0) 
%   measure of similarity is to be used. Finally, STEPS 
%   defines the number of steps used during thresholding. 
%   [THRESHOLD, F, THRESHOLDS]=SCUT_KNN(A, Q, K, LABELS_TR, 
%   LABELS_TE, MINF1, NORMALIZE, STEPS) returns also the best 
%   F1 value as well as the matrix of thresholds for each step 
%   (row i corresponds to step i).
%
%   REFERENCES: 
%   [1] Y. Yang. A Study of Thresholding Strategies for Text 
%   Categorization. In Proc. 24th ACM SIGIR, pages 137–145, 
%   New York, NY, USA, 2001. ACM Press.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(8, 8, nargin));
if nargout==1, varargout{1}=scut_knn_p(A, Q, k, labels_tr, labels_te, minf1, normalize, steps); end
if nargout==2, [varargout{1}, varargout{2}]=scut_knn_p(A, Q, k, labels_tr, labels_te, minf1, normalize, steps); end
if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=scut_knn_p(A, Q, k, labels_tr, labels_te, minf1, normalize, steps); end