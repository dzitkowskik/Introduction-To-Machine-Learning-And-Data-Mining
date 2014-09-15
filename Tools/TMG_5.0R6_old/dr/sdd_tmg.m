function [X, D, Y]=sdd_tmg(A, k)
% SDD_TMG - interface for SDDPACK
%   [X, D, Y]=SDD_TMG(A, K) computes a rank-K Semidiscrete 
%   Decomposition of A using the SDDPACK [1]. 
% 
%   REFERENCES: 
%   Tamara G. Kolda and Dianne P. O'Leary, Computation and 
%   Uses of the Semidiscrete Matrix Decomposition, Computer 
%   Science Department Report CS-TR-4012 Institute for Advanced 
%   Computer Studies Report UMIACS-TR-99-22, University of 
%   Maryland, April 1999.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

error(nargchk(2, 2, nargin));
[X, D, Y]=sdd_tmg_p(A, k);