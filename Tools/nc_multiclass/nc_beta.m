function beta = nc_beta(W,par)

%NC_BETA - Compute the estimated scaled outlier probability with 
%          Brent's method for fitting quadratic functions. For further
%          information see 'Numerical recipies in C'.
%
% beta = nc_beta(W,par)
%  
% Input:
%    W    : The weight vector
%    par  : Struct variable with all other parameters
%
% Output:
%    beta : The estimated scaled outlier probability
%
% Neural classifier for multiple classes, version 1.0
% Sigurdur Sigurdsson 2002, DSP, IMM, DTU.

% Transform the weights from a weight vector to matrices
[Wi,Wo] = nc_W2Wio(W,par.Ni,par.Nh,par.No);

% Change variable names
Inputs = par.x;
Targets = par.t;
alpha = par.alpha;
beta = par.beta;

% Some constants for Brent's method
tol = sqrt(eps)*2;
ZEPS = 1e-10;
ee = 0;
CGOLD = 0.3819660;
ITMAX = 100;

% Initial values to search beta
xx = [0 beta 0.99*1/size(Wo,1)];

% Initialize the points
for i = 1:3
  % Compute the Hessian
  A = nc_gnhess(Wi,Wo,alpha,xx(i),Inputs,Targets);
  % Compute the log det of the Hessian
  logdetA = 2*sum(log(diag(chol(A))));
  % Compute the value of the function for point i
  f(i) = nc_cost(Wi,Wo,alpha,xx(i),Inputs,Targets)+0.5*logdetA;
end

% Initialization
a = xx(1);b = xx(3);x = xx(2);w = xx(2);v = xx(2);
fx = f(2);fw = f(2);fv = f(2);

for iter = 1:ITMAX

  xm = 0.5*(a+b);
  tol1 = tol*abs(x)+ZEPS;
  tol2 = 2*tol1;
  
  if (abs(x-xm) <= (tol2-0.5*(b-a)))
    beta = x;
    break;
  end
  
  if (abs(ee) > tol1)
    r = (x-w)*(fx-fv);
    q = (x-v)*(fx-fw);
    p = (x-v)*q-(x-w)*r;
    q = 2*(q-r);
    if (q > 0)
      p = -p;
    end
    q = abs(q);    
    etemp = ee;
    ee = d;
    if (abs(p) >= abs(0.5*q*etemp) | p <= q*(a-x) | p >= q*(b-x))
      if (x >= xm)
        ee = a-x;
      else
        ee = b-x;
      end
      d = CGOLD*ee;
    else
      d = p/q;
      u = x+d;
      if (u-a < tol2 | b-u < tol2)
        if (xm-x >= 0)
           d = abs(tol1);
        else
           d = -abs(tol1);
        end
      end
    end
  else
    if (x >= xm)
      ee = a-x;
    else
      ee = b-x; 
    end
    d = CGOLD*ee; 
  end
  
  if (abs(d) >= tol1)
    u = x+d;
  else
    if d >= 0
      u = x+abs(tol1);
    else
      u = x-abs(tol1);
    end
  end

  % Compute the Hessian
  A = nc_gnhess(Wi,Wo,alpha,u,Inputs,Targets);
  % Compute the log det of the Hessian
  logdetA = 2*sum(log(diag(chol(A))));
  % Compute the value of the function for point i
  fu = nc_cost(Wi,Wo,alpha,u,Inputs,Targets)+0.5*logdetA;
  
  if (fu <= fx)
    if (u >= x)
      a = x;
    else
      b = x;
    end
    v = w;w = x;x = u;
    fv = fw;fw = fx;fx = fu;
  else
    if (u < x)
      a = u;
    else
      b = u;
    end
    if (fu <= fw | w == x)
      v = w;w = u;fv = fw;fw = fu;
    elseif (fu <= fv | v == x | v == w)
      v = u;fv = fu;
    end
  end
  if (iter == ITMAX)
    disp('Maximun number of iterations')
    beta = x;
  end
end

