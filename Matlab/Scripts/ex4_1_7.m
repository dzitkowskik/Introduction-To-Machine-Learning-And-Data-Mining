% exercise 4.1.7

mfig('Data matrix (standardized)'); clf;
imagesc(zscore(X));
set(gca, 'XTick', 1:M, 'XTickLabel', attributeNames);
xlabel('Attribute');
ylabel('Data object');
colormap(gray);
colorbar;
