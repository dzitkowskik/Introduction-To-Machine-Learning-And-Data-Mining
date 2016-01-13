function varargout = dr_gui(varargin)
% DR_GUI 
%   DR_GUI is a graphical user interface for all 
%   the dimensionality reduction functions of the Text 
%   to Matrix Generator (TMG) Toolbox. 
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

% Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dr_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @dr_gui_OutputFcn, ...
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

% --- Executes just before dr_gui is made visible.
function dr_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for dr_gui
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
        handles.maxlPDDP;handles.ksSelection;handles.ksSelection1];
    
states=zeros(length(handles.objects), 1); states([1 2])=1; 
handles=activate_uicontrol(states, handles);
    
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dr_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dr_gui_OutputFcn(hObject, eventdata, handles)
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


% --- Executes on button press in SVDRadio.
function SVDRadio_Callback(hObject, eventdata, handles)
% hObject    handle to SVDRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SVDRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.PCARadio, 'Value', 0);
    set(handles.CLSIRadio, 'Value', 0);
    set(handles.CMRadio, 'Value', 0);
    set(handles.SDDRadio, 'Value', 0);
    set(handles.SPQRRadio, 'Value', 0);
end

states=zeros(length(handles.objects), 1); states([1 2])=1; 
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);



function nFactorsSVD_Callback(hObject, eventdata, handles)
% hObject    handle to nFactorsSVD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nFactorsSVD as text
%        str2double(get(hObject,'String')) returns contents of nFactorsSVD as a double
if get(handles.CMRadio, 'Value')==1, set(handles.nClusters, 'String', get(hObject, 'String')); end
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
if mod(k, 1)~=0, msgbox('You have to provide an integer number of factors...', 'Error', 'modal'); return; end
load(strcat(datasets{id}, filesep, 'A.mat'));

if get(handles.CLSIRadio, 'Value')==1 | get(handles.CMRadio, 'Value')==1, 
    nc=get(handles.nClusters, 'String'); 
    if isempty(nc), msgbox('You have to provide the number of clusters...', 'Error', 'modal'); return; end
    nc=str2double(nc);
    if ~isnumeric(nc), msgbox('You have to provide the number of clusters...', 'Error', 'modal'); return; end
    if mod(nc, 1)~=0, msgbox('You have to provide an integer number of clusters...', 'Error', 'modal'); return; end
    if nc>k, msgbox('Number of clusters must not exceed number of factors...', 'Error', 'modal'); return; end
    if nc<k & get(handles.CMRadio, 'Value')==1, msgbox('Number of clusters must be equal to the number of factors for the Centroids Method...', 'Error', 'modal'); return; end
    
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
            clusters=ekmeans(A, C, nc, term_method, opts);
        else, 
            clusters=skmeans(A, C, nc, term_method, opts);
        end
    else, 
        if get(handles.svdsRadio, 'Value')==1, svd_method='svds'; else, svd_method='propack'; end
        if get(handles.maxlPDDP, 'Value')==1, 
            v=get(handles.PDDPVariant, 'Value'); 
            if v==1, 
                clusters=pddp(A, nc, 'max', svd_method, get(handles.DispRes, 'Value'));
            else, 
                clusters=pddp_optcutpd(A, nc, 'max', svd_method, get(handles.DispRes, 'Value'));
            end
        else, 
            l=get(handles.lPDDP, 'String');
            tmp=2^str2num(l); while tmp<k, tmp=tmp+2^str2num(l)-1; end
            if tmp>k,
                if get(handles.CLSIRadio, 'Value')==1, 
                    err_pddp=sprintf('Number of principal components for PDDP you supplied produces more than %d clusters (number of factors for CLSI). Please alter your selection...', k); 
                else, 
                    err_pddp=sprintf('Number of principal components for PDDP you supplied produces more than %d clusters (number of factors for CM). Please alter your selection...', k); 
                end
                msgbox(err_pddp, 'Error', 'modal'); return;
            end
            if isempty(l), msgbox('You have to provide the number of principal directions for PDDP...', 'Error', 'modal'); return; end
            v=get(handles.PDDPVariant, 'Value'); 
            if str2double(l)>1, 
                if v==1, 
                    clusters=pddp(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
                else, 
                    clusters=pddp_optcutpd(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
                end
            else, 
                if v==1, 
                    clusters=pddp(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
                elseif v==2,
                    clusters=pddp_2means(A, nc, svd_method, get(handles.DispRes, 'Value'), 0);
                elseif v==3, 
                    clusters=pddp_optcut(A, nc, svd_method, get(handles.DispRes, 'Value'));
                elseif v==4, 
                    clusters=pddp_optcut_2means(A, nc, svd_method, get(handles.DispRes, 'Value'), 0);
                else, 
                    clusters=pddp_optcutpd(A, nc, l, svd_method, get(handles.DispRes, 'Value'));
                end
            end
        end
    end
    assignin('base', 'clusters', clusters);
end


if get(handles.SVDRadio, 'Value')==1, 
    if get(handles.svdsRadio, 'Value')==1, svd_method='svds'; else, svd_method='propack'; end
    [Usvd, Ssvd, Vsvd]=svd_tmg(A, k, svd_method);
    
    assignin('base', 'A', A); assignin('base', 'Usvd', Usvd); assignin('base', 'Ssvd', Ssvd); assignin('base', 'Vsvd', Vsvd); assignin('base', 'k', k);
end
if get(handles.PCARadio, 'Value')==1, 
    if get(handles.svdsRadio, 'Value')==1, svd_method='svds'; else, svd_method='propack'; end
    [Upca, Spca, Vpca]=pca(A, sum(A, 2)/size(A, 2), k, svd_method);
    
    assignin('base', 'A', A); assignin('base', 'Upca', Upca); assignin('base', 'Spca', Spca); assignin('base', 'Vpca', Vpca); assignin('base', 'k', k);
end
if get(handles.CLSIRadio, 'Value')==1, 
    if get(handles.svdsRadio, 'Value')==1, svd_method='svds'; else, svd_method='propack'; end
    if get(handles.ksSelection, 'Value')==0, func='ff'; elseif get(handles.ksSelection1, 'Value')==1, func='f1'; else, func='f'; end
    [Xclsi, Yclsi]=clsi(A, clusters, k, func, 0.5, svd_method);
    
    assignin('base', 'A', A); assignin('base', 'Xclsi', Xclsi); assignin('base', 'Yclsi', Yclsi); assignin('base', 'k', k);
end
if get(handles.CMRadio, 'Value')==1, 
    [Xcm, Ycm]=cm(A, clusters);
    
    assignin('base', 'A', A); assignin('base', 'Xcm', Xcm); assignin('base', 'Ycm', Ycm); assignin('base', 'k', k);
end
if get(handles.SDDRadio, 'Value')==1, 
    if get(handles.svdsRadio, 'Value')==1, svd_method='svds'; else, svd_method='propack'; end
    [Xsdd, Dsdd, Ysdd]=sdd_tmg(A, k);
    
    assignin('base', 'A', A); assignin('base', 'Dsdd', Dsdd); assignin('base', 'Xsdd', Xsdd); assignin('base', 'Ysdd', Ysdd); assignin('base', 'k', k);
end
if get(handles.SPQRRadio, 'Value')==1, 
    [ncols, Rspqr, colx, norms]=spqr(A, 10^(-8)*norm(A, 'fro'), k);
    Qspqr=A(:, colx(1:ncols))*inv(Rspqr(:, 1:ncols));
    Apspqr=A(:, colx);
    assignin('base', 'A', A); assignin('base', 'Apspqr', Apspqr); assignin('base', 'Qspqr', Qspqr); assignin('base', 'Rspqr', Rspqr); assignin('base', 'k', k);
end

if get(handles.StoreRes, 'Value')==1, 
    datasets=get(handles.DatasetMenu, 'String'); v=get(handles.DatasetMenu, 'Value'); dataset=datasets{v};
    if get(handles.SVDRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'svd');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(k));
        if ~exist(str), 
            mkdir(str); 
        else, 
            str1=strcat(str, filesep, 'Usvd.mat'); str2=strcat(str, filesep, 'Ssvd.mat'); str3=strcat(str, filesep, 'Vsvd.mat'); 
            if exist(str1), delete(str1); end; if exist(str2), delete(str2); end; if exist(str3), delete(str3); end; 
        end
        str1=strcat(str, filesep, 'Usvd'); str2=strcat(str, filesep, 'Ssvd'); str3=strcat(str, filesep, 'Vsvd');
        save(str1, 'Usvd'); save(str2, 'Ssvd'); save(str3, 'Vsvd'); 
    end
    if get(handles.PCARadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'pca');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(k));
        if ~exist(str), 
            mkdir(str); 
        else, 
            str1=strcat(str, filesep, 'Upca.mat'); str2=strcat(str, filesep, 'Spca.mat'); str3=strcat(str, filesep, 'Vpca.mat'); 
            if exist(str1), delete(str1); end; if exist(str2), delete(str2); end; if exist(str3), delete(str3); end; 
        end
        str1=strcat(str, filesep, 'Upca'); str2=strcat(str, filesep, 'Spca'); str3=strcat(str, filesep, 'Vpca');
        save(str1, 'Upca'); save(str2, 'Spca'); save(str3, 'Vpca');         
    end
    if get(handles.CLSIRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'clsi');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(k));
        if ~exist(str), 
            mkdir(str); 
        else, 
            str1=strcat(str, filesep, 'Xclsi.mat'); str2=strcat(str, filesep, 'Yclsi.mat');
            if exist(str1), delete(str1); end; if exist(str2), delete(str2); end;
        end
        str1=strcat(str, filesep, 'Xclsi'); str2=strcat(str, filesep, 'Yclsi');
        save(str1, 'Xclsi'); save(str2, 'Yclsi');
    end
    if get(handles.CMRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'cm');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(k));
        if ~exist(str), 
            mkdir(str); 
        else, 
            str1=strcat(str, filesep, 'Xcm.mat'); str2=strcat(str, filesep, 'Ycm.mat');
            if exist(str1), delete(str1); end; if exist(str2), delete(str2); end;
        end
        str1=strcat(str, filesep, 'Xcm'); str2=strcat(str, filesep, 'Ycm');
        save(str1, 'Xcm'); save(str2, 'Ycm');        
    end
    if get(handles.SDDRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'sdd');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(k));
        if ~exist(str), 
            mkdir(str); 
        else, 
            str1=strcat(str, filesep, 'Dsdd.mat'); str2=strcat(str, filesep, 'Xsdd.mat'); str3=strcat(str, filesep, 'Ysdd.mat'); 
            if exist(str1), delete(str1); end; if exist(str2), delete(str2); end; if exist(str3), delete(str3); end; 
        end
        str1=strcat(str, filesep, 'Dsdd'); str2=strcat(str, filesep, 'Xsdd'); str3=strcat(str, filesep, 'Ysdd');
        save(str1, 'Dsdd'); save(str2, 'Xsdd'); save(str3, 'Ysdd');         
    end
    if get(handles.SPQRRadio, 'Value')==1, 
        str=strcat(dataset, filesep, 'spqr');
        if ~exist(str), mkdir(str); end
        str=strcat(str, filesep, 'k_', num2str(k));
        if ~exist(str), 
            mkdir(str); 
        else, 
            str1=strcat(str, filesep, 'Qspqr.mat'); str2=strcat(str, filesep, 'Rspqr.mat'); str3=strcat(str, filesep, 'Apspqr.mat');
            if exist(str1), delete(str1); end; if exist(str2), delete(str2); end; if exist(str3), delete(str3); end;
        end
        str1=strcat(str, filesep, 'Qspqr'); str2=strcat(str, filesep, 'Rspqr'); str3=strcat(str, filesep, 'Apspqr'); 
        save(str1, 'Qspqr'); save(str2, 'Rspqr'); save(str3, 'Apspqr');
    end    
end
msgbox('Done!', 'modal')

guidata(hObject, handles);

% --- Executes on button press in ClearBotton.
function ClearBotton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearBotton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DatasetMenu, 'Value', 1);
set(handles.SVDRadio, 'Value', 1); set(handles.PCARadio, 'Value', 0); set(handles.CLSIRadio, 'Value', 0); 
set(handles.CMRadio, 'Value', 0); set(handles.SDDRadio, 'Value', 0); set(handles.SPQRRadio, 'Value', 0); 
set(handles.svdsRadio, 'Value', 1); set(handles.propackRadio, 'Value', 0);
set(handles.kmeansRadio, 'Value', 1); set(handles.skmeansRadio, 'Value', 0); set(handles.PDDPRadio, 'Value', 0);
set(handles.CentroidInit, 'Value', 1); set(handles.CentroidsVar, 'String', '');
set(handles.Termination, 'Value', 1); set(handles.TerminationValue, 'String', '1');
set(handles.lPDDP, 'String', '1'); set(handles.maxlPDDP, 'Value', 0);
set(handles.ksSelection, 'Value', 1); set(handles.ksSelection1, 'Value', 0); set(handles.nClusters, 'String', ''); 
set(handles.DispRes, 'Value', 1); set(handles.nFactorsSVD, 'String', ''); 
set(handles.StoreRes, 'Value', 1);
s={'Basic';'Split with k-means';'Optimal Split';'Optimal Split with k-means';'Optimal Split on Projection'}; v=1; 
set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 

states=zeros(length(handles.objects), 1); states([1 2])=1; 
handles=activate_uicontrol(states, handles);
guidata(hObject, handles);

% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);


% --- Executes on button press in PCARadio.
function PCARadio_Callback(hObject, eventdata, handles)
% hObject    handle to PCARadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PCARadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.SVDRadio, 'Value', 0);
    set(handles.CLSIRadio, 'Value', 0);
    set(handles.CMRadio, 'Value', 0);
    set(handles.SDDRadio, 'Value', 0);
    set(handles.SPQRRadio, 'Value', 0);
end

states=zeros(length(handles.objects), 1); states([1 2])=1; 
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);

% --- Executes on button press in CLSIRadio.
function CLSIRadio_Callback(hObject, eventdata, handles)
% hObject    handle to CLSIRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CLSIRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.SVDRadio, 'Value', 0);
    set(handles.PCARadio, 'Value', 0);
    set(handles.CMRadio, 'Value', 0);
    set(handles.SDDRadio, 'Value', 0);
    set(handles.SPQRRadio, 'Value', 0);
end

states=ones(length(handles.objects), 1); states(8)=-1;
handles=activate_uicontrol(states, handles);

state_kmeans=get(handles.kmeansRadio, 'Value');
state_skmeans=get(handles.skmeansRadio, 'Value');
state_pddp=get(handles.PDDPRadio, 'Value');
if state_kmeans==1, 
    states=ones(length(handles.objects), 1); states([13 14 15])=0; states(8)=-1;
    state=get(handles.CentroidInit, 'Value');
    if state==1, states([8 9])=0; end    
end
if state_skmeans==1, 
    states=ones(length(handles.objects), 1); states([13 14 15])=0; states(8)=-1;
    state=get(handles.CentroidInit, 'Value');
    if state==1, states([8 9])=0; end    
end
if state_pddp==1, 
    states=zeros(length(handles.objects), 1); states([1 2 3 4 5 6 12 13 14 15 16])=1; 
    state=get(handles.maxlPDDP, 'Value'); 
    if state==1, 
        set(handles.lPDDP, 'String', ''); 
        s={'Basic';'Optimal Split on Projection'}; v=1; set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 
    else, 
        s={'Basic';'Split with k-means';'Optimal Split';'Optimal Split with k-means';'Optimal Split on Projection'}; v=1; set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 
    end
end
if get(handles.ksSelection, 'Value')==1, states(17)=1; else, states(17)=0; end
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);

% --- Executes on button press in CMRadio.
function CMRadio_Callback(hObject, eventdata, handles)
% hObject    handle to CMRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CMRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.SVDRadio, 'Value', 0);
    set(handles.PCARadio, 'Value', 0);
    set(handles.CLSIRadio, 'Value', 0);
    set(handles.SDDRadio, 'Value', 0);
    set(handles.SPQRRadio, 'Value', 0);
end

states=ones(length(handles.objects), 1); states([1 2])=0; states(8)=-1; states(6)=-1;
handles=activate_uicontrol(states, handles);

state_kmeans=get(handles.kmeansRadio, 'Value');
state_skmeans=get(handles.skmeansRadio, 'Value');
state_pddp=get(handles.PDDPRadio, 'Value');
if state_kmeans==1, 
    states=ones(length(handles.objects), 1); states([1 2 13 14 15 16 17])=0; states(8)=-1; states(6)=-1;
    state=get(handles.CentroidInit, 'Value');
    if state==1, states([8 9])=0; end    
end
if state_skmeans==1, 
    states=ones(length(handles.objects), 1); states([1 2 13 14 15 16 17])=0; states(8)=-1; states(6)=-1;
    state=get(handles.CentroidInit, 'Value');
    if state==1, states([8 9])=0; end    
end
if state_pddp==1, 
    states=zeros(length(handles.objects), 1); states([1 2 3 4 5 6 12 13 14 15])=1; states(6)=-1;
    state=get(handles.maxlPDDP, 'Value'); 
    if state==1, 
        set(handles.lPDDP, 'String', ''); 
        s={'Basic';'Optimal Split on Projection'}; v=1; set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 
    else, 
        s={'Basic';'Split with k-means';'Optimal Split';'Optimal Split with k-means';'Optimal Split on Projection'}; v=1; set(handles.PDDPVariant, 'String', s); set(handles.PDDPVariant, 'Value', 1); 
    end 
end
set(handles.nClusters, 'String', get(handles.nFactorsSVD, 'String'));
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);

% --- Executes on button press in SDDRadio.
function SDDRadio_Callback(hObject, eventdata, handles)
% hObject    handle to SDDRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SDDRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.SVDRadio, 'Value', 0);
    set(handles.PCARadio, 'Value', 0);
    set(handles.CLSIRadio, 'Value', 0);
    set(handles.CMRadio, 'Value', 0);
    set(handles.SPQRRadio, 'Value', 0);
end

states=zeros(length(handles.objects), 1);
handles=activate_uicontrol(states, handles);

guidata(hObject, handles);

% --- Executes on button press in SPQRRadio.
function SPQRRadio_Callback(hObject, eventdata, handles)
% hObject    handle to SPQRRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SPQRRadio
state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.SVDRadio, 'Value', 0);
    set(handles.PCARadio, 'Value', 0);
    set(handles.CLSIRadio, 'Value', 0);
    set(handles.CMRadio, 'Value', 0);
    set(handles.SDDRadio, 'Value', 0);
end

states=zeros(length(handles.objects), 1);
handles=activate_uicontrol(states, handles);

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

states=ones(length(handles.objects), 1); states([13 14 15])=0; states(8)=-1;
if ~get(handles.CLSIRadio, 'Value')==1, states([1 2])=0; end
state=get(handles.CentroidInit, 'Value');
if state==1, states([8 9])=0; end    
if get(handles.ksSelection, 'Value')==0, states(17)=0; else, states(17)=1; end
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

states=ones(length(handles.objects), 1); states([13 14 15])=0; states(8)=-1;
if ~get(handles.CLSIRadio, 'Value')==1, states([1 2])=0; end
state=get(handles.CentroidInit, 'Value');
if state==1, states([8 9])=0; end    
if get(handles.ksSelection, 'Value')==0, states(17)=0; else, states(17)=1; end
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
if get(handles.ksSelection, 'Value')==0, states(17)=0; else, states(17)=1; end
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


% --- Executes on button press in ksSelection.
function ksSelection_Callback(hObject, eventdata, handles)
% hObject    handle to ksSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ksSelection
state=get(hObject, 'Value');
if state==0, set(handles.ksSelection1, 'Enable', 'off'); else, set(handles.ksSelection1, 'Enable', 'on'); end

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


% --- Executes on button press in ksSelection1.
function ksSelection1_Callback(hObject, eventdata, handles)
% hObject    handle to ksSelection1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ksSelection1


% --------------------------------------------------------------------
function NNMFMenu_Callback(hObject, eventdata, handles)
% hObject    handle to NNMFMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


