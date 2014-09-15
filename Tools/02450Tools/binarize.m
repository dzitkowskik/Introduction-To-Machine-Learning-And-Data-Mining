function [Xbinary,attributeNamesBin]=binarize(X,nIntervals,attributeNames)

% function to turn data binary in order to do association mining by the
% Apriori algorithm
%
% Usage:
%   [Xbinary,attributeNames_binary]=binarize(X,nIntervals,attributeNames)
%
% Input:
%   X               N x M data matrix
%   nIntervals      M x 1 vector specifying the number of bins used for each
%                   attribute. Each bin defined as percentiles of the data
%   attributeNames  M x 1 cell array of names of each of the M attributes
%
% Output: 
%   Xbin                 binarized data matrix
%   attributeNamesBin    attributeNames for the binarized data
%
% Copyright 2011, Morten Mørup, Technical University of Denmark


Y=sort(X,'ascend');
[N,M]=size(X);
Q=zeros(N,M);
t=0;
attributeNamesBin={};
Xbinary=zeros(N,sum(nIntervals));
for m=1:M    
    for nI=1:nIntervals(m)-1
        Q(:,m) = Q(:,m) + double(X(:,m)>Y(ceil(nI/(nIntervals(m))*N),m));
    end    
    v=unique(Q(:,m))+1;      
    X_tmp=categoric2numeric(Q(:,m));    
    m_new=size(X_tmp,2);
    Xbinary(:,t+1:t+m_new)=X_tmp;
    for a=1:length(v)
        t=t+1;
        if a==1
            attributeNamesBin{t}=[attributeNames{m} ' ' num2str(0) '-' num2str(ceil(v(a)/nIntervals(m)*10000)/100) ' percentile'];
        elseif a==length(v) && nIntervals(m)~=length(v)
            attributeNamesBin{t}=[attributeNames{m} ' ' num2str(ceil((v(a-1))/nIntervals(m)*10000)/100) '-' num2str(100) ' percentile'];
        else
            attributeNamesBin{t}=[attributeNames{m} ' ' num2str(ceil((v(a-1))/nIntervals(m)*10000)/100) '-' num2str(ceil(v(a)/nIntervals(m)*10000)/100) ' percentile'];
        end
    end    
end
Xbinary=Xbinary(:,1:t);