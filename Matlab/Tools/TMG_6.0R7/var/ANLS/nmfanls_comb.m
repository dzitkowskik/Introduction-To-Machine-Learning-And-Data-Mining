%
% NMF/ANLS  
%
% Author: Hyunsoo Kim and Haesun Park, Georgia Insitute of Technology
% Modified by: Dimitris Zeimpekis (zeimpekis@gmail.com)
%
% Reference: 
%
%   Non-negative Matrix Factorization Based on Alternating Non-negativity 
%   Constrained Least Squares and Active Set Method, 
%   Hyunsoo Kim and Haesun Park, SIAM J. Matrix Anal. Appl., to appear, 2008.
%
% URL for updating codes:
%   http://compbio.med.harvard.edu/hkim/nmf/index.html
%
% This software requires fcnnls.m that can be obtained from 
% M. H. Van Benthem and M. R. Keenan, J. Chemometrics, 2004; 18: 441-450
%
% NMF: min_{W,H} (1/2) || A - WH ||_F^2 s.t. W>=0, H>=0 
%
% A: m x n data matrix (m: features, n: data points)
% W: m x k basis matrix
% H: k x n coefficient matrix
%
% function 
%   [W,H,i]=nmfanls_comb(A,k,H,verbose,bi_conv,eps_conv)
%
% input parameters:
%   A: m x n data matrix (m: features, n: data points)
%   k: desired positive integer k
%   H: initial k x n coefficient matrix (is empty initialized to a random
%   matrix)
%   verbose: verbose = 0 for silence mode, otherwise print log
%   bi_conv=[wminchange iconv] biclustering convergence test 
%      wminchange: the minimal allowance of the change of 
%         row-clusters  (default wminchange=0)
%      iconv: decide convergence if row-clusters (within wminchange)
%         and column-clusters have not changed for iconv 
%         convergence checks. (default iconv=10)
%   eps_conv: epsilon (to check KKT convergence)
%         The smaller epsilon, the more rigorous KKT convergence 
%         check is. (default eps_conv = 1e-4)
%
% output:
%   W: m x k basis matrix
%   H: k x n coefficient matrix
%   i: the number of iterations
%
% sample usage:
%  [W,H]=nmfanls_comb(amlall,3,[],1);
%  [W,H]=nmfanls_comb(amlall,3,[],1,[3 10]); 
%     -- in the convergence check, the row-cluster change
%        of at most three rows is allowed.
%
%
function [W,H,i]=nmfanls_comb(A,k,H,verbose,bi_conv,eps_conv)

if nargin<2, error('too small number of input arguments.'); end
if nargin<6, eps_conv=1e-4; end
if nargin<5, bi_conv=[0 10]; end
if nargin<4, verbose=1; end
if nargin<3, H=rand(k,size(A,2)); end
if isempty(H), H=rand(k,size(A,2)); end

[m,n]=size(A); maxiter=20000; 
wminchange=bi_conv(1); iconv=bi_conv(2);

if verbose, 
    fprintf('NMF/ANLS k=%d iconv=%d eps_conv=%e\n',k,iconv,eps_conv); 
end

idxWold=zeros(m,1); idxHold=zeros(1,n); inc=0; 

% initialize random H
%%H=rand(k,n); 

for i=1:maxiter

  % min_w ||H'*W' - A'||, s.t. W>=0, for given A and H.
  Wt=fcnnls(H',A'); W=Wt'; 

  % min_h ||W*H - A||, s.t. H>=0, for given A and W.
  H = fcnnls(W,A); 

  % test convergence every 5 iterations
  if(mod(i,5)==0) || (i==1)
      [y,idxW]=max(W,[],2);  [y,idxH]=max(H,[],1);    
      changedW=length(find(idxW ~= idxWold)); changedH=length(find(idxH ~= idxHold));
      if (changedW<=wminchange) && (changedH==0), inc=inc+1; else inc=0; end
      
      resmat=min(H,(W'*W)*H-W'*A); resvec=resmat(:);
      resmat=min(W,W*(H*H')-A*H'); resvec=[resvec; resmat(:)];      
      deltao=norm(resvec,1); %L1-norm      
      num_notconv=length(find(abs(resvec)>0));
      delta=deltao/num_notconv;
      if i==1, delta1=delta; end
      
      if verbose || (mod(i,1000)==0) % prints number of changing elements 
         fprintf('\t%d\t%d\t%d %d --- delta: %.4e\n',...
             i,inc,changedW,changedH,delta);
      end
      if (inc>=iconv) && (delta<=eps_conv*delta1), break, end 
      idxWold=idxW; idxHold=idxH;
  end
  
end

% normalization
norm2=sqrt(sum(W.^2,1)); W=W./repmat(norm2,m,1);  H=H.*repmat(norm2',1,n);  

return;  