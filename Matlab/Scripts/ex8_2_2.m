% exercise 8.2.1

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/synth5'))

%% Fit model using boosting (AdaBoost)

% Number of rounds of boosting
L = 100;

% Allocate variable for model parameters
w_est = nan(M+1, L);

% Allocate variable for model importance weights
alpha = nan(1, L);

% Weights for selecting samples in each round of boosting
weights = ones(N,1)/N;
 
%% Boosting (AdaBoost)
% For each round of boosting
l = 1;
while l<=L
    % Choose data objects by random sampling with replacement 
    i = discreternd(weights, N);
%     for j=1:length(i)
%         i(j) = randsample(N,1,true,weights); 
%     end
     
    % Extract training set
    X_train = X(i, :);
    y_train = y(i);

    % Fit logistic regression model to training data and save result
    %if nnz(y_train == 0) == 0 || nnz(y_train == 1) == 0, 
    %    assert(false);
    %end
    %fprintf('%g, %g\n', nnz(y_train==0),nnz(y_train==1));
    w_est(:,l) = glmfit(X_train, y_train, 'binomial');
    %glmfit(X, y, 'binomial')
    % Make predictions on the whole data set
    p = glmval(w_est(:,l), X, 'logit');    
    
    y_est = p>0.5;
      
    % Compute error rate
    ErrorRate = sum(weights.*(y~=y_est))/N;
    
    %disp(sum(y~=y_est)/N)
    % Restart if error rate is above 50%
    % From Tan et al. p. 289: "In addition, if any intermediate rounds
    % produce an error rate higher than 50%, the weights are reverted back
    % to their original uniform values (...) and the resampling procedure
    % is repeated. 
    if ErrorRate > .5
        % Reset weights and do a new round
        weights = ones(N,1)/N;
        %disp('breaking, bad error rate');
        %disp(ErrorRate)
    else 
        % Compute model importance weight
        % Tan et al. p. 288, equation below equation 5.68
        alpha(l) = .5*log((1-ErrorRate)/ErrorRate);
 
        % Update weights
        % Tan et al. p. 288, equation 5.69
        weights(y==y_est) = weights(y==y_est)*exp(-alpha(l));
        weights(y~=y_est) = weights(y~=y_est)*exp(alpha(l));
        weights = weights/sum(weights);
        
        % Next round
        l = l+1;
    end    
end

% Normalize the importance weights
alpha = alpha/sum(alpha);

% Evaluate the logistic regression on the training data
p = glmval(w_est, X, 'logit');

% From Tan el al. p. 288: "Instead of using a majority voting scheme, the
% prediction made by each classifier (...) is weighted according to
% (alpha).
y_est = sum(bsxfun(@times, p>.5, alpha), 2)>.5;

% Compute error rate
ErrorRate = sum(y~=y_est)/N;
fprintf('Error rate: %.0f%%\n', ErrorRate*100);

%% Plot decision boundary
mfig('Decision boundary'); clf;
dbplot(X, y, @(X) sum(bsxfun(@times, glmval(w_est, X, 'logit')>.5, alpha), 2));
xlabel(attributeNames(1)); ylabel(attributeNames(2));
legend(classNames);