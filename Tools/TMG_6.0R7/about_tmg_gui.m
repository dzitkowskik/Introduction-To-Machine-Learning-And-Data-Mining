function varargout = about_tmg_gui(varargin)
% ABOUT_TMG_GUI 
%   ABOUT_TMG_GUI displays information for TMG.
%
% Copyright 2011 Dimitrios Zeimpekis, Eugenia Maria Kontopoulou, Efstratios Gallopoulos

%Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @about_tmg_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @about_tmg_gui_OutputFcn, ...
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


% --- Executes just before about_tmg_gui is made visible.
function about_tmg_gui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
%load the matlab logo
current_path=strcat(fileparts(mfilename('fullpath')));
A=imread(strcat(current_path, filesep, 'documentation', filesep, 'images', filesep, 'logo-upatras.jpg'));
image(A);
set(handles.AxesImage, 'Visible', 'off');

%centre the gui
set(0, 'Units', 'centimeters');
scr_position=get(0, 'ScreenSize');
hght=6.107230937499999;
wdth=11.712135520833332;
pos=[(scr_position(3)-wdth)/2 (scr_position(4)-hght)/2 wdth hght];
set(hObject, 'Units', 'centimeters');
set(hObject, 'Position', pos);

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = about_tmg_gui_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes on button press in OnButton.
function OnButton_Callback(hObject, eventdata, handles)

delete(handles.figure1);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes on button press in updatebutton.
function updatebutton_Callback(hObject, eventdata, handles)
% hObject    handle to updatebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cur_tmg_version='6.0R7';
% dis_tmg_version='5.0R6';
% urlwrite(kapoio url);
latest_tmg_version = urlread('http://scgroup20.ceid.upatras.gr:8000/tmg/v.html');
if ~strcmp(cur_tmg_version, latest_tmg_version),
    msgbox('New Version available', 'Update', 'modal'); 
    web('http://scgroup20.ceid.upatras.gr:8000/tmg/index.php?option=com_content&view=article&id=118&Itemid=14','-browser'); 
else
    msgbox('No new versions available...','Update','modal');
end
