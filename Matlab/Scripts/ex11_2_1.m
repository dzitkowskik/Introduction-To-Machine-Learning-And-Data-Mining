% exercise 11.2.1

% Kernel width
w = 5;

% Outlier scores
% Compute kernel density estimate
f = ksdensity(X, X, 'width', w);

% Sort the densities
[y,i] = sort(f);

% Display the index of the lowest density data object
% The outlier should have index 1001
disp(i(1));

% Plot density estimate outlier scores
mfig('Outlier score'); clf;
bar(y(1:20));


