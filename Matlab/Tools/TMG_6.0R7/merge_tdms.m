function [A, dictionary]=merge_tdms(varargin)
% MERGE_TDMS - Merges two document collections
%   [A, DICTIONARY]=MERGE_TDMS(A1, DICTIONARY1, A2, DICTIONARY2] 
%   merges the tdms A1 and A2 with corresponding dictionaries 
%   DICTIONARY1 and DICTIONARY2. 
%   MERGE_TDS(A1, DICTIONARY1, A2, DICTIONARY2, OPTIONS) defines 
%   optional parameters: 
%       - OPTIONS.min_local_freq: The minimum local frequency for 
%         a term (default 1)
%       - OPTIONS.max_local_freq: The maximum local frequency for 
%         a term (default inf)
%       - OPTIONS.min_global_freq: The minimum global frequency 
%         for a term (default 1)
%       - OPTIONS.max_global_freq: The maximum global frequency 
%         for a term (default inf)
%       - OPTIONS.local_weight: The local term weighting function 
%         (default 't'). Possible values (see [1, 2]): 
%               't': Term Frequency
%               'b': Binary
%               'l': Logarithmic
%               'a': Alternate Log
%               'n': Augmented Normalized Term Frequency
%       - OPTIONS.global_weight: The global term weighting function 
%         (default 'x'). Possible values (see [1, 2]): 
%               'x': None
%               'e': Entropy
%               'f': Inverse Document Frequency (IDF)
%               'g': GfIdf
%               'n': Normal
%               'p': Probabilistic Inverse
%       - OPTIONS.normalization: Indicates if we normalize the 
%         document vectors (default 'x'). Possible values:
%               'x': None
%               'c': Cosine
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(4, 5, nargin));
if naragin==4, 
    [A, dictionary]=merge_tdms(varargin{1}, varargin{2}, varargin{3}, varargin{4}); 
else, 
    [A, dictionary]=merge_tdms(varargin{1}, varargin{2}, varargin{3}, varargin{4}, varargin{5});
end