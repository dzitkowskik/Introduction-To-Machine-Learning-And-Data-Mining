% exercise 3.2.1

% Image to use as query
i = 1;

% Similarity: 'SMC', 'Jaccard', 'ExtendedJaccard', 'Cosine', 'Correlation' 
SimilarityMeasure = 'cos';

%% Load the CBCL face database
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/wildfaces_grayscale.mat'));
[N,M] = size(X);

%% Search the face database for similar faces

% Index of all other images than i
noti = [1:i-1 i+1:N]; 
% Compute similarity between image i and all others
sim = similarity(X(i,:), X(noti,:), SimilarityMeasure);
% Sort similarities
[val, j] = sort(sim, 'descend');

%% Plot query and result
mfig('Faces: Query'); clf;
subplot(3,5,1:5);
imagesc(reshape(X(i,:),[40,40]));
axis image
set(gca, 'XTick', [], 'YTick', []);
ylabel(sprintf('Image #%d', i));
title('Query image','FontWeight','bold');
for k = 1:5
    subplot(3,5,k+5)
    ii = noti(j(k));
    imagesc(reshape(X(ii,:),[40,40]));
    axis image
    set(gca, 'XTick', [], 'YTick', []);
    xlabel(sprintf('sim=%.2f', val(k)));
    ylabel(sprintf('Image #%d', ii));
    if k==3, title('Most similar images','FontWeight','bold'); end;
end
for k = 1:5
    subplot(3,5,k+10)
    ii = noti(j(end+1-k));
    imagesc(reshape(X(ii,:),[40,40]));
    axis image
    set(gca, 'XTick', [], 'YTick', []);
    xlabel(sprintf('sim=%.3f', val(end+1-k)));
    ylabel(sprintf('Image #%d', ii));
    if k==3, title('Least similar images','FontWeight','bold'); end;
end
colormap(gray);
