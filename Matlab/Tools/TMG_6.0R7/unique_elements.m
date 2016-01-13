function [elements, n]=unique_elements(x)
% UNIQUE_ELEMENTS - detects all distinct elements of a vector
%   [ELEMENTS, N] = UNIQUE_ELEMENTS(X) returns in ELEMENTS all 
%   distinct elements of vector X, and in N the number of times 
%   each element appears in X. A value is repeated if it appears 
%   in non-consecutive elements. For no repetitive elements sort 
%   the input vector.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(1, 1, nargin));
[elements, n]=unique_elements_p(x);