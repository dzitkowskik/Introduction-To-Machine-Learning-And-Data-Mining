function varargout=tdm_update(varargin)
% TDM_UPDATE renews a text collection by updating the 
% correspoding term-document matrix. 
%   A = TDM_UPDATE(FILENAME, UPDATE_STRUCT) returns the new 
%   term - document matrix of the updated collection. FILENAME 
%   defines the file (or files in case a directory is supplied) 
%   containing the new documents, while UPDATE_STRUCT defines 
%   the update structure returned by TMG. In case FILENAME 
%   variable is empty, the collection is simply updated using 
%   the options defined by UPDATE_STRUCT (for example, use 
%   another term-weighting scheme).
%   [A, DICTIONARY] = TDM_UPDATE(FILENAME, UPDATE_STRUCT) 
%   returns also the dictionary for the updated collection, 
%   while [A, DICTIONARY, GLOBAL_WEIGHTS, NORMALIZED_FACTORS]
%   = TDM_UPDATE(FILENAME, UPDATE_STRUCT) returns the vectors 
%   of global weights for the dictionary and the normalization 
%   factor for each document in case such a factor is used. 
%   If normalization is not used TDM_UPDATE returns a vector 
%   of all ones. 
%   [A, DICTIONARY, GLOBAL_WEIGHTS, NORMALIZATION_FACTORS, 
%   WORDS_PER_DOC] = TDM_UPDATE(FILENAME, UPDATE_STRUCT) returns 
%   statistics for each document, i.e. the number of terms for 
%   each document. 
%   [A, DICTIONARY, GLOBAL_WEIGHTS, NORMALIZATION_FACTORS, 
%   WORDS_PER_DOC, TITLES, FILES] = TDM_UPDATE(FILENAME, 
%   UPDATE_STRUCT) returns in FILES the filenames contained in 
%   directory (or file) FILENAME and a cell array (TITLES) that 
%   containes a declaratory title for each document, as well as 
%   the document's first line.
%   Finally [A, DICTIONARY, GLOBAL_WEIGHTS, NORMALIZATION_FACTORS, 
%   WORDS_PER_DOC, TITLES, FILES, UPDATE_STRUCT] = 
%   TDM_UPDATE(FILENAME, UPDATE_STRUCT) returns the update 
%   structure that keeps the essential information for the 
%   collection' s update (or downdate).
%   TDM_UPDATE(FILENAME, UPDATE_STRUCT, OPTIONS) defines optional 
%   parameters: 
%       - OPTIONS.delimiter: The delimiter between documents within 
%         the same file. Possible values are 'emptyline' (default), 
%         'none_delimiter' (treats each file as a single document) 
%         or any other string.
%       - OPTIONS.line_delimiter: Defines if the delimiter takes a 
%         whole line of text (default, 1) or not.
%       - OPTIONS.update_step: The step used for the incremental 
%         built of the inverted index (default 10,000).
%       - OPTIONS.dsp: Displays results (default 1) or not (0) to 
%         the command window.
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
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

%==================================================================    
%check input and set parameters
%==================================================================    
error(nargchk(2, 3, nargin));
if nargin==2, 
    if nargout==1, varargout{1}=tdm_update_p(varargin{1}, varargin{2}); end
    if nargout==2, [varargout{1}, varargout{2}]=tdm_update_p(varargin{1}, varargin{2}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=tdm_update_p(varargin{1}, varargin{2}); end
    if nargout==4, [varargout{1}, varargout{2}, varargout{3}, varargout{4}]=tdm_update_p(varargin{1}, varargin{2}); end
    if nargout==5, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}]=tdm_update_p(varargin{1}, varargin{2}); end
    if nargout==6, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}]=tdm_update_p(varargin{1}, varargin{2}); end
    if nargout==7, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}]=tdm_update_p(varargin{1}, varargin{2}); end
    if nargout==8, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}, varargout{8}]=tdm_update_p(varargin{1}, varargin{2}); end    
else, 
    if nargout==1, varargout{1}=tdm_update_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==2, [varargout{1}, varargout{2}]=tdm_update_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=tdm_update_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==4, [varargout{1}, varargout{2}, varargout{3}, varargout{4}]=tdm_update_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==5, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}]=tdm_update_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==6, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}]=tdm_update_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==7, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}]=tdm_update_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==8, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}, varargout{8}]=tdm_update_p(varargin{1}, varargin{2}, varargin{3}); end    
end