function writeAprioriFile(X,filename)

% function to write a binary matrix X into a .txt file given by filename in
% order to analyze this file by the apriori.m script
%
% Usage
%   writeAprioriFile(X,filename)
%
% Input
%   X         N x M binary data matrix
%   filename  name of the .txt file to generate
%
% Copyright 2011, Morten Mørup, Technical University
% of Denmark

if exist(filename,'file')
    delete(filename);
end
[N,M]=size(X);
for n=1:N
   ind=find(X(n,:));
   dlmwrite(filename,ind,'-append', 'newline' ,'pc')  
end