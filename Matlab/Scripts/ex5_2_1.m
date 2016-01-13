% exercise 5.2.1

% Number of data objects
N = 100;

% Attribute values
X = (0:N-1)';

% Noise
epsilon = normrnd(0, 0.1, N, 1);

% Model parameters
w0 = -.5;
w1 = 0.01;

% Outputs
y = w0+w1*X+epsilon;

% Make a scatter plot
mfig('Linear regression'); clf;
plot(X, y, '.');
xlabel('X');
ylabel('y');
