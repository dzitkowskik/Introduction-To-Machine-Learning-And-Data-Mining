function H = nc_gnhess(Wi,Wo,alpha,beta,Inputs,Targets)

% NC_GNHESS - Evaluate the Gauss-Newton approximated Hessian matrix of the cost function 
% 
% A = nc_gnhess(Wi,Wo,alpha,beta,Inputs,Targets)
%
% Inputs:
%    Wi      : The input-to-hidden weight matrix
%    Wo      : The hidden-to-output weight matrix
%    alpha   : The regularization parameter
%    beta    : The estimated scaled outlier probability
%    Inputs  : The input data matrix
%    Targets : The target labels
%
% Output:
%    A       : The Gauss-Newton Hessian matrix
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Gradient of the outputs w.r.t. the inputs of the network 
[grad_Wi,grad_Wo] = nc_gradientnet(Wi,Wo,Inputs,Targets);
g = [grad_Wi grad_Wo];

% Get some constants
Nc = size(grad_Wi,3);
Nwi = length(Wi(:));
Nwo = length(Wo(:));
Nw = Nwi + Nwo;
N = size(Inputs,1);

% Evaluate the network output
[Vj,yj] = nc_forward(Wi,Wo,Inputs);
z = nc_softmax(yj);

% Variable for the Hessian computation
zz = 1./(z*(1-beta*Nc)+beta);

% Start evaluating the Hessian 
H = zeros(Nw);
for i = 1:Nc
  dt_dw_i = zeros(N,Nw);
  for j = 1:Nc
    fi_j = g(:,:,j);
    if i == Nc
      dt_dw_i = dt_dw_i-repmat(z(:,i),1,Nw).*repmat(z(:,j),1,Nw).*fi_j;
    else
      if i==j
        dt_dw_i = dt_dw_i+repmat(z(:,i),1,Nw).*repmat(1-z(:,j),1,Nw).*fi_j;
      else
        dt_dw_i = dt_dw_i+repmat(z(:,i),1,Nw).*repmat(-z(:,j),1,Nw).*fi_j;
      end
    end
  end
  H = H+(repmat(zz(:,i),1,Nw).*dt_dw_i)'*dt_dw_i;
end

% Add the outlier term
H = (1-beta*Nc)^2*H;

% Add the regularization term
H = H + alpha*eye(Nw);