function i = discreternd(p, varargin)
% DISCRETERND Random numbers from a discrete distribution
%
% Usage:
%   p = [.5 .25 .25];
%   i = discreternd(p) 
%      Generates a random number in {1,2,3} with 50 pct. probability of
%      being 1 and 25 pct. probability of being 2 or 3.
%
%   i = discreternd(p, M, N, ...) 
%      Returns an N-by-M-by-... array.
%
% Input:
%   p           Vector of (relative) probabilities. If p sums to one, each 
%               element in p is the probability of generating the 
%               corresponding integer. If p is not normalized it denotes 
%               the relative probability.
%   M, N, ...   Size of the returned array.
%
% Output:
%   i           Array of size M-by-N-by-... of random integers
%               between 1 and length(p).
%
% Copyright 2011, Mikkel N. Schmidt, Technical University of Denmark

if nargin>1
    n = varargin{:};
else
    n = 1;
end
i = sum(~bsxfun(@gt, cumsum(p(:)'), rand(n,1)*sum(p(:))),2)+1;
