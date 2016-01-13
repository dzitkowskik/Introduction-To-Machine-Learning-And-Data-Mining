% exercise 3.3.5

% Number of samples
N = 1000; 

% Mean
mu = [13 17];       

% Standard deviation of x1
s1 = 2;

% Standard deviation of x2
s2 = 3;

% Correlation between x1 and x2
corr = 0;

% Covariance matrix
S = [s1^2 corr*s1*s2;corr*s1*s2 s2^2];

% Number of bins in histogram
NBins = 20;

%% Generate samples from the Normal distribution
X = mvnrnd(mu, S, N);

%% Plot scatter plot of data
mfig('2-D Normal distribution'); clf;

subplot(1,2,1);
plot(X(:,1), X(:,2), 'x');
axis equal;
xlabel('x_1'); ylabel('x_2');
title('Scatter plot of data');

subplot(1,2,2);
[n, x] = hist2d(X, NBins);
imagesc(x(1,:), x(2,:), n);
axis equal;
axis xy;
colorbar('South');
colormap(1-gray);
xlabel('x_1'); ylabel('x_2');
title('2D histogram');
