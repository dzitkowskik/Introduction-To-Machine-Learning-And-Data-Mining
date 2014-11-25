clear all; close all; clc;
%%
% Load Matlab data file and extract variables of interest
mat_data = load('../project2/letter_reg.mat')
%%
yy=mat_data.y;
X = mat_data.X;

% Restrict the data to letter 'A'
X = X(yy==1,:);
[N,M] = size(X);

L=60

mean = mean(X);
%% Gausian Kernel density estimator
% cross-validate kernel width by leave-one-out-cross-validation
% automatically implemented in the script gausKernelDensity
widths=max(var(X))*(2.^[-10:2]); % evaluate for a range of kernel widths
for w=1:length(widths)
   [density,log_density]=gausKernelDensity(X,widths(w));
   logP(w)=sum(log_density);
end
[val,ind]=max(logP);
width=widths(ind);
display(['Optimal kernel width is ' num2str(width)])
% evaluate density for estimated width
density=gausKernelDensity(X,width);

% Sort the densities
[y,i] = sort(density);

% Plot outlier scores
mfig('Gaussian Kernel Density: outlier score'); clf;
bar(y(1:L));
hold on
bar(y(1:33),'r');
legend('','outlayers');

idx_gk = i(1:L);
idx_gk1 = [i(1:33); 0 ; 0 ; 0];
idx_gk = i(1:33);
%% K-nearest neighbor density estimator 

% Number of neighbors
K = 5;

% Find the k nearest neighbors
[idx, D] = knnsearch(X, X, 'K', K+1);

% Compute the density
density = 1./(sum(D(:,2:end),2)/K);

% Sort the densities
[y,i] = sort(density);

% Plot outlier scores
mfig('KNN density: outlier score'); clf;
bar(y(1:L));
hold on 
bar(y(1:35),'r');
legend('','outlayers');

idx_knn = i(1:L);
idx_knn1 = [i(1:35) ; 0];
idx_knn = i(1:35);

%% K-nearest neigbor average relative density
% Compute the average relative density
avg_rel_density=density./(sum(density(idx(:,2:end)),2)/K);

% Sort the densities
[y,i] = sort(avg_rel_density);

% Plot outlier scores
mfig('KNN average relative density: outlier score'); clf;
bar(y(1:L));
hold on
bar(y(1:32),'r');
legend('','outlayers');

idx_knn_ar = i(1:L);
idx_knn_ar1 = [i(1:32) ; 0; 0; 0; 0];
idx_knn_ar = i(1:32);
%% Distance to 5'th nearest neighbor outlier score

% Neighbor to use
K = 5;

% Find the k nearest neighbors
[i, D] = knnsearch(X, X, 'K', K+1);

% Outlier score
f = D(:,K+1);

% Sort the outlier scores
[y,i] = sort(f, 'descend');

% Plot kernel density estimate outlier scores
mfig('Distance: Outlier score'); clf;
bar(y(1:L));
hold on 
bar(y(1:36),'r');

idx_dis = i(1:L);
idx_dis1 = i(1:36);
idx_dis = i(1:36);

%%

idx_gk
idx_knn
idx_knn_ar
idx_dis

idx_gk1
idx_knn1
idx_knn_ar1
idx_dis1

%out = [idx_gk idx_knn idx_knn_ar idx_dis]
out = [idx_gk1 idx_knn1 idx_knn_ar1 idx_dis1]

oo=0;
for k=1:36
    p = out == out(k,4);
    if sum(sum(p))==4
        oo(end+1)= out(k,1);
    end
end
outlayers=oo(2:end)

%% PLOT PCA
% Subtract the mean from the data
Y = bsxfun(@minus, X, mean);

% Obtain the PCA solution by calculate the SVD of Y
[U, S, V] = svd(Y, 'econ');

% Compute the projection onto the principal components
Z = U*S;

%% Plot PCA of data
mfig('Letters: density estimate'); clf; hold all; 

plot(Z(:,1), Z(:,2), 'o');
hold on
for u=1:length(idx_gk)
    
    p1(u,:) = [Z(idx_gk(u),1) Z(idx_gk(u),2)];
end
plot (p1(:,1) , p1(:,2),'r*');
legend('data','outliers');
xlabel('PC 1');
ylabel('PC 2');


mfig('Letters: KNN density'); clf; hold all; 

plot(Z(:,1), Z(:,2), 'o');
hold on
for u=1:length(idx_knn)
    
    p2(u,:) = [Z(idx_knn(u),1) Z(idx_knn(u),2)];
end
plot (p2(:,1) , p2(:,2),'r*');
legend('data','outliers');
xlabel('PC 1');
ylabel('PC 2');

mfig('Letters: KNN average relative density'); clf; hold all; 

plot(Z(:,1), Z(:,2), 'o');
hold on
for u=1:length(idx_knn_ar)
    
    p3(u,:) = [Z(idx_knn_ar(u),1) Z(idx_knn_ar(u),2)];
end
plot (p3(:,1) , p3(:,2),'r*');
legend('data','outliers');
xlabel('PC 1');
ylabel('PC 2');

mfig('Letters: 5th neighbor distance'); clf; hold all; 

plot(Z(:,1), Z(:,2), 'o');
hold on
for u=1:length(idx_dis)
    
    p4(u,:) = [Z(idx_dis(u),1) Z(idx_dis(u),2)];
end
plot (p4(:,1) , p4(:,2),'r*');
legend('data','outliers');
xlabel('PC 1');
ylabel('PC 2');

mfig('Letters: outlayers PCA'); clf; hold all; 

plot(Z(:,1), Z(:,2), 'o');
hold on
for u=1:length(outlayers)
    
    pp(u,:) = [Z(outlayers(u),1) Z(outlayers(u),2)];
end
plot (pp(:,1) , pp(:,2),'r*');
legend('data','outliers');

xlabel('PC 1');
ylabel('PC 2');
title('PCA of letters data');
        