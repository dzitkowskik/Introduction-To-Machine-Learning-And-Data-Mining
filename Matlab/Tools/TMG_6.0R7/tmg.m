function varargout=tmg(varargin)
% TMG - Text to Matrix Generator 
  % TMG parses a text collection and generates the term - 
  % document matrix.
  % A = TMG(FILENAME) returns the term - document matrix, 
  % that corresponds to the text collection contained in 
  % files of directory (or file) FILENAME. 
  % Each document must be separeted by a blank line (or 
  % another delimiter that is defined by OPTIONS argument) 
  % in each file. 
  % [A, DICTIONARY] = TMG(FILENAME) returns also the 
  % dictionary for the collection, while [A, DICTIONARY, 
  % GLOBAL_WEIGHTS, NORMALIZED_FACTORS] = TMG(FILENAME) 
  % returns the vectors of global weights for the dictionary 
  % and the normalization factor for each document in case 
  % such a factor is used. If normalization is not used TMG 
  % returns a vector of all ones. 
  % [A, DICTIONARY, GLOBAL_WEIGHTS, NORMALIZATION_FACTORS, 
  % WORDS_PER_DOC] = TMG(FILENAME) returns statistics for 
  % each document, i.e. the number of terms for each document. 
  % [A, DICTIONARY, GLOBAL_WEIGHTS, NORMALIZATION_FACTORS, 
  % WORDS_PER_DOC, TITLES, FILES] = TMG(FILENAME) returns in 
  % FILES the filenames contained in directory (or file) 
  % FILENAME and a cell array (TITLES) that containes a 
  % declaratory title for each document, as well as the 
  % document's first line. Finally [A, DICTIONARY, 
  % GLOBAL_WEIGHTS, NORMALIZATION_FACTORS, WORDS_PER_DOC, 
  % TITLES, FILES, UPDATE_STRUCT] = TMG(FILENAME) returns a 
  % structure that keeps the essential information for the 
  % collection' s update (or downdate).
  %
  % TMG(FILENAME, OPTIONS) defines optional parameters: 
  %     - OPTIONS.use_mysql: Indicates if results are to be 
  %       stored in MySQL.
  %     - OPTIONS.db_name: The name of the directory where 
  %       the results are to be saved.
  %     - OPTIONS.delimiter: The delimiter between documents 
  %       within the same file. Possible values are 'emptyline' 
  %       (default), 'none_delimiter' (treats each file as a 
  %       single document) or any other string.
  %     - OPTIONS.line_delimiter: Defines if the delimiter 
  %       takes a whole line of text (default, 1) or not.
  %     - OPTIONS.stoplist: The filename for the stoplist, 
  %       i.e. a list of common words that we don't use for 
  %       the indexing (default no stoplist used).
  %     - OPTIONS.stemming: Indicates if the stemming algorithm 
  %       is used (1) or not (0 - default).
  %     - OPTIONS.update_step: The step used for the incremental 
  %       built of the inverted index (default 10,000).
  %     - OPTIONS.min_length: The minimum length for a term 
  %       (default 3).
  %     - OPTIONS.max_length: The maximum length for a term 
  %       (default 30).
  %     - OPTIONS.min_local_freq: The minimum local frequency for 
  %       a term (default 1).
  %     - OPTIONS.max_local_freq: The maximum local frequency for 
  %       a term (default inf).
  %     - OPTIONS.min_global_freq: The minimum global frequency 
  %       for a term (default 1).
  %     - OPTIONS.max_global_freq: The maximum global frequency 
  %       for a term (default inf).
  %     - OPTIONS.local_weight: The local term weighting function 
  %       (default 't'). Possible values (see [1, 2]): 
  %                 't': Term Frequency
  %                 'b': Binary
  %                 'l': Logarithmic
  %                 'a': Alternate Log
  %                 'n': Augmented Normalized Term Frequency
  %     - OPTIONS.global_weight: The global term weighting function 
  %       (default 'x'). Possible values (see [1, 2]): 
  %                 'x': None
  %                 'e': Entropy
  %                 'f': Inverse Document Frequency (IDF)
  %                 'g': GfIdf
  %                 'n': Normal
  %                 'p': Probabilistic Inverse
  %     - OPTIONS.normalization: Indicates if we normalize the 
  %       document vectors (default 'x'). Possible values:
  %                 'x': None
  %                 'c': Cosine
  %     - OPTIONS.dsp: Displays results (default 1) or not (0) to 
  %       the command window.
  %     - OPTIONS.remove_num: Indicates if we remove the numbers from the
  %       dictionary (value 1) or not (value 0- default).
  %     - OPTIONS.remove_al: Indicates if we remove the alphanumerics from 
  %       the dictionary (value 1) or not (value 0-default).
  %     - OPTIONS.parse_subd: Indicates if we parse all the subdirectories
  %       without be questioned (value 1), or we are asked which 
  %       subdirectories to parse (value 0-default). This option is 
  %       recommended for large collections with many subdirectories
  %       so that they can be run in batch mode. Setting this options we
  %       are avoiding questions during the parsing.
  %
  % REFERENCES: 
  % [1] M.Berry and M.Browne, Understanding Search Engines, Mathematical 
  % Modeling and Text Retrieval, Philadelphia, PA: Society for Industrial 
  % and Applied Mathematics, 1999.
  % [2] T.Kolda, Limited-Memory Matrix Methods with Applications,
  % Tech.Report CS-TR-3806, 1997.
  %
  % Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

%==================================================================    
%check input and set parameters
%==================================================================    
TMG_current_directory = pwd();
error(nargchk(1, 2, nargin));
if nargin==1, 
    if nargout==1, varargout{1}=tmg_p(varargin{1}); end
    if nargout==2, [varargout{1}, varargout{2}]=tmg_p(varargin{1}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=tmg_p(varargin{1}); end
    if nargout==4, [varargout{1}, varargout{2}, varargout{3}, varargout{4}]=tmg_p(varargin{1}); end
    if nargout==5, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}]=tmg_p(varargin{1}); end
    if nargout==6, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}]=tmg_p(varargin{1}); end
    if nargout==7, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}]=tmg_p(varargin{1}); end
    if nargout==8, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}, varargout{8}]=tmg_p(varargin{1}); end    
else, 
    if nargout==1, varargout{1}=tmg_p(varargin{1}, varargin{2}); end
    if nargout==2, [varargout{1}, varargout{2}]=tmg_p(varargin{1}, varargin{2}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=tmg_p(varargin{1}, varargin{2}); end
    if nargout==4, [varargout{1}, varargout{2}, varargout{3}, varargout{4}]=tmg_p(varargin{1}, varargin{2}); end
    if nargout==5, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}]=tmg_p(varargin{1}, varargin{2}); end
    if nargout==6, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}]=tmg_p(varargin{1}, varargin{2}); end
    if nargout==7, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}]=tmg_p(varargin{1}, varargin{2}); end
    if nargout==8, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}, varargout{8}]=tmg_p(varargin{1}, varargin{2}); end    
end
cd(TMG_current_directory);