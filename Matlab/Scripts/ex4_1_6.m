% exercise 4.1.6

ind = [1 2 3]; % Indices of the variables to plot
mfig('3D scatter plot'); clf; hold all;
for c = 1:C
    plot3(X(y==c-1,ind(1)),X(y==c-1,ind(2)),X(y==c-1,ind(3)), '.');
end
grid on;
xlabel(attributeNames{ind(1)});
ylabel(attributeNames{ind(2)});
zlabel(attributeNames{ind(3)});
legend(classNames);
view(3);