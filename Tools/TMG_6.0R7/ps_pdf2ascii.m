function result=ps_pdf2ascii(filename,directory)
% PS_PDF2ASCII - converts the input ps or pdf file to ASCII
%   RESULT = PS_PDF2ASCII(FILENAME,DIRECTORY) converts the input ps or 
%   pdf files to ASCII, using ghostscript's utility 'ps2ascii' and moves 
%   the converted file into directory. 
%   RESULT returns a success indicator, e.g. -2 if the input 
%   file does not exist or has a wrong format, -1 if gs is not 
%   installed or the path isn't set, 0 if 'ps2ascii' didn't 
%   work properly, and 1 if the conversion was successful.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));

result=ps_pdf2ascii_p(filename,directory);