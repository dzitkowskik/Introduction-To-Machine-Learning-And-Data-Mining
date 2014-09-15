function dbplot(X, y, fun)
% DBPLOT Plots a decision boundary for a classification problem.
%
% Usage:
%    dbplot(X, y, fun) where X is an N-by-M matrix of attribute values,
%    y is an N-by-1 vector of class labels, and fun is a function
%    handle to a function fun(X) that returns a class label for a
%    matrix of attribute values. N is the number of data objects and M is
%    the number of attributes. For a binary classification problem, fun(X)
%    can also return a class probability (between 0 and 1).  
%
%    If the number of attributes is M=2, the decision boundary is plotted
%    in the attribute space. If M>2, the decision boundary is plotted in
%    the plane spanned by the first two principal components.
%
% Input:
%    X         N-by-M matrix of attribute values for N data objects with M
%              attributes.
%    y         N-by-1 vector of class labels
%    fun       Function handle to classification function that takes a
%              matrix of data objects as input and returns class labels or
%              (for a binary classifier) class funReturnsProbabilities.
%
% Copyright 2011, Mikkel N. Schmidt, Technical University of Denmark

[N,M] = size(X);

DoPCA = M>2;
if DoPCA
    mX = mean(X);
    Z = bsxfun(@minus, X, mX);
    [U,S,V] = svd(Z, 'econ');
    X = U*S;
end

xRange = [min(X(:,1)), max(X(:,1))];
xRange = xRange + [-1 1]*range(xRange)*0.05;
yRange = [min(X(:,2)), max(X(:,2))];
yRange = yRange + [-1 1]*range(yRange)*0.05;

NGrid = 400;
xGrid = linspace(xRange(1), xRange(2), NGrid);
yGrid = linspace(yRange(1), yRange(2), NGrid);
[xMesh,yMesh] = meshgrid(xGrid, yGrid);

if DoPCA
    Xeval = bsxfun(@plus, [xMesh(:) yMesh(:) zeros(NGrid^2,M-2)]*V', mX);
else
    Xeval = [xMesh(:) yMesh(:)];
end
fMesh = reshape(fun(Xeval), NGrid, NGrid);

AxisNextPlot = get(gca, 'NextPlot');
ColorOrder = get(gca, 'ColorOrder');
Ncol = size(ColorOrder,1);

C = max(y)+1;
funReturnsProbabilities = ~all(ismember(unique(fMesh(:)), 0:C-1));
a = .3; b = .7;
if funReturnsProbabilities
    cMap = interp1([0 .5 1], [ColorOrder(1,:)*a+b; 1 1 1; ColorOrder(2,:)*a+b], linspace(0,1,256));
    imagesc(xGrid, yGrid, fMesh);
else
    cMap = ColorOrder(mod(0:C-1,Ncol)+1,:)*a+b;
    image(xGrid, yGrid, fMesh+1);
end

hold all;
for c = 1:C
    plot(X(y==c-1,1), X(y==c-1,2), 'wo', 'MarkerFaceColor', ColorOrder(mod(c-1,Ncol)+1,:), 'LineWidth', 1, 'MarkerSize', 7);
end

colormap(cMap);
axis xy;

set(gca, 'NextPlot', AxisNextPlot);

if DoPCA, xlabel('PC1'); ylabel('PC2'); end;