% exercise 3.3.4

% Number of samples
N = 1000; 

% Mean
mu = [13 17];       

% Covariance matrix
S = [4 3;3 9];  

%% Generate samples from the Normal distribution
X = mvnrnd(mu, S, N);
