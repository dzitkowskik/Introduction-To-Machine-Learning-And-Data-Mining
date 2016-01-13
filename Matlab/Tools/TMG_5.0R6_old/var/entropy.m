function [ventropy, confusion_matrix, mistakes]=entropy(clusters, labels)
% ENTROPY - computes the entropy of a clustering result
%   [VENTROPY, CONFUSION_MATRIX, MISTAKES]=ENTROPY(CLUSTERS, 
%   LABELS) computes the entropy value of a clustering result 
%   represented by the CLUSTERS structure. LABELS is a vector 
%   of integers containing the true labeling of the objects. 
%   The entropy value is stored in VENTOPY, while 
%   CONFUSION_MATRIX is a k x r matrix, where k is the number 
%   of clusters and r the number of true classes, and 
%   CONFUSION_MATRIX(i, j) records the number of objects 
%   of class j assigned to cluster i. Finally, MISTAKES contains 
%   the number of misassigned objects, measured by m1+...+mk, 
%   where mi=sum(CONFUSION_MATRIX(i, j)), j~=i.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));
[ventropy, confusion_matrix, mistakes]=entropy_p(clusters, labels);