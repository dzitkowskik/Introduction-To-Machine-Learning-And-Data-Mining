function varargout = classification_gui(varargin)
% CLASSIFICATION_GUI 
%   CLASSIFICATION_GUI is a graphical user interface for all 
%   the classification functions of the Text to Matrix Generator 
%   (TMG) Toolbox. 
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

% Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @classification_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @classification_gui_OutputFcn, ...
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

% --- Executes just before classification_gui is made visible.
function classification_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for classification_gui
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

OPTIONS=struct('delimiter', 'none_delimiter', 'line_delimiter', 1, 'stemming', 0, ...
        'local_weight', 't', 'dsp', 0);
handles.OPTIONS=OPTIONS;
handles.gwquery_type='Files'; handles.labels_type='Files';

handles.objects=[handles.Labels;handles.LabelsButton;handles.StoredLabels;handles.SQuery;...
    handles.FQuery;handles.FQueryButton;handles.SQueryRadio;handles.FQueryRadio;...
    handles.GW;handles.GWButton;handles.StoredGW;handles.Stoplist;handles.StoplistButton;...
    handles.TW;handles.MultiRadio;handles.SingleRadio;handles.kNNRadio;handles.kNN;...
    handles.RocchioRadio;handles.RocchioPos;handles.RocchioNeg;handles.LLSFRadio;...
    handles.nFactorsLLSF;handles.UseThresholds;handles.ComputeThresholds;handles.Thresholds;...
    handles.ThresholdsButton;handles.Fvalue;handles.VSMRadio;handles.LSARadio;handles.LSAMethod;...
    handles.nFactors;handles.Similarity;handles.svdsRadio;handles.propackRadio;handles.Delimiter;...
    handles.LineDelimiter];
     
states=zeros(length(handles.objects), 1); states([4 7 8])=1;
handles=activate_uicontrol(states, handles);
handles.methods={'Singular Value Decomposition';'Clustered Latent Semantic Indexing';'Centroid Method'};
handles.k=cell(1, 1); handles.real_methods=cell(1, 1);
set(handles.sp_text1, 'Visible', 'off'); set(handles.sp_text2, 'Visible', 'off'); 
set(handles.sp_text3, 'Visible', 'off'); set(handles.sp_text4, 'Visible', 'off'); 
set(handles.sp_text5, 'Visible', 'off'); set(handles.sp_text6, 'Visible', 'on'); 
set(handles.FQuery, 'Visible', 'off'); set(handles.FQueryButton, 'Visible', 'off');
set(handles.svdsRadio, 'Visible', 'off'); set(handles.propackRadio, 'Visible', 'off'); 
set(handles.Delimiter, 'Visible', 'off'); set(handles.LineDelimiter, 'Visible', 'off'); 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes classification_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = classification_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in DatasetMenu.
function DatasetMenu_Callback(hObject, eventdata, handles)
% hObject    handle to DatasetMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns DatasetMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        DatasetMenu
s=get(hObject, 'String'); v=get(hObject, 'Value');
states=zeros(length(handles.objects), 1);
if ~isempty(s{v}),  
    states(3)=1;  
    if get(handles.StoredLabels, 'Value')==0, states([1 2])=1; end
    states((4:8))=1;
    if get(handles.StoredGW, 'Value')==0, states([9 10])=1; end
    states((11:17))=1; states(19)=1; states(22)=1; 
    if get(handles.kNNRadio, 'Value')==1, states(18)=1; end
    if get(handles.RocchioRadio, 'Value')==1, states([20 21])=1; end
    if get(handles.LLSFRadio, 'Value')==1, states(23)=1; end
    if get(handles.MultiRadio, 'Value')==1, 
        states([24 25])=1;
        if get(handles.UseThresholds, 'Value')==1, states([26 27])=1; end
        if get(handles.ComputeThresholds, 'Value')==1, states(28)=1; end
    end
    states(29)=1;
    k=cell(4, 1);
    act=zeros(4, 1);
    ss={'svd';'clsi';'cm'};
    str=s{v};
    for i=1:length(ss),
        str1=strcat(str, filesep, ss{i});
        if exist(str1), 
            sss=dir(str1);
            for j=1:size(sss, 1),
                cur=sss(j);
                if isequal(cur, '.') | isequal(cur, '..') | ~isdir(strcat(str1, filesep, cur.name)), continue; end
                if i==1, 
                    if exist(strcat(str1, filesep, cur.name, filesep, 'Usvd.mat')) & exist(strcat(str1, filesep, cur.name, filesep, 'Ssvd.mat')) & exist(strcat(str1, filesep, cur.name, filesep, 'Vsvd.mat')), 
                        act(1)=1;
                        kk=str2double(cur.name(3:end)); if isempty(k{1}), k{1}=kk; else, k{1}(end+1, 1)=kk; end
                    end
                end
                if i==2, 
                    if exist(strcat(str1, filesep, cur.name, filesep, 'Xclsi.mat')) & exist(strcat(str1, filesep, cur.name, filesep, 'Yclsi.mat')), 
                        act(2)=1;
                        kk=str2double(cur.name(3:end)); if isempty(k{2}), k{2}=kk; else, k{2}(end+1, 1)=kk; end
                    end
                end
                if i==3, 
                    if exist(strcat(str1, filesep, cur.name, filesep, 'Xcm.mat')) & exist(strcat(str1, filesep, cur.name, filesep, 'Ycm.mat')), 
                        act(3)=1;
                        kk=str2double(cur.name(3:end)); if isempty(k{3}), k{3}=kk; else, k{3}(end+1, 4)=kk; end
                    end
                end                
            end
        end
    end

    if ~isempty(find(act)), 
        handles.k=k; handles.real_methods={handles.methods{find(act)}}';
        set(handles.sp_text1, 'Visible', 'off'); set(handles.sp_text2, 'Visible', 'off');         
        states(32)=1;
    else, 
        handles.k=cell(1, 1); handles.real_methods=cell(1, 1);
        set(handles.sp_text1, 'Visible', 'on'); set(handles.sp_text2, 'Visible', 'on');         
        set(handles.LSARadio, 'Value', 0); set(handles.VSMRadio, 'Value', 1);
    end
    guidata(hObject, handles);
    set(handles.LSAMethod, 'String', handles.real_methods); set(handles.LSAMethod, 'Value', 1);
    set(handles.nFactors, 'String', handles.k); set(handles.nFactors, 'Value', 1);
    
    if get(handles.LLSFRadio, 'Value')==1, 
        states([29 32 33])=0; states([30 31 34 35])=1;
        set(handles.svdsRadio, 'Visible', 'on'); set(handles.propackRadio, 'Visible', 'on');  set(handles.sp_text3, 'Visible', 'on'); 
        set(handles.svdsRadio, 'Enable', 'on'); set(handles.propackRadio, 'Enable', 'on');  
        set(handles.LSARadio, 'Value', 1); 
    else, 
        set(handles.svdsRadio, 'Visible', 'off'); set(handles.propackRadio, 'Visible', 'off');  set(handles.sp_text3, 'Visible', 'off'); 
        set(handles.svdsRadio, 'Enable', 'off'); set(handles.propackRadio, 'Enable', 'off');  
        states(33)=1;
        states(29)=1;
        if isempty(find(act)), 
            states([30 31])=0;
        else, 
            states([30 31])=1;
            set(handles.LSAMethod, 'String', {handles.methods{find(act)}}'); 
            frs=find(act); set(handles.nFactors, 'String', k{frs(1)}); 
        end
    end
    
    if get(handles.FQueryRadio, 'Value')==1, 
        set(handles.sp_text5, 'Visible', 'on'); set(handles.sp_text6, 'Visible', 'off'); 
        states([5 6 36 37])=1; 
        set(handles.Delimiter, 'Enable', 'on'); set(handles.Delimiter, 'BackgroundColor', 'white'); set(handles.sp_text4, 'Visible', 'on'); 
        set(handles.LineDelimiter, 'Visible', 'on'); 
    else, 
        set(handles.sp_text5, 'Visible', 'off'); set(handles.sp_text6, 'Visible', 'on'); 
        states(36)=0; 
        set(handles.Delimiter, 'Enable', 'off'); set(handles.Delimiter, 'BackgroundColor', handles.light_gray);set(handles.sp_text4, 'Visible', 'off'); 
        set(handles.LineDelimiter, 'Visible', 'off'); 
    end
end
handles=activate_uicontrol(states, handles);
if get(handles.SQueryRadio, 'Value')==1, 
    set(handles.SQuery, 'Visible', 'on'); 
    set(handles.FQuery, 'Visible', 'off'); set(handles.FQueryButton, 'Visible', 'off'); 
else, 
    set(handles.SQuery, 'Visible', 'off'); 
    set(handles.FQuery, 'Visible', 'on'); set(handles.FQueryButton, 'Visible', 'on');     
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function DatasetMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DatasetMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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

% --- Executes on button press in ContinueButton.
function ContinueButton_Callback(hObject, eventdata, handles)
% hObject    handle to ContinueButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(handles.DatasetMenu, 'String'); str=str{get(handles.DatasetMenu, 'Value')};
if isempty(str), 
    an=sprintf('Select a dataset...');
    msgbox(an, 'Error', 'modal');
    return;    
end
load(strcat(str, filesep, 'A.mat'));
if get(handles.StoredLabels, 'Value')==1, 
    try, 
        load(strcat(str, filesep, 'labels.mat')); 
    catch, 
        an=sprintf('Variable %s not found...', strcat(str, filesep, 'labels.mat'));
        msgbox(an, 'Error', 'modal');
        return;             
    end
else, 
    if isempty(get(handles.Labels, 'String')), 
        an=sprintf('You didn''t supply the labels file-variable...');
        msgbox(an, 'Error', 'modal');
        return;
    end    
    if isequal(handles.labels_type, 'Files'), 
        try, 
            load(get(handles.Labels, 'String'));
            labels=eval(char(fieldnames(load(get(handles.Labels, 'String')))));
        catch, 
            an=sprintf('Bad format for labels file %s...', get(handles.Labels, 'String'));
            msgbox(an, 'Error', 'modal');
            return;             
        end        
    else, 
        labels=evalin('base', get(handles.Labels, 'String'));
    end
end
if ~iscell(labels),
    an=sprintf('Labels must be a cell array...');
	msgbox(an, 'Error', 'modal');
	return;                 
end
if size(A, 2)~=length(labels) | (size(labels, 2)~=1 & size(labels, 2)~=1 & size(A, 2)~=1),
    an=sprintf('Labels variable size does not match with number of documents...', get(handles.Labels, 'String'));
	msgbox(an, 'Error', 'modal');
	return;                 
end

[labels, unique_labels]=make_labels(labels);

if iscell(labels)==1 & get(handles.SingleRadio, 'Value')==1, 
    an=sprintf('You supplied a multi-label variable for a single-label collection...', get(handles.Labels, 'String'));
	msgbox(an, 'Error', 'modal');
	return;                     
end

if get(handles.MultiRadio, 'Value')==1, 
    if get(handles.UseThresholds, 'Value')==1, 
        if isempty(get(handles.Thresholds, 'String')), 
            an=sprintf('You haven''t supplied the thresholds variable...', get(handles.Labels, 'String'));
        	msgbox(an, 'Error', 'modal');
        	return;                             
        end
        try, 
            thresholds=evalin('base', get(handles.Thresholds, 'String'));
        catch, 
            an=sprintf('Variable %s not found...', get(handles.Thresholds, 'String'));
        	msgbox(an, 'Error', 'modal');
        	return;                                         
        end
        if length(thresholds)~=length(unique_labels), 
            an=sprintf('Length of thresholds variable does not match number of classes...');
        	msgbox(an, 'Error', 'modal');
        	return;                                                                 
        end
    else, 
        if isempty(get(handles.Fvalue, 'String')), 
            an=sprintf('You haven''t supply the minimum F-value...');
        	msgbox(an, 'Error', 'modal');
        	return;                                                     
        end        
        minF1=str2double(get(handles.Fvalue, 'String'));
        if minF1<=0 | minF1>=1, 
            an=sprintf('Minimum F-value must be greater than 0 and less than 1...');
        	msgbox(an, 'Error', 'modal');
        	return;                                                     
        end
        thresholds=[];
        inds=make_val_inds(labels);
        clusters1=make_clusters_multi({labels{find(inds==1)}}');
    end
end
if get(handles.MultiRadio, 'Value')==1, clusters=make_clusters_multi(labels); else, clusters=make_clusters_single(labels); end

if get(handles.SQueryRadio, 'Value')==1, 
    if isempty(get(handles.SQuery, 'String')), 
        an=sprintf('You didn''t provide a query...');
        msgbox(an, 'Error', 'modal');
        return;
    end
else, 
    if isempty(handles.filename), 
        an=sprintf('You didin''t supply a file...');
        msgbox(an, 'Error', 'modal');
        return;
    end
    if ~exist(handles.filename), 
        an=sprintf('File %s not found...', handles.filename);
        msgbox(an, 'Error', 'modal');
        return;
    end
end
if get(handles.StoredGW, 'Value'), 
    if exist(strcat(str, filesep, 'global_weights.mat')), load(strcat(str, filesep, 'global_weights.mat')); end
else, 
    if isempty(get(handles.GW, 'String')), 
        global_weights=ones(size(dictionary, 1), 1); 
    else, 
        if isequal(handles.gwquery_type, 'Files'), 
            if ~exist(get(handles.GW, 'String')), 
                an=sprintf('File %s not found...', get(handles.GW, 'String'));
                msgbox(an, 'Error', 'modal');
                return;
            else, 
                load(get(handles.GW, 'String'))
                global_weights=eval(char(fieldnames(load(get(handles.GW, 'String')))));
                if size(global_weights, 1)~=size(A, 1),
                    an=sprintf('Dictionary size does not match...');
                    msgbox(an, 'Error', 'modal');
                    return;                    
                end
                opts.global_weights=global_weights;
            end
        else, 
            global_weights=evalin('base', get(handles.GW, 'String'));
            if size(global_weights, 1)~=size(A, 1),
                an=sprintf('Dictionary size does not match...');
                msgbox(an, 'Error', 'modal');
                return;                    
            end 
            opts.global_weights=global_weights;
        end
    end
end
if ~isempty(get(handles.Stoplist, 'String')), 
    if ~exist(get(handles.Stoplist, 'String')), 
        an=sprintf('File %s not found...', get(handles.Stoplist, 'String'));
        msgbox(an, 'Error', 'modal');
        return;
	else, 
        handles.OPTIONS.stoplist=get(handles.Stoplist, 'String');
	end
end 
if exist(strcat(str, filesep, 'update_struct.mat')),
    load(strcat(str, filesep, 'update_struct.mat'));
    handles.OPTIONS.stemming=update_struct.stemming;
end
guidata(hObject, handles);
try, 
	load(strcat(str, filesep, 'dictionary.mat'));
catch, 
	an=sprintf('Dictionary not found in %s...', strcat(str, filesep, 'dictionary.mat'));
	msgbox(an, 'Error', 'modal');
	return;             
end        
if get(handles.FQueryRadio, 'Value')==1, 
    warning off; Q=tmg_query(handles.filename, dictionary, handles.OPTIONS); warning on;
else, 
    fname=datestr(now); fname=strrep(fname, ' ', '_'); fname=strrep(fname, ':', '-');
    qry=get(handles.SQuery, 'String');
    fid=fopen(fname, 'wt'); fprintf(fid, '%s', qry); fclose(fid); 
    warning off; Q=tmg_query(fname, dictionary, handles.OPTIONS); warning on;
    delete(fname);
end
if nnz(Q)==0, an=sprintf('The query is empty...'); msgbox(an, 'Error', 'modal'); return; end

if get(handles.MultiRadio, 'Value')==1, k_max=max([labels{:}]); else, k_max=max(labels); labels; end; 
if get(handles.LLSFRadio, 'Value')==1, 
    method=[]; svd_method=[]; clsi_method='f1';
    if get(handles.LSAMethod, 'Value')==1, method='svd'; end
    if get(handles.LSAMethod, 'Value')==2, method='clsi'; end
    if get(handles.LSAMethod, 'Value')==3, method='cm'; end
    if get(handles.svdsRadio, 'Value')==1, svd_method='svds'; else, svd_method='propack'; end
    if isempty(get(handles.nFactorsLLSF, 'String')), 
        an=sprintf('You haven''t supply the number of factors...');
        msgbox(an, 'Error', 'modal');
        return;        
    end
    l=str2double(get(handles.nFactorsLLSF, 'String')); 
    if l<k_max, 
        an=sprintf('Number of factors must be at least equal to the number of classes...');
        msgbox(an, 'Error', 'modal');
        return;                
    end
    if get(handles.MultiRadio, 'Value')==1, 
        if isempty(thresholds), 
            thresholds=scut_llsf(A(:, find(inds==1)), A(:, find(inds==2)), clusters1, {labels{find(inds==1)}}', {labels{find(inds==2)}}', minF1, l, method, 10, svd_method, clsi_method);
        end
        labels_as=llsf_multi(A, Q, clusters, labels, l, method, thresholds, svd_method, clsi_method);
%         for i=1:length(labels_as), 
%             tmp=labels_as{i}; tmp1='';
%             for j=1:length(tmp), 
%                 if j==1, tmp1=unique_labels{tmp(j)}; else, tmp1=sprintf('%s %s', tmp1, unique_labels{tmp(j)}); end
%             end
%             labels_as{i}=tmp1;
%         end
    else, 
        labels_as=llsf_single(A, Q, clusters, labels, l, method, svd_method, clsi_method);
%        labels_as={unique_labels{labels_as}}';
    end
else, 
    if get(handles.Similarity, 'Value')==1, normalize=1; else, normalize=0; end    
    if get(handles.VSMRadio, 'Value')==1, 
        AA=A; QQ=Q;
    else, 
        s=get(handles.LSAMethod, 'String'); v=get(handles.LSAMethod, 'Value'); k=get(handles.nFactors, 'String');
        if isequal(s{v}, handles.methods{1}), 
            str=strcat(str, filesep, 'svd', filesep, 'k_', k);
            load(strcat(str, filesep, 'Usvd.mat')); load(strcat(str, filesep, 'Ssvd.mat')); load(strcat(str, filesep, 'Vsvd.mat'));
            AA=Ssvd*Vsvd'; QQ=Usvd'*Q;
        end        
        if isequal(s{v}, handles.methods{2}), 
            str=strcat(str, filesep, 'clsi', filesep, 'k_', k);
            load(strcat(str, filesep, 'Xclsi.mat')); load(strcat(str, filesep, 'Yclsi.mat')); 
            AA=Yclsi; QQ=Xclsi'*Q;
        end                
        if isequal(s{v}, handles.methods{3}), 
            str=strcat(str, filesep, 'cm', filesep, 'k_', k);
            load(strcat(str, filesep, 'Xcm.mat')); load(strcat(str, filesep, 'Ycm.mat')); 
            AA=Ycm; QQ=Xcm'*Q;
        end 
    end
    if get(handles.kNNRadio, 'Value')==1, 
        if isempty(get(handles.kNN, 'String')), 
            an=sprintf('You haven''t supply the number of nearest neighboors...');
            msgbox(an, 'Error', 'modal');
            return;        
        end
        knn=str2double(get(handles.kNN, 'String')); 
        if knn<1, 
            an=sprintf('Number of nearest neighboors must be at least 1...');
            msgbox(an, 'Error', 'modal');
            return;                
        end            
    end
    if get(handles.RocchioRadio, 'Value')==1, 
        if isempty(get(handles.RocchioPos, 'String')), 
            an=sprintf('You haven''t supply the weight of positive examples...');
            msgbox(an, 'Error', 'modal');
            return;        
        end
        r_pos=str2double(get(handles.RocchioPos, 'String')); 
        if r_pos<=0, 
            an=sprintf('Positive weight must be a positive value...');
            msgbox(an, 'Error', 'modal');
            return;                
        end            
        if isempty(get(handles.RocchioNeg, 'String')), 
            r_neg=0;
        else, 
            r_neg=str2double(get(handles.RocchioNeg, 'String')); 
            if r_neg<0, 
                an=sprintf('Negative weight must be a non-negative value...');
                msgbox(an, 'Error', 'modal');
                return;                
            end                        
        end
    end        
    if get(handles.kNNRadio, 'Value')==1, 
        if get(handles.SingleRadio, 'Value')==1, 
            labels_as=knn_single(AA, QQ, knn, labels, normalize);
        else, 
            if isempty(thresholds), 
                thresholds=scut_knn(AA(:, find(inds==1)), AA(:, find(inds==2)), knn, {labels{find(inds==1)}}', {labels{find(inds==2)}}', minF1, normalize, 10);
            end            
            labels_as=knn_multi(AA, QQ, knn, labels, normalize, thresholds);
        end
    end
    if get(handles.RocchioRadio, 'Value')==1, 
        if get(handles.SingleRadio, 'Value')==1, 
            labels_as=rocchio_single(AA, clusters, r_pos, r_neg, QQ, labels, normalize);
        else, 
            if isempty(thresholds), 
                thresholds=scut_rocchio(AA(:, find(inds==1)), clusters1, r_pos, r_neg, AA(:, find(inds==2)), {labels{find(inds==1)}}', {labels{find(inds==2)}}', minF1, normalize, 10);
            end            
            labels_as=rocchio_multi(AA, clusters, r_pos, r_neg, QQ, labels, normalize, thresholds);
        end
    end    
    assignin('base', 'Anew', AA); assignin('base', 'Qnew', QQ); 
end
if get(handles.SingleRadio, 'Value')==1, 
    labels_as={unique_labels{labels_as}}';
else, 
    for i=1:length(labels_as), 
        tmp=labels_as{i}; tmp1='';
        for j=1:length(tmp), 
            if j==1, tmp1=unique_labels{tmp(j)}; else, tmp1=sprintf('%s %s', tmp1, unique_labels{tmp(j)}); end
        end
        labels_as{i}=tmp1;
    end    
end
assignin('base', 'labels_as', labels_as);
assignin('base', 'A', A); assignin('base', 'Q', Q); 
msgbox('Done! Results saved to labels_as variable of workspace.', 'modal');

% --- Executes on button press in ClearBotton.
function ClearBotton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearBotton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DatasetMenu, 'Value', 1); set(handles.Labels, 'String', ''); 
set(handles.StoredLabels, 'Value', 1); set(handles.SQuery, 'String', '');
set(handles.SQuery, 'Visible', 'on'); set(handles.FQuery, 'Visible', 'off'); set(handles.FQueryButton, 'Visible', 'off'); 
set(handles.SQueryRadio, 'Value', 1); set(handles.FQueryRadio, 'Value', 0);
set(handles.GW, 'String', ''); set(handles.StoredGW, 'Value', 1);
set(handles.Stoplist, 'String', ''); set(handles.TW, 'Value', 1);  
set(handles.LSAMethod, 'String', cell(1, 1));
set(handles.MultiRadio, 'Value', 1); set(handles.SingleRadio, 'Value', 0);
set(handles.kNNRadio, 'Value', 1); set(handles.kNN, 'String', ''); 
set(handles.RocchioRadio, 'Value', 0); set(handles.RocchioPos, 'String', ''); set(handles.RocchioNeg, 'String', ''); 
set(handles.LLSFRadio, 'Value', 0); set(handles.nFactorsLLSF, 'String', '');
set(handles.UseThresholds, 'Value', 1); set(handles.ComputeThresholds, 'Value', 0); 
set(handles.Thresholds, 'String', ''); set(handles.Fvalue, 'String', '');
set(handles.VSMRadio, 'Value', 1); set(handles.LSARadio, 'Value', 0);
set(handles.LSAMethod, 'String', cell(1, 1)); set(handles.LSAMethod, 'Value', 1); 
set(handles.nFactors, 'String', cell(1, 1)); set(handles.Similarity, 'Value', 1);
set(handles.Similarity, 'Value', 1); 
set(handles.svdsRadio, 'Value', 1); set(handles.propackRadio, 'Value', 1);
set(handles.svdsRadio, 'Visible', 'off'); set(handles.propackRadio, 'Visible', 'off');
set(handles.sp_text1, 'Visible', 'off'); set(handles.sp_text2, 'Visible', 'off'); 
set(handles.sp_text3, 'Visible', 'off'); set(handles.sp_text4, 'Visible', 'off');
set(handles.sp_text5, 'Visible', 'off'); set(handles.sp_text6, 'Visible', 'on'); 
set(handles.Delimiter, 'Visible', 'off'); set(handles.LineDelimiter, 'Visible', 'off'); set(handles.LineDelimiter, 'Value', 1);
states=zeros(size(handles.objects, 1), 1); states([4 7 8])=1;
handles=activate_uicontrol(states, handles);

% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);



function Labels_Callback(hObject, eventdata, handles)
% hObject    handle to Labels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Labels as text
%        str2double(get(hObject,'String')) returns contents of Labels as a double
s=get(hObject, 'String');
handles.labels_type='Files';
guidata(hObject, handles);
if isempty(s), return; end
if isequal(handles.labels_type, 'Files'),
    [pathstr, name, ext] = fileparts(s);
    if ~isequal(ext, '.mat'),
        msgbox('You have to provide a mat file...', 'Error', 'modal');
        set(hObject, 'String', '');guidata(hObject, handles);
        return;
    end
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Labels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Labels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LabelsButton.
function LabelsButton_Callback(hObject, eventdata, handles)
% hObject    handle to LabelsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[s, handles.labels_type]=open_file(2);
guidata(hObject, handles);
set(handles.Labels, 'String', s);

if isempty(s), return; end
if isequal(handles.labels_type, 'Files'),
    [pathstr, name, ext] = fileparts(s);
    if ~isequal(ext, '.mat'),
        msgbox('You have to provide a mat file...', 'Error', 'modal');
        set(handles.Labels, 'String', '');guidata(hObject, handles);
        return;
    end
end

guidata(hObject, handles);

% --- Executes on button press in StoredLabels.
function StoredLabels_Callback(hObject, eventdata, handles)
% hObject    handle to StoredLabels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StoredLabels
s=get(hObject, 'Value'); 
if s==1, 
    set(handles.Labels, 'BackgroundColor', handles.light_gray);
    set(handles.Labels, 'Enable', 'off'); set(handles.LabelsButton, 'Enable', 'off'); 
else, 
    set(handles.Labels, 'BackgroundColor', 'white');
    set(handles.Labels, 'Enable', 'on'); set(handles.LabelsButton, 'Enable', 'on'); 
end
guidata(hObject, handles);

% --- Executes on button press in MultiRadio.
function MultiRadio_Callback(hObject, eventdata, handles)
% hObject    handle to MultiRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MultiRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.SingleRadio, 'Value', 0);
end
set(handles.UseThresholds, 'Enable', 'on'); set(handles.ComputeThresholds, 'Enable', 'on');
if get(handles.UseThresholds, 'Value')==1, 
    set(handles.Thresholds, 'Enable', 'on'); set(handles.ThresholdsButton, 'Enable', 'on');
    set(handles.Thresholds,'BackgroundColor', 'white');
    set(handles.Fvalue, 'Enable', 'off'); set(handles.Fvalue,'BackgroundColor', handles.light_gray);
else, 
    set(handles.Thresholds, 'Enable', 'off'); set(handles.ThresholdsButton, 'Enable', 'off');
    set(handles.Thresholds,'BackgroundColor', handles.light_gray);
    set(handles.Fvalue, 'Enable', 'on'); set(handles.Fvalue,'BackgroundColor', 'white');
end

% --- Executes on button press in SingleRadio.
function SingleRadio_Callback(hObject, eventdata, handles)
% hObject    handle to SingleRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SingleRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.MultiRadio, 'Value', 0);
end
set(handles.UseThresholds, 'Enable', 'off'); set(handles.ComputeThresholds, 'Enable', 'off');
set(handles.Thresholds, 'Enable', 'off'); set(handles.ThresholdsButton, 'Enable', 'off');
set(handles.Fvalue, 'Enable', 'off');
set(handles.Thresholds, 'BackgroundColor', handles.light_gray); set(handles.Fvalue, 'BackgroundColor', handles.light_gray);

% --- Executes on button press in kNNRadio.
function kNNRadio_Callback(hObject, eventdata, handles)
% hObject    handle to kNNRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of kNNRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.RocchioRadio, 'Value', 0);
    set(handles.LLSFRadio, 'Value', 0);
end
set(handles.kNN, 'Enable', 'on'); set(handles.kNN, 'BackgroundColor', 'white'); 
set(handles.RocchioPos, 'Enable', 'off'); set(handles.RocchioNeg, 'Enable', 'off'); set(handles.nFactorsLLSF, 'Enable', 'off'); 
set(handles.RocchioPos, 'BackgroundColor', handles.light_gray); set(handles.RocchioNeg, 'BackgroundColor', handles.light_gray); 
set(handles.nFactorsLLSF, 'BackgroundColor', handles.light_gray); 

set(handles.VSMRadio, 'Enable', 'on'); 
if isempty(handles.k{1}), set(handles.VSMRadio, 'Value', 1); set(handles.LSARadio, 'Value', 0); set(handles.LSARadio, 'Enable', 'off'); set(handles.LSAMethod, 'Enable', 'off'); 
else, set(handles.LSARadio, 'Enable', 'on'); set(handles.LSAMethod, 'Enable', 'on'); end
set(handles.LSAMethod, 'String', handles.real_methods); set(handles.LSAMethod, 'Value', 1);    
set(handles.nFactors, 'String', handles.k); set(handles.nFactors, 'Value', 1); 
set(handles.svdsRadio, 'Visible', 'off'); set(handles.propackRadio, 'Visible', 'off');  set(handles.sp_text3, 'Visible', 'off'); 
set(handles.svdsRadio, 'Enable', 'off'); set(handles.propackRadio, 'Enable', 'off');  


% --- Executes on button press in RocchioRadio.
function RocchioRadio_Callback(hObject, eventdata, handles)
% hObject    handle to RocchioRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RocchioRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.kNNRadio, 'Value', 0);
    set(handles.LLSFRadio, 'Value', 0);
end
set(handles.kNN, 'Enable', 'off'); set(handles.kNN, 'BackgroundColor', handles.light_gray); 
set(handles.RocchioPos, 'Enable', 'on'); set(handles.RocchioNeg, 'Enable', 'on'); set(handles.nFactorsLLSF, 'Enable', 'off'); 
set(handles.RocchioPos, 'BackgroundColor', 'white'); set(handles.RocchioNeg, 'BackgroundColor', 'white'); 
set(handles.nFactorsLLSF, 'BackgroundColor', handles.light_gray); 

set(handles.VSMRadio, 'Enable', 'on'); 
if isempty(handles.k{1}), set(handles.VSMRadio, 'Value', 1); set(handles.LSARadio, 'Value', 0); set(handles.LSARadio, 'Enable', 'off'); set(handles.LSAMethod, 'Enable', 'off'); 
else, set(handles.LSARadio, 'Enable', 'on'); set(handles.LSAMethod, 'Enable', 'on'); end
set(handles.LSAMethod, 'String', handles.real_methods); set(handles.LSAMethod, 'Value', 1);    
set(handles.nFactors, 'String', handles.k); set(handles.nFactors, 'Value', 1); 
set(handles.svdsRadio, 'Visible', 'off'); set(handles.propackRadio, 'Visible', 'off');  set(handles.sp_text3, 'Visible', 'off'); 
set(handles.svdsRadio, 'Enable', 'off'); set(handles.propackRadio, 'Enable', 'off');  

function kNN_Callback(hObject, eventdata, handles)
% hObject    handle to kNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kNN as text
%        str2double(get(hObject,'String')) returns contents of kNN as a double


% --- Executes during object creation, after setting all properties.
function kNN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RocchioPos_Callback(hObject, eventdata, handles)
% hObject    handle to RocchioPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RocchioPos as text
%        str2double(get(hObject,'String')) returns contents of RocchioPos as a double


% --- Executes during object creation, after setting all properties.
function RocchioPos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RocchioPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RocchioNeg_Callback(hObject, eventdata, handles)
% hObject    handle to RocchioNeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RocchioNeg as text
%        str2double(get(hObject,'String')) returns contents of RocchioNeg as a double


% --- Executes during object creation, after setting all properties.
function RocchioNeg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RocchioNeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in VSMRadio.
function VSMRadio_Callback(hObject, eventdata, handles)
% hObject    handle to VSMRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VSMRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.LSARadio, 'Value', 0); 
    set(handles.LSAMethod, 'Enable', 'off'); set(handles.nFactors, 'Enable', 'off'); 
end

% --- Executes on button press in LSARadio.
function LSARadio_Callback(hObject, eventdata, handles)
% hObject    handle to LSARadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LSARadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.VSMRadio, 'Value', 0);
end

% --- Executes on selection change in LSAMethod.
function LSAMethod_Callback(hObject, eventdata, handles)
% hObject    handle to LSAMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns LSAMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LSAMethod


% --- Executes during object creation, after setting all properties.
function LSAMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LSAMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nFactors.
function nFactors_Callback(hObject, eventdata, handles)
% hObject    handle to nFactors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns nFactors contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nFactors


% --- Executes during object creation, after setting all properties.
function nFactors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nFactors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Similarity.
function Similarity_Callback(hObject, eventdata, handles)
% hObject    handle to Similarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Similarity contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Similarity


% --- Executes during object creation, after setting all properties.
function Similarity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Similarity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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



function SQuery_Callback(hObject, eventdata, handles)
% hObject    handle to SQuery (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SQuery as text
%        str2double(get(hObject,'String')) returns contents of SQuery as a double


% --- Executes during object creation, after setting all properties.
function SQuery_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SQuery (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GW_Callback(hObject, eventdata, handles)
% hObject    handle to GW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GW as text
%        str2double(get(hObject,'String')) returns contents of GW as a double
s=get(hObject, 'String');
handles.gwquery_type='Files';
guidata(hObject, handles);
OPT=handles.OPTIONS;
if isempty(s) & isfield(OPT, 'global_weights'),
    OPT=rmfield(OPT, 'global_weights');
    handles.OPTIONS=OPT;
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
if isequal(handles.gwquery_type, 'Files'),
    [pathstr, name, ext] = fileparts(s);
    if ~isequal(ext, '.mat'),
        msgbox('You have to provide a mat file...', 'Error', 'modal');
        OPT=handles.OPTIONS;if isfield(OPT, 'global_weights'), OPT=rmfield(OPT, 'global_weights'); end
        handles.OPTIONS=OPT;
        set(hObject, 'String', '');guidata(hObject, handles);
        return;
    end
end

OPT.global_weights=s;
handles.OPTIONS=OPT;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function GW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GWButton.
function GWButton_Callback(hObject, eventdata, handles)
% hObject    handle to GWButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[s, handles.gwquery_type]=open_file(2);
guidata(hObject, handles);
set(handles.GW, 'String', s);

OPT=handles.OPTIONS;
if isempty(s) & isfield(OPT, 'global_weights'),
    OPT=rmfield(OPT, 'global_weights');
    handles.OPTIONS=OPT;
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
if isequal(handles.gwquery_type, 'Files'),
    [pathstr, name, ext] = fileparts(s);
    if ~isequal(ext, '.mat'),
        msgbox('You have to provide a mat file...', 'Error', 'modal');
        OPT=handles.OPTIONS;if isfield(OPT, 'global_weights'), OPT=rmfield(OPT, 'global_weights'); end
        handles.OPTIONS=OPT;
        set(handles.GW, 'String', '');guidata(hObject, handles);
        return;
    end
end

OPT.global_weights=s;
handles.OPTIONS=OPT;
guidata(hObject, handles);

% --- Executes on selection change in TW.
function TW_Callback(hObject, eventdata, handles)
% hObject    handle to TW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns TW contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TW
OPT=handles.OPTIONS;
ind=get(hObject, 'Value');
switch ind,
    case 1,
        OPT.local_weight='t';
    case 2,
        OPT.local_weight='b';
    case 3,
        OPT.local_weight='l';
    case 4,
        OPT.local_weight='a';
    case 5,
        OPT.local_weight='n';
end
handles.OPTIONS=OPT;
handles.gwquery_type='Files';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Stoplist_Callback(hObject, eventdata, handles)
% hObject    handle to Stoplist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Stoplist as text
%        str2double(get(hObject,'String')) returns contents of Stoplist as a double
s=get(hObject,'String');
OPT=handles.OPTIONS;
if isempty(s) & isfield(OPT, 'stoplist'),
    OPT=rmfield(OPT, 'stoplist');
    handles.OPTIONS=OPT;
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end

OPT.stoplist=s;
handles.OPTIONS=OPT;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Stoplist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stoplist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StoplistButton.
function StoplistButton_Callback(hObject, eventdata, handles)
% hObject    handle to StoplistButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=open_file(1);
set(handles.Stoplist, 'String', s);

OPT=handles.OPTIONS;
if isempty(s) & isfield(OPT, 'stoplist'),
    OPT=rmfield(OPT, 'stoplist');
    handles.OPTIONS=OPT;
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end

OPT.stoplist=s;
handles.OPTIONS=OPT;
guidata(hObject, handles);

% --- Executes on button press in StoredGW.
function StoredGW_Callback(hObject, eventdata, handles)
% hObject    handle to StoredGW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StoredGW
s=get(hObject, 'Value'); 
if s==1, 
    set(handles.GW, 'BackgroundColor', handles.light_gray);
    set(handles.GW, 'Enable', 'off'); set(handles.GWButton, 'Enable', 'off'); 
else, 
    set(handles.GW, 'BackgroundColor', 'white');
    set(handles.GW, 'Enable', 'on'); set(handles.GWButton, 'Enable', 'on'); 
end
guidata(hObject, handles);

% --- Executes on button press in LLSFRadio.
function LLSFRadio_Callback(hObject, eventdata, handles)
% hObject    handle to LLSFRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LLSFRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.kNNRadio, 'Value', 0);
    set(handles.RocchioRadio, 'Value', 0);
end
set(handles.kNN, 'Enable', 'off'); set(handles.kNN, 'BackgroundColor', handles.light_gray); 
set(handles.RocchioPos, 'Enable', 'off'); set(handles.RocchioNeg, 'Enable', 'off'); set(handles.nFactorsLLSF, 'Enable', 'on'); 
set(handles.RocchioPos, 'BackgroundColor', handles.light_gray); set(handles.RocchioNeg, 'BackgroundColor', handles.light_gray); 
set(handles.nFactorsLLSF, 'BackgroundColor', 'white'); 
set(handles.VSMRadio, 'Value', 0); set(handles.VSMRadio, 'Enable', 'off'); set(handles.nFactors, 'Enable', 'off'); set(handles.Similarity, 'Enable', 'off'); 
set(handles.LSARadio, 'Enable', 'on'); set(handles.LSARadio, 'Value', 1); 
set(handles.LSAMethod, 'Enable', 'on'); set(handles.LSAMethod, 'String', handles.methods); set(handles.LSAMethod, 'Value', 1); 
set(handles.svdsRadio, 'Visible', 'on'); set(handles.propackRadio, 'Visible', 'on');  set(handles.sp_text3, 'Visible', 'on'); 
set(handles.svdsRadio, 'Enable', 'on'); set(handles.propackRadio, 'Enable', 'on');  

function FQuery_Callback(hObject, eventdata, handles)
% hObject    handle to FQuery (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FQuery as text
%        str2double(get(hObject,'String')) returns contents of FQuery as a double
s=get(hObject,'String');
if isempty(s) & isfield(handles, 'filename'),
    handles=rmfield(handles, 'filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end

handles.filename=s;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function FQuery_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FQuery (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FQueryButton.
function FQueryButton_Callback(hObject, eventdata, handles)
% hObject    handle to FQueryButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flname=open_file(0);
set(handles.FQuery, 'String', flname);
if isempty(flname) & isfield(handles, 'filename'),
    handles=rmfield(handles, 'filename');
    guidata(hObject, handles);
    return;
end
if isempty(flname), return; end

handles.filename=flname;
guidata(hObject, handles);

% --- Executes on button press in SQueryRadio.
function SQueryRadio_Callback(hObject, eventdata, handles)
% hObject    handle to SQueryRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SQueryRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.FQueryRadio, 'Value', 0);
end
set(handles.FQuery, 'Visible', 'off'); set(handles.FQueryButton, 'Visible', 'off');
set(handles.Delimiter, 'Visible', 'off'); set(handles.sp_text4, 'Visible', 'off');
set(handles.sp_text5, 'Visible', 'off'); set(handles.sp_text6, 'Visible', 'on'); 
set(handles.LineDelimiter, 'Visible', 'off'); set(handles.LineDelimiter, 'Enable', 'off');
set(handles.SQuery, 'Visible', 'on'); 

% --- Executes on button press in FQueryRadio.
function FQueryRadio_Callback(hObject, eventdata, handles)
% hObject    handle to FQueryRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FQueryRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.SQueryRadio, 'Value', 0);
end
set(handles.FQuery, 'Visible', 'on'); set(handles.FQueryButton, 'Visible', 'on');
set(handles.FQuery, 'Enable', 'on'); set(handles.FQueryButton, 'Enable', 'on'); set(handles.FQuery, 'BackgroundColor', 'white'); 
set(handles.Delimiter, 'Visible', 'on'); set(handles.sp_text4, 'Visible', 'on');
set(handles.sp_text5, 'Visible', 'on'); set(handles.sp_text6, 'Visible', 'off'); 
set(handles.Delimiter, 'Enable', 'on'); set(handles.Delimiter, 'BackgroundColor', 'white'); 
set(handles.SQuery, 'Visible', 'off'); 
set(handles.LineDelimiter, 'Visible', 'on'); set(handles.LineDelimiter, 'Enable', 'on');
handles.OPTIONS.delimiter='none_delimiter';
guidata(hObject, handles);

% --- Executes on button press in UseThresholds.
function UseThresholds_Callback(hObject, eventdata, handles)
% hObject    handle to UseThresholds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UseThresholds
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.ComputeThresholds, 'Value', 0);
end
set(handles.Thresholds, 'BackgroundColor', 'white'); 
set(handles.Thresholds, 'Enable', 'on'); set(handles.ThresholdsButton, 'Enable', 'on');
set(handles.Fvalue, 'BackgroundColor', handles.light_gray); set(handles.Fvalue, 'Enable', 'off');

% --- Executes on button press in ComputeThresholds.
function ComputeThresholds_Callback(hObject, eventdata, handles)
% hObject    handle to ComputeThresholds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ComputeThresholds
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.UseThresholds, 'Value', 0);
end
set(handles.Thresholds, 'BackgroundColor', handles.light_gray); 
set(handles.Thresholds, 'Enable', 'off'); set(handles.ThresholdsButton, 'Enable', 'off');
set(handles.Fvalue, 'BackgroundColor', 'white'); set(handles.Fvalue, 'Enable', 'on');


function Thresholds_Callback(hObject, eventdata, handles)
% hObject    handle to Thresholds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Thresholds as text
%        str2double(get(hObject,'String')) returns contents of Thresholds as a double
s=get(hObject, 'String');
if ~isempty(s), 
	an=sprintf('Use the Browse button in order to set the thresholds variable...');
	msgbox(an, 'Error', 'modal');
    set(hObject, 'String', '');
	return;
end

% --- Executes during object creation, after setting all properties.
function Thresholds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Thresholds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ThresholdsButton.
function ThresholdsButton_Callback(hObject, eventdata, handles)
% hObject    handle to ThresholdsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s=open_file(3);
set(handles.Thresholds, 'String', s);
guidata(hObject, handles);


function Fvalue_Callback(hObject, eventdata, handles)
% hObject    handle to Fvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fvalue as text
%        str2double(get(hObject,'String')) returns contents of Fvalue as a double


% --- Executes during object creation, after setting all properties.
function Fvalue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nFactorsLLSF_Callback(hObject, eventdata, handles)
% hObject    handle to nFactorsLLSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nFactorsLLSF as text
%        str2double(get(hObject,'String')) returns contents of nFactorsLLSF as a double


% --- Executes during object creation, after setting all properties.
function nFactorsLLSF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nFactorsLLSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in svdsRadio.
function svdsRadio_Callback(hObject, eventdata, handles)
% hObject    handle to svdsRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of svdsRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.propackRadio, 'Value', 0);
end

% --- Executes on button press in propackRadio.
function propackRadio_Callback(hObject, eventdata, handles)
% hObject    handle to propackRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of propackRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.svdsRadio, 'Value', 0);
end



function Delimiter_Callback(hObject, eventdata, handles)
% hObject    handle to Delimiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Delimiter as text
%        str2double(get(hObject,'String')) returns contents of Delimiter as a double
s=get(hObject,'String');
if ~isempty(s),
    handles.OPTIONS.delimiter=s;
    guidata(hObject, handles);
else,
    handles.OPTIONS.delimiter='emptyline';
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function Delimiter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Delimiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LineDelimiter.
function LineDelimiter_Callback(hObject, eventdata, handles)
% hObject    handle to LineDelimiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LineDelimiter
state=get(hObject, 'Value');
if state==0,
    OPT=handles.OPTIONS;
    OPT.line_delimiter=0;
    handles.OPTIONS=OPT;
else,
    OPT=handles.OPTIONS;
    OPT.line_delimiter=1;
    handles.OPTIONS=OPT;
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function NNMFMenu_Callback(hObject, eventdata, handles)
% hObject    handle to NNMFMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


