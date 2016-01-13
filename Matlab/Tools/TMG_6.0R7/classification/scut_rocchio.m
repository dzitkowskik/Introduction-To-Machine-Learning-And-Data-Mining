function varargout=scut_rocchio(A, clusters, beta, gamma, Q, labels_tr, labels_te, minf1, normalize, steps)
% SCUT_ROCCHIO - implements the Scut thresholding technique 
% from [1] for the Rocchio classifier
%   THRESHOLD=SCUT_ROCCHIO(A, CLUSTERS, BETA, GAMMA, Q, 
%   LABELS_TR, LABELS_TE, MINF1, NORMALIZE, STEPS) returns 
%   the vector of thresholds for the Rocchio classifier 
%   for the collection [A Q]. A and Q define the training 
%   and test parts of the validation set with labels 
%   LABELS_TR and LABELS_TE respectively. MINF1 defines 
%   the minimum F1 value, while NORMALIZE defines if cosine 
%   (1) or euclidean distance (0) measure of similarity is 
%   to be used, CLUSTERS is a structure defining the classes 
%   and STEPS defines the number of steps used during 
%   thresholding. BETA and GAMMA define the weight of positive 
%   and negative examples in the formation of each class 
%   centroid.
%   [THRESHOLD, F, THRESHOLDS]=SCUT_ROCCHIO(A, CLUSTERS, BETA, 
%   GAMMA, Q, LABELS_TR, LABELS_TE, MINF1, NORMALIZE, STEPS) 
%   returns also the best F1 value as well as the matrix of 
%   thresholds for each step (row i corresponds to step i).
%
%   REFERENCES: 
%   [1] Y. Yang. A Study of Thresholding Strategies for Text 
%   Categorization. In Proc. 24th ACM SIGIR, pages 137–145, 
%   New York, NY, USA, 2001. ACM Press.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(10, 10, nargin));
if nargout==1, varargout{1}=scut_rocchio_p(A, clusters, beta, gamma, Q, labels_tr, labels_te, minf1, normalize, steps); end
if nargout==2, [varargout{1}, varargout{2}]=scut_rocchio_p(A, clusters, beta, gamma, Q, labels_tr, labels_te, minf1, normalize, steps); end
if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=scut_rocchio_p(A, clusters, beta, gamma, Q, labels_tr, labels_te, minf1, normalize, steps); end