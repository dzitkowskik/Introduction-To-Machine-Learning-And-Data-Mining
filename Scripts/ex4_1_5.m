% exercise 4.1.5

mfig('Matrix of scatter plots'); clf;
for m1 = 1:M
    for m2 = 1:M
        subplot(M,M,(m1-1)*M+m2, 'align'); hold all;
        for c = 0:C-1
            plot(X(y==c,m2), X(y==c,m1), '.');
        end
        axis tight;
        if m1<M, set(gca, 'XTick', []); else xlabel(attributeNames{m2}); end;
        if m2>1, set(gca, 'YTick', []); else ylabel(attributeNames{m1}); end;
    end
end
legend(classNames);

