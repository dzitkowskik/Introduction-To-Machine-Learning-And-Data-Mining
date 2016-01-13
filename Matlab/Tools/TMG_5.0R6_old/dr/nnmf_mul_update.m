function varargout = nnmf_mul_update(A, W, H, nit, dsp)
% NNMF_MUL_UPDATE - Applies the multiplicative update algorithm 
% of Lee and Seung. 
%   NNMF_MUL_UPDATE applies the multiplicative update algorithm 
%   of Lee and Seung for non-negative factorizations. [W, H, S] 
%   = nnmf_mul_update(A, W, H, NIT, DSP) produces a non-negative 
%   factorization of A, W*H, using as initial factors W and H, 
%   applying NIT iterations. 
%
%   REFERENCES: 
%   [1] D. Lee, S. Seung, Algorithms for Non-negative Matrix 
%   Factorization, NIPS (2000), 556-562.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(5, 5, nargin));
if nargout==1, varargout{1}=nnmf_mul_update_p(A, W, H, nit, dsp); end
if nargout==2, [varargout{1}, varargout{2}]=nnmf_mul_update_p(A, W, H, nit, dsp); end
if nargout==3, [varargout{1}, varargout{2}, varargout{3}]=nnmf_mul_update_p(A, W, H, nit, dsp); end