%% exercise 2.1.2
cdir = fileparts(mfilename('fullpath')); 
OPTIONS.stoplist = fullfile(cdir,'../Data/stopWords.txt');
OPTIONS.stemming = 1;
[A, D] = tmg(fullfile(cdir,'../Data/textDocs.txt'), OPTIONS);
X = full(A)';
attributeNames = cellstr(D); 

%% Display the result
display(attributeNames);


%% display(X);