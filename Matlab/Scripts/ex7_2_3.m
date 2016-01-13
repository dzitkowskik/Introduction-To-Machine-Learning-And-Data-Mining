% exercise 7.2.3

%% Read male and female names and extract features
cdir = fileparts(mfilename('fullpath')); 
male = importdata(fullfile(cdir,'../Data/male.txt'),'\n');
female = importdata(fullfile(cdir,'../Data/female.txt'),'\n');

% Filter the data to remove names that are less than four letters long
idx_male = cellfun(@(x) length(x)>=4, male);    
idx_female = cellfun(@(x) length(x)>=4, female);    
male=male(idx_male);
female=female(idx_female);

% Extract male name features
Xmale = lower(cellfun(@(x) [x(1) x(2) x(end-1) x(end)], male, 'UniformOutput', false));
Xmale = double(char(Xmale))-double('a')+1;

% Extract female name features
Xfemale = lower(cellfun(@(x) [x(1) x(2) x(end-1) x(end)], female, 'UniformOutput', false));
Xfemale = double(char(Xfemale))-double('a')+1;

% Concatenate male and female
X = [Xmale; Xfemale];

% Make class indices etc.
y = [zeros(size(Xmale,1),1); ones(size(Xfemale,1),1)];
[N,M] = size(X);
C = 2;
attributeNames = {'1st letter', '2nd letter', 'Next-to-last letter', 'Last letter'};
classNames = {'Female', 'Male'};
