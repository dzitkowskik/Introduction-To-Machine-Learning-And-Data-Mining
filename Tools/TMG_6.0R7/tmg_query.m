function varargout=tmg_query(varargin)
% TMG_QUERY - Text to Matrix Generator, query vector constructor
%   TMG_QUERY parses a query text collection and generates the 
%   query vectors corresponding to the supplied dictionary.
%   Q = TMG_QUERY(FILENAME, DICTIONARY) returns the query 
%   vectors, that corresponds to the text collection contained 
%   in files of directory FILENAME. DICTIONARY is the array of 
%   terms corresponding to a text collection.
%   Each query must be separeted by a blank line (or another 
%   delimiter that is defined by OPTIONS argument) in each file. 
%   [Q, WORDS_PER_QUERY] = TMG_QUERY(FILENAME, DICTIONARY) 
%   returns statistics for each query, i.e. the number of terms 
%   for each query. 
%   Finally, [Q, WORDS_PER_QUERY, TITLES, FILES] = 
%   TMG_QUERY(FILENAME) returns in FILES the filenames contained 
%   in directory (or file) FILENAME and a cell array (TITLES) 
%   that containes a declaratory title for each query, as well 
%   as the query's first line.
%
%   TMG_QUERY(FILENAME, DICTIONARY, OPTIONS) defines optional 
%   parameters: 
%       - OPTIONS.delimiter: The delimiter between queries within 
%         the same file. Possible values are 'emptyline' (default), 
%         'none_delimiter' (treats each file as a single query) 
%         or any other string.
%       - OPTIONS.line_delimiter: Defines if the delimiter takes a 
%         whole line of text (default, 1) or not.
%       - OPTIONS.stoplist: The filename for the stoplist, i.e. a 
%         list of common words that we don't use for the indexing 
%         (default no stoplist used).
%       - OPTIONS.stemming: Indicates if the stemming algorithm is 
%         used (1) or not (0 - default).
%       - OPTIONS.update_step: The step used for the incremental 
%         built of the inverted index (default 10,000).
%       - OPTIONS.local_weight: The local term weighting function 
%         (default 't'). Possible values (see [1, 2]): 
%               't': Term Frequency
%               'b': Binary
%               'l': Logarithmic
%               'a': Alternate Log
%               'n': Augmented Normalized Term Frequenct
%       - OPTIONS.global_weights: The vector of term global 
%         weights (returned by tmg).
%       - OPTIONS.dsp: Displays results (default 1) or not (0).
%       - OPTIONS.remove_num: Indicates if we remove the numbers from the
%         dictionary (value 1) or not (value 0- default).
%       - OPTIONS.remove_al: Indicates if we remove the alphanumerics from 
%         the dictionary (value 1) or not (value 0- default).
%       - OPTIONS.parse_subd: Indicates if we parse all the subdirectories
%         without be questioned (value 1), or we are asked which 
%         subdirectories to parse (value 0-default). This option is
%         recommended for large collections with many subdirectories
%         so that they can be run in batch mode. Setting this options we
%         are avoiding questions during the parsing.
%   REFERENCES: 
%   [1] M.Berry and M.Browne, Understanding Search Engines, 
%   Mathematical Modeling and Text Retrieval, Philadelphia, 
%   PA: Society for Industrial and Applied Mathematics, 1999.
%   [2] T.Kolda, Limited-Memory Matrix Methods with Applications,
%   Tech.Report CS-TR-3806, 1997.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

%==================================================================    
%check input and set parameters
%==================================================================    
error(nargchk(2, 3, nargin));
if nargin==2, 
    if nargout==1, varargout{1}=tmg_query_p(varargin{1}, varargin{2}); end
    if nargout==2, [varargout{1}, varargout{2}]=tmg_query_p(varargin{1}, varargin{2}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=tmg_query_p(varargin{1}, varargin{2}); end
    if nargout==4, [varargout{1}, varargout{2}, varargout{3}, varargout{4}]=tmg_query_p(varargin{1}, varargin{2}); end
else, 
    if nargout==1, varargout{1}=tmg_query_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==2, [varargout{1}, varargout{2}]=tmg_query_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=tmg_query_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==4, [varargout{1}, varargout{2}, varargout{3}, varargout{4}]=tmg_query_p(varargin{1}, varargin{2}, varargin{3}); end
end