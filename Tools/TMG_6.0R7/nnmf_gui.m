function varargout = nnmf_gui(varargin)
% nnmf_gui 
%   nnmf_gui is a graphical user interface for all 
%   non-negative dimensionality reduction techniques implemented 
%   in the Text to Matrix Generator (TMG) Toolbox. 
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

% Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nnmf_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @nnmf_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before nnmf_gui is made visible.
function nnmf_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for nnmf_gui
handles.output = hObject;

handles.light_gray=[0.8824 0.8824 0.8824];
handles.gray=[0.9255 0.9137 0.8471];
%centre the gui
set(0, 'Units', 'centimeters');
scr_position=get(0, 'ScreenSize');
hght=14.5410;
wdth=15.7572;
pos=[(scr_position(3)-wdth)/2 (scr_position(4)-hght)/2 wdth hght];
set(hObject, 'Units', 'centimeters');
set(hObject, 'Position', pos);

handles.objects=[handles.kmeansRadio;
                 handles.skmeansRadio;
                 handles.PDDPRadio;
                 handles.nClusters;
                 handles.CentroidInit;
                 handles.CentroidsVar;
                 handles.CentroidsVarButton;
                 handles.Termination;
                 handles.TerminationValue;
                 handles.DispRes;
                 handles.lPDDP;
                 handles.PDDPvariant;
                 handles.maxlPDDP;
                 handles.svds;
                 handles.propack;
                 handles.refinementMethod;
                 handles.RefineNIter;
                 handles.refineResultsDisplay];
    
states=zeros(length(handles.objects), 1); 
handles=activate_uicontrol(states, handles);
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nnmf_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nnmf_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function DatasetMenu_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
datasets=cell(1, 1); datasets{1, 1}='';
n_datasets=0;
str=fileparts(mfilename('fullpath'));
dirs=dir(strcat(str, filesep, 'data'));
for i=1:size(dirs, 1),
    cur=dirs(i);
    if isequal(cur.name, '.') | isequal(cur.name, '..') | ~isdir(strcat(str, filesep, 'data', filesep, cur.name)), continue; end
    if exist(strcat(str, filesep, 'data', filesep, cur.name, filesep, 'A.mat')), n_datasets=n_datasets+1; datasets{n_datasets+1, 1}=strcat(str, filesep, 'data', filesep, cur.name); end
end
set(hObject, 'String', datasets);
guidata(hObject, handles);

function DatasetMenu_Callback(hObject, eventdata, handles)

function nFactorsSVD_Callback(hObject, eventdata, handles)
% hObject    handle to nFactorsSVD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nFactorsSVD as text
%        str2double(get(hObject,'String')) returns contents of nFactorsSVD as a double
if get(handles.CLRadio, 'Value')==1, set(handles.nClusters, 'String', get(hObject, 'String')); end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function nFactorsSVD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nFactorsSVD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StoreRes.
function StoreRes_Callback(hObject, eventdata, handles)
% hObject    handle to StoreRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StoreRes
guidata(hObject, handles);

% --- Executes on button press in ContinueButton.
function ContinueButton_Callback(hObject, eventdata, handles)
% hObject    handle to ContinueButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datasets=get(handles.DatasetMenu, 'String');
id=get(handles.DatasetMenu, 'Value');
if isequal(datasets{id}, ''), msgbox('You have to provide a dataset...', 'Error', 'modal'); return; end
k=get(handles.nFactorsSVD, 'String');
if isempty(k), msgbox('You have to provide the number of factors...', 'Error', 'modal'); return; end
k=str2double(k);
if ~isnumeric(k), msgbox('You have to provide the number of factors...', 'Error', 'modal'); return; end
if mod(k, 1)~=0 | k<=0, msgbox('You have to provide a positive integer number of factors...', 'Error', 'modal'); return; end
load(strcat(datasets{id}, filesep, 'A.mat'));
load(strcat(datasets{id}, filesep, 'titles.mat'));

if get(handles.RefineFactorsCheckbox, 'Value') == 1,
    refine_dsp = get(handles.refineResultsDisplay, 'Value');
    if get(handles.refinementMethod, 'Value') == 1, 
        nit = get(handles.RefineNIter, 'String');
        if isempty(nit), msgbox('You have to provide the number of iterations...', 'Error', 'modal'); return; end
        nit=str2double(nit);
        if ~isnumeric(nit), msgbox('You have to provide the number of iterations...', 'Error', 'modal'); return; end
        if mod(nit, 1)~=0, msgbox('You have to provide an integer number of iterations...', 'Error', 'modal'); return; end    
    end
end

if get(handles.BLOCKNNDSVDRadio, 'Value')==1 | get(handles.CLRadio, 'Value')==1, 
    nc=get(handles.nClusters, 'String'); 
    if isempty(nc), msgbox('You have to provide the number of clusters...', 'Error', 'modal'); return; end
    nc=str2double(nc);
    if ~isnumeric(nc), msgbox('You have to provide the number of clusters...', 'Error', 'modal'); return; end
    if mod(nc, 1)~=0, msgbox('You have to provide an integer number of clusters...', 'Error', 'modal'); return; end
    if get(handles.CLRadio, 'Value')==1 & nc~=k, msgbox('Number of clusters must be equal to the number of factors...', 'Error', 'modal'); return; end
    if nc>k, msgbox('Number of clusters must not exceed number of factors...', 'Error', 'modal'); return; end
    
    clust_method=''; 
    if get(handles.kmeansRadio, 'Value')==1, clust_method='kmeans'; elseif get(handles.skmeansRadio, 'Value')==1, clust_method='skmeans'; else, clust_method='pddp'; end
    if ~isequal(clust_method, 'pddp'), 
        centroids=get(handles.CentroidInit, 'Value'); 
        if centroids==1, 
            C=[]; 
        else,
            s=get(handles.CentroidsVar, 'String'); 
            if isempty(s), msgbox('You have to provide the centroids variable. Use the Browse button...', 'Error', 'modal'); return; end
            C=evalin('base', s); 
            [m, n]=size(C); if m~=size(A, 1) | n~=k, msgbox('The centroid variable you provided has incorrect dimensions...', 'Error', 'modal'); return; end
        end
        
        term_method=get(handles.Termination, 'Value');
        s=get(handles.TerminationValue, 'String'); 
        if term_method==1, 
            term_method='epsilon';
            if isempty(s), 
                r=questdlg('You didn''t provide the epsilon value. Using the default value...', 'Genie Question', 'OK', 'CANCEL', 'OK');
                if ~isequal(r, 'OK'), return; end
            else, 
                s=str2double(s);
                if ~isnumeric(s), msgbox('You have to provide the epsilon value...', 'Error', 'modal'); return; end
                opts.epsilon=s;
            end
        else, 
            term_method='n_iter';
            if isempty(s), 
                r=questdlg('You didn''t provide the ''number of iterations'' value. Using the default value...', 'Genie Question', 'OK', 'CANCEL', 'OK');
                if ~isequal(r, 'OK'), return; end
            else, 
                s=str2double(s);
                if ~isnumeric(s), msgbox('You have to provide the number of iterations...', 'Error', 'modal'); return; end                
                if mod(s, 1)~=0, msgbox('You have to provide an integer number of iterations...', 'Error', 'modal'); return; end
                opts.iter=s;
            end            
        end
        if get(handles.DispRes, 'Value')==1, opts.dsp=1; else, opts.dsp=0; end
        if isequal(clust_method, 'kmeans'), 
            [clusters, QQ, Wkmeans]=ekmeans(A, C, nc, term_method, opts);
            Wkmeans = col_normalization(Wkmeans);
        else, 
            [clusters, QQ, Wskmeans]=skmeans(A, C, nc, term_method, opts);
            Wskmeans = col_normalization(Wskmeans);
        end
    else, 
        state=get(handles.propack, 'Value'); if state==0, svd_method = 'svds'; else, svd_method = 'propack'; end
        v=get(handles.PDDPvariant, 'Value'); 
        state=get(handles.maxlPDDP, 'Value'); 
        if state == 1, 
            if v==1, 
                [clusters, tree_struct]=pddp(A, nc, 'max', svd_method, get(handles.DispRes, 'Value'));
            else, 
                [clusters, tree_struct]=pddp_optcutpd(A, nc, 'max', svd_method, get(handles.DispRes, 'Value'));
            end            
        else, 
            l=get(handles.lPDDP, 'String');
            tmp=2^str2num(l); while tmp<k, tmp=tmp+2^str2num(l)-1; end
            if tmp>k,
                 err_pddp=new_sprintf('Number of principal components for PDDP you supplied produces more than %d clusters (number of NNMF factors). Please alter your selection...', k); 
                msgbox(err_pddp, 'Error', 'modal'); return;
            end
            if isempty(l), msgbox('You have to provide the number of principal directions for PDDP...', 'Error', 'modal'); return; end
            if str2double(l)>1, 
                if v==1, 
                    [clusters, tree_struct]=pddp(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
                else, 
                    [clusters, tree_struct]=pddp_optcutpd(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
                end
            else, 
                if v==1, 
                    [clusters, tree_struct]=pddp(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
                elseif v==2,
                    [clusters, tree_struct]=pddp_2means(A, nc, svd_method, get(handles.DispRes, 'Value'), 0);
                elseif v==3, 
                    [clusters, tree_struct]=pddp_optcut(A, nc, svd_method, get(handles.DispRes, 'Value'));
                elseif v==4, 
                    [clusters, tree_struct]=pddp_optcut_2means(A, nc, svd_method, get(handles.DispRes, 'Value'), 0);
                else, 
                    [clusters, tree_struct]=pddp_optcutpd(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
                end
            end
        end
        Wpddp = col_normalization(pddp_extract_centroids(tree_struct, size(A, 1), nc));
    end
    assignin('base', 'clusters', clusters);
end


if get(handles.RandomRadio, 'Value')==1, 
    Wrandom = rand(size(A, 1), k); Hrandom = rand(k, size(A, 2));
    if get(handles.RefineFactorsCheckbox, 'Value') == 1, 
        if get(handles.refinementMethod, 'Value') == 1, 
            [Wrandom, Hrandom, ss]=nnmf_mul_update(A, Wrandom, Hrandom, nit, refine_dsp);
        else, 
            [Wrandom, Hrandom]=nmfanls_comb(A, size(Hrandom, 1), Hrandom, refine_dsp);
        end
    end
    
    assignin('base', 'A', A); assignin('base', 'Wrandom', Wrandom); assignin('base', 'Hrandom', Hrandom); assignin('base', 'k', k);
end
if get(handles.NNDSVDRadio, 'Value')==1, 
    state=get(handles.propack, 'Value'); if state==0, svd_method = 'svds'; else, svd_method = 'propack'; end
    [Wnndsvd, Hnndsvd] = nndsvd(A, k, svd_method, 0); 
    if get(handles.RefineFactorsCheckbox, 'Value') == 1, 
        if get(handles.refinementMethod, 'Value') == 1, 
            [Wnndsvd, Hnndsvd, ss]=nnmf_mul_update(A, Wnndsvd, Hnndsvd, nit, refine_dsp);
        else, 
            [Wnndsvd, Hnndsvd] = nmfanls_comb(A, size(Hnndsvd, 1), Hnndsvd, refine_dsp);
        end
    end    
    
    assignin('base', 'A', A); assignin('base', 'Wnndsvd', Wnndsvd); assignin('base', 'Hnndsvd', Hnndsvd); assignin('base', 'k', k);
end
if get(handles.BLOCKNNDSVDRadio, 'Value')==1, 
    state=get(handles.propack, 'Value'); if state==0, svd_method = 'svds'; else, svd_method = 'propack'; end
    [Wblocknndsvd, Hblocknndsvd]=block_nndsvd(A, clusters, k, 'f', 0.5, svd_method);
    if get(handles.RefineFactorsCheckbox, 'Value') == 1, 
        if get(handles.refinementMethod, 'Value') == 1, 
            [Wblocknndsvd, Hblocknndsvd, ss]=nnmf_mul_update(A, Wblocknndsvd, Hblocknndsvd, nit, refine_dsp);
        else, 
            [Wblocknndsvd, Hblocknndsvd] = nmfanls_comb(A, size(Hblocknndsvd, 1), Hblocknndsvd, refine_dsp);
        end
    end        
    
    assignin('base', 'A', A); assignin('base', 'Wblocknndsvd', Wblocknndsvd); assignin('base', 'Hblocknndsvd', Hblocknndsvd); assignin('base', 'k', k);
end
if get(handles.BISECTINGNNDSVDRadio, 'Value')==1, 
    state=get(handles.propack, 'Value'); if state==0, svd_method = 'svds'; else, svd_method = 'propack'; end
    [Wbisnndsvd, Hbisnndsvd] = bisecting_nndsvd(A, k, svd_method);
    if get(handles.RefineFactorsCheckbox, 'Value') == 1, 
        if get(handles.refinementMethod, 'Value') == 1, 
            [Wbisnndsvd, Hbisnndsvd, ss]=nnmf_mul_update(A, Wbisnndsvd, Hbisnndsvd, nit, refine_dsp);
        else, 
            [Wbisnndsvd, Hbisnndsvd] = nmfanls_comb(A, size(Hbisnndsvd, 1), Hbisnndsvd, refine_dsp);
        end
    end            
    
    assignin('base', 'A', A); assignin('base', 'Wbisnndsvd', Wbisnndsvd); assignin('base', 'Hbisnndsvd', Hbisnndsvd); assignin('base', 'k', k);
end
if get(handles.CLRadio, 'Value')==1, 
    if isequal(clust_method, 'kmeans'), 
        Hkmeans = rand(k, size(A, 2));
        if get(handles.RefineFactorsCheckbox, 'Value') == 1, 
            if get(handles.refinementMethod, 'Value') == 1, 
                [Wkmeans, Hkmeans, ss]=nnmf_mul_update(A, Wkmeans, Hkmeans, nit, refine_dsp);
            else, 
                [Wtmp, Htmp] = nmfanls_comb(A', size(Wkmeans, 2), Wkmeans', refine_dsp);
                Wkmeans = Htmp';
                Hkmeans = Wtmp';
            end
        end                    
        assignin('base', 'A', A); assignin('base', 'Wkmeans', Wkmeans); assignin('base', 'Hkmeans', Hkmeans); assignin('base', 'k', k);
    end
    if isequal(clust_method, 'skmeans'), 
        Hskmeans = rand(k, size(A, 2));
        if get(handles.RefineFactorsCheckbox, 'Value') == 1, 
            if get(handles.refinementMethod, 'Value') == 1, 
                [Wskmeans, Hskmeans, ss]=nnmf_mul_update(A, Wskmeans, Hskmeans, nit, refine_dsp);
            else, 
                [Wtmp, Htmp] = nmfanls_comb(A', size(Wskmeans, 2), Wskmeans', refine_dsp);
                Wskmeans = Htmp';
                Hskmeans = Wtmp';                
            end
        end                            
        assignin('base', 'A', A); assignin('base', 'Wskmeans', Wskmeans); assignin('base', 'Hskmeans', Hskmeans); assignin('base', 'k', k);
    end
    if isequal(clust_method, 'pddp'), 
        Hpddp = rand(k, size(A, 2));
        if get(handles.RefineFactorsCheckbox, 'Value') == 1, 
            if get(handles.refinementMethod, 'Value') == 1, 
                [Wpddp, Hpddp, ss]=nnmf_mul_update(A, Wpddp, Hpddp, nit, refine_dsp);
            else, 
                [Wtmp, Htmp] = nmfanls_comb(A', size(Wpddp, 2), Wpddp', refine_dsp);
                Wpddp = Htmp';
                Hpddp = Wtmp';                
            end
        end                            
        assignin('base', 'A', A); assignin('base', 'Wpddp', Wpddp); assignin('base', 'Hpddp', Hpddp); assignin('base', 'k', k);
    end    
end

if get(handles.RandomRadio, 'Value')==1, 
    [s, ind]=max(Hrandom, [], 1);
    clusters_random={'ind'}; for j=1:k, clusters_random{j+1, 1}=find(ind==j); end
    title = 'NNMF Clustering with random initialization';
    assignin('base', 'clusters_random', clusters_random); 
end
if get(handles.NNDSVDRadio, 'Value')==1, 
    [s, ind]=max(Hnndsvd, [], 1);
    clusters_nndsvd={'ind'}; for j=1:k, clusters_nndsvd{j+1, 1}=find(ind==j); end
    title = 'NNMF Clustering with NNDSVD Initialization';    
    assignin('base', 'clusters_nndsvd', clusters_nndsvd);
end
if get(handles.BLOCKNNDSVDRadio, 'Value')==1, 
    [s, ind]=max(Hblocknndsvd, [], 1);
    clusters_blocknndsvd={'ind'}; for j=1:k, clusters_blocknndsvd{j+1, 1}=find(ind==j); end
    if isequal(clust_method, 'kmeans'),     
        title = 'NNMF Clustering with Block NNDSVD (k-means) Initialization';
    elseif isequal(clust_method, 'skmeans'),     
        title = 'NNMF Clustering with Block NNDSVD (Spherical k-means) Initialization';
    else, 
        title = 'NNMF Clustering with Block NNDSVD (PDDP) Initialization';
    end
    assignin('base', 'clusters_blocknndsvd', clusters_blocknndsvd);
end
if get(handles.BISECTINGNNDSVDRadio, 'Value')==1, 
    [s, ind]=max(Hbisnndsvd, [], 1);
    clusters_bisnndsvd={'ind'}; for j=1:k, clusters_bisnndsvd{j+1, 1}=find(ind==j); end
    title = 'NNMF Clustering with Bisecting NNDSVD Initialization';    
    assignin('base', 'clusters_bisnndsvd', clusters_bisnndsvd);
end
if get(handles.CLRadio, 'Value')==1, 
    if isequal(clust_method, 'kmeans'),     
        [s, ind]=max(Hkmeans, [], 1);
        clusters_kmeans={'ind'}; for j=1:k, clusters_kmeans{j+1, 1}=find(ind==j); end
        title = 'NNMF Clustering with k-means Preconditioning';    
        assignin('base', 'clusters_kmeans', clusters_kmeans);
    end
    if isequal(clust_method, 'skmeans'),     
        [s, ind]=max(Hskmeans, [], 1);
        clusters_skmeans={'ind'}; for j=1:k, clusters_skmeans{j+1, 1}=find(ind==j); end
        title = 'NNMF Clustering with Spherical k-means Preconditioning';    
        assignin('base', 'clusters_skmeans', clusters_skmeans);
    end
    if isequal(clust_method, 'pddp'),     
        [s, ind]=max(Hpddp, [], 1);
        clusters_pddp={'ind'}; for j=1:k, clusters_pddp{j+1, 1}=find(ind==j); end
        title = 'NNMF Clustering with PDDP Preconditioning';    
        assignin('base', 'clusters_pddp', clusters_pddp);
    end    
end

if get(handles.StoreRes, 'Value')==1, 
    datasets=get(handles.DatasetMenu, 'String'); v=get(handles.DatasetMenu, 'Value'); dataset=datasets{v};
    if get(handles.RandomRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'nnmf');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(k));
        if ~exist(str), 
            mkdir(str); 
        else, 
            if get(handles.RefineFactorsCheckbox, 'Value') == 1,
                if get(handles.refinementMethod, 'Value') == 1, 
                    str=strcat(str, filesep, 'mlup');
                else, 
                    str=strcat(str, filesep, 'anls');
                end
                if ~exist(str), mkdir(str); end
            end
            str1=strcat(str, filesep, 'Wrandom.mat'); str2=strcat(str, filesep, 'Hrandom.mat'); 
            if exist(str1), delete(str1); end; if exist(str2), delete(str2); end; 
        end
        str1=strcat(str, filesep, 'Wrandom'); str2=strcat(str, filesep, 'Hrandom'); 
        save(str1, 'Wrandom'); save(str2, 'Hrandom'); 
    end
    if get(handles.NNDSVDRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'nnmf');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(k));
        if ~exist(str), 
            mkdir(str); 
        else, 
            if get(handles.RefineFactorsCheckbox, 'Value') == 1,
                if get(handles.refinementMethod, 'Value') == 1, 
                    str=strcat(str, filesep, 'mlup');
                else, 
                    str=strcat(str, filesep, 'anls');
                end
                if ~exist(str), mkdir(str); end
            end            
            str1=strcat(str, filesep, 'Wnndsvd.mat'); str2=strcat(str, filesep, 'Hnndsvd.mat'); 
            if exist(str1), delete(str1); end; if exist(str2), delete(str2); end; 
        end
        str1=strcat(str, filesep, 'Wnndsvd'); str2=strcat(str, filesep, 'Hnndsvd'); 
        save(str1, 'Wnndsvd'); save(str2, 'Hnndsvd'); 
    end
    if get(handles.BLOCKNNDSVDRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'nnmf');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(k));
        if ~exist(str), 
            mkdir(str); 
        else, 
            if get(handles.RefineFactorsCheckbox, 'Value') == 1,
                if get(handles.refinementMethod, 'Value') == 1, 
                    str=strcat(str, filesep, 'mlup');
                else, 
                    str=strcat(str, filesep, 'anls');
                end
                if ~exist(str), mkdir(str); end
            end            
            str1=strcat(str, filesep, 'Wblocknndsvd.mat'); str2=strcat(str, filesep, 'Hblocknndsvd.mat'); 
            if exist(str1), delete(str1); end; if exist(str2), delete(str2); end; 
        end
        str1=strcat(str, filesep, 'Wblocknndsvd'); str2=strcat(str, filesep, 'Hblocknndsvd'); 
        save(str1, 'Wblocknndsvd'); save(str2, 'Hblocknndsvd'); 
    end
    if get(handles.BISECTINGNNDSVDRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'nnmf');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(k));
        if ~exist(str), 
            mkdir(str); 
        else, 
            if get(handles.RefineFactorsCheckbox, 'Value') == 1,
                if get(handles.refinementMethod, 'Value') == 1, 
                    str=strcat(str, filesep, 'mlup');
                else, 
                    str=strcat(str, filesep, 'anls');
                end
                if ~exist(str), mkdir(str); end
            end            
            str1=strcat(str, filesep, 'Wbisnndsvd.mat'); str2=strcat(str, filesep, 'Hbisnndsvd.mat'); 
            if exist(str1), delete(str1); end; if exist(str2), delete(str2); end; 
        end
        str1=strcat(str, filesep, 'Wbisnndsvd'); str2=strcat(str, filesep, 'Hbisnndsvd'); 
        save(str1, 'Wbisnndsvd'); save(str2, 'Hbisnndsvd'); 
    end
    if get(handles.CLRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'nnmf');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(k));
        if ~exist(str), 
            mkdir(str); 
        else, 
            if isequal(clust_method, 'kmeans'), 
                if get(handles.RefineFactorsCheckbox, 'Value') == 1,
                    if get(handles.refinementMethod, 'Value') == 1, 
                        str=strcat(str, filesep, 'mlup');
                    else, 
                        str=strcat(str, filesep, 'anls');
                    end
                    if ~exist(str), mkdir(str); end
                end                
                str1=strcat(str, filesep, 'Wkmeans.mat'); str2=strcat(str, filesep, 'Hkmeans.mat'); 
                if exist(str1), delete(str1); end; if exist(str2), delete(str2); end; 
            end
            if isequal(clust_method, 'skmeans'), 
                if get(handles.RefineFactorsCheckbox, 'Value') == 1,
                    if get(handles.refinementMethod, 'Value') == 1, 
                        str=strcat(str, filesep, 'mlup');
                    else, 
                        str=strcat(str, filesep, 'anls');
                    end
                    if ~exist(str), mkdir(str); end
                end                               
                str1=strcat(str, filesep, 'Wskmeans.mat'); str2=strcat(str, filesep, 'Hskmeans.mat'); 
                if exist(str1), delete(str1); end; if exist(str2), delete(str2); end; 
            end
            if isequal(clust_method, 'pddp'), 
                if get(handles.RefineFactorsCheckbox, 'Value') == 1,
                    if get(handles.refinementMethod, 'Value') == 1, 
                        str=strcat(str, filesep, 'mlup');
                    else, 
                        str=strcat(str, filesep, 'anls');
                    end
                    if ~exist(str), mkdir(str); end
                end                               
                str1=strcat(str, filesep, 'Wpddp.mat'); str2=strcat(str, filesep, 'Hpddp.mat'); 
                if exist(str1), delete(str1); end; if exist(str2), delete(str2); end; 
            end            
        end
        if isequal(clust_method, 'kmeans'), 
            str1=strcat(str, filesep, 'Wkmeans'); str2=strcat(str, filesep, 'Hkmeans'); 
            save(str1, 'Wkmeans'); save(str2, 'Hkmeans'); 
        end
        if isequal(clust_method, 'skmeans'), 
            str1=strcat(str, filesep, 'Wskmeans'); str2=strcat(str, filesep, 'Hskmeans'); 
            save(str1, 'Wskmeans'); save(str2, 'Hskmeans'); 
        end
        if isequal(clust_method, 'pddp'), 
            str1=strcat(str, filesep, 'Wpddp'); str2=strcat(str, filesep, 'Hpddp'); 
            save(str1, 'Wpddp'); save(str2, 'Hpddp'); 
        end        
    end
end

view_res = questdlg('View NNMF clustering result?', ...
                         'clustering Result', ...
                         'Yes', 'No', 'Yes');
if isequal(view_res, 'Yes'), 
    if get(handles.RefineFactorsCheckbox, 'Value') == 1, 
        if get(handles.refinementMethod, 'Value') == 1, 
             title = new_sprintf('Multiplicative update %s', title); 
        else, 
             title = new_sprintf('ANLS %s', title); 
        end
    end
    if get(handles.RandomRadio, 'Value')==1, 
        create_kmeans_response(clusters_random, titles, title);
    end
    if get(handles.NNDSVDRadio, 'Value')==1, 
        create_kmeans_response(clusters_nndsvd, titles, title);
    end
    if get(handles.BLOCKNNDSVDRadio, 'Value')==1, 
        create_kmeans_response(clusters_blocknndsvd, titles, title);
    end
    if get(handles.BISECTINGNNDSVDRadio, 'Value')==1, 
        create_kmeans_response(clusters_bisnndsvd, titles, title);
    end
    if get(handles.CLRadio, 'Value')==1, 
        if isequal(clust_method, 'kmeans'),     
            create_kmeans_response(clusters_kmeans, titles, title);
        end
        if isequal(clust_method, 'skmeans'),     
            create_kmeans_response(clusters_skmeans, titles, title);
        end
        if isequal(clust_method, 'pddp'),     
            create_kmeans_response(clusters_pddp, titles, title);
        end    
    end    
else
    msgbox('Done!', 'modal');
end

guidata(hObject, handles);

% --- Executes on button press in ClearBotton.
function ClearBotton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearBotton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DatasetMenu, 'Value', 1);

set(handles.RandomRadio, 'Value', 1); 
set(handles.NNDSVDRadio, 'Value', 0); 
set(handles.BLOCKNNDSVDRadio, 'Value', 0); 
set(handles.BISECTINGNNDSVDRadio, 'Value', 0); 
set(handles.CLRadio, 'Value', 0); 

set(handles.kmeansRadio, 'Value', 1); 
set(handles.skmeansRadio, 'Value', 0); 
set(handles.PDDPRadio, 'Value', 0);

set(handles.CentroidInit, 'Value', 1); 
set(handles.CentroidsVar, 'String', '');
set(handles.Termination, 'Value', 1); 
set(handles.TerminationValue, 'String', '1');
set(handles.lPDDP, 'String', '1'); 
set(handles.nClusters, 'String', ''); 
set(handles.DispRes, 'Value', 1); 

set(handles.nFactorsSVD, 'String', ''); 
set(handles.StoreRes, 'Value', 1);

set(handles.RefineFactorsCheckbox, 'Value', 0);
set(handles.RefineNIter, 'String', '');

states=zeros(length(handles.objects), 1); 
handles=activate_uicontrol(states, handles);
guidata(hObject, handles);

% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);

% --- Executes on button press in RandomRadio.
function RandomRadio_Callback(hObject, eventdata, handles)
% hObject    handle to RandomRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RandomRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.NNDSVDRadio, 'Value', 0);
    set(handles.BLOCKNNDSVDRadio, 'Value', 0);
    set(handles.BISECTINGNNDSVDRadio, 'Value', 0);
    set(handles.CLRadio, 'Value', 0);
end

states=zeros(length(handles.objects), 1); 
refine_status = get(handles.RefineFactorsCheckbox, 'Value'); 
if refine_status == 1, 
    states(end - 2) = 1; 
    states(end) = 1; 
    if get(handles.refinementMethod, 'Value') == 1, 
        states(end - 1) = 1; 
    end    
end
             
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);


% --- Executes on button press in NNDSVDRadio.
function NNDSVDRadio_Callback(hObject, eventdata, handles)
% hObject    handle to NNDSVDRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NNDSVDRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.RandomRadio, 'Value', 0);
    set(handles.BLOCKNNDSVDRadio, 'Value', 0);
    set(handles.BISECTINGNNDSVDRadio, 'Value', 0);
    set(handles.CLRadio, 'Value', 0);
end
             
states=zeros(length(handles.objects), 1); 
states([14 15]) = 1;
handles=activate_uicontrol(states, handles);
refine_status = get(handles.RefineFactorsCheckbox, 'Value'); 
if refine_status == 1, 
    states(end - 2) = 1; 
    states(end) = 1; 
    if get(handles.refinementMethod, 'Value') == 1, 
        states(end - 1) = 1; 
    end    
end
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);

% --- Executes on button press in BLOCKNNDSVDRadio.
function BLOCKNNDSVDRadio_Callback(hObject, eventdata, handles)
% hObject    handle to BLOCKNNDSVDRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BLOCKNNDSVDRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.RandomRadio, 'Value', 0);
    set(handles.NNDSVDRadio, 'Value', 0);
    set(handles.BISECTINGNNDSVDRadio, 'Value', 0);
    set(handles.CLRadio, 'Value', 0);
end

states=ones(length(handles.objects), 1); 
handles=activate_uicontrol(states, handles);

state_kmeans=get(handles.kmeansRadio, 'Value');
state_skmeans=get(handles.skmeansRadio, 'Value');
state_pddp=get(handles.PDDPRadio, 'Value');
             
if state_kmeans==1, 
    states=ones(length(handles.objects), 1); states([11:13])=0; states(7)=-1;
    state=get(handles.CentroidInit, 'Value');
    if state==1, states([6 7])=0; end    
end
if state_skmeans==1, 
    states=ones(length(handles.objects), 1); states([11:13])=0; states(7)=-1;
    state=get(handles.CentroidInit, 'Value');
    if state==1, states([6 7])=0; end    
end
if state_pddp==1, 
    states=ones(length(handles.objects), 1); states(5:9)=0; 
    state=get(handles.maxlPDDP, 'Value');
    if state==1, 
        states(11) = 0;
    end    
end
refine_status = get(handles.RefineFactorsCheckbox, 'Value'); 
if refine_status == 1, 
    states(end - 2) = 1; 
    states(end) = 1; 
    if get(handles.refinementMethod, 'Value') == 2, 
        states(end - 1) = 0; 
    end    
else, 
    states(end - 2: end) = 0;
end
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);

% --- Executes on button press in BISECTINGNNDSVDRadio.
function BISECTINGNNDSVDRadio_Callback(hObject, eventdata, handles)
% hObject    handle to BISECTINGNNDSVDRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BISECTINGNNDSVDRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.RandomRadio, 'Value', 0);
    set(handles.NNDSVDRadio, 'Value', 0);
    set(handles.BLOCKNNDSVDRadio, 'Value', 0);
    set(handles.CLRadio, 'Value', 0);
end

states=zeros(length(handles.objects), 1); states(10) = 1;
states([14 15]) = 1;
handles=activate_uicontrol(states, handles);
refine_status = get(handles.RefineFactorsCheckbox, 'Value'); 
if refine_status == 1, 
    states(end - 2) = 1; 
    states(end) = 1; 
    if get(handles.refinementMethod, 'Value') == 1, 
        states(end - 1) = 1; 
    end    
end
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);

% --- Executes on button press in CLRadio.
function CLRadio_Callback(hObject, eventdata, handles)
% hObject    handle to CLRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CLRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.RandomRadio, 'Value', 0);
    set(handles.NNDSVDRadio, 'Value', 0);
    set(handles.BLOCKNNDSVDRadio, 'Value', 0);
    set(handles.BISECTINGNNDSVDRadio, 'Value', 0);
end
             
states=ones(length(handles.objects), 1); 
handles=activate_uicontrol(states, handles);

state_kmeans=get(handles.kmeansRadio, 'Value');
state_skmeans=get(handles.skmeansRadio, 'Value');
state_pddp=get(handles.PDDPRadio, 'Value');

if state_kmeans==1, 
    states=ones(length(handles.objects), 1); states([11:13])=0; states(7)=-1;
    state=get(handles.CentroidInit, 'Value');
    if state==1, states([6 7])=0; end    
end
if state_skmeans==1, 
    states=ones(length(handles.objects), 1); states([11:13])=0; states(7)=-1;
    state=get(handles.CentroidInit, 'Value');
    if state==1, states([6 7])=0; end    
end
if state_pddp==1, 
    states=ones(length(handles.objects), 1); states(5:9)=0; 
    state=get(handles.maxlPDDP, 'Value');
    if state==1, 
        states(11) = 0;
    end    
end
refine_status = get(handles.RefineFactorsCheckbox, 'Value'); 
if refine_status == 1, 
    states(end - 2) = 1; 
    states(end) = 1; 
    if get(handles.refinementMethod, 'Value') == 2, 
        states(end - 1) = 0; 
    end    
else, 
    states(end - 2: end) = 0;
end
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);

% --- Executes on button press in kmeansRadio.
function kmeansRadio_Callback(hObject, eventdata, handles)
% hObject    handle to kmeansRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of kmeansRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.skmeansRadio, 'Value', 0);
    set(handles.PDDPRadio, 'Value', 0);
end

states=ones(length(handles.objects), 1); states([11:13])=0; 
state=get(handles.CentroidInit, 'Value');
if state==1, states([6 7])=0; end    
refine_status = get(handles.RefineFactorsCheckbox, 'Value'); 
if refine_status == 1, 
    states(end - 2) = 1; 
    states(end) = 1; 
    if get(handles.refinementMethod, 'Value') == 2, 
        states(end - 1) = 0; 
    end    
else, 
    states(end - 2: end) = 0;
end
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);

% --- Executes on button press in skmeansRadio.
function skmeansRadio_Callback(hObject, eventdata, handles)
% hObject    handle to skmeansRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of skmeansRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.kmeansRadio, 'Value', 0);
    set(handles.PDDPRadio, 'Value', 0);
end
             
states=ones(length(handles.objects), 1); states([11:13])=0; 
state=get(handles.CentroidInit, 'Value');
if state==1, states([6 7])=0; end    
refine_status = get(handles.RefineFactorsCheckbox, 'Value'); 
if refine_status == 1, 
    states(end - 2) = 1; 
    states(end) = 1; 
    if get(handles.refinementMethod, 'Value') == 2, 
        states(end - 1) = 0; 
    end    
else, 
    states(end - 2: end) = 0;
end
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);

% --- Executes on button press in PDDPRadio.
function PDDPRadio_Callback(hObject, eventdata, handles)
% hObject    handle to PDDPRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PDDPRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.kmeansRadio, 'Value', 0);
    set(handles.skmeansRadio, 'Value', 0);
end
             
states=ones(length(handles.objects), 1); states([5:9])=0; states(7) = -1;
state=get(handles.maxlPDDP, 'Value');
if state==1, 
    states(11)=0;
end
refine_status = get(handles.RefineFactorsCheckbox, 'Value'); 
if refine_status == 1, 
    states(end - 2) = 1; 
    states(end) = 1; 
    if get(handles.refinementMethod, 'Value') == 2, 
        states(end - 1) = 0; 
    end    
else, 
    states(end - 2: end) = 0;
end
handles=activate_uicontrol(states, handles);
    
guidata(hObject, handles);


function nClusters_Callback(hObject, eventdata, handles)
% hObject    handle to nClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nClusters as text
%        str2double(get(hObject,'String')) returns contents of nClusters as a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function nClusters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in CentroidInit.
function CentroidInit_Callback(hObject, eventdata, handles)
% hObject    handle to CentroidInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns CentroidInit contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CentroidInit
state=get(hObject, 'Value'); 
if state==1, 
    set(handles.CentroidsVarButton, 'Enable', 'off');
else, 
    set(handles.CentroidsVarButton, 'Enable', 'on');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function CentroidInit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentroidInit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CentroidsVar_Callback(hObject, eventdata, handles)
% hObject    handle to CentroidsVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CentroidsVar as text
%        str2double(get(hObject,'String')) returns contents of CentroidsVar
%        as a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function CentroidsVar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CentroidsVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CentroidsVarButton.
function CentroidsVarButton_Callback(hObject, eventdata, handles)
% hObject    handle to CentroidsVarButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=open_file(3);
set(handles.CentroidsVar, 'String', s);
guidata(hObject, handles);

% --- Executes on selection change in Termination.
function Termination_Callback(hObject, eventdata, handles)
% hObject    handle to Termination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Termination contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Termination

state=get(hObject, 'Value'); s=get(handles.TerminationValue, 'String');
if state==1 & isempty(s), set(handles.TerminationValue, 'String', 1); end
if state==2 & isempty(s), set(handles.TerminationValue, 'String', 10); end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Termination_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Termination (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TerminationValue_Callback(hObject, eventdata, handles)
% hObject    handle to TerminationValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TerminationValue as text
%        str2double(get(hObject,'String')) returns contents of TerminationValue as a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TerminationValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TerminationValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DispRes.
function DispRes_Callback(hObject, eventdata, handles)
% hObject    handle to DispRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DispRes
guidata(hObject, handles);


function lPDDP_Callback(hObject, eventdata, handles)
% hObject    handle to lPDDP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lPDDP as text
%        str2double(get(hObject,'String')) returns contents of lPDDP as a double
l=get(hObject, 'String');
if isempty(l), return; end
l=str2double(l);
if ~isnumeric(l), msgbox('You have to provide the number of principal directions...', 'Error', 'modal'); return; end
if mod(l, 1)~=0, msgbox('You have to provide an integer number of principal directions...', 'Error', 'modal'); return; end
state=get(handles.maxlPDDP, 'Value');
if state==1, 
    set(handles.maxlPDDP, 'Value', 0);
    s={'Basic';'Split with k-means';'Optimal Split';'Optimal Split with k-means';'Optimal Split on Projection'}; v=1; 
    set(handles.PDDPvariant, 'String', s); set(handles.PDDPvariant, 'Value', 1); 
end
if l>1, 
    s={'Basic';'Optimal Split on Projection'}; v=1; set(handles.PDDPvariant, 'String', s); set(handles.PDDPvariant, 'Value', 1); 
else, 
    s={'Basic';'Split with k-means';'Optimal Split';'Optimal Split with k-means';'Optimal Split on Projection'}; v=1; set(handles.PDDPvariant, 'String', s); set(handles.PDDPvariant, 'Value', 1); 
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lPDDP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lPDDP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ksSelection1.
function ksSelection1_Callback(hObject, eventdata, handles)
% hObject    handle to ksSelection1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ksSelection1


% --- Executes on button press in RefineFactorsCheckbox.
function RefineFactorsCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to RefineFactorsCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RefineFactorsCheckbox

state = get(hObject, 'Value');
if state == 1, tmp = 'on'; elseif state == 0, tmp = 'off'; else, tmp = 'inactive'; end
set(handles.refinementMethod, 'Enable', tmp);
set(handles.refineResultsDisplay, 'Enable', tmp);

set(handles.RefineNIter, 'Enable', tmp);
if state ~= 1,
    set(handles.RefineNIter, 'BackgroundColor', handles.light_gray); 
else, 
    if get(handles.refinementMethod, 'Value') == 2, 
        set(handles.RefineNIter, 'Enable', 'off');
        set(handles.RefineNIter, 'BackgroundColor', handles.light_gray); 
    else, 
        set(handles.RefineNIter, 'BackgroundColor', 'white');
    end
end


function RefineNIter_Callback(hObject, eventdata, handles)
% hObject    handle to RefineNIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RefineNIter as text
%        str2double(get(hObject,'String')) returns contents of RefineNIter as a double
l=get(hObject, 'String');
if isempty(l), return; end
l=str2double(l);
if ~isnumeric(l), msgbox('You have to provide the number of iterations...', 'Error', 'modal'); return; end
if mod(l, 1)~=0 | l<=0, msgbox('You have to provide a positive integer number of iterations...', 'Error', 'modal'); return; end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function RefineNIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RefineNIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',handles.light_gray);
end


% --- Executes on selection change in refinementMethod.
function refinementMethod_Callback(hObject, eventdata, handles)
% hObject    handle to refinementMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns refinementMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from refinementMethod
if get(handles.refinementMethod, 'Value') == 2, 
	set(handles.RefineNIter, 'Enable', 'off');
    set(handles.RefineNIter, 'BackgroundColor', handles.light_gray); 
else, 
    set(handles.RefineNIter, 'Enable', 'on');
	set(handles.RefineNIter, 'BackgroundColor', 'white');
end


% --- Executes during object creation, after setting all properties.
function refinementMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to refinementMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in refineResultsDisplay.
function refineResultsDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to refineResultsDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of refineResultsDisplay


% --- Executes on button press in svds.
function svds_Callback(hObject, eventdata, handles)
% hObject    handle to svds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of svds
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.propack, 'Value', 0);
end
guidata(hObject, handles);


% --- Executes on button press in propack.
function propack_Callback(hObject, eventdata, handles)
% hObject    handle to propack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of propack
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.svds, 'Value', 0);
end
guidata(hObject, handles);


% --- Executes on selection change in PDDPvariant.
function PDDPvariant_Callback(hObject, eventdata, handles)
% hObject    handle to PDDPvariant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns PDDPvariant contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PDDPvariant


% --- Executes during object creation, after setting all properties.
function PDDPvariant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PDDPvariant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maxlPDDP.
function maxlPDDP_Callback(hObject, eventdata, handles)
% hObject    handle to maxlPDDP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of maxlPDDP
state=get(hObject, 'Value');
if state==1, 
    set(handles.lPDDP, 'Enable', 'off'); 
    set(handles.lPDDP, 'BackgroundColor', handles.light_gray); 
    s={'Basic';'Optimal Split on Projection'}; v=1; set(handles.PDDPvariant, 'String', s); set(handles.PDDPvariant, 'Value', 1); 
else, 
    set(handles.lPDDP, 'Enable', 'on'); 
    set(handles.lPDDP, 'BackgroundColor', 'white');     
    s={'Basic';'Split with k-means';'Optimal Split';'Optimal Split with k-means';'Optimal Split on Projection'}; v=1; set(handles.PDDPvariant, 'String', s); set(handles.PDDPvariant, 'Value', 1); 
end

%--------------------------------------------------------------------------
%set Active and BackgroundColor field of each uicontrol item depending on
%the Radio Button that is pressed (called by the corresponding callback)
function handles=activate_uicontrol(states, handles)
sz=size(handles.objects, 1);
for i=1:sz,
    if states(i)==1, tmp='on'; elseif states(i)==0, tmp='off'; else, tmp='inactive'; end
    set(handles.objects(i), 'Enable', tmp);
    if states(i)~=1 & isequal(get(handles.objects(i), 'Style'), 'edit'),
        set(handles.objects(i), 'BackgroundColor', handles.light_gray);continue;
    end
    if states(i)==1 & isequal(get(handles.objects(i), 'Style'), 'edit'),
        set(handles.objects(i), 'BackgroundColor', 'white');
    end
end
