function clusterplot(X, y, i, varargin)
% CLUSTERPLOT Plots a clustering of a data set as well as the true class
% labels. If data is more than 2-dimensional they are projected onto the
% first two principal components. Data objects are plotted as a dot with a
% circle around. The color of the dot indicates the true class, and the
% cicle indicates the cluster index.
%
% Usage:
%    clusterplot(X, y, i) where X is an N-by-M matrix of attribute
%    values, y is an N-by-1 vector of class labels, and i is an N-by-1
%    vector of cluster indices. N is the number of data objects and C is
%    the number of classes.
%
%    clusterplot(X, y, i, Xc) where Xc is an K-by-M matrix of cluster
%    centroids plots centroids as crosses.
%
%    If the number of attributes is M=2, the clustering is plotted in the
%    attribute space. If M>2, the clusteringis plotted in the plane spanned
%    by the first two principal components. 
%
% Input:
%    X         N-by-M matrix of attribute values for N data objects with M
%              attributes.
%    y         N-by-1 vector of class labels 
%    i         N-by-1 vector of cluster indices
%    Xc        K-by-M matrix of cluster centroids (optional)
%    Covc      M-by-M-by-K tensor of covariance matrices (optional)
%
% Copyright 2011, Mikkel N. Schmidt, Technical University of Denmark

[N,M] = size(X);

if nargin>3    
    centroids = varargin{1};
    if length(varargin)>1
        Sigmas = varargin{2};
    else
        Sigmas=[];
    end
else
    centroids = zeros(0,M);
    Sigmas=[];
end


DoPCA = M>2;
if DoPCA
    mX = mean(X);
    Z = bsxfun(@minus, X, mX);
    [U,S,V] = svd(Z, 'econ');
     X = U(:,1:2)*S(1:2,1:2);
    V=V(:,1:2);
    centroids = bsxfun(@minus, centroids, mX)*V;
    if ~isempty(Sigmas)
        Sigmas_old=Sigmas;
        Sigmas=zeros(size(V,2),size(V,2),size(Sigmas,3));
        for n=1:size(Sigmas,3)
            Sigmas(:,:,n)= V'*Sigmas_old(:,:,n)*V;
        end
    end
end

xRange = [min(X(:,1)), max(X(:,1))];
xRange = xRange + [-1 1]*range(xRange)*0.05;
yRange = [min(X(:,2)), max(X(:,2))];
yRange = yRange + [-1 1]*range(yRange)*0.05;

AxisNextPlot = get(gca, 'NextPlot');
ColorOrder = get(gca, 'ColorOrder');
Ncol = size(ColorOrder,1);

C = max(y)+1;

% Plot clustering
ui = unique(i); K = length(ui);
for k = 1:K
    plot(X(i==ui(k),1), X(i==ui(k),2), 'o', 'MarkerEdgeColor', ColorOrder(mod(k-1,Ncol)+1,:), 'LineWidth', 2, 'MarkerSize', 8); hold on;
end

% Plot class labels
for k = 1:C
    plot(X(y==k-1,1), X(y==k-1,2), 'o', 'MarkerEdgeColor', ColorOrder(mod(k-1,Ncol)+1,:), 'MarkerFaceColor', ColorOrder(mod(k-1,Ncol)+1,:), 'LineWidth', 1, 'MarkerSize', 4);
end

% Plot cluster centroids
if ~isempty(Sigmas)
   q=2*[cos(2*pi*linspace(0,1,100))' sin(2*pi*linspace(0,1,100))'];   
end
for k = 1:size(centroids,1)
    plot(centroids(k,1), centroids(k,2), 'x', 'MarkerEdgeColor', 'w', 'LineWidth', 5, 'MarkerSize', 20);
    plot(centroids(k,1), centroids(k,2), 'x', 'MarkerEdgeColor', ColorOrder(mod(k-1,Ncol)+1,:), 'LineWidth', 3, 'MarkerSize', 18);
    if ~isempty(Sigmas)
        [V,D]=eig(Sigmas(:,:,k));        
        p=q*sqrt(D)'*V';
        plot(centroids(k,1)+p(:,1), centroids(k,2)+p(:,2),'-','color',ColorOrder(mod(k-1,Ncol)+1,:),'LineWidth', 3)
    end
end

axis xy;

set(gca, 'NextPlot', AxisNextPlot);

if DoPCA, xlabel('PC1'); ylabel('PC2'); end;