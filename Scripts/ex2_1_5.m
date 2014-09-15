%% exercise 2.1.5

% Query vector
q = [0; 0; 0; 0; 0; 0; 0; 1; 0; 0; 0; 0; 1; 1; 0; 0; 0]';

%% Method #1 (a for loop)
N = size(X,1); % Get the number of data objects
sim = nan(N,1); % Allocate a vector for the similarity
for i = 1:N
    x = X(i,:); % Get the i'th data object
    sim(i) = dot(q/norm(q),x/norm(x)); % Compute cosine similarity
end

%% Method #2 (one compact line of code)
sim = (q*X')'./(sqrt(sum(X.^2,2))*sqrt(sum(q.^2)));

%% Method #3 (use the "similarity" function)
sim = similarity(X, q, 'cos');

%% Display the result
display(sim);