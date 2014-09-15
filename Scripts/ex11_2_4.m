% exercise 11.2.4

% Neighbor to use
K = 5;

% Find the k nearest neighbors
[i, D] = knnsearch(X, X, 'K', K+1);

% Outlier score
f = D(:,K+1);

% Sort the outlier scores
[y,i] = sort(f, 'descend');

% Display the index of the lowest density data object
% The outlier should have index 1001
disp(i(1));

% Plot kernel density estimate outlier scores
mfig('Distance: Outlier score'); clf;
bar(y(1:20));



