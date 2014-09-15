%% exercise 2.1.2
cdir = fileparts(mfilename('fullpath')); 
[A, D] = tmg(fullfile(cdir,'../Data/textDocs.txt'));
X = full(A)';
attributeNames = cellstr(D); 

%% Display the result
display(attributeNames);
display(X);