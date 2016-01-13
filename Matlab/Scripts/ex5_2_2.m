% exercise 5.2.2

% Estimate model parameters
w_est = glmfit(X, y, 'normal');

% Plot the predictions of the model
mfig('Linear regression'); clf; hold all
plot(X, y, '.');
y_est = w_est(1)+w_est(2)*X;
plot(X, y_est, 'r');
y_true = w0+w1*X;
plot(X, y_true, 'g');
xlabel('X');
ylabel('y');
legend('Data', 'Fitted model', 'True model');