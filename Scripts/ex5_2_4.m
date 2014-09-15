% exercise 5.2.4

% Load wine data 
ex5_1_5;

% Fit linear regression model to predict Alcohol from all other attributes
y = X(:, 11);
Xr = X(:, 1:10);
w_est = glmfit(Xr, y, 'normal');

% Make a scatter plot of predicted versus true values of Alcohol
mfig('Alcohol content'); clf;
y_est = glmval(w_est, Xr, 'identity');
plot(y, y_est, '.');
xlabel('Alcohol (true)');
ylabel('Alcohol (estimated)');

% Make a histogram of the residual error
mfig('Residual error');
hist(y-y_est, 40);
