% exercise 4.1.4

%% Boxplot of each attribute for each class
mfig('Boxplot per class'); clf;
for c = 1:C
    subplot(1,C,c,'align');
    boxplot(X(y==c-1,:), attributeNames, 'labelorientation', 'inline');   
    title(classNames{c});    
end
linkax;
