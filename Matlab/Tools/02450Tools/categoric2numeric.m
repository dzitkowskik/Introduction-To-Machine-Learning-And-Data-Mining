function [X_tmp, attributeNames_tmp]=categoric2numeric(x)

% CATEGORIC2NUMERIC converts data matrix with categorical columns given by
% numeric values or cells to numeric columns using one out of K coding.
%
% Usage:
%   [X_tmp, attributeNames_tmp]=categoric2numeric(x)
%
% Input:
%   x               categorical column of a data matrix 
%
% Output:
%   X_tmp                   Data matrix where categoric column has been
%                           converted to one out of K coding
%   attributeNames_tmp      new cell array of the M' attributes
%
% Copyright 2011, Morten Mørup, Technical University of Denmark

N=size(x,1);
val=unique(x);
M=length(val);
X_tmp=zeros(N,M);
attributeNames_tmp=cell(1,M);
for t=1:M      
   if isnumeric(val(t))
       X_tmp(:,t)=(x==val(t));       
       attributeNames_tmp{t}=num2str(val(t));
   else
       X_tmp(:,t)=strcmp(x,val{t});       
       attributeNames_tmp{t}=val{t};
   end
end   
