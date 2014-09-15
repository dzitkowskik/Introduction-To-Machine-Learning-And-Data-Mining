function varargout = tmg_save_results(varargin)
% TMG_SAVE_RESULTS
%   TMG_SAVE_RESULTS is a graphical user interface used from 
%   TMG_GUI, for saving the results to a (or multiple) .mat 
%   file(s).
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

% Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tmg_save_results_OpeningFcn, ...
                   'gui_OutputFcn',  @tmg_save_results_OutputFcn, ...
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


% --- Executes just before tmg_save_results is made visible.
function tmg_save_results_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

handles.light_gray=[0.8824 0.8824 0.8824];
handles.gray=[0.9255 0.9137 0.8471];
handles.calling_function='tmg';
%centre the gui
set(0, 'Units', 'centimeters');
scr_position=get(0, 'ScreenSize');
hght=12.4260;
wdth=11.5271;
pos=[(scr_position(3)-wdth)/2 (scr_position(4)-hght)/2 wdth hght];
set(hObject, 'Units', 'centimeters');
set(hObject, 'Position', pos);

handles.objects=[handles.SingleFilename;handles.TdmMatrix;handles.QueryMatrix;handles.Dictionary;...
        handles.UpdateStruct;handles.GlobalWeights;handles.NormalizationFactors;handles.WordsPerDoc;...
        handles.WordsPerQuery;handles.Titles;handles.Files];

if nargin==4 & varargin{1}~=1, 
    handles.calling_function='tmg_query';
end
% Update handles structure
guidata(hObject, handles);
set(handles.figure1, 'Resize', 'off');

% UIWAIT makes tmg_save_results wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tmg_save_results_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;
delete(handles.figure1);


% --- Executes on button press in SingleFiles.
function SingleFiles_Callback(hObject, eventdata, handles)

state=get(hObject, 'Value');
if state==0, 
    set(hObject, 'Value', 1);
else, 
    set(handles.MultipleFiles, 'Value', 0);
    states=zeros(11, 1);states(1)=1;
    handles=activate_uicontrol(states, handles);
end
guidata(hObject, handles);


% --- Executes on button press in MultipleFiles.
function MultipleFiles_Callback(hObject, eventdata, handles)

state=get(hObject, 'Value');
if state==0, 
    set(hObject, 'Value', 1);
else, 
    set(handles.SingleFiles, 'Value', 0);
    states=ones(11, 1);states(1)=0;
    if isequal(handles.calling_function, 'tmg'), states([3 9])=0; else, states([2 4:8])=0; end
    handles=activate_uicontrol(states, handles);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function SingleFilename_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SingleFilename_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'single_filename'), 
    handles=rmfield(handles, 'single_filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
[pathstr, name, ext] = fileparts(s);
if ~isequal(ext, '.mat'), 
    s=strcat(s, '.mat');
end

handles.single_filename=s;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TdmMatrix_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function TdmMatrix_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'tdm_matrix_filename'), 
    handles=rmfield(handles, 'tdm_matrix_filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
[pathstr, name, ext] = fileparts(s);
if ~isequal(ext, '.mat'), 
    s=strcat(s, '.mat');
end

handles.tdm_matrix_filename=s;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function QueryMatrix_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function QueryMatrix_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'query_matrix_filename'), 
    handles=rmfield(handles, 'query_matrix_filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
[pathstr, name, ext] = fileparts(s);
if ~isequal(ext, '.mat'), 
    s=strcat(s, '.mat');
end

handles.query_matrix_filename=s;
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
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'dictionary_filename'), 
    handles=rmfield(handles, 'dictionary_filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
[pathstr, name, ext] = fileparts(s);
if ~isequal(ext, '.mat'), 
    s=strcat(s, '.mat');
end

handles.dictionary_filename=s;
guidata(hObject, handles);

% --- Executes on button press in OkButton.
function OkButton_Callback(hObject, eventdata, handles)

state=get(handles.SingleFiles, 'Value');
if state, 
    A_flag=1;dictionary_flag=1;global_weights_flag=1;normalization_factors_flag=1;
    words_per_doc_flag=1;titles_flag=1;files_flag=1;update_struct_flag=1;
    words_per_query_flag=1;Q_flag=1;
    an='';    
    if isequal(handles.calling_function, 'tmg'), 
        try, A=evalin('base', 'A'); catch, A_flag=0; an='A';end
        try, 
            dictionary=evalin('base', 'dictionary'); 
        catch, 
            dictionary_flag=0; if isempty(an), an='dictionary'; else, an=strcat(an, ', dictionary'); end
        end
        try, 
            words_per_doc=evalin('base', 'words_per_doc'); 
        catch, 
            words_per_doc_flag=0; if isempty(an), an='words_per_doc'; else, an=strcat(an, ', words_per_doc'); end
        end    
        try, 
            normalization_factors=evalin('base', 'normalization_factors'); 
        catch, 
            normalization_factors_flag=0; if isempty(an), an='normalization_factors'; else, an=strcat(an, ', normalization_factors'); end
        end    
        try, 
            global_weights=evalin('base', 'global_weights'); 
        catch, 
            global_weights_flag=0; if isempty(an), an='global_weights'; else, an=strcat(an, ', global_weights'); end
        end    
        try, 
            update_struct=evalin('base', 'update_struct'); 
        catch, 
            update_struct_flag=0; if isempty(an), an='update_struct'; else, an=strcat(an, ', update_struct'); end
        end    
    else, 
        try, Q=evalin('base', 'Q'); catch, Q_flag=0; an='Q';end
        try, 
            words_per_query=evalin('base', 'words_per_query'); 
        catch, 
            words_per_query_flag=0; if isempty(an), an='words_per_query'; else, an=strcat(an, ', words_per_query'); end
        end           
    end
    try, 
        titles=evalin('base', 'titles');
    catch, 
        titles_flag=0; if isempty(an), an='titles'; else, an=strcat(an, ', titles'); end
    end    
    try, 
        files=evalin('base', 'files'); 
    catch, 
        files_flag=0; if isempty(an), an='files'; else, an=strcat(an, ', files'); end
    end       
    
   if ~isempty(an), 
        an=sprintf('Variable(s) %s is(are) empty. Do you want to proceed?', an);
        an=questdlg(an, 'Warning', 'YES', 'NO', 'NO');
        if isequal(an, 'NO'), 
            uiresume(handles.figure1);
        end    
    end
    
    if isequal(handles.calling_function, 'tmg'), 
        exist_flag=0;
        if A_flag, exist_flag=1; save(handles.single_filename, 'A'); end
        if dictionary_flag, 
            if exist_flag==1, 
                save(handles.single_filename, 'dictionary', '-append'); 
            else, 
                save(handles.single_filename, 'dictionary');
                exist_flag=1;
            end
        end
        if words_per_doc_flag, 
            if exist_flag==1, 
                save(handles.single_filename, 'words_per_doc', '-append'); 
            else, 
                save(handles.single_filename, 'words_per_doc');
                exist_flag=1;
            end
        end                
        if global_weights_flag, 
            if exist_flag==1, 
                save(handles.single_filename, 'global_weights', '-append'); 
            else, 
                save(handles.single_filename, 'global_weights');
                exist_flag=1;
            end
        end        
        if normalization_factors_flag, 
            if exist_flag==1, 
                save(handles.single_filename, 'normalization_factors', '-append'); 
            else, 
                save(handles.single_filename, 'normalization_factors');
                exist_flag=1;
            end
        end                
        if titles_flag, 
            if exist_flag==1, 
                save(handles.single_filename, 'titles', '-append'); 
            else, 
                save(handles.single_filename, 'titles');
                exist_flag=1;
            end
        end      
        if files_flag, 
            if exist_flag==1, 
                save(handles.single_filename, 'files', '-append'); 
            else, 
                save(handles.single_filename, 'files');
                exist_flag=1;
            end
        end                
        if update_struct_flag, 
            if exist_flag==1, 
                save(handles.single_filename, 'update_struct', '-append'); 
            else, 
                save(handles.single_filename, 'update_struct');
            end
        end                
    else, 
        exist_flag=0;    
        if Q_flag, exist_flag=1; save(handles.single_filename, 'Q'); end
        if words_per_query_flag, 
            if exist_flag==1, 
                save(handles.single_filename, 'words_per_query', '-append'); 
            else, 
                save(handles.single_filename, 'words_per_query');
                exist_flag=1;
            end
        end                
        if titles_flag, 
            if exist_flag==1, 
                save(handles.single_filename, 'titles', '-append'); 
            else, 
                save(handles.single_filename, 'titles');
                exist_flag=1;
            end
        end      
        if files_flag, 
            if exist_flag==1, 
                save(handles.single_filename, 'files', '-append'); 
            else, 
                save(handles.single_filename, 'files');
            end
        end                
    end
else, 
    A_flag=0;dictionary_flag=0;global_weights_flag=0;normalization_factors_flag=0;
    words_per_doc_flag=0;titles_flag=0;files_flag=0;update_struct_flag=0;
    words_per_query_flag=0;Q_flag=0;    
    an='';
    if isequal(handles.calling_function, 'tmg'), 
        if isfield(handles, 'tdm_matrix_filename'), 
            try, A=evalin('base', 'A'); A_flag=1; catch, A_flag=0; an='A';end 
        end
        if isfield(handles, 'dictionary_filename'), 
            try, 
                dictionary=evalin('base', 'dictionary'); dictionary_flag=1; 
            catch, 
                dictionary_flag=0; if isempty(an), an='dictionary'; else, an=strcat(an, ', dictionary'); end
            end
        end        
        if isfield(handles, 'update_struct_filename'), 
            try, 
                update_struct=evalin('base', 'update_struct'); update_struct_flag=1; 
            catch, 
                update_struct_flag=0; if isempty(an), an='update_struct'; else, an=strcat(an, ', update_struct'); end
            end
        end                
        if isfield(handles, 'global_weights_filename'), 
            try, 
                global_weights=evalin('base', 'global_weights'); global_weights_flag=1; 
            catch, 
                global_weights_flag=0; if isempty(an), an='global_weights'; else, an=strcat(an, ', global_weights'); end
            end
        end                
        if isfield(handles, 'normalization_factors_filename'), 
            try, 
                normalization_factors=evalin('base', 'normalization_factors'); normalization_factors_flag=1; 
            catch, 
                normalization_factors_flag=0; if isempty(an), an='normalization_factors'; else, an=strcat(an, ', normalization_factors'); end
            end
        end                
        if isfield(handles, 'words_per_doc_filename'), 
            try, 
                words_per_doc=evalin('base', 'words_per_doc'); words_per_doc_flag=1; 
            catch, 
                words_per_doc_flag=0; if isempty(an), an='words_per_doc'; else, an=strcat(an, ', words_per_doc'); end
            end
        end                
    else, 
        if isfield(handles, 'query_matrix_filename'), 
            try, Q=evalin('base', 'Q'); Q_flag=1; catch, Q_flag=0; an='Q';end 
        end
        if isfield(handles, 'words_per_query_filename'), 
            try, 
                words_per_query=evalin('base', 'words_per_query'); words_per_query_flag=1; 
            catch, 
                words_per_query_flag=0; if isempty(an), an='words_per_query'; else, an=strcat(an, ', words_per_query'); end
            end
        end                            
    end
    if isfield(handles, 'titles_filename'), 
        try, 
            titles=evalin('base', 'titles'); titles_flag=1; 
        catch, 
            titles_flag=0; if isempty(an), an='titles'; else, an=strcat(an, ', titles'); end
        end
    end            
    if isfield(handles, 'files_filename'), 
        try, 
            files=evalin('base', 'files'); files_flag=1; 
        catch, 
            files_flag=0; if isempty(an), an='files'; else, an=strcat(an, ', files'); end
        end
    end
    
   if ~isempty(an), 
        an=sprintf('Variable(s) %s is(are) empty. Do you want to proceed?', an);
        an=questdlg(an, 'Warning', 'YES', 'NO', 'NO');
        if isequal(an, 'NO'), 
            uiresume(handles.figure1);
        end    
    end
    if isequal(handles.calling_function, 'tmg'), 
        if A_flag, save(handles.tdm_matrix_filename, 'A'); end
        if dictionary_flag, save(handles.dictionary_filename, 'dictionary'); end
        if global_weights_flag, save(handles.global_weights_filename, 'global_weights'); end
        if normalization_factors_flag, save(handles.normalization_factors_filename, 'normalization_factors'); end
        if words_per_doc_flag, save(handles.words_per_doc_filename, 'words_per_doc'); end
        if update_struct_flag, save(handles.update_struct_filename, 'update_struct'); end
    else, 
        if Q_flag, save(handles.query_matrix_filename, 'Q'); end
        if words_per_query_flag, save(handles.words_per_query_filename, 'words_per_query'); end
    end
    if titles_flag, save(handles.titles_filename, 'titles'); end
    if files_flag, save(handles.files_filename, 'files'); end
end
uiresume(handles.figure1);

% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)

uiresume(handles.figure1);


% --- Executes during object creation, after setting all properties.
function UpdateStruct_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function UpdateStruct_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'update_struct_filename'), 
    handles=rmfield(handles, 'update_struct_filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
[pathstr, name, ext] = fileparts(s);
if ~isequal(ext, '.mat'), 
    s=strcat(s, '.mat');
end

handles.update_struct_filename=s;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function GlobalWeights_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function GlobalWeights_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'global_weights_filename'), 
    handles=rmfield(handles, 'global_weights_filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
[pathstr, name, ext] = fileparts(s);
if ~isequal(ext, '.mat'), 
    s=strcat(s, '.mat');
end

handles.global_weights_filename=s;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function NormalizationFactors_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function NormalizationFactors_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'normalization_factors_filename'), 
    handles=rmfield(handles, 'normalization_factors_filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
[pathstr, name, ext] = fileparts(s);
if ~isequal(ext, '.mat'), 
    s=strcat(s, '.mat');
end

handles.normalization_factors_filename=s;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function WordsPerDoc_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function WordsPerDoc_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'words_per_doc_filename'), 
    handles=rmfield(handles, 'words_per_doc_filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
[pathstr, name, ext] = fileparts(s);
if ~isequal(ext, '.mat'), 
    s=strcat(s, '.mat');
end

handles.words_per_doc_filename=s;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Titles_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Titles_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'titles_filename'), 
    handles=rmfield(handles, 'titles_filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
[pathstr, name, ext] = fileparts(s);
if ~isequal(ext, '.mat'), 
    s=strcat(s, '.mat');
end

handles.titles_filename=s;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Files_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Files_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'files_filename'), 
    handles=rmfield(handles, 'files_filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
[pathstr, name, ext] = fileparts(s);
if ~isequal(ext, '.mat'), 
    s=strcat(s, '.mat');
end

handles.files_filename=s;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function WordsPerQuery_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor', [0.8824 0.8824 0.8824]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function WordsPerQuery_Callback(hObject, eventdata, handles)

s=get(hObject, 'String');
guidata(hObject, handles);
if isempty(s) & isfield(handles, 'words_per_query_filename'), 
    handles=rmfield(handles, 'words_per_query_filename');
    guidata(hObject, handles);
    return;
end
if isempty(s), return; end
[pathstr, name, ext] = fileparts(s);
if ~isequal(ext, '.mat'), 
    s=strcat(s, '.mat');
end

handles.words_per_query_filename=s;
guidata(hObject, handles);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
    uiresume(handles.figure1);
else
    delete(handles.figure1);
end

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