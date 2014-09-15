function varargout = open_file(varargin)
% OPEN_FILE
%   OPEN_FILE is a graphical user interface for selecting a file, 
%   directory or variable from the workspace. The function returns 
%   the name of the selected file, directory or variable.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

%Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @open_file_OpeningFcn, ...
                   'gui_OutputFcn',  @open_file_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before open_file is made visible.
function open_file_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

%centre the gui
set(0, 'Units', 'centimeters');
scr_position=get(0, 'ScreenSize');
hght=6.741748437499999;
wdth=14.778970104166666;
pos=[(scr_position(3)-wdth)/2 (scr_position(4)-hght)/2 wdth hght];
set(hObject, 'Units', 'centimeters');
set(hObject, 'Position', pos);

%-----
root=pwd;
tmp={pwd};
str=strcat(fileparts(mfilename('fullpath')), filesep, 'log_files');
cd(str); 
% if exist('./history.log')~=2, 
if exist('history.log')~=2, 
    fid=fopen('history.log', 'at');
    if fid==-1, error('Unable to open file history.log...'); end
    fprintf(fid, '%s\n', root);fclose(fid);
else, 
    tmp=textread('history.log', '%s', -1, 'delimiter', '\n');
end

cd(root);% change dir to the previous current path

pwd_ind=find(ismember(tmp, pwd));

if isempty(pwd_ind),
    cd(str);
    fid=fopen('history.log', 'at');
    if fid==-1, error('Unable to open file history.log...'); end
    fprintf(fid, '%s\n', root);fclose(fid);
    cd(root);    
    tmp{end+1}=pwd;pwd_ind=size(tmp, 1);
end

set(handles.WorkingDir, 'String', tmp);
set(handles.WorkingDir, 'Value', pwd_ind);
handles.work_dirs=tmp;
handles.work_dir_ind=pwd_ind;
%-----
handles.c_dir=pwd;
handles.open_type='Files';
guidata(hObject, handles);

%check input
if nargin~=4 | varargin{1}>3, 
    errordlg('Type load_list(i)...', 'Input Argument Error!');
    return;
end
handles.open_files=varargin{1};
guidata(hObject, handles);

tmp={'Files'};
ind=1;
if handles.open_files==2, 
    tmp{2}='Variables';
end
if handles.open_files==3, 
    tmp={'Variables'};
    handles.open_type='Variables';
end
set(handles.Popup1, 'String', tmp);
set(handles.Popup1, 'Value', ind);
if handles.open_files<3, set(handles.listbox1, 'String', GetList(pwd)); else, set(handles.listbox1, 'String', GetList1); end
guidata(hObject, handles);

% UIWAIT makes open_file wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = open_file_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.c_dir;
varargout{2} = handles.open_type;
delete(handles.figure1);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
files=GetList(pwd);
set(hObject, 'String', files);
set(hObject, 'Value', 1);

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

str=strcat(fileparts(mfilename('fullpath')), filesep, 'log_files');

if isequal(get(handles.figure1,'SelectionType'), 'open'), 
    if isequal(handles.open_type, 'Variables'), 
        vars=get(hObject, 'String');
        vars_ind=get(hObject, 'Value');
        handles.c_dir=vars{vars_ind};
        guidata(hObject, handles);
        uiresume(handles.figure1);
        return;
    end    
    dirs=get(hObject, 'String');
    dirs_ind=get(hObject, 'Value');
    cur_dir=dirs{dirs_ind};
    if isequal(cur_dir, '.'), 
        return;
    end
    if isequal(cur_dir, '..'), 
        [pathstr, name] = fileparts(handles.c_dir);
        handles.c_dir=pathstr;
        guidata(hObject, handles);
    else, 
        if ~isequal(handles.c_dir(end), filesep), 
            handles.c_dir=strcat(handles.c_dir, filesep, cur_dir);
        else, 
            handles.c_dir=strcat(handles.c_dir, cur_dir);
        end
        guidata(hObject, handles);
    end 
    cur_dir=handles.c_dir;
    if isdir(cur_dir), 
        files=GetList(cur_dir);
        set(hObject, 'String', files);
        set(hObject, 'Value', 1);
        cur_ind=find(ismember(handles.work_dirs, cur_dir));
        if isempty(cur_ind), 
            handles.work_dirs{end+1, 1}=cur_dir;
            guidata(hObject, handles);
            handles.work_dir_ind=size(handles.work_dirs, 1);
            root=pwd;
			cd(str);
            fid=fopen('history.log', 'at');
            if fid==-1, error('Unable to open file history.log...'); end
            fprintf(fid, '%s\n', cur_dir);fclose(fid);
            cd(root);                
        else, 
            handles.work_dir_ind=cur_ind;
        end
        guidata(hObject, handles);
        set(handles.WorkingDir, 'String', handles.work_dirs);
        set(handles.WorkingDir, 'Value', handles.work_dir_ind);
        guidata(hObject, handles);
    else, 
        uiresume(handles.figure1);
    end
end

% --- Executes on button press in OpenButton.
function OpenButton_Callback(hObject, eventdata, handles)

str=strcat(fileparts(mfilename('fullpath')), filesep, 'log_files');

dirs=get(handles.listbox1, 'String');
dirs_ind=get(handles.listbox1, 'Value');
cur_dir=dirs{dirs_ind};
if isequal(handles.open_type, 'Variables'), 
    handles.c_dir=cur_dir;
    guidata(hObject, handles);
    uiresume(handles.figure1);
    return;
end
if isequal(cur_dir, '.'), 
    if handles.open_files==0, uiresume(handles.figure1); end
    return;
end
if isequal(cur_dir, '..'), 
    [pathstr, name] = fileparts(handles.c_dir);
    handles.c_dir=pathstr;
    guidata(hObject, handles);
    if handles.open_files==0, uiresume(handles.figure1); return; end
else, 
    if ~isequal(handles.c_dir(end), filesep), 
        handles.c_dir=strcat(handles.c_dir, filesep, cur_dir);
    else, 
        handles.c_dir=strcat(handles.c_dir, cur_dir);
    end
    guidata(hObject, handles);
end
cur_dir=handles.c_dir;
if isdir(cur_dir), 
    if handles.open_files==0, uiresume(handles.figure1); return; end
    files=GetList(cur_dir);
    set(handles.listbox1, 'String', files);
    set(handles.listbox1, 'Value', 1);
    cur_ind=find(ismember(handles.work_dirs, cur_dir));
    if isempty(cur_ind), 
        handles.work_dirs{end+1, 1}=cur_dir;
        guidata(hObject, handles);        
        handles.work_dir_ind=size(handles.work_dirs, 1);
		root=pwd;
		cd(str);
        fid=fopen('history.log', 'at');
        if fid==-1, error('Unable to open file history.log...'); end
        fprintf(fid, '%s\n', cur_dir);fclose(fid);
        cd(root);                
    else, 
        handles.work_dir_ind=cur_ind;
    end
    guidata(hObject, handles);
    set(handles.WorkingDir, 'String', handles.work_dirs);
    set(handles.WorkingDir, 'Value', handles.work_dir_ind);
    guidata(hObject, handles);
else, 
    uiresume(handles.figure1);    
end


% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)

handles.c_dir=[];
guidata(hObject, handles);
uiresume(handles.figure1);

function figure1_CloseRequestFcn(hObject, eventdata, handles)

if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
    uiresume(handles.figure1);
else
    delete(handles.figure1);
end


% --- Executes during object creation, after setting all properties.
function Popup1_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in Popup1.
function Popup1_Callback(hObject, eventdata, handles)

open_type=get(hObject, 'String');
open_type_ind=get(hObject, 'Value');
handles.open_type=open_type{open_type_ind};

if open_type_ind==1,
    handles.c_dir=pwd;guidata(hObject, handles);
    files=GetList(handles.c_dir);
    set(handles.listbox1, 'String', files);
    set(handles.listbox1, 'Value', 1);
    pwd_ind=find(ismember(handles.work_dirs, pwd));
    set(handles.WorkingDir, 'String', handles.work_dirs);
    set(handles.WorkingDir, 'Value', pwd_ind);    
    handles.work_dir_ind=pwd_ind;
else, 
    variables=GetList1;
    set(handles.listbox1, 'String', variables);
    set(handles.listbox1, 'Value', 1);
    set(handles.WorkingDir, 'String', 'Workspace');    
    set(handles.WorkingDir, 'Value', 1);
end
guidata(hObject, handles);

%-------------------------------------------------------------------------
%get list of files of the input directory
function files=GetList(dir_name)

file_struct=dir(dir_name);
files={};
n_files=0;
for i=1:size(file_struct, 1), 
    n_files=n_files+1;
    files{n_files, 1}=file_struct(i).name;
end

%get list of variables of the workspace
function variables=GetList1

vars=evalin('base', 'whos');
variables={};
n_variables=0;
for i=1:size(vars, 1), 
    n_variables=n_variables+1;
    variables{n_variables, 1}=vars(i).name;
end


% --- Executes during object creation, after setting all properties.
function WorkingDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WorkingDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in WorkingDir.
function WorkingDir_Callback(hObject, eventdata, handles)
% hObject    handle to WorkingDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns WorkingDir contents as cell array
%        contents{get(hObject,'Value')} returns selected item from WorkingDir

if isequal(handles.open_type, 'Variables'), return; end
s=get(hObject, 'String');
ind=get(hObject, 'Value');
if ~isdir(s{ind}), 
   an=new_sprintf('Error opening directory ''%s''. Directory does not exist...', s{ind}); 
    msgbox(an, 'modal');
    set(hObject, 'Value', handles.work_dir_ind);
    return;
end
handles.c_dir=s{ind};
set(handles.listbox1, 'String', GetList(s{ind}));
set(handles.listbox1, 'Value', 1);
guidata(hObject, handles);