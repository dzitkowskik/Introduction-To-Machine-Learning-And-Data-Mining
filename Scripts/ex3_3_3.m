% exercise 3.3.3

% Number of samples
N = 1000; 

% Mean
mu = 17;       

% Standard deviation
s = 2;  

% Number of bins in histogram
NBins = 50;

%% Generate samples from the Normal distribution
X = normrnd(mu, s, N, 1);

% Plot a histogram
mfig('Normal distribution'); clf; hold all;
[n, x] = hist(X, NBins);
bar(x, n/N./gradient(x));
x = linspace(min(x), max(x), 1000);
plot(x, normpdf(x, mu, s), 'r', 'LineWidth', 5);
xlim([min(x), max(x)]);

%% Compute empirical mean and standard deviation
mu_ = mean(X);
s_ = std(X);

display(mu_);
display(s_);