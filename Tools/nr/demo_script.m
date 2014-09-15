% An script that shows the usage of the neural network regressor.
% The data set used is the sunspot data.

% Load the sunspot data:
% The data set has 12 inputs. There are 209 examples used
% for training and 35 are used for testing.
[x,t,x_test,t_test] = load_sunspot_data;

% Set the number of hidden units
Nh = 6;

% Train the network
disp('Network training, this might take a couple of minutes...')
results = nr_main(x,t,x_test,t_test,Nh);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                PLOT RESULTS                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the error
figure(1)
x_axis = 0:length(results.mse_test)-1;
plot(x_axis,results.mse_test,'r*-',x_axis,results.mse_train,'bo-')
xlabel('Number of hyperparameter updates')
ylabel('Mean square error')
legend('Test set','Training set')

% Plot the evolution of the hyperparameters
figure(2)
subplot(2,1,1)
plot(x_axis,results.alpha,'b*-')
xlabel('Number of hyperparameter updates')
ylabel('alpha value')
subplot(2,1,2)
plot(x_axis,results.beta,'b*-')
xlabel('Number of hyperparameter updates')
ylabel('beta value')

% Plot the network predictions
% Get the x-axis
load sunspot.dat
x_axis_train = sunspot(1:length(t),1);
x_axis_test = sunspot(length(t)+1:length(t)+length(t_test),1);

figure(3)
subplot(2,1,1)
plot(x_axis_train,results.t,'bo-',x_axis_train,results.t_pred_train,'r*-');
axis([1850 1900 0 1.0])
xlabel('Year')
ylabel('Number of sunspots (scaled)')
legend('Training set','Network prediction')

subplot(2,1,2)
plot(x_axis_test,results.t_test,'bo-',x_axis_test,results.t_pred_test,'r*-');
axis([1909 1943 0 1.2])
xlabel('Year')
ylabel('Number of sunspots (scaled)')
legend('Test set','Network prediction',2)
