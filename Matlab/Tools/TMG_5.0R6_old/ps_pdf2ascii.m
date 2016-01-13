function result=ps_pdf2ascii(filename)
% PS_PDF2ASCII - converts the input ps or pdf file to ASCII
%   RESULT = PS_PDF2ASCII(FILENAME) converts the input ps or 
%   pdf files to ASCII, using ghostscript's utility 'ps2ascii'. 
%   RESULT returns a success indicator, e.g. -2 if the input 
%   file does not exist or has a wrong format, -1 if gs is not 
%   installed or the path isn't set, 0 if 'ps2ascii' didn't 
%   work properly, and 1 if the conversion was successful.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(1, 1, nargin));
result=ps_pdf2ascii_p(filename);