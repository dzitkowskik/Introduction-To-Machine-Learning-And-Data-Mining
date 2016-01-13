function s=stemmer(token, dsp)
% STEMMER - applies the Porter's Stemming algorithm [1]
%   S = STEMMER(TOKEN, DSP) returns in S the stemmed word of 
%   TOKEN. DSP indicates if the function displays the result 
%   of each stem (1).
%
%   REFERENCES:
%   [1] M.F.Porter, An algorithm for suffix stripping, Program, 
%   14(3): 130-137, 1980.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));
s=stemmer_p(token, dsp);