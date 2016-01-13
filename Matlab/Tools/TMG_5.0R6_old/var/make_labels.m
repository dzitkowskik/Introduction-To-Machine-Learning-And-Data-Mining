function [labels, unique_labels]=make_labels(input_labels)
% MAKE_LABELS - creates a label vector of integers for the input 
% cell array of string
%   [LABELS, UNIQUE_LABELS]=MAKE_LABELS(INPUT_LABELS) creates a 
%   vector of integer labels (LABELS) for the input cell array 
%   of strings INPUT_LABELS. UNIQUE_LABELS contains the strings 
%   of unique labels of the input cell array.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(1, 1, nargin));
[labels, unique_labels]=make_labels_p(input_labels);