% An script that shows the usage of the neural classifier for multiple
% classes. The data set used is the well known forensic glass data.

% Load the forensic glass data:
% The data set containes 6 classes and 9 inputs. The 107 examples are use
% for training and 53 are used for testing.
% See 'Pattern Recognition and Neural Networks' by B.D. Ripley (1996) page 13 for detailes.
load forensic_glass_data_small

% Set the number of hidden units
Nh = 7;

% Train the network
disp('Network training, this might take a couple of minutes ...')
results = nc_main(x,t,x_test,t_test,Nh);

% Plot the error
figure(1)
x_axis = 0:length(results.Etest)-1;
plot(x_axis,results.Etest,'r*-',x_axis,results.Etrain,'bo-')
xlabel('Number of hyperparameter updates')
ylabel('Average cross-entropy error')
legend('Test set','Training set')

% Plot the classification error
figure(2)
plot(x_axis,results.Ctest,'r*-',x_axis,results.Ctrain,'bo-')
xlabel('Number of hyperparameter updates')
ylabel('Classification error')
legend('Test set','Training set')

% Plot the evolution of the hyperparameters
figure(3)
subplot(2,1,1)
plot(x_axis,results.alpha,'b*-')
xlabel('Number of hyperparameter updates')
ylabel('alpha value')
subplot(2,1,2)
plot(x_axis,results.beta,'b*-')
xlabel('Number of hyperparameter updates')
ylabel('beta value')
