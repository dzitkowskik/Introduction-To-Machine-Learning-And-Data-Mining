function y=pca_mat_afun(x, A, h, g)
% PCA_MAT_AFUN - Auxiliary function used in PCA_MAT.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(4, 4, nargin));
y=pca_mat_afun_p(x, A, h, g);