%% exercise 2.2.1
% Load the data into Matlab
cdir = fileparts(mfilename('fullpath')); 
[NUMERIC, TXT, RAW] = xlsread(fullfile(cdir,'../Data/nanonose.xls'));

% Extract the rows and columns corresponding to the sensor data, and
% transpose the matrix to have rows correspond to data items
X = NUMERIC(:,3:10);

% Extract attribute names from the first column
attributeNames = RAW(1,4:end);

% Extract unique class names from the first row
classLabels = RAW(3:end,1);
classNames = unique(classLabels);

% Extract class labels that match the class names
[y_,y] = ismember(classLabels, classNames); y = y-1;
 