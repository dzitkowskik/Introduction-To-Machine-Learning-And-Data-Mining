function bmplot(i,j,X)
% BMPLOT Plots a binary matrix 
%
% Usage:
%   bmplot(i, j, X);
%
% Input:
%     i : labels for rows
%     j : Labels for columns
%     X : Binary data matrix of size length(i) x length(j)
%
% Copyright 2011 Mikkel N. Schmidt, Technical University of Denmark

c0 = [1 1 1];
c1 = [.2 .5 .4];
c2 = [.7 .8 .8];

[I,J] = size(X);
imagesc(X);
colormap([c0;c1]);
set(gca, 'XTick', 1:J);
set(gca, 'YTick', 1:I)
set(gca, 'YTickLabel', i);
set(gca, 'XTickLabel', j);
set(gca, 'TickLength', [0 0]);
box on;
for i=1:I
    line([.5, J+.5], [1,1]*i-.5, 'Color', c2); 
end
for j=1:J
    line([1,1]*j-.5, [.5, I+.5], 'Color', c2); 
end
axis image