% exercise 4.2.1

% Load the data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/wine'));

% We start with a box plot of each attribute
mfig('Wine: Boxplot');
boxplot(X, attributeNames, 'LabelOrientation', 'inline');

% From this it is clear that there are some outliers in the Alcohol
% attribute (10x10^14 is clearly not a proper value for alcohol content)
% However, it is impossible to see the distribution of the data, because
% the axis is dominated by these extreme outliers. To avoid this, we plot a
% box plot of standardized data (using the zscore function).

mfig('Wine: Boxplot (standardized)');
boxplot(zscore(X), attributeNames, 'LabelOrientation', 'inline');

% This plot reveals that there are clearly some outliers in the Volatile
% acidity, Density, and Alcohol attributes, i.e. attribute number 2, 8,
% and 11. 
 
% Next, we plot histograms of all attributes.

mfig('Wine: Histogram'); clf;
for m = 1:M
    u = floor(sqrt(M)); v = ceil(M/u);
    subplot(u,v,m);
	hist(X(:,m));
	xlabel(attributeNames{m});      
	axis square;
end
linkax('y'); % Makes the y-axes equal for improved readability

% This confirms our belief about outliers in attributes 2, 8, and 11.
% To take a closer look at this, we next plot histograms of the 
% attributes we suspect contains outliers

mfig('Wine: Histogram (attributes 2, 8, and 11)'); clf;
m = [2 8 11];
for i = 1:3    
   subplot(1,3,i,'align');
   hist(X(:,m(i)),50);
   xlabel(attributeNames{m(i)});
end
linkax('y'); % Makes the y-axes equal for improved readability

% The histograms show that there are a few very extreme values in these
% three attributes. To identify these values as outliers, we must use our
% knowledge about the data set and the attributes. Say we expect volatide
% acidity to be around 0-2 g/dm^3, density to be close to 1 g/cm^3, and
% alcohol percentage to be somewhere between 5-20 % vol. Then we can safely
% identify the following outliers, which are a factor of 10 greater than
% the largest we expect.

idxOutlier = find(X(:,2)>20 | X(:,8)>10 | X(:,11)>200);

% Finally we will remove these from the data set
X(idxOutlier,:) = [];
y(idxOutlier) = [];
N = N-length(idxOutlier);

% Now, we can repeat the process to see if there are any more outliers
% present in the data. We take a look at a histogram of all attributes:

mfig('Wine: Histogram (after outlier detection)'); clf;
for m = 1:M
    u = floor(sqrt(M)); v = ceil(M/u);
    subplot(u,v,m);
	hist(X(:,m));
	xlabel(attributeNames{m});      
	axis square;
end
linkax('y'); % Makes the y-axes equal for improved readability

% This reveals no further outliers, and we conclude that all outliers have
% been detected and removed.
