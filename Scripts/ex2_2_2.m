%% exercise 2.2.2

% Data attributes to be plotted
i = 1;
j = 2;

% Make a simple plot of the i'th attribute against the j'th attribute
mfig('NanoNose: Data'); clf;
plot(X(:,i), X(:,j), 'o');

% Make another more fancy plot that includes legend, class labels, 
% attribute names, and a title
mfig('NanoNose: Classes'); clf; hold all; 
C = length(classNames);
for c = 0:C-1
    plot(X(y==c,i), X(y==c,j), 'o');
end
legend(classNames);
xlabel(attributeNames{i});
ylabel(attributeNames{j});
title('NanoNose data');