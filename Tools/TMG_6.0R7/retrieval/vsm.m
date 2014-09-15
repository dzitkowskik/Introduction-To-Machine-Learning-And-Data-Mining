function [sc, doc_inds]=vsm(D, q, normalize_docs)
% VSM - Applies the Vector Space Model to a document collection
%   [SC, DOCS_INDS] = VSM(D, Q, NORMALIZE_DOCS) applies the 
%   Vector Space Model to the text collection represented by 
%   the term - document matrix D for the query defined by the 
%   vector Q [1]. NORMALIZE_DOCS defines if the document 
%   vectors are to be normalized (1) or not (0). SC contains 
%   the sorted similarity coefficients, while DOC_INDS contains 
%   the corresponding document indices.
%
%   REFERENCES: 
%   [1] M.Berry and M.Browne, Understanding Search Engines, 
%   Mathematical Modeling and Text Retrieval, Philadelphia, 
%   PA: Society for Industrial and Applied Mathematics, 1999.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

error(nargchk(3, 3, nargin));
[sc, doc_inds]=vsm_p(D, q, normalize_docs);