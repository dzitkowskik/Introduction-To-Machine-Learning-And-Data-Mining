function results = nr_main(x,t,x_test,t_test,Nh,state)

%NR_MAIN
%
% Main program for feed-forward neural network regression training
%
% The architecture has two-layers of weights and 
% tangent hyperbolic sigmoidal function.
%
% The network is trained using the BFGS optimization algorithm
% using soft line search to determine step lengths. The BFGS program
% was written by Hans Bruun Nielsen at IMM, DTU.
%
% The hyperparameters alpha and beta are adapted with MacKays 
% Bayesian MLII scheme with one regularization parameter for all weights.
%
% The Hessian matrix is evaluated using the Gauss-Newton approximation.
%
% This program is based on an older neural regression toolbox by 
% Morten With Pedersen in October 1995. Most of the routines have
% though been changed.
%
% res = nr_main(Inputs,Targets,Inputs_test,Targets_test,Nh,state);
%
% Inputs:
%    x       : Matrix with example inputs as rows 
%    t       : Matrix with example targets as rows 
%    x_test  : Matrix with example test inputs as rows 
%    t_test  : Matrix with example test targets as rows 
%    Nh      : Number of hidden units
%    state   : Random seed for weight initialization (Optional)
%  
% Output:
%    results : Struct variable holding the results from the network
%       .mse_test        : A vector representing the mean square error 
%                          on the test set at each hyperparameter update
%       .mse_train       : A vector representing the mean square error 
%                          on the training set at each hyperparameter update
%       .alpha           : A vector representing the value of the alpha 
%                          hyperparameter updates
%       .beta            : A vector representing the value of the beta 
%                          hyperparameter updates
%       .gamma           : A vector representing the number of "well determined"
%                          weights at each hyperparameter update
%       .cputime         : The training time in seconds
%       .Nh              : The number of hidden units
%       .x               : The normalized input patterns for training where
%                          x = (x_argin - repmat(mean_x,Ntrain,1))./repmat(std_x,Ntrain,1)
%       .t               : The target class labels for training
%       .x_test          : The normalized input patterns for testing
%                          x_test = (x_argin_test - repmat(mean_x,Ntest,1))./repmat(std_x,Ntest,1)
%       .t_test          : The target class labels for testing
%       .mean_x          : The mean subtracted from input patterns for normalization
%       .std_x           : The scaling of the input patterns for normalization
%       .t_pred_train    : The networks predicted target values on the test set
%       .var_pred_train  : The variance of the predicted target values, from
%                          the estimated noise variance and network uncertainty
%       .errorbars_train : The errorbar on each prediction, 2 times the standard deviation
%       .t_pred_test     : The networks predicted target values on the test set
%       .var_pred_test   : The variance of the predicted target values, from
%                          the estimated noise variance and network uncertainty
%       .errorbars_test  : The errorbar on each prediction, 2 times the standard deviation
%       .state           : The random seed used for initializing the weights
%       .Wi              : The input-to-hidden weight matrix
%       .Wo              : The hidden-to-output weight matrix
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Initialization of various parameters        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Scale and remove the mean of the input patterns
[x,x_test,results.mean_x,results.std_x] = nr_normalize_data(x,x_test);

% Get some size parameters
[N,Ni] = size(x);         % Number of external inputs and example
No = 1;                   % Number of output units
N_test = length(t_test);  % Number of test examples

% Initialize the hyperparameters
par.alpha = Ni;  % Regularization parameter
par.beta = 1;      % Inverse variance of additive noise

% Initialize the random seed for the weight initialization
if nargin < 6
  state = sum(100*clock);
end
randn('state',state);

% Parameters for hyperparameter convergence
max_count = 100;
STOP = 0;

% Collect parameters for the bfgs function
par.x = x;
par.t = t;
par.Ni = Ni;
par.Nh = Nh;

% Initialize network weights
[Wi,Wo] = nr_winit(Ni,Nh);

% Change the weights matrices into a weight vector
Weights = [Wi(:);Wo(:)];

% Options for the BFGS algorithm and soft linesearch
% see the ucminf.m file for detailes
opts = [1  1e-4  1e-8  1000];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Train the network                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start taking the training time
t_cpu = cputime;

% Initialize the counter
count = 0;

% Train the network until parameters have converged
while (STOP==0)

  % Increment counter
  count = count + 1;

  % Train the weights
  Weights = ucminf('nr_net',par,Weights,opts);

  % Save some values of hyperparameters convergence
  results.alpha(count) = par.alpha;
  results.beta(count) = par.beta;

  % Save the test and training MSE
  [Wi,Wo] = nr_W2Wio(Weights,Ni,Nh);
  results.mse_test(count) = nr_cost(Wi,Wo,0,2/N_test,x_test,t_test);
  results.mse_train(count) = nr_cost(Wi,Wo,0,2/N,x,t);

  % Save the old hyperparameters
  par.old_alpha = par.alpha;
  par.old_beta = par.beta;

  % Update the hyperparameters
  [par,results.gamma(count)] = nr_hyperparameters(Weights,par);

  % Check for convergence of hyperparameters (internal function)
  STOP = check_convergence(par,max_count,count);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Save some results from the modeling        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Save the random state
results.state = state;

% Time used for training
results.cputime = cputime-t_cpu;

% Number of hidden units
results.Nh = Nh;

% The dataset, inputs and labels
results.x = x;
results.t = t;
results.x_test = x_test;
results.t_test = t_test;

% Save the weights
results.Wi = Wi;
results.Wo = Wo;

% Compute the predictions on the test set, variance and errorbars
[results.t_pred_test,results.var_pred_test] = nr_predictions(Wi,Wo,par,x_test);
results.errorbars_test = 2*sqrt(results.var_pred_test);

% Compute the predictions on the traing set, variance and errorbars
[results.t_pred_train,results.var_pred_train] = nr_predictions(Wi,Wo,par,x);
results.errorbars_train = 2*sqrt(results.var_pred_train);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Internal functions              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function STOP = check_convergence(par,max_count,count)
% Check if modeling is finished

% Stop if exceeding maximum number of iteration
if (count >= max_count)
  STOP = 1;
  return;
end

% Check the relative changes of the hyperparameters
alpha_diff = abs(par.alpha-par.old_alpha)/par.alpha;
beta_diff = abs(par.beta-par.old_beta)/par.beta;

% Determine the convergence
if (alpha_diff < 1e-5) & (beta_diff < 1e-5)
  STOP = 1;
else
  STOP = 0;
end