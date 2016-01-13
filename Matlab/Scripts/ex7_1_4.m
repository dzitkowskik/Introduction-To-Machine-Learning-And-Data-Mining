% exercise 7.1.4

% Load the wine data set
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/wine2'))

y = X(:, 11);
Xr = X(:, 1:10);

% K-nearest neighbors parameters
Distance = 'euclidean'; % Distance measure
L = 40; % Maximum number of neighbors

IDX = knnsearch(Xr,Xr,'K',L+1,'Distance',Distance);
IDX=IDX(:,2:end); % Remove distance for each point to itself

Error = nan(N,L);
for ll = 1:L % For each number of neighbours
    
    y_est= mean(y(IDX(:,1:ll)),2);    
    Error(:,ll) = (y-y_est).^2;

end

%% Plot the Regression least squares error
mfig('LS Error');
plot(sum(Error)/N);
xlabel('Number of neighbors');
ylabel('LS Error (%)');