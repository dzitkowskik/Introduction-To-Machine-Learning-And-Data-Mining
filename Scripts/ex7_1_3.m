% exercise 7.1.3

% Load data
ex4_1_1

% K-nearest neighbors parameters
Distance = 'euclidean'; % Distance measure
L = 40; % Maximum number of neighbors

IDX = knnsearch(X,X,'K',L+1,'Distance',Distance);
IDX=IDX(:,2:end); % Remove distance for each point to itself

class_count = nan(N,C);
Error = nan(1,L);
for ll = 1:L % For each number of neighbours
    
    % Count the number of observations in the neighbourhood belonging to each class
    for c=0:C-1
        class_count(:,c+1)=sum(y(IDX(:,1:ll))==c,2);
    end
    % Assign observations to the class with most observations
    y_est=max_idx(class_count)-1; % Ties are by max_idx very primitively handled by taking the first class
        
    Error(ll) = sum(y~=y_est); 
end

%% Plot the classification error rate
mfig('Error rate');
plot(Error/N*100);
xlabel('Number of neighbors');
ylabel('Classification error rate (%)');
