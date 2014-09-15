function [new_words, new_doc_ids]=unique_words(words, doc_ids, n_docs)
% UNIQUE_WORDS - detects all distinct elements of a cell array of 
% chars (used by tmg.m, tmg_query.m, tdm_update.m)
%   [NEW_WORDS, NEW_DOC_IDS]=UNIQUE_WORDS(WORDS, DOC_IDS, N_DOCS)
%   returns in NEW_WORDS all distinct elements of the cell array
%   of chars WORDS. DOC_IDS is the vector of the document identifiers
%   containing the corresponding words, while N_DOCS is the total 
%   number of documents contained to the collection. NEW_DOC_IDS 
%   contains the inverted index of the collection as a cell array 
%   of 2 x N_DOCS arrays. 
%
% Copyright 2008 Dimitris Zeimpekis, Efstratios Gallopoulos

error(nargchk(3, 3, nargin));
[new_words, new_doc_ids]=unique_words_p(words, doc_ids, n_docs);