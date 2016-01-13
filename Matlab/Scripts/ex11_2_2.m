% exercise 11.2.2

% Kernel width
w = 5;

% Estimate optimal kernel density width by leave-one-out cross-validation
widths=2.^[-10:10];
for w=1:length(widths)
    [f, log_f] = gausKernelDensity(X, widths(w));
    logP(w)=sum(log_f);
end
[val,ind]=max(logP);
width=widths(ind);
disp(['Optimal estimated width is ' num2str(width)])

% Estimate density for each observation not including the observation
% itself in the density estimate
f = gausKernelDensity(X, width);

% Sort the densities
[y,i] = sort(f);

% Display the index of the lowest density data object
% The outlier should have index 1001
disp(i(1));

% Plot density estimate outlier scores
mfig('Outlier score'); clf;
bar(y(1:20));