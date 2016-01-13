function displayDecisionFunctionNetwork(Xtrain,ytrain,Xtest,ytest,net)
% Display decision boundaries for model or model ensemble
X=[Xtrain; Xtest];
X_min=min(X);
X_max=max(X);


% Define resolution of grid
Nx1 = 2500;
Nx2 = 2500;

% Display decision boundary
x1=linspace(X_min(1),X_max(1),Nx1);
x2=linspace(X_min(2),X_max(2),Nx2);
[xx1,xx2] = meshgrid(x1,x2);
XX=[xx1(:) xx2(:)];

% Evaluate network on a grid of values
XX=XX-ones(size(XX,1),1)*net.mean_x;
XX=XX./(ones(size(XX,1),1)*net.std_x);
[dummy,y_pred] = nr_forward(net.Wi,net.Wo,XX);    
imagesc(x1,x2,reshape(y_pred,Nx2,Nx1));
title(['Decision boundaries for trained network'],'FontWeight','bold');

% Plot Training and test data
hold on;
col=colormap(jet);
scol=size(col,1);
Nclass=2;
plot(Xtrain(ytrain==0,1),Xtrain(ytrain==0,2),'o','Color',col(1,:));    
plot(Xtrain(ytrain==1,1),Xtrain(ytrain==1,2),'o','Color',col(end,:));    
plot(Xtest(ytest==0,1),Xtest(ytest==0,2),'x','Color',col(1,:));    
plot(Xtest(ytest==1,1),Xtest(ytest==1,2),'x','Color',col(end,:));    
caxis([0 1]);
colormap(jet/2+.5);
set(gca,'YDir','normal');
xlabel('x_1','FontWeight','bold');
ylabel('x_2','FontWeight','bold');
legend({'Train class 0','Train class 1','test class 0','test class 1'});
