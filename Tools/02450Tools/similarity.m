function sim = similarity(X, Y, method)
% SIMILARITY Computes similarity matrices
%
% Usage:
%   sim = similarity(X, Y, method)
%
% Input:
%   X       N1 x M matrix
%   Y       N2 x M matrix 
%   method  string defining one of the following similarity measure
%           'SMC', 'smc'             : Simple Matching Coefficient
%           'Jaccard', 'jac'         : Jaccard coefficient 
%           'ExtendedJaccard', 'ext' : The Extended Jaccard coefficient
%           'Cosine', 'cos'          : Cosine Similarity
%           'Correlation', 'cor'     : Correlation coefficient
%
% Output:
%   sim     Estimated similarity matrix between X and Y
%           If input is not binary, SMC and Jaccard will make each
%           attribute binary according to x>median(x)
%
% Copyright, Morten Mørup and Mikkel N. Schmidt
% Technical University of Denmark

[N1, M] = size(X);
[N2, M] = size(Y);

switch lower(method(1:3))
    case 'smc' % SMC
        if ~all(ismember([X(:);Y(:)], [0 1])), [X,Y] = binarize(X,Y); end
        sim = ((X*Y')+((1-X)*(1-Y)'))/M;
    case 'jac' % Jaccard
        if ~all(ismember([X(:);Y(:)], [0 1])), [X,Y] = binarize(X,Y); end
        sim = (X*Y')./(M-(1-X)*(1-Y)');        
    case 'ext' % Extended Jaccard
        XYt = X*Y'; 
        sim = XYt./(log(exp(sum(X'.^2))'*exp(sum(Y'.^2)))-XYt);        
    case 'cos' % Cosine
         sim = (X*Y')./(sqrt(sum(X'.^2))'*sqrt(sum(Y'.^2)));         
    case 'cor' % Correlation
        X_ = zscore(X);
        Y_ = zscore(Y);
        sim = 1/(M-1)*X_*Y_'; 
end

function [X,Y] = binarize(X,Y)
disp('Attributes non-binary: Forcing representation to be binary.')
med = median([X;Y]);
X = double(bsxfun(@gt, X, med));
Y = double(bsxfun(@gt, Y, med));

