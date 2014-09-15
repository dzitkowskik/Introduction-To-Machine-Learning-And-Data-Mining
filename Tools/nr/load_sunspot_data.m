function [x,t,x_test,t_test] = load_sunspot_data

% Load the sunspot data
% [x,t,x_test,t_test,x_test1,t_test1] = load_sunspot_data

% Load the raw data
load sunspot.dat
sunspot = sunspot(:,2);

% Set the number of inputs and examples
Ninputs = 12;
N = 244;

% Make the targets and scale 
T = sunspot((Ninputs+1):(N+Ninputs),:)/max(sunspot(1:N+Ninputs));

% Make the input patterns
X = zeros(N,Ninputs);
for n = 1:N
  X(n,:) = sunspot(n:n+Ninputs-1)';
end

% Split data into training and test sets
x = X(1:209,:);
x_test = X(210:end,:);
t = T(1:209);
t_test = T(210:end);
