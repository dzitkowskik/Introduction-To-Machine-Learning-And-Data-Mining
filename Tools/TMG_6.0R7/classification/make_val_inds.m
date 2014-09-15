function inds=make_val_inds(labels)
% MAKE_VAL_INDS - auxiliary function for the classification 
% algorithms
%   INDS=MAKE_VAL_INDS(LABELS) constructs an index vector used 
%   during the thresholding phase of any classifier for the 
%   multi-label collection with document classes defined by 
%   LABELS (cell array of vectors of integers).
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(1, 1, nargin));
inds=make_val_inds_p(labels);