function [sc, doc_inds]=lsa(D, P, q, normalize_docs)
% LSA - Applies the Latent Semantic Analysis Model to a 
% document collection
%   [SC, DOCS_INDS] = LSA(D, P, Q, NORMALIZE_DOCS) applies 
%   LSA to the text collection represented by the latent 
%   semantic factors D, P of the collection's term - document 
%   matrix, for the query defined by the vector Q [1]. 
%   NORMALIZE_DOCS defines if the document vectors are to be 
%   normalized (1) or not (0). SC contains the sorted 
%   similarity coefficients, while DOC_INDS contains the 
%   corresponding document indices.
%
%   REFERENCES: 
%   [1] M.Berry and M.Browne, Understanding Search Engines, 
%   Mathematical Modeling and Text Retrieval, Philadelphia, 
%   PA: Society for Industrial and Applied Mathematics, 1999.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(4, 4, nargin));
[sc, doc_inds]=lsa_p(D, P, q, normalize_docs);