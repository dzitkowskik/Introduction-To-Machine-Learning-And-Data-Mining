function [all_words, all_doc_ids]=merge_dictionary(all_words, new_words, all_doc_ids, new_doc_ids)
% MERGE_DICTIONARY - merges two cell arrays of chars and returns 
% only the distinct elements of their union (used by tmg.m, 
% tmg_query.m, tdm_update.m)
%   [ALL_WORDS, ALL_DOC_IDS]=MERGE_DICTIONARY(ALL_WORDS, NEW_WORDS,
%   ALL_DOC_IDS, NEW_DOC_IDS) returns in ALL_WORDS all distinct 
%   elements of the union of the cell arrays of chars ALL_WORDS, 
%   NEW_WORDS corresponding to two document collections. ALL_DOC_IDS 
%   and NEW_DOC_IDS contain the inverted indices of the two 
%   collections. Output argument ALL_DOC_IDS contains the inverted 
%   index of the whole collection.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(4, 4, nargin));
[all_words, all_doc_ids]=merge_dictionary_p(all_words, new_words, all_doc_ids, new_doc_ids);