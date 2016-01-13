function [N,Range]=hist2d(X,B)
% Function to evaluate co-occurence, i.e. 2D histogram
%
% Usage:
%   [N,Range]=hist2d(X,B)
%
% Input:
%   X               N x 2 data matrix
%   B               number of bins
%
% Output: 
%   N               B x B matrix of co-occurences N(l,m) is the co-occurrence
%                   of bin m of X(:,1) with bin l of X(:,2)
%   Range           The ranges used to define the co-occurences
%
% Copyright 2013, Morten Mørup, Technical University of Denmark

minX=min(X);
maxX=max(X);
x_vals=linspace(minX(1)-eps*abs(minX(1)),maxX(1)+eps*abs(maxX(1)),B+1);
y_vals=linspace(minX(2)-eps*abs(minX(2)),maxX(2)+eps*abs(maxX(2)),B+1);
Range=[x_vals; y_vals];
N=zeros(B);
for k=1:length(x_vals)-1    
    Xt=X((X(:,1)>=x_vals(k)) & (X(:,1)<x_vals(k+1)),:);
    for kk=1:length(y_vals)-1                
        N(kk,k)=sum((Xt(:,2)>=y_vals(kk)) & (Xt(:,2)<y_vals(kk+1)));
    end
end