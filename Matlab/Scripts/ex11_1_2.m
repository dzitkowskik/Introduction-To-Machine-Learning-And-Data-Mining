% exercise 11.1.2

% x-values to evaluate the KDE
x = linspace(-10, 10, 100)';

% Compute kernel density estimate
f = ksdensity(X, x, 'width', 1);

% Plot kernel density estimate
mfig('Kernel density estimate'); clf;
plot(x, f);

