function varargout = tmg_gui(varargin)
% TMG_GUI 
%   TMG_GUI is a graphical user interface for all the indexing 
%   routines of the Text to Matrix Generator (TMG) Toolbox. 
%   For a full documentation type 'help tmg', 'help tmg_query', 
%   'help tdm_update' or 'help tdm_downdate'.
%   For a full documentation of the GUI's usage, select the 
%   help tab to the GUI.
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

% Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tmg_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @tmg_gui_OutputFcn, ...
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

% --- Executes just before tmg_gui is made visible.
function tmg_gui_OpeningFcn(hObject, eventdata, handles, varargin)

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

OPTIONS=struct('use_mysql', 0, 'delimiter', 'emptyline', 'line_delimiter', 1, 'stemming', 0, 'min_length', 3, 'max_length', 30, ...
        'min_local_freq', 1, 'min_global_freq', 1, 'max_local_freq', inf, 'max_global_freq', inf, ...
        'local_weight', 't', 'global_weight', 'x', 'normalization', 'x', 'dsp', 1);
handles.OPTIONS=OPTIONS;
handles.update_struct_type='Files';
handles.removed_docs_type='Files';
handles.dictionary_type='Files';
handles.gwquery_type='Files';
handles.objects=[handles.Filename;handles.FilenameButton;handles.Dictionary;handles.DictionaryButton;handles.GWQuery;...
        handles.GWQueryButton;handles.UpdateStruct;handles.UpdateStructButton;handles.RemovedDocs;handles.RemovedDocsButton;...
        handles.Delimiter;handles.Stoplist;handles.StoplistButton;handles.MinLength;handles.MaxLength;handles.MinLocal;handles.MaxLocal;...
        handles.MinGlobal;handles.MaxGlobal;handles.LocalWeight;handles.GlobalWeight;handles.Normalization;handles.Stemming;handles.UseMySQL;...
        handles.StoreIn];

guidata(hObject, handles);
%set(handles.StoreIn, 'Enable', 'off');
%set(handles.StoreIn, 'BackgroundColor', handles.light_gray);    
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = tmg_gui_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function StoreIn_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function StoreIn_Callback(hObject, eventdata, handles)

s=get(hObject,'String');
if ~isempty(s),
    handles.OPTIONS.db_name=s;
    guidata(hObject, handles);
else,
    OPT=handles.OPTIONS;
    if isfield(OPT, 'db_name'), handles.OPTIONS=rmfield(OPT, 'db_name'); end
    guidata(hObject, handles); 
end

% --- Executes on button press in Disp.
function UseMySQL_Callback(hObject, eventdata, handles)

OPT=handles.OPTIONS;
s=get(hObject, 'Value');
if s==1, 
%    set(handles.StoreIn, 'Enable', 'on');
%    set(handles.StoreIn, 'BackgroundColor', 'white');
    OPT.use_mysql=1; 
else, 
%    set(handles.StoreIn, 'Enable', 'off');
%    set(handles.StoreIn, 'BackgroundColor', handles.light_gray);    
    OPT.use_mysql=0; 
end
handles.OPTIONS=OPT;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Filename_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Filename_Callback(hObject, eventdata, handles)

s=get(hObject,'String');
if isempty(s) & isfield(handles, 'filename'),
    handles=rmfield(handles, 'filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end

handles.filename=s;
guidata(hObject, handles);

% --- Executes on button press in FilenameButton.
function FilenameButton_Callback(hObject, eventdata, handles)

flname=open_file(0);
set(handles.Filename, 'String', flname);
if isempty(flname) & isfield(handles, 'filename'),
    handles=rmfield(handles, 'filename');
    guidata(hObject, handles);
    return;
end
if isempty(flname), return; end

handles.filename=flname;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Delimiter_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Delimiter_Callback(hObject, eventdata, handles)

s=get(hObject,'String');
if ~isempty(s),
    handles.OPTIONS.delimiter=s;
    guidata(hObject, handles);
else,
    handles.OPTIONS.delimiter='emptyline';
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function Stoplist_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Stoplist_Callback(hObject, eventdata, handles)

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

% --- Executes on button press in StoplistButton.
function StoplistButton_Callback(hObject, eventdata, handles)

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

% --- Executes during object creation, after setting all properties.
function MinLength_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function MinLength_Callback(hObject, eventdata, handles)

n=str2double(get(hObject,'String'));
if ~isempty(n),
    handles.OPTIONS.min_length=n;
    guidata(hObject, handles);
else,
    handles.OPTIONS.min_length=3;
end

% --- Executes during object creation, after setting all properties.
function MaxLength_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function MaxLength_Callback(hObject, eventdata, handles)

n=str2double(get(hObject,'String'));
if ~isempty(n),
    handles.OPTIONS.max_length=n;
    guidata(hObject, handles);
else,
    handles.OPTIONS.max_length=30;
end

% --- Executes during object creation, after setting all properties.
function MinLocal_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function MinLocal_Callback(hObject, eventdata, handles)

n=str2double(get(hObject,'String'));
if ~isempty(n),
    handles.OPTIONS.min_local_freq=n;
    guidata(hObject, handles);
else,
    handles.OPTIONS.min_local_freq=1;
end

% --- Executes during object creation, after setting all properties.
function MaxLocal_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function MaxLocal_Callback(hObject, eventdata, handles)

n=str2double(get(hObject,'String'));
if ~isempty(n),
    handles.OPTIONS.max_local_freq=n;
    guidata(hObject, handles);
else,
    handles.OPTIONS.max_local_freq=inf;
end

% --- Executes during object creation, after setting all properties.
function MinGlobal_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function MinGlobal_Callback(hObject, eventdata, handles)

n=str2double(get(hObject,'String'));
if ~isempty(n),
    handles.OPTIONS.min_global_freq=n;
    guidata(hObject, handles);
else,
    handles.OPTIONS.min_global_freq=1;
end

% --- Executes during object creation, after setting all properties.
function MaxGlobal_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function MaxGlobal_Callback(hObject, eventdata, handles)

n=str2double(get(hObject,'String'));
if ~isempty(n),
    handles.OPTIONS.max_global_freq=n;
    guidata(hObject, handles);
else,
    handles.OPTIONS.max_global_freq=inf;
end

% --- Executes during object creation, after setting all properties.
function LocalWeight_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in LocalWeight.
function LocalWeight_Callback(hObject, eventdata, handles)

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
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function GlobalWeight_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in GlobalWeight.
function GlobalWeight_Callback(hObject, eventdata, handles)

OPT=handles.OPTIONS;
ind=get(hObject, 'Value');
switch ind,
    case 1,
        OPT.global_weight='x';
    case 2,
        OPT.global_weight='e';
    case 3,
        OPT.global_weight='f';
    case 4,
        OPT.global_weight='g';
    case 5,
        OPT.global_weight='n';
    case 6,
        OPT.global_weight='p';
end
handles.OPTIONS=OPT;
guidata(hObject, handles);

% --- Executes on button press in Normalization.
function Normalization_Callback(hObject, eventdata, handles)

OPT=handles.OPTIONS;
s=get(hObject, 'Value');
if s==1, OPT.normalization='c'; else, OPT.normalization='x'; end
handles.OPTIONS=OPT;
guidata(hObject, handles);

% --- Executes on button press in Stemming.
function Stemming_Callback(hObject, eventdata, handles)

OPT=handles.OPTIONS;
s=get(hObject, 'Value');
if s==1, OPT.stemming=1; else, OPT.stemming=0; end
handles.OPTIONS=OPT;
guidata(hObject, handles);

% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)

delete(handles.figure1);


% --- Executes on button press in Disp.
function Disp_Callback(hObject, eventdata, handles)

OPT=handles.OPTIONS;
s=get(hObject, 'Value');
if s==1, OPT.dsp=1; else, OPT.dsp=0; end
handles.OPTIONS=OPT;
guidata(hObject, handles);

% --- Executes on button press in ContinueButton.
function ContinueButton_Callback(hObject, eventdata, handles)

create_flag=get(handles.CreateRadio, 'Value');
create_query_flag=get(handles.RadioQuery, 'Value');
update_flag=get(handles.RadioUpdate, 'Value');
downdate_flag=get(handles.RadioDowndate, 'Value');

if create_flag,
    if ~isfield(handles, 'filename') | isempty(handles.filename),
        msgbox('You have to specify the directory...', 'Error', 'modal');
        return;
    end
    OPT=handles.OPTIONS;
    filename=handles.filename;
    if isfield(OPT, 'db_name'), 
        if exist(strcat(fileparts(mfilename('fullpath')), filesep, 'data', filesep, OPT.db_name)), 
            an=sprintf('%s collection already exists. Please give another name...', OPT.db_name); msgbox(an, 'Error', 'modal'); return;
        end
    end
    [A, dictionary, global_weights, normalization_factors, words_per_doc, titles, files, update_struct]=tmg(filename, OPT);
end

if create_query_flag,
    if ~isfield(handles, 'filename') | isempty(handles.filename),
        msgbox('You have to specify the directory...', 'Error', 'modal');
        return;
    end
    if ~isfield(handles, 'dictionary') | isempty(handles.dictionary),
        msgbox('You have to specify the dictionary...', 'Error', 'modal');
        return;
    end
    filename=handles.filename;
    if isequal(handles.dictionary_type, 'Files'),
        if exist(handles.dictionary)==0,
            an=sprintf('File %s not found...', handles.dictionary);
            msgbox(an, 'Error', 'modal');
            return;
        else,
            load(handles.dictionary);
            dictionary=eval(char(fieldnames(load(handles.dictionary))));
        end
    else,
        dictionary=evalin('base', handles.dictionary);
    end

    OPT=handles.OPTIONS;
    OPTS1.delimiter=OPT.delimiter;
    OPTS1.line_delimiter=OPT.line_delimiter;
    if isfield(OPT, 'stoplist'), OPTS1.stoplist=OPT.stoplist; end
    OPTS1.local_weight=OPT.local_weight;OPTS1.stemming=OPT.stemming;OPTS1.dsp=OPT.dsp;

    if isfield(OPT, 'global_weights'),
        s=OPT.global_weights;
        if isequal(handles.gwquery_type, 'Files'),
            if ~isempty(s) & exist(s)==0,
                an=sprintf('File %s not found...', s);
                msgbox(an, 'Error', 'modal');
                return;
            else,
                load(s);
                OPTS1.global_weights=eval(char(fieldnames(load(s))));
            end
        else,
            OPTS1.global_weights=evalin('base', s);
        end
    end

    [Q, words_per_query, titles, files]=tmg_query(filename, dictionary, OPTS1);
end

if update_flag,
    if ~isfield(handles, 'filename'),
        handles.filename='';
        guidata(hObject, handles);
    end
    if ~isfield(handles, 'update_struct') | isempty(handles.update_struct),
        msgbox('You have to specify the update struct...', 'Error', 'modal');
        return;
    end
    filename=handles.filename;
    if isequal(handles.update_struct_type, 'Files'),
        if exist(handles.update_struct)==0,
            an=sprintf('File %s not found...', handles.update_struct);
            msgbox(an, 'Error', 'modal');
            return;
        else,
            load(handles.update_struct);
            update_struct=eval(char(fieldnames(load(handles.update_struct))));
        end
    else,
        update_struct=evalin('base', handles.update_struct);
    end

    OPT=handles.OPTIONS;
    OPTS1.delimiter=OPT.delimiter;OPTS1.dsp=OPT.dsp;
    OPTS1.line_delimiter=OPT.line_delimiter;

    [A, dictionary, global_weights, normalization_factors, words_per_doc, titles, files, update_struct]=tdm_update(filename, update_struct, OPTS1);
end
if downdate_flag,
    if ~isfield(handles, 'update_struct') | isempty(handles.update_struct),
        msgbox('You have to specify the update struct...', 'Error', 'modal');
        return;
    end
    if ~isfield(handles, 'removed_docs') | isempty(handles.removed_docs),
        msgbox('You have to specify the document indices...', 'Error', 'modal');
        return;
    end

    if isequal(handles.update_struct_type, 'Files'),
        if exist(handles.update_struct)==0,
            an=sprintf('File %s not found...', handles.update_struct);
            msgbox(an, 'Error', 'modal');
            return;
        else,
            load(handles.update_struct);
            update_struct=eval(char(fieldnames(load(handles.update_struct))));
        end
    else,
        update_struct=evalin('base', handles.update_struct);
    end
    if isequal(handles.removed_docs_type, 'Files'),
        if exist(handles.removed_docs)==0,
            an=sprintf('File %s not found...', handles.removed_docs);
            msgbox(an, 'Error', 'modal');
            return;
        else,
            load(handles.removed_docs);
            removed_docs=eval(char(fieldnames(load(handles.removed_docs))));
        end
    else,
        removed_docs=evalin('base', handles.removed_docs);
    end

    OPT=handles.OPTIONS;
    OPTS1.dsp=OPT.dsp;

    [A, dictionary, global_weights, normalization_factors, words_per_doc, titles, files, update_struct]=tdm_downdate(update_struct, removed_docs, OPTS1);
end

if create_query_flag==0,
    assignin('base', 'A', A);assignin('base', 'dictionary', dictionary);
    assignin('base', 'global_weights', global_weights);assignin('base', 'normalization_factors', normalization_factors);
    assignin('base', 'words_per_doc', words_per_doc);assignin('base', 'titles', titles);
    assignin('base', 'files', files);assignin('base', 'update_struct', update_struct);
    if create_flag==0, 
        an=sprintf('Do you want to save the results?');
        an=questdlg(an, 'Results', 'YES', 'NO', 'YES');
        if isequal(an, 'YES'),
            tmg_save_results(1);
        end
    end
else,
    if isempty(Q), return; end
    assignin('base', 'Q', Q);assignin('base', 'words_per_query', words_per_query);
    assignin('base', 'titles', titles);assignin('base', 'files', files);
    an=sprintf('Do you want to save the results?');
    an=questdlg(an, 'Results', 'YES', 'NO', 'YES');
    if isequal(an, 'YES'),
        tmg_save_results(2);
    end
end
msgbox('Done!', 'modal');

% --- Executes on button press in ClearButton.
function ClearButton_Callback(hObject, eventdata, handles)

OPTIONS=struct('delimiter', 'emptyline', 'stemming', 0, 'min_length', 3, 'max_length', 30, ...
        'min_local_freq', 1, 'min_global_freq', 1, 'max_local_freq', inf, 'max_global_freq', inf, ...
        'local_weight', 't', 'global_weight', 'x', 'normalization', 'x', 'dsp', 1);
handles.OPTIONS=OPTIONS;

if isfield(handles, 'filename'), handles.filename=''; end

set(handles.Filename, 'String', '');
set(handles.Dictionary, 'String', '');
set(handles.GWQuery, 'String', '');
set(handles.UpdateStruct, 'String', '');
set(handles.RemovedDocs, 'String', '');
set(handles.Delimiter, 'String', 'emptyline');
set(handles.Stoplist, 'String', '');
set(handles.MinLength, 'String', '3');
set(handles.MaxLength, 'String', '30');
set(handles.MinLocal, 'String', '1');
set(handles.MaxLocal, 'String', 'inf');
set(handles.MinGlobal, 'String', '1');
set(handles.MaxGlobal, 'String', 'inf');
set(handles.LocalWeight, 'Value', 1);
set(handles.GlobalWeight, 'Value', 1);
set(handles.Normalization, 'Value', 0);
set(handles.Disp, 'Value', 1);
set(handles.Stemming, 'Value', 0);
handles.update_struct_type='Files';
handles.removed_docs_type='Files';
handles.dictionary_type='Files';
handles.gwquery_type='Files';
guidata(hObject, handles);

% --- Executes on button press in CreateRadio.
function CreateRadio_Callback(hObject, eventdata, handles)

state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.RadioQuery, 'Value', 0);
    set(handles.RadioUpdate, 'Value', 0);
    set(handles.RadioDowndate, 'Value', 0);
    states=ones(25, 1);states([(3:10)])=0;
    handles=activate_uicontrol(states, handles);
end
guidata(hObject, handles);


% --- Executes on button press in RadioUpdate.
function RadioUpdate_Callback(hObject, eventdata, handles)

state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.CreateRadio, 'Value', 0);
    set(handles.RadioQuery, 'Value', 0);
    set(handles.RadioDowndate, 'Value', 0);
    states=zeros(25, 1);states([(1:2) (7:8) 11])=1;
    handles=activate_uicontrol(states, handles);
end
guidata(hObject, handles);


% --- Executes on button press in RadioDowndate.
function RadioDowndate_Callback(hObject, eventdata, handles)

state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.CreateRadio, 'Value', 0);
    set(handles.RadioQuery, 'Value', 0);
    set(handles.RadioUpdate, 'Value', 0);
    states=zeros(25, 1);states([(7:10)])=1;
    handles=activate_uicontrol(states, handles);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function UpdateStruct_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function UpdateStruct_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
handles.update_struct_type='Files';
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'update_struct'),
    handles=rmfield(handles, 'update_struct');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
if isequal(handles.update_struct_type, 'Files'),
    [pathstr, name, ext] = fileparts(s);
    if ~isequal(ext, '.mat'),
        msgbox('You have to provide a mat file...', 'Error', 'modal');
        if isfield(handles, 'update_struct'), handles=rmfield(handles, 'update_struct'); end
        set(handles.UpdateStruct, 'String', '');guidata(hObject, handles);
        return;
    end
end

handles.update_struct=s;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function RemovedDocs_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function RemovedDocs_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
handles.removed_docs_type='Files';
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'removed_docs'),
    handles=rmfield(handles, 'removed_docs');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
if isequal(handles.removed_docs_type, 'Files'),
    [pathstr, name, ext] = fileparts(s);
    if ~isequal(ext, '.mat'),
        msgbox('You have to provide a mat file...', 'Error', 'modal');
        if isfield(handles, 'removed_docs'), handles=rmfield(handles, 'removed_docs'); end
        set(handles.RemovedDocs, 'String', '');guidata(hObject, handles);
        return;
    end
end

handles.removed_docs=s;
guidata(hObject, handles);

% --- Executes on button press in UpdateStructButton.
function UpdateStructButton_Callback(hObject, eventdata, handles)

[s, handles.update_struct_type]=open_file(2);
guidata(hObject, handles);
set(handles.UpdateStruct, 'String', s);

if isempty(s) & isfield(handles, 'update_struct'),
    handles=rmfield(handles, 'update_struct');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
if isequal(handles.update_struct_type, 'Files'),
    [pathstr, name, ext] = fileparts(s);
    if ~isequal(ext, '.mat'),
        msgbox('You have to provide a mat file...', 'Error', 'modal');
        if isfield(handles, 'update_struct'), handles=rmfield(handles, 'update_struct'); end
        set(handles.UpdateStruct, 'String', '');guidata(hObject, handles);
        return;
    end
end

handles.update_struct=s;
guidata(hObject, handles);

% --- Executes on button press in RemovedDocsButton.
function RemovedDocsButton_Callback(hObject, eventdata, handles)

[s, handles.removed_docs_type]=open_file(2);
guidata(hObject, handles);
set(handles.RemovedDocs, 'String', s);

if isempty(s) & isfield(handles, 'removed_docs'),
    handles=rmfield(handles, 'removed_docs');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
if isequal(handles.removed_docs_type, 'Files'),
    [pathstr, name, ext] = fileparts(s);
    if ~isequal(ext, '.mat'),
        msgbox('You have to provide a mat file...', 'Error', 'modal');
        if isfield(handles, 'removed_docs'), handles=rmfield(handles, 'removed_docs'); end
        set(handles.RemovedDocs, 'String', '');guidata(hObject, handles);
        return;
    end
end

handles.removed_docs=s;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Dictionary_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Dictionary_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
handles.dictionary_type='Files';
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'dictionary'),
    handles=rmfield(handles, 'dictionary');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
if isequal(handles.dictionary_type, 'Files'),
    [pathstr, name, ext] = fileparts(s);
    if ~isequal(ext, '.mat'),
        msgbox('You have to provide a mat file...', 'Error', 'modal');
        if isfield(handles, 'dictionary'), handles=rmfield(handles, 'dictionary'); end
        set(handles.Dictionary, 'String', '');guidata(hObject, handles);
        return;
    end
end

handles.dictionary=s;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function GWQuery_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function GWQuery_Callback(hObject, eventdata, handles)

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
        set(handles.GWQuery, 'String', '');guidata(hObject, handles);
        return;
    end
end

OPT.global_weights=s;
handles.OPTIONS=OPT;
guidata(hObject, handles);

% --- Executes on button press in DictionaryButton.
function DictionaryButton_Callback(hObject, eventdata, handles)

[s, handles.dictionary_type]=open_file(2);
guidata(hObject, handles);
set(handles.Dictionary, 'String', s);

if isempty(s) & isfield(handles, 'dictionary'),
    handles=rmfield(handles, 'dictionary');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
if isequal(handles.dictionary_type, 'Files'),
    [pathstr, name, ext] = fileparts(s);
    if ~isequal(ext, '.mat'),
        msgbox('You have to provide a mat file...', 'Error', 'modal');
        if isfield(handles, 'dictionary'), handles=rmfield(handles, 'dictionary'); end
        set(handles.Dictionary, 'String', '');guidata(hObject, handles);
        return;
    end
end

handles.dictionary=s;
guidata(hObject, handles);

% --- Executes on button press in GWQueryButton.
function GWQueryButton_Callback(hObject, eventdata, handles)

[s, handles.gwquery_type]=open_file(2);
guidata(hObject, handles);
set(handles.GWQuery, 'String', s);

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
        set(handles.GWQuery, 'String', '');guidata(hObject, handles);
        return;
    end
end

OPT.global_weights=s;
handles.OPTIONS=OPT;
guidata(hObject, handles);


% --- Executes on button press in RadioQuery.
function RadioQuery_Callback(hObject, eventdata, handles)

state=get(hObject, 'Value');
if state==0,
    set(hObject, 'Value', 1);
else,
    set(handles.CreateRadio, 'Value', 0);
    set(handles.RadioUpdate, 'Value', 0);
    set(handles.RadioDowndate, 'Value', 0);
    states=zeros(25, 1);states([(1:6) (11:13) 20 23])=1;
    handles=activate_uicontrol(states, handles);
end
guidata(hObject, handles);


%--------------------------------------------------------------------------
% --- Executes on button press in LineDelimiter.
function LineDelimiter_Callback(hObject, eventdata, handles)

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
%--------------------------------------------------------------------------


%set Active and BackgroundColor field of each uicontrol item depending on
%the Radio Button that is pressed (called by the corresponding callback)
function handles=activate_uicontrol(states, handles)
sz=size(handles.objects, 1);
for i=1:sz,
    if states(i), tmp='on'; else, tmp='off'; end
    set(handles.objects(i), 'Enable', tmp);
    if states(i)==0 & isequal(get(handles.objects(i), 'Style'), 'edit'),
        set(handles.objects(i), 'BackgroundColor', handles.light_gray);continue;
    end
    if states(i)==1 & isequal(get(handles.objects(i), 'Style'), 'edit'),
        set(handles.objects(i), 'BackgroundColor', 'white');
    end
end