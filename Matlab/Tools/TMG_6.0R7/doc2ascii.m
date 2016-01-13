function result=doc2ascii(filename,directory)
% DOC2ASCII - converts the input doc or docx or
%   pdf or rtf or html or odt file to ASCII
%   RESULT = DOC2ASCII(FILENAME,DIRECTORY) converts the input  
%   files to ASCII, using the Apache POI which is a Java 
%   api for text conversion and move the resulted file into directory. 
%   RESULT returns a success indicator, e.g. -2 if the input 
%   file does not exist or has a wrong format, -1 if JRE is not 
%   installed or the path isn't set, 0 if the api didn't 
%   work properly, and 1 if the conversion was successful.
%
% Copyright 2011 Eugenia Maria Kontopoulou, Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));

result=doc2ascii_p(filename,directory);