function scat=compute_scat(A, c)
% COMPUTE_SCAT - computes the cluster selection criterion value 
% of PDDP
%   SCAT=COMPUTE_SCAT(A, C) returns the square of the frobenius 
%   norm of A-C*ones(1, size(A, 2)).
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));
scat=compute_scat_p(A, c);