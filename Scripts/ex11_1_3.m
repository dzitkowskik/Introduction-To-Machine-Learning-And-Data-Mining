% exercise 11.1.3

% Number of components
K = 3;

% x-values to evaluate the GMM
x = linspace(-10, 10, 100)';

% Fit Gaussian mixture model
G = gmdistribution.fit(X, K);

% Plot GMM estimate
mfig('Gaussian mixture model'); clf;
plot(x, pdf(G, x));

