function confmatplot(G, Ghat)
% CONFMATPLOT
% Graphically display a confusion matrix
%
% Usage:
%   confmatplot(G, Ghat) plots a confusion matrix
%
% Input:
%   G        Grouping variable for the known groups
%   Ghat     Grouping variable for the predicted groups
%
% Copyright 2011, Mikkel N. Schmidt, Morten Mørup, Technical University of Denmark

[C, classNames] = confusionmat(G, Ghat);
if isnumeric(classNames), classNames = cellstr(num2str(classNames)); end;

% Create image of confusion matrix
image(64*bsxfun(@rdivide, C, sum(C,2)));
axis equal tight;
colormap(1-gray);
set(gca, 'XTick', 1:length(classNames), 'XTickLabel', classNames);
set(gca, 'YTick', 1:length(classNames), 'YTickLabel', classNames);
set(gca, 'TickLength', [0 0]);
xlabel('Predicted class');
ylabel('Actual class');

% Set labels on plot
for i = 1:size(C,1)   
    for j = 1:size(C,2)
        text(j, i, num2str(C(i,j)), 'Color', 'r', 'HorizontalAlignment', 'center');        
        if i==size(C,1)
        end
    end
end
title(sprintf('Accuracy=%.1f%%, Error Rate=%.1f%%', ...
    trace(C)/sum(sum(C))*100, (sum(sum(C))-trace(C))/sum(sum(C))*100));
