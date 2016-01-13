function [AUC, TPR, FPR] = rocplot(p, y)
% ROCPLOT Plots the receiver operating characteristic (ROC) curve and
% calculates the area under the curve (AUC).
%
% Usage:
%   rocplot(p, y);
%   [AUC, TPR, FDR] = rocplot(p, y);
% 
% Input: 
%   p: Estimated probability of class 1. (Between 0 and 1.)
%   y: True class indices. (Equal to 0 or 1.)
%
% Output:
%   AUC: The area under the ROC curve
%   TPR: True positive rate
%   FPR: False positive rate
%
% Copyright 2011, Mikkel N. Schmidt, Morten Mørup, Technical University of Denmark

%% Old code assumes values of p are not the same
% [val, ind] = sort(p(:), 'ascend');
% x = y(ind);
% FNR = cumsum(x==1)/sum(x==1);
% TPR = 1-FNR;
% TNR = cumsum(x==0)/sum(x==0);
% FPR = 1-TNR;
% TPR = [1; TPR];
% FPR = [1; FPR];
% AUC = -diff(FPR)' * (TPR(1:end-1)+TPR(2:end))/2;

%% Code assuming values of p may be the same
[val,ind]=sort(p(:),'ascend');
x=y(ind);
N0=sum(1-x);
N1=sum(x);
FNR=[zeros(length(x),1); 1];
TNR=[zeros(length(x),1); 1];
N_true=x(1);
N_false=1-x(1);
t=1;
for k=2:length(val)
    if val(k-1)~=val(k)
        t=t+1;
        FNR(t)=N_true/N1;
        TNR(t)=N_false/N0;
    end
    N_true=N_true+x(k);
    N_false=N_false+(1-x(k));            
end
FNR(t+1)=1;
FNR(t+2:end)=[];
TNR(t+1)=1;
TNR(t+2:end)=[];
TPR = 1-FNR;
FPR = 1-TNR;
AUC = -trapz(FPR,TPR);

plot(FPR, TPR, 'r', [0 1], [0 1], 'k');
axis equal;
axis([0 1 0 1]);
set(gca, 'XTick', 0:.1:1, 'YTick', 0:.1:1);
grid on;
xlabel('False positive rate (1-Specificity)');
ylabel('True positive rate (Sensitivity)');
title(sprintf('Receiver operating characteristic (ROC)\n AUC=%.3f', AUC));
