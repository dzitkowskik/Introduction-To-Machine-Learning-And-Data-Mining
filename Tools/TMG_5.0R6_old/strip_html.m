function varargout=strip_html(filename)
% STRIP_HTML - removes html entities from an html file
%   S = STRIP_HTML(FILENAME) parses the file FILENAME and removes 
%   the html entities, while the result is stored in S as a 
%   cell array and written in file "FILENAME.TXT".
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(1, 1, nargin));
if nargout==0, strip_html_p(filename); else, s=strip_html_p(filename); end