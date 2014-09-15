%% exercise 2.3.1

% Digit number to display
i = 1; 

% Load data
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/zipdata.mat'));

% Extract digits data
X = traindata(:,2:end);
y = traindata(:,1);

% Visualize the i'th digit as a vector
mfig('Digits: Data');
subplot(4,1,4);
imagesc(X(i,:));
xlabel('Pixel number');
title('Digit in vector format');
set(gca, 'YTick', []);

% Visualize the i'th digit as an image
subplot(4,1,1:3);
I = reshape(X(i,:), [16,16])';
imagesc(I);
colormap(1-gray);
axis image off
title('Digit as a image');
