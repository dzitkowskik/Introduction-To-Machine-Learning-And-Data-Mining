% exercise 4.1.1

% Disable xlsread warning
warning('off', 'MATLAB:xlsread:ActiveX'); 
warning('off', 'MATLAB:xlsread:Mode'); 

% Load the data into Matlab
cdir = fileparts(mfilename('fullpath')); 
[NUMERIC, TXT, RAW] = xlsread(fullfile(cdir,'../Data/iris.xls'),1,'','basic');

% Extract the rows and columns corresponding to the data
if isnan(NUMERIC(1,1))
	X = NUMERIC(2:end,:);
else
	X = NUMERIC;
end

% Extract attribute names from the first row
attributeNames = RAW(1,1:4)';

% Extract unique class names from the last column
classLabels = RAW(2:end,5)';
classNames = unique(classLabels);

% Extract class labels that match the class names
[y_,y] = ismember(classLabels, classNames); y = y'-1;

% Get the number of data objects, attributes, and classes
[N, M] = size(X);
C = length(classNames);

