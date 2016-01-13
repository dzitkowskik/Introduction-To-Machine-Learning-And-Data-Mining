% TDM_TEMPLATE - demo script  
%   This is a template script demonstrating the use of TMG,
%   as well as the application of the resulting TDM'S in 
%   two IR tasks, quering and clustering. The quering models 
%   used is the Vector Space Model (see vsm.m) and LSI 
%   (see lsi.m), while two versions of the k-means algorithm 
%   (euclidean and spherical, see ekmeans.m and skmeans.m) 
%   cluster the resulting matrix (see also pddp.m). The user can 
%   edit this code in order to change the default OPTIONS of 
%   TMG, as well as to apply other IR tasks or use his own 
%   implementations regarding these tasks. 
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

% ---Edit these lines in order to set the desired OPTIONS for tmg-----
% OPTIONS.use_mysql=1; % uncomment this line is MySQL is installed in order to store results
% OPTIONS.db_name=''; % uncomment and edit this line in order to store resulting mat files to the data directory
OPTIONS.delimiter='emptyline';
OPTIONS.line_delimiter=1;
% OPTIONS.stoplist='common_words';
OPTIONS.stemming=0;
OPTIONS.update_step=10000;
OPTIONS.min_length=3;
OPTIONS.max_length=30;
OPTIONS.min_local_freq=1;
OPTIONS.min_global_freq=1;
OPTIONS.max_local_freq=inf;
OPTIONS.max_global_freq=inf;
OPTIONS.local_weight='t';
OPTIONS.global_weight='x';
OPTIONS.normalization='x';
OPTIONS.dsp=1;
% --------------------------------------------------------------------

% ---Run tmg----------------------------------------------------------
[A, dictionary, global_weights, normalization_factors, words_per_doc, titles, files, update_struct]=...
    tmg('sample_documents/sample1', OPTIONS);
% --------------------------------------------------------------------

% ---Edit these lines in order to set the desired OPTIONS for tmg_query-----
OPTIONS.delimiter='emptyline';
OPTIONS.line_delimiter=1;
% OPTIONS.stoplist=common_words;
OPTIONS.stemming=0;
OPTIONS.local_weight='t';
OPTIONS.global_weights=global_weights;
OPTIONS.dsp=1;
% --------------------------------------------------------------------------

% ---Run tmg_query----------------------------------------------------------
[Q, words_per_query, titles_query, files_query] = ...
    tmg_query('sample_documents/sample_query1', dictionary, OPTIONS);
% --------------------------------------------------------------------------

% ---Edit these lines in order to set the desired OPTIONS for clustering functions-----
OPTIONSc.iter=10;
% OPTIONSc.epsilon=1;
OPTIONSc.dsp=1;
% --------------------------------------------------------------------------

% ---Apply VSM, LSI or k-means (euclidean or spherical) clustering algorithm to the resulting tdm's-------
an=sprintf('1. Run Vector Space Model.\n2. Run LSI.\n3. Run ekmeans algorithm.\n4. Run skmeans algorithm.\n5. Exit.');disp(an);
an=input('Give your choice: ');
while an<1 | an>5, 
    an=input('Give your choice (1-5): ');
end
switch an, 
    case 1, 
        % ---Edit this line in order to use another implementation of VSM----
        sc=zeros(size(Q, 2), size(A, 2)); doc_inds=sc;
        for i=1:size(Q, 2), [sc(i, :), doc_inds(i, :)]=vsm(A, Q(:, i), 1); end
        % ------------------------------------------------------------------
    case 2, 
        % ---Edit this line in order to use another function for the computation of the SVD
        k=min(size(A));[U, S, V]=svds(A, min(k, 20));
        % ----------------------------------------------------------
        docs=S*V';
        sc=zeros(size(Q, 2), size(A, 2)); doc_inds=sc;
        for i=1:size(Q, 2), [sc(i, :), doc_inds(i, :)]=lsa(docs, U, Q(:, i), 1); end
    case 3, 
        % ---Edit this line in order to use another clustering algorithm----
        C=[];
        k=2;
        % epsilon=1;        
        [cluster_struct, centroids, Q]=ekmeans(A, C, min(size(A, 2), k), 'n_iter', OPTIONSc);
        % ------------------------------------------------------------------
    case 4, 
        % ---Edit this line in order to use another clustering algorithm----
        C=[];
        k=2;
        % epsilon=1;        
        [cluster_struct, centroids, Q]=skmeans(A, C, min(size(A, 2), k), 'n_iter', OPTIONSc);
        % ------------------------------------------------------------------        
end
% --------------------------------------------------------------------------