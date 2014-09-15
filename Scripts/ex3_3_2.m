% exercise 3.3.2

% Number of samples
N = 100; 

% Mean
mu = 17;       

% Standard deviation
s = 2;  

% Number of bins in histogram
NBins = 10;

%% Generate samples from the Normal distribution
X = normrnd(mu, s, N, 1);

%% Plot a histogram
mfig('Normal distribution');
subplot(1,2,1);
plot(X, 'x');
subplot(1,2,2);
hist(X, NBins);

%% Compute empirical mean and standard deviation
mu_ = mean(X);
s_ = std(X);

display(mu_);
display(s_);