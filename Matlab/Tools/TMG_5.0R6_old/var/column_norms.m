function tmp=column_norms(A)
% COLUMN_NORMS - returns the column norms of a matrix
% 
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(1, 1, nargin));
tmp=column_norms_p(A);