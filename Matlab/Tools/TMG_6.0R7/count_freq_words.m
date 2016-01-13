function [words] = count_freq_words(A_tdm,dictionary,howmany)
%   count_freq_words Summary of this function goes here
%   return the top howmany most frequent words in the documents of 
%   A_tdm indexing dictionary
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

%[m,n]=size(A_tdm);
[TERMS,I]=sort(sum(A_tdm,2),'descend');
words = dictionary(I(1:howmany),:);
end

