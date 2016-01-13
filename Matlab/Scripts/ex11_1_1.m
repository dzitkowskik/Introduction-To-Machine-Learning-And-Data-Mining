% exercise 11.1.1

% Number of data objects
N = 1000;

% x-values to evaluate the histogram
x = linspace(-10, 10, 50)';

% Number of attributes
M = 1;

% Allocate variable for data
X = nan(N,M);

% Mean and covariances
m = [1 3 6];
s = [1 .5 2];

% For each data object
for n = 1:N
    k = discreternd([1/3 1/3 1/3]);    
    X(n,1) = normrnd(m(k), sqrt(s(k)));
end

% Plot histogram
mfig('Histogram'); clf;
hist(X, x);
    