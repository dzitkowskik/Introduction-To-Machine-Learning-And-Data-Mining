% exercise 4.1.2

mfig('Histogram for attributes'); clf;
for m = 1:M
    u = floor(sqrt(M)); v = ceil(M/u);
    subplot(u,v,m);
	hist(X(:,m));
	xlabel(attributeNames{m});      
	axis square;
end
linkax('y'); % Makes the y-axes equal for improved readability