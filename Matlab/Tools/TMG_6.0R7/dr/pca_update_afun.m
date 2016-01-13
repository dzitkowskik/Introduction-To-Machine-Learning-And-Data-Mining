function y=pca_update_afun(x, A, W, H, h, g)
% PCA_UPDATE_AFUN - Auxiliary function used in PCA_UPDATE.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(6, 6, nargin));
y=pca_update_afun_p(x, A, W, H, h, g);