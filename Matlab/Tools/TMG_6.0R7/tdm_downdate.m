function varargout=tdm_downdate(varargin)
% TDM_DOWNDATE - renews a text collection by downdating the 
% correspoding term-document matrix
%   A = TDM_DOWNDATE(UPDATE_STRUCT, REMOVED_DOCS) returns the new 
%   term - document matrix of the downdated collection. 
%   UPDATE_STRUCT defines the update structure returned by TMG, 
%   while REMOVED_DOCS defines the indices of the documents that 
%   is to be be removed. 
%   [A, DICTIONARY] = TDM_DOWNDATE(UPDATE_STRUCT, REMOVED_DOCS) 
%   returns also the dictionary for the updated collection, while 
%   [A, DICTIONARY, GLOBAL_WEIGHTS, NORMALIZED_FACTORS]
%   = TDM_DOWNDATE(UPDATE_STRUCT, REMOVED_DOCS) returns the 
%   vectors of  global weights for the dictionary and the 
%   normalization factor for each document in case such a factor 
%   is used. If normalization is not used TDM_DOWNDATE returns a 
%   vector of all ones. [A, DICTIONARY, GLOBAL_WEIGHTS, 
%   NORMALIZATION_FACTORS, WORDS_PER_DOC] = 
%   TDM_DOWNDATE(UPDATE_STRUCT, REMOVED_DOCS) returns statistics 
%   for each document, i.e. the number of terms for each document. 
%   [A, DICTIONARY, GLOBAL_WEIGHTS, NORMALIZATION_FACTORS, 
%   WORDS_PER_DOC, TITLES, FILES] = TDM_DOWNDATE(UPDATE_STRUCT, 
%   REMOVED_DOCS) returns in FILES the filenames containing the 
%   collection's documents and a cell array (TITLES) that contains 
%   a declaratory title for each document, as well as the document's 
%   first line. 
%   Finally [A, DICTIONARY, GLOBAL_WEIGHTS, NORMALIZATION_FACTORS, 
%   WORDS_PER_DOC, TITLES, FILES, UPDATE_STRUCT] = 
%   TDM_DOWNDATE(UPDATE_STRUCT, REMOVED_DOCS) returns the update 
%   structure that keeps the essential information for the 
%   collection' s update (or downdate).
%   TDM_DOWNDATE(UPDATE_STRUCT, REMOVED_DOCS, OPTIONS) defines 
%   optional parameters: 
%       - OPTIONS.dsp: Displays results (default 1) or not (0) 
%         to the command window.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

%==================================================================    
%check input and set parameters
%==================================================================    
error(nargchk(2, 3, nargin));
if nargin==2, 
    if nargout==1, varargout{1}=tdm_downdate_p(varargin{1}, varargin{2}); end
    if nargout==2, [varargout{1}, varargout{2}]=tdm_downdate_p(varargin{1}, varargin{2}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=tdm_downdate_p(varargin{1}, varargin{2}); end
    if nargout==4, [varargout{1}, varargout{2}, varargout{3}, varargout{4}]=tdm_downdate_p(varargin{1}, varargin{2}); end
    if nargout==5, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}]=tdm_downdate_p(varargin{1}, varargin{2}); end
    if nargout==6, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}]=tdm_downdate_p(varargin{1}, varargin{2}); end
    if nargout==7, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}]=tdm_downdate_p(varargin{1}, varargin{2}); end
    if nargout==8, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}, varargout{8}]=tdm_downdate_p(varargin{1}, varargin{2}); end    
else, 
    if nargout==1, varargout{1}=tdm_downdate_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==2, [varargout{1}, varargout{2}]=tdm_downdate_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=tdm_downdate_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==4, [varargout{1}, varargout{2}, varargout{3}, varargout{4}]=tdm_downdate_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==5, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}]=tdm_downdate_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==6, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}]=tdm_downdate_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==7, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}]=tdm_downdate_p(varargin{1}, varargin{2}, varargin{3}); end
    if nargout==8, [varargout{1}, varargout{2}, varargout{3}, varargout{4}, varargout{5}, varargout{6}, varargout{7}, varargout{8}]=tdm_downdate_p(varargin{1}, varargin{2}, varargin{3}); end    
end