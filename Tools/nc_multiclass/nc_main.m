function results = nc_main(x,t,x_test,t_test,Nh,state);

%NC_MAIN    Neural classifier main program
%  Main program for neural network training
%  This program implements classification using the SOFTMAX function
%
%  The network is trained using the BFGS optimization algorithm
%  using soft line search to determine step lengths.
%  The regularization is adapted with MacKays Bayesian MLII scheme
%  with only one regularization parameter for all weights.
%  Outlier probability is also implemented using Bayesian MLII estimates and
%  Brent's method for fitting quadratic functions
%
%  This program is based on an older neural classifier programmed by 
%  Morten With Pedersen in February 1997. The following has been added
%  *Adaptive regularization with MacKays evidence scheme. 2001 Siggi 
%  *Gauss-Newton Hessian matrix evaluation.               2001 Siggi 
%  *Outlier model based on Gaussian approximation.        2001 Siggi
%  *Use BFGS algorithm for weigth optimization.           2001 Siggi
%
%  The BFGS program was written by Hans Bruun Nielsen at IMM, DTU.
%
%  results = nc_main_outlier(x,t,x_test,t_test,Nh,state);
%
%  Inputs:
%     x       : Matrix with training examples as rows
%     t       : Column vector with class labels (1 to #Classes)
%     x_test  : Matrix with test examples as rows
%     t_test  : Column vector with class labels (1 to #Class)
%     Nh      : Number of hidden units
%     state   : Intger random seed for weight initialization (Optional) 
%
%  Output:
%     results : Struct variable with all information on the network
%       .Ctest       : A vector representing the classification error 
%                      on the test set at each hyperparameter update
%       .Ctrain      : A vector representing the classification error 
%                      on the training set at each hyperparameter update
%       .Etest       : A vector representing the cross-entropy error 
%                      on the test set at each hyperparameter update
%                      with beta set to 0 and averaged over test examples
%       .Etrain      : A vector representing the cross-entropy error 
%                      on the training set at each hyperparameter update
%                      with beta set to 0 and averaged over training examples
%       .alpha       : A vector representing the value of the alpha 
%                      hyperparameter updates
%       .beta        : A vector representing the value of the beta 
%                      hyperparameter updates
%       .gamma       : A vector representing the number of "well determined"
%                      weights at each hyperparameter update
%       .cputime     : The training time in seconds
%       .Nh          : The number of hidden units
%       .x           : The normalized input patterns for training where
%                      x = (x_argin - repmat(mean_x,Ntrain,1))./repmat(std_x,Ntrain,1)
%       .t           : The target class labels for training
%       .x_test      : The normalized input patterns for testing
%                      x_test = (x_argin_test - repmat(mean_x,Ntest,1))./repmat(std_x,Ntest,1)
%       .t_test      : The target class labels for testing
%       .mean_x      : The mean subtracted from input patterns for normalization
%       .std_x       : The scaling of the input patterns for normalization
%       .Poutlier    : The outlier probability of each example in the training set where
%                      a value higher than 0.5 indicates that the examples is an outlier
%       .p_train     : The conditional class probability for all training examples
%                      and classes using the outlier probability
%       .p_test      : The conditional class probability for all test examples
%                      and classes using the outlier probability
%       .t_est_train : The estimated class labels for the training examples
%       .t_est_test  : The estimated class labels for the test examples
%       .state       : The random seed used for initializing the weights
%       .Wi          : The input-to-hidden weight matrix
%       .Wo          : The hidden-to-output weight matrix
%
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% References
%
%@article{ mackay92evidence,
%    author = "MacKay, D.",
%    title = "The Evidence Framework Applied to Classification Networks",
%    journal = "Neural Computation",
%    volume = "4",
%    number = "5",
%    pages = "720--736",
%    year = "1992",
%    url = "citeseer.nj.nec.com/mackay92evidence.html" }
%
%@article{ mackay92practical,
%    author = "David J. C. MacKay",
%    title = "A practical {B}ayesian framework for backpropagation networks",
%    journal = "Neural Computation",
%    volume = "4",
%    pages = "448--472",
%    year = "1992"}
%
%@InProceedings{sigurdsson02,
%  author = {S.\ Sigurdsson and J.\ Larsen and L.K.\ Hansen},
%  title = {{Outlier estimation and detection: Application to Skin Lesion Classification}},
%  booktitle = {{To appear in Proceedings of the 2002 International Conference on
%              Acoustics, Speech and Signal Processing}},}
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Initialization of various parameters        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Scale and remove the mean of the input patterns
[x,x_test,results.mean_x,results.std_x] = nc_normalize_data(x,x_test);

% Determine the number of inputs and outputs
Ni = size(x,2);
No = max(t);

% Determine the number of training and test examples
Ntrain = length(t);
Ntest = length(t_test);

% Random seed for the weight initialization
if nargin < 6
  state = sum(100*clock);
end
randn('state',state);
  
% Initial hyperparameter values, small values 
par.alpha = Ni;
par.beta = 0;

% Parameters for network convergence;
% Number of hyperparameter updates
max_count = 100

% Initialize network weights
[Wi,Wo] = nc_winit(Ni,Nh,No);

% Collect data and parameters for training
par.x = x;
par.t = t;
par.Ni = Ni;
par.No = No;
par.Nh = Nh;

% Options for the BFGS algorithm and soft linesearch
% see the ucminf.m file for detailes
opts = [1  1e-4  1e-8  1000];

% Make a weight vector from the two layer matrices
W = [Wi(:);Wo(:)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Train the network                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start taking the training time
t_cpu = cputime;

% Initialize the counter for hyperparameter update
count = 0;

% Train the network until parameters have converged
STOP = 0;
while (STOP==0)
  
  % Increment the counter
  count = count+1
  
  % Training of the network weights
  W = ucminf('nc_network',par,W,opts);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %            Save some results of hyperparameters update                % 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Convert the weights from vector to matrices                           %
  [Wi,Wo] = nc_W2Wio(W,Ni,Nh,No);                                         %
  % Classification error for test and training                            %
  results.Ctest(count) = nc_err_frac(Wi,Wo,par.beta,x_test,t_test);       %
  results.Ctrain(count) = nc_err_frac(Wi,Wo,par.beta,x,t);                %
  % Mean square error for test and training                               %
  results.Etest(count) = 2/Ntest*nc_cost(Wi,Wo,0,0,x_test,t_test);        %
  results.Etrain(count) = 2/Ntrain*nc_cost(Wi,Wo,0,0,x,t);                %
  % Hyperparameters                                                       %
  results.alpha(count) = par.alpha;                                       %
  results.beta(count) = par.beta;                                         %
  % Model selection                                                       %
  %results.log_evidence(count) = nc_evidence(Wi,Wo,par.alpha,par.beta,x,t);%  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Save the old hyperparameters
  par.old_alpha = par.alpha;
  par.old_beta = par.beta;
  
  % Update the estimated outlier probability
  par.beta = nc_beta(W,par);
  
  % Adapt the regularization parameters
  [par.alpha,results.gamma(count)] = nc_alpha(W,par);
  
  % Check for convergence of hyperparameters (internal function)
  STOP = check_convergence(par,max_count,count);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Save some results from the training        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Time used for training
results.cputime = cputime-t_cpu;

% Number of hidden units
results.Nh = Nh;

% The data set; inputs and labels for both test and training set
results.x = x;
results.t = t;
results.x_test = x_test;
results.t_test = t_test;

% The outlier probability of the training examples
results.Poutlier = nc_outlier_probs(Wi,Wo,par.beta,x,t);

% The output probability of the training and test set for all classes
[results.p_train,results.t_est_train] = nc_output_probs(Wi,Wo,par.beta,x);
[results.p_test,results.t_est_test] = nc_output_probs(Wi,Wo,par.beta,x_test);

% Save the random state
results.state = state;

% Save the weights
results.Wi = Wi;
results.Wo = Wo;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Internal functions              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function STOP = check_convergence(par,max_count,count)
% Check if the hyperparameters have converged

% Stop if exceeding maximum number of iteration
if (count >= max_count)
  STOP = 1;
  return;
end

% Check the relative changes of the hyperparameters
alpha_diff = abs(par.alpha-par.old_alpha)/par.alpha;
if par.beta == 0
  beta_diff = abs(par.beta-par.old_beta);
else
  beta_diff = abs(par.beta-par.old_beta)/par.beta;
end

% Determine the convergence
if (alpha_diff < 1e-5) & (beta_diff < 1e-5)
  STOP = 1;
else
  STOP = 0;
end
