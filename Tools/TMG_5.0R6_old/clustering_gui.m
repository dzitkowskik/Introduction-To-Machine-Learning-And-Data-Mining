function varargout = clustering_gui(varargin)
% CLUSTERING_GUI 
%   CLUSTERING_GUI is a graphical user interface for all 
%   the clustering functions of the Text to Matrix Generator 
%   (TMG) Toolbox. 
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

% Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @clustering_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @clustering_gui_OutputFcn, ...
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

% --- Executes just before clustering_gui is made visible.
function clustering_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for clustering_gui
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

handles.objects=[handles.svdsRadio;handles.propackRadio;handles.kmeansRadio;handles.skmeansRadio;...
        handles.PDDPRadio;handles.nClusters;handles.CentroidInit;handles.CentroidsVar;handles.CentroidsVarButton;...
        handles.Termination;handles.TerminationValue;handles.DispRes;handles.lPDDP;handles.PDDPVariant;...
        handles.maxlPDDP];

states=ones(length(handles.objects), 1); states([1 2 8 9 13 14 15])=0; 
handles=activate_uicontrol(states, handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes clustering_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = clustering_gui_OutputFcn(hObject, eventdata, handles)
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
%        contents{get(hObject,'Value')} returns selected item from DatasetMenu


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
guidata(hObject, handles);


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
guidata(hObject, handles);


% --- Executes on button press in StoreRes.
function StoreRes_Callback(hObject, eventdata, handles)
% hObject    handle to StoreRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StoreRes


% --- Executes on button press in ContinueButton.
function ContinueButton_Callback(hObject, eventdata, handles)
% hObject    handle to ContinueButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datasets=get(handles.DatasetMenu, 'String');
id=get(handles.DatasetMenu, 'Value');
if isequal(datasets{id}, ''), msgbox('You have to provide a dataset...', 'Error', 'modal'); return; end
load(strcat(datasets{id}, filesep, 'A.mat'));
try, load(strcat(datasets{id}, filesep, 'titles.mat')); catch, titles=cell(size(A, 2), 1); end

nc=get(handles.nClusters, 'String'); 
if isempty(nc), msgbox('You have to provide the number of clusters...', 'Error', 'modal'); return; end
nc=str2double(nc);
if ~isnumeric(nc), msgbox('You have to provide the number of clusters...', 'Error', 'modal'); return; end
if mod(nc, 1)~=0, msgbox('You have to provide an integer number of clusters...', 'Error', 'modal'); return; end
  
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
        [m, n]=size(C); if m~=size(A, 1) | n~=nc, msgbox('The centroid variable you provided has incorrect dimensions...', 'Error', 'modal'); return; end
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
        clusters_kmeans=ekmeans(A, C, nc, term_method, opts);
        assignin('base', 'clusters_kmeans', clusters_kmeans);
    else, 
        clusters_skmeans=skmeans(A, C, nc, term_method, opts);
        assignin('base', 'clusters_skmeans', clusters_skmeans);
    end
else, 
    if get(handles.svdsRadio, 'Value')==1, svd_method='svds'; else, svd_method='propack'; end
    if get(handles.maxlPDDP, 'Value')==1, 
        v=get(handles.PDDPVariant, 'Value'); 
        if v==1, 
            [clusters_pddp, tree_struct]=pddp(A, nc, 'max', svd_method, get(handles.DispRes, 'Value'));
        else, 
            [clusters_pddp, tree_struct]=pddp_optcutpd(A, nc, 'max', svd_method, get(handles.DispRes, 'Value'));
        end
    else, 
        l=get(handles.lPDDP, 'String');
        if isempty(l), msgbox('You have to provide the number of principal directions for PDDP...', 'Error', 'modal'); return; end
        v=get(handles.PDDPVariant, 'Value'); 
        if str2double(l)>1, 
            if v==1, 
                [clusters_pddp, tree_struct]=pddp(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
            else, 
                [clusters_pddp, tree_struct]=pddp_optcutpd(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
            end
        else, 
            if v==1, 
                [clusters_pddp, tree_struct]=pddp(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
            elseif v==2,
                [clusters_pddp, tree_struct]=pddp_2means(A, nc, svd_method, get(handles.DispRes, 'Value'), 0);
            elseif v==3, 
                [clusters_pddp, tree_struct]=pddp_optcut(A, nc, svd_method, get(handles.DispRes, 'Value'));
            elseif v==4, 
                [clusters_pddp, tree_struct]=pddp_optcut_2means(A, nc, svd_method, get(handles.DispRes, 'Value'), 0);
            else, 
                [clusters_pddp, tree_struct]=pddp_optcutpd(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
            end
        end
    end
    if size(clusters_pddp, 1)-1~=nc, nc=size(clusters_pddp, 1)-1; end
    assignin('base', 'clusters_pddp', clusters_pddp);
end
assignin('base', 'A', A); assignin('base', 'nclusters', nc);

if get(handles.StoreRes, 'Value')==1, 
    datasets=get(handles.DatasetMenu, 'String'); v=get(handles.DatasetMenu, 'Value'); dataset=datasets{v};
    if get(handles.kmeansRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'kmeans');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(nc));
        if ~exist(str), 
            mkdir(str); 
        else, 
            str1=strcat(str, filesep, 'clusters_kmeans.mat');
            if exist(str1), delete(str1); end; 
        end
        str1=strcat(str, filesep, 'clusters_kmeans');
        save(str1, 'clusters_kmeans'); 
    end
    if get(handles.skmeansRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'skmeans');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(nc));
        if ~exist(str), 
            mkdir(str); 
        else, 
            str1=strcat(str, filesep, 'clusters_skmeans.mat');
            if exist(str1), delete(str1); end; 
        end
        str1=strcat(str, filesep, 'clusters_skmeans');
        save(str1, 'clusters_skmeans'); 
    end    
    if get(handles.PDDPRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'pddp');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(nc));
        if ~exist(str), 
            mkdir(str); 
        else, 
            str1=strcat(str, filesep, 'clusters_pddp.mat');
            if exist(str1), delete(str1); end; 
        end
        str1=strcat(str, filesep, 'clusters_pddp');
        save(str1, 'clusters_pddp'); 
    end    
end
if get(handles.kmeansRadio, 'Value')==1, create_kmeans_response(clusters_kmeans, titles); end
if get(handles.skmeansRadio, 'Value')==1, create_kmeans_response(clusters_skmeans, titles, 'skmeans'); end
if get(handles.PDDPRadio, 'Value')==1, 
    if get(handles.maxlPDDP, 'Value')==1, 
        l=1; while 2^l<=nc, l=l+1; end; l=l-1;
    else, 
        l=str2num(get(handles.lPDDP, 'String'));
    end
    create_pddp_response(tree_struct, clusters_pddp, l, titles);
end

guidata(hObject, handles);

% --- Executes on button press in ClearBotton.
function ClearBotton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearBotton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DatasetMenu, 'Value', 1);
set(handles.svdsRadio, 'Value', 1); set(handles.propackRadio, 'Value', 0);
set(handles.kmeansRadio, 'Value', 1); set(handles.skmeansRadio, 'Value', 0); set(handles.PDDPRadio, 'Value', 0);
set(handles.CentroidInit, 'Value', 1); set(handles.CentroidsVar, 'String', '');
set(handles.Termination, 'Value', 1); set(handles.TerminationValue, 'String', '1');
set(handles.lPDDP, 'String', '1'); set(handles.maxlPDDP, 'Value', 0);
set(handles.nClusters, 'String', ''); 
set(handles.DispRes, 'Value', 1);
set(handles.StoreRes, 'Value', 1);
s={'Basic';'Split with k-means';'Optimal Split';'Optimal Split with k-means';'Optimal Split on Projection'}; v=1; 
set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 

states=ones(length(handles.objects), 1); states([1 2 8 9 13 14 15])=0; 
handles=activate_uicontrol(states, handles);
guidata(hObject, handles);

% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);

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

states=ones(length(handles.objects), 1); states([1 2 13 14 15])=0; states(8)=-1;
state=get(handles.CentroidInit, 'Value');
if state==1, states([8 9])=0; end    
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

states=ones(length(handles.objects), 1); states([1 2 13 14 15])=0; states(8)=-1;
state=get(handles.CentroidInit, 'Value');
if state==1, states([8 9])=0; end    
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

states=zeros(length(handles.objects), 1); states([1 2 3 4 5 6 12 13 14 15 16])=1; 
state=get(handles.maxlPDDP, 'Value'); 
if state==1, 
    set(handles.lPDDP, 'String', ''); 
    s={'Basic';'Optimal Split on Projection'}; v=1; set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 
else, 
    s={'Basic';'Split with k-means';'Optimal Split';'Optimal Split with k-means';'Optimal Split on Projection'}; v=1; set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 
end
handles=activate_uicontrol(states, handles);
    
guidata(hObject, handles);


function nClusters_Callback(hObject, eventdata, handles)
% hObject    handle to nClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nClusters as text
%        str2double(get(hObject,'String')) returns contents of nClusters as a double


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
%        str2double(get(hObject,'String')) returns contents of CentroidsVar as a double
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
    set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 
end
if l>1, 
    s={'Basic';'Optimal Split on Projection'}; v=1; set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 
else, 
    s={'Basic';'Split with k-means';'Optimal Split';'Optimal Split with k-means';'Optimal Split on Projection'}; v=1; set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 
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


% --- Executes on selection change in PDDPVariant.
function PDDPVariant_Callback(hObject, eventdata, handles)
% hObject    handle to PDDPVariant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns PDDPVariant contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PDDPVariant
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PDDPVariant_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PDDPVariant (see GCBO)
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
    set(handles.lPDDP, 'String', ''); 
    s={'Basic';'Optimal Split on Projection'}; v=1; set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 
else, 
    s={'Basic';'Split with k-means';'Optimal Split';'Optimal Split with k-means';'Optimal Split on Projection'}; v=1; set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 
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