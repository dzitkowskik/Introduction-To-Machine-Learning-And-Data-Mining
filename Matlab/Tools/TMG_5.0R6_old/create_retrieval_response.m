function html_file=create_retrieval_response(dataset, ids, similarity, query)
% CREATE_RETRIEVAL_RESPONSE returns an html response for a query 
%   CREATE_RETRIEVAL_RESPONSE(DATASET, IDS, SIMILARITY, QUERY) 
%   creates an html file containing information for the text of 
%   documents of DATASET stored in MySQL defined by IDS and 
%   having SIMILARITY similarity coefficients against QUERY. 
%   The result is stored in the "results" directory and displayed 
%   using the default web browser. 
%
% Copyright 2008 Dimitris Zeimpekis, Efstratios Gallopoulos

error(nargchk(4, 4, nargin));
html_file=create_retrieval_response_p(dataset, ids, similarity, query);