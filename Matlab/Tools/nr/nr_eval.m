function y = nr_eval(netwrk, x)

%NR_EVAL - Compute output of neural network
%
% y = nr_eval(netwrk, x)
%
% Input:
%    netwrk : Neural network, struct variable returned from nr_main
%    x      : Matrix with example inputs as rows
%
% Output:
%    y      : Vector with output unit outputs as rows
%
% Neural network regressor, version 1.0
% Sigurdur Sigurdsson 2002, DTU, IMM, DSP.
% Mikkel N. Schmidt 2011, Tehcnical Unviersit of Denmark
% Morten Mørup 2011, Tehcnical Unviersit of Denmark

% Determine the number of examples and dimension
[N,D] = size(x);

% Normalize the training input data
if iscell(netwrk)
    y=zeros(N,length(netwrk));
   for c=1:length(netwrk)
       xt = (x-repmat(netwrk{c}.mean_x,N,1))./repmat(netwrk{c}.std_x,N,1);

       % Forward
       [dummy, y(:,c)] = nr_forward(netwrk{c}.Wi, netwrk{c}.Wo, xt); 
   end
else
    xt = (x-repmat(netwrk.mean_x,N,1))./repmat(netwrk.std_x,N,1);

    % Forward
    [dummy, y] = nr_forward(netwrk.Wi, netwrk.Wo, xt); 
end