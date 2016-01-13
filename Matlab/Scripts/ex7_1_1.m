% exercise 7.1.1

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/synth1'))

%% Make a scatterplot of the data
mfig('Synthetic data'); clf; hold all;
Color = {'b', 'r', 'g', 'm'};
for c = 1:C
    plot(X_train(y_train==c-1,1), X_train(y_train==c-1,2), '.', 'Color', Color{c});
end
plot(X_test(:,1), X_test(:,2), 'kx');

%% K-nearest neighbors
K = 5; % Number of neighbors
Distance = 'euclidean'; % Distance measure

% Use knnclassify to find the K nearest neighbors
y_test_est = knnclassify(X_test, X_train, y_train, K, Distance);

% Plot estimated classes
mfig('Synthetic data'); hold all;
for c = 1:C
    plot(X_test(y_test_est==c-1,1), X_test(y_test_est==c-1,2), 'o', 'Color', Color{c});
end

% Plot confusion matrix
mfig('Confusion matrix');
confmatplot(classNames(y_test+1), classNames(y_test_est+1));