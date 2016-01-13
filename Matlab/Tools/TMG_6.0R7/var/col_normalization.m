function A=col_normalization(A)
% COL_NORMALIZATION - normalizes the columns of the input 
% matrix.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(1, 1, nargin));
A=col_normalization_p(A);