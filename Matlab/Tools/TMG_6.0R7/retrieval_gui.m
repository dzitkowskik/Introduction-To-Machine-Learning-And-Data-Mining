function varargout = retrieval_gui(varargin)
% RETRIEVAL_GUI 
%   RETRIEVAL_GUI is a graphical user interface for all the retrieval 
%   functions of the Text to Matrix Generator (TMG) Toolbox. 
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

% Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @retrieval_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @retrieval_gui_OutputFcn, ...
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

% --- Executes just before retrieval_gui is made visible.
function retrieval_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for retrieval_gui
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
handles.gwquery_type='Files';

handles.objects=[handles.Query;handles.GW;handles.GWButton;handles.StoredGW;handles.Stoplist;handles.StoplistButton;...
    handles.TW;handles.VSMRadio;handles.LSARadio;handles.LSAMethod;handles.nFactors;handles.Similarity;...
    handles.NTopRadio;handles.NTop;handles.MostRelRadio;handles.SimCoef];
    
states=zeros(length(handles.objects), 1); 
handles=activate_uicontrol(states, handles);
handles.methods={'Singular Value Decomposition';'Principal Component Analysis';'Clustered Latent Semantic Indexing';'Centroid Method';'Semidiscrete Decomposition';'SPQR'};
handles.k=cell(6, 1);
set(handles.sp_text1, 'Visible', 'off'); set(handles.sp_text2, 'Visible', 'off');

handles.ntop_def=20;
handles.thres_def=20;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes retrieval_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = retrieval_gui_OutputFcn(hObject, eventdata, handles)
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
    if exist(strcat(str, filesep, 'data', filesep, cur.name, filesep, 'A.mat')) & exist(strcat(str, filesep, 'data', filesep, cur.name, filesep, 'dictionary.mat')), 
        n_datasets=n_datasets+1; datasets{n_datasets+1, 1}=strcat(str, filesep, 'data', filesep, cur.name); 
    end
end
set(hObject, 'String', datasets);
guidata(hObject, handles);

function DatasetMenu_Callback(hObject, eventdata, handles)
s=get(hObject, 'String'); v=get(hObject, 'Value');
states=zeros(length(handles.objects), 1);
if ~isempty(s{v}),  
    states(1)=1;
    if get(handles.StoredGW, 'Value')==0, states([2 3])=1; end
    states((4:8))=1;
    k=cell(6, 1);
    act=zeros(6, 1);
    ss={'svd';'pca';'clsi';'cm';'sdd';'spqr'};
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
                    if exist(strcat(str1, filesep, cur.name, filesep, 'Upca.mat')) & exist(strcat(str1, filesep, cur.name, filesep, 'Spca.mat')) & exist(strcat(str1, filesep, cur.name, filesep, 'Vpca.mat')), 
                        act(2)=1;
                        kk=str2double(cur.name(3:end)); if isempty(k{2}), k{2}=kk; else, k{2}(end+1, 1)=kk; end
                    end
                end                
                if i==3, 
                    if exist(strcat(str1, filesep, cur.name, filesep, 'Xclsi.mat')) & exist(strcat(str1, filesep, cur.name, filesep, 'Yclsi.mat')), 
                        act(3)=1;
                        kk=str2double(cur.name(3:end)); if isempty(k{3}), k{3}=kk; else, k{3}(end+1, 1)=kk; end
                    end
                end
                if i==4, 
                    if exist(strcat(str1, filesep, cur.name, filesep, 'Xcm.mat')) & exist(strcat(str1, filesep, cur.name, filesep, 'Ycm.mat')), 
                        act(4)=1;
                        kk=str2double(cur.name(3:end)); if isempty(k{4}), k{4}=kk; else, k{4}(end+1, 4)=kk; end
                    end
                end                
                if i==5, 
                    if exist(strcat(str1, filesep, cur.name, filesep, 'Xsdd.mat')) & exist(strcat(str1, filesep, cur.name, filesep, 'Dsdd.mat')) & exist(strcat(str1, filesep, cur.name, filesep, 'Ysdd.mat')), 
                        act(5)=1;
                        kk=str2double(cur.name(3:end)); if isempty(k{5}), k{5}=kk; else, k{5}(end+1, 1)=kk; end
                    end
                end                
                if i==6, 
                    if exist(strcat(str1, filesep, cur.name, filesep, 'Qspqr.mat')) & exist(strcat(str1, filesep, cur.name, filesep, 'Rspqr.mat')), 
                        act(6)=1;
                        kk=str2double(cur.name(3:end)); if isempty(k{6}), k{6}=kk; else, k{6}(end+1, 1)=kk; end
                    end
                end                
            end
        end
    end
    if ~isempty(find(act)), 
        set(handles.sp_text1, 'Visible', 'off'); set(handles.sp_text2, 'Visible', 'off');         
        states(9)=1;
        if get(handles.LSARadio, 'Value')==1, states([10 11])=1; end
        set(handles.LSAMethod, 'String', {handles.methods{find(act)}}'); set(handles.LSAMethod, 'Value', 1);
        frs=find(act); set(handles.nFactors, 'String', k{frs(1)}); 
        handles.k=k; 
    else, 
        set(handles.VSMRadio, 'Value', 1); set(handles.LSARadio, 'Value', 0);
        set(handles.sp_text1, 'Visible', 'on'); set(handles.sp_text2, 'Visible', 'on'); 
        handles.k=cell(6, 1);
    end
    states(12)=1;
    states([13 15])=1;
    if get(handles.NTopRadio, 'Value')==1, states(14)=1; states(16)=0; else, states(14)=0; states(16)=1; end
end
handles=activate_uicontrol(states, handles);
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in ContinueButton.
function ContinueButton_Callback(hObject, eventdata, handles)
% hObject    handle to ContinueButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.Query, 'String')), 
	an=new_sprintf('You didin''t supply a query...'); 
	msgbox(an, 'Error', 'modal');
	return;
end
str=get(handles.DatasetMenu, 'String'); str=str{get(handles.DatasetMenu, 'Value')};
load(strcat(str, filesep, 'A.mat')); load(strcat(str, filesep, 'dictionary.mat'));
if get(handles.StoredGW, 'Value'), 
    if exist(strcat(str, filesep, 'global_weights.mat')), load(strcat(str, filesep, 'global_weights.mat')); end
else, 
    if isempty(get(handles.GW, 'String')), 
        global_weights=ones(size(dictionary, 1), 1); 
    else, 
        if isequal(handles.gwquery_type, 'Files'), 
            if ~exist(get(handles.GW, 'String')), 
                an=new_sprintf('File %s not found...', get(handles.GW, 'String')); 
                msgbox(an, 'Error', 'modal');
                return;
            else, 
                load(get(handles.GW, 'String'));
                global_weights=eval(char(fieldnames(load(get(handles.GW, 'String')))));
                if size(global_weights, 1)~=size(A, 1),
                    an=new_sprintf('Dictionary size does not match...'); 
                    msgbox(an, 'Error', 'modal');
                    return;                    
                end
                opts.global_weights=global_weights;
            end
        else, 
            global_weights=evalin('base', get(handles.GW, 'String'));
            if size(global_weights, 1)~=size(A, 1),
                an=new_sprintf('Dictionary size does not match...'); 
                msgbox(an, 'Error', 'modal');
                return;                    
            end 
            opts.global_weights=global_weights;
        end
    end
end
opts.dsp=0;
opts.delimiter='none_delimiter'; opts.line_delimiter=1;
opts.remove_num=0; opts.remove_al=0; opts.parse_subd=0;
opts.local_weight=handles.OPTIONS.local_weight;
if ~isempty(get(handles.Stoplist, 'String')), 
    if ~exist(get(handles.Stoplist, 'String')), 
        an=new_sprintf('File %s not found...', get(handles.Stoplist, 'String')); 
        msgbox(an, 'Error', 'modal');
        return;
	else, 
        opts.stoplist=get(handles.Stoplist, 'String');
	end
end 
if exist(strcat(str, filesep, 'update_struct.mat')),
    load(strcat(str, filesep, 'update_struct.mat'));
    opts.stemming=update_struct.stemming;
end
fname=datestr(now); fname=strrep(fname, ' ', '_'); fname=strrep(fname, ':', '-');
qry=get(handles.Query, 'String');
fid=fopen(fname, 'wt'); qry(:, end+1)=' '; for ij=1:size(qry, 1), fprintf(fid, '%s', qry(ij, :)); end; fclose(fid); 
filename=strcat(pwd,filesep,fname);
q=tmg_query(filename, dictionary, opts);
if nnz(q)==0, an=new_sprintf('The query is empty...'); msgbox(an, 'Error', 'modal'); return; end
load(strcat(str, filesep, 'A.mat')); 
normalize_docs=(get(handles.Similarity, 'Value')==1);
if get(handles.VSMRadio, 'Value'), 
    [sc, doc_inds]=vsm(A, q, normalize_docs);
else, 
    s=get(handles.LSAMethod, 'String'); v=get(handles.LSAMethod, 'Value'); k=get(handles.nFactors, 'String'); k=strtrim(k(get(handles.nFactors, 'Value'), :)); 
    if isequal(s{v}, handles.methods{1}), 
        str=strcat(str, filesep, 'svd', filesep, 'k_', k);
        load(strcat(str, filesep, 'Usvd.mat')); load(strcat(str, filesep, 'Ssvd.mat')); load(strcat(str, filesep, 'Vsvd.mat'));
        D=Ssvd*Vsvd'; P=Usvd;
        assignin('base', 'Usvd', Usvd); assignin('base', 'Ssvd', Ssvd); assignin('base', 'Vsvd', Vsvd);
    end
    if isequal(s{v}, handles.methods{2}), 
        str=strcat(str, filesep, 'pca', filesep, 'k_', k);
        load(strcat(str, filesep, 'Upca.mat')); load(strcat(str, filesep, 'Spca.mat')); load(strcat(str, filesep, 'Vpca.mat'));
        D=Spca*Vpca'; P=Upca;
        assignin('base', 'Upca', Upca); assignin('base', 'Spca', Spca); assignin('base', 'Vpca', Vpca);
    end    
    if isequal(s{v}, handles.methods{3}), 
        str=strcat(str, filesep, 'clsi', filesep, 'k_', k);
        load(strcat(str, filesep, 'Xclsi.mat')); load(strcat(str, filesep, 'Yclsi.mat')); 
        D=Yclsi; P=Xclsi;
        assignin('base', 'Xclsi', Xclsi); assignin('base', 'Yclsi', Yclsi); 
    end        
    if isequal(s{v}, handles.methods{4}), 
        str=strcat(str, filesep, 'cm', filesep, 'k_', k);
        load(strcat(str, filesep, 'Xcm.mat')); load(strcat(str, filesep, 'Ycm.mat')); 
        D=Ycm; P=Xcm;
        assignin('base', 'Xcm', Xcm); assignin('base', 'Ycm', Ycm); 
    end      
    if isequal(s{v}, handles.methods{5}), 
        str
        str=strcat(str, filesep, 'sdd', filesep, 'k_', k)
        load(strcat(str, filesep, 'Xsdd.mat')); load(strcat(str, filesep, 'Dsdd.mat')); load(strcat(str, filesep, 'Ysdd.mat')); 
        D=Xsdd*diag(Dsdd)*Ysdd'; P=[];
        assignin('base', 'Xsdd', Xsdd); assignin('base', 'Dsdd', Dsdd); assignin('base', 'Ysdd', Ysdd);
    end            
    if isequal(s{v}, handles.methods{6}), 
        str=strcat(str, filesep, 'spqr', filesep, 'k_', k);
        load(strcat(str, filesep, 'Qspqr.mat')); load(strcat(str, filesep, 'Rspqr.mat')); 
        D=Rspqr; P=Qspqr;
        assignin('base', 'Qspqr', Qspqr); assignin('base', 'Rspqr', Rspqr); 
    end          
    assignin('base', 'D', D); assignin('base', 'P', P);
    [sc, doc_inds]=lsa(D, P, q, normalize_docs);
end
assignin('base', 'A', A); assignin('base', 'q', q); assignin('base', 'sc', sc); assignin('base', 'doc_inds', doc_inds); 
str=get(handles.DatasetMenu, 'String'); dataset=str{get(handles.DatasetMenu, 'Value')};
sc=sc(find(sc>0)); if ~isempty(sc), doc_inds=doc_inds(1:length(sc)); else, doc_inds=[]; end
fid=fopen(fname, 'r'); qry=fgetl(fid); fclose(fid); 
delete(fname);
if get(handles.NTopRadio, 'Value') == 1, 
    ntop=get(handles.NTop, 'String'); 
    if ~isempty(ntop), 
        ntop=str2double(ntop); if ceil(ntop)~=ntop || ntop<=0, ntop=handles.ntop_def; end
    else, 
        ntop=handles.ntop_def;
    end
else, 
    thres=get(handles.SimCoef, 'String'); 
    if ~isempty(thres), 
        thres=str2double(thres); if thres<0, thres=handles.thres_def; end
    else, 
        thres=handles.thres_def;
    end
end
if get(handles.NTopRadio, 'Value') == 1, 
    if length(doc_inds)>ntop, create_retrieval_response(dataset, doc_inds(1:ntop), sc(1:ntop), qry);
    else, create_retrieval_response(dataset, doc_inds, sc, qry); 
    end
else,  
    create_retrieval_response(dataset, doc_inds(find(sc>=thres)), sc(find(sc>=thres)), qry); 
end

guidata(hObject, handles);

% --- Executes on button press in ClearBotton.
function ClearBotton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearBotton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DatasetMenu, 'Value', 1); set(handles.Query, 'String', '');
set(handles.GW, 'String', ''); set(handles.Stoplist, 'String', '');
set(handles.TW, 'Value', 1);  set(handles.LSAMethod, 'String', cell(1, 1));
set(handles.nFactors, 'String', cell(1, 1)); set(handles.Similarity, 'Value', 1);
set(handles.VSMRadio, 'Value', 1); set(handles.LSARadio, 'Value', 0);
set(handles.StoredGW, 'Value', 1);
states=zeros(size(handles.objects, 1), 1); 
handles=activate_uicontrol(states, handles);

% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);


function Query_Callback(hObject, eventdata, handles)
% hObject    handle to Query (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Query as text
%        str2double(get(hObject,'String')) returns contents of Query as a double


% --- Executes during object creation, after setting all properties.
function Query_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Query (see GCBO)
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
end
set(handles.LSAMethod, 'Enable', 'off'); set(handles.nFactors, 'Enable', 'off'); 

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

states=ones(length(handles.objects), 1);
if get(handles.NTopRadio, 'Value') == 1, 
    states(16) = 0;
else, 
    states(14) = 0;
end
handles=activate_uicontrol(states, handles);
if get(handles.StoredGW, 'Value') == 1, 
    set(handles.GW, 'Enable', 'off');
    set(handles.GWButton, 'Enable', 'off');
    set(handles.GW, 'BackgroundColor', handles.light_gray);    
else, 
    set(handles.GW, 'Enable', 'on');
    set(handles.GWButton, 'Enable', 'on');
    set(handles.GW, 'BackgroundColor', 'white');
end

% --- Executes on selection change in LSAMethod.
function LSAMethod_Callback(hObject, eventdata, handles)
% hObject    handle to LSAMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns LSAMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LSAMethod
s=get(hObject, 'String'); s=s{get(hObject, 'Value')};
switch s, 
    case 'Singular Value Decomposition', 
        set(handles.nFactors, 'String', num2str(handles.k{1}));
    case 'Principal Component Analysis', 
        set(handles.nFactors, 'String', num2str(handles.k{2}));
    case 'Clustered Latent Semantic Indexing', 
        set(handles.nFactors, 'String', num2str(handles.k{3}));
    case 'Centroid Method', 
        set(handles.nFactors, 'String', num2str(handles.k{4}));
    case 'Semidiscrete Decomposition', 
        set(handles.nFactors, 'String', num2str(handles.k{5}));
    case 'SPQR', 
        set(handles.nFactors, 'String', num2str(handles.k{6}));
end
% Update handles structure
guidata(hObject, handles);


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


% --- Executes on button press in NTopRadio.
function NTopRadio_Callback(hObject, eventdata, handles)
% hObject    handle to NTopRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NTopRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.MostRelRadio, 'Value', 0); 
end
set(handles.NTop, 'Enable', 'on');
set(handles.SimCoef, 'Enable', 'off');
set(handles.NTop, 'BackgroundColor', 'white');
set(handles.SimCoef, 'BackgroundColor', handles.light_gray);

% --- Executes on button press in MostRelRadio.
function MostRelRadio_Callback(hObject, eventdata, handles)
% hObject    handle to MostRelRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MostRelRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.NTopRadio, 'Value', 0); 
end
set(handles.NTop, 'Enable', 'off');
set(handles.SimCoef, 'Enable', 'on');
set(handles.SimCoef, 'BackgroundColor', 'white');
set(handles.NTop, 'BackgroundColor', handles.light_gray);


function NTop_Callback(hObject, eventdata, handles)
% hObject    handle to NTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NTop as text
%        str2double(get(hObject,'String')) returns contents of NTop as a double


% --- Executes during object creation, after setting all properties.
function NTop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SimCoef_Callback(hObject, eventdata, handles)
% hObject    handle to SimCoef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SimCoef as text
%        str2double(get(hObject,'String')) returns contents of SimCoef as a double


% --- Executes during object creation, after setting all properties.
function SimCoef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SimCoef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


