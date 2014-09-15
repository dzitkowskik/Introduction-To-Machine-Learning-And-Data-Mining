function y=svd_update_afun(x, A, X, Y)
% SVD_UPDATE_AFUN - Auxiliary function used in SVD_UPDATE.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(4, 4, nargin));
y=svd_update_afun_p(x, A, X, Y);