% exercise 5.2.3

% Number of data objects
N = 50;

% Number of non-linear terms in generated data
Kd = 2;

% Number of non-linear terms in model
Km = 2;

% Noise variance
s = 0.5;

% X-values to evaluate model and fit
Xe = linspace(-1, 1, 1000)';

%% Data set generation

% Attribute values
X = linspace(-1, 1, N)';
Xd = bsxfun(@power, X, 1:Kd);
Xde = bsxfun(@power, Xe, 1:Kd);

% Noise
epsilon = normrnd(0, s, N, 1);

% Model parameters
w = -(-.9).^(1:Kd+1)';

% Outputs
y = [ones(N,1) Xd]*w+epsilon;


%% Model to fit

% Attribute values
Xm = bsxfun(@power, X, 1:Km);
Xme = bsxfun(@power, Xe, 1:Km);

% Estimate model parameters
w_est = glmfit(Xm, y, 'normal');

% Plot the predictions of the model
mfig('Linear regression'); clf; hold all
plot(X, y, '.');
y_est = glmval(w_est, Xme, 'identity');
plot(Xe, y_est, 'r');
y_true = glmval(w, Xde, 'identity');
plot(Xe, y_true, 'g');
xlabel('X');
ylabel('y');
legend('Data', 'Fitted model', 'True model');
ylim([-2 8]);
