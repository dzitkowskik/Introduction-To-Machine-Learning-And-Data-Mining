function result=untex(filename,directory)
% UNTEX - converts the input tex file to ASCII
%   RESULT = UNTEX(FILENAME,DIRECTORY) converts the input tex 
%   files to ASCII, using untex filters suitable for unix systems
%   or microsoft windows systems and moves the converted file into 
%   directory. 
%   RESULT returns a success indicator, e.g. -2 if the input 
%   file does not exist or has a wrong format, -1 if untex is 
%   not installed for unix users or the untex.exe is missing for windows 
%   users, 0 if untexing didn't work properly, and 1 if the conversion 
%   was successful.
% Copyright 2011 Eugenia Maria Kontopoulou, Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));

result=untex_p(filename,directory);