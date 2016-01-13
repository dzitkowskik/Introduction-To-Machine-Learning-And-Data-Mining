function varargout = gui(varargin)
% GUI 
%   GUI is a simple, top graphical user interface of the Text to
%   Matrix Generator (TMG) Toolbox. Using GUI, the user can 
%   select any of the four GUI modules (indexing, dimensionality 
%   reduction, clustering, classification) of TMG. 
%
% Copyright 2008 Dimitrios Zeimpekis, Efstratios Gallopoulos

% Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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

% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for gui
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

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in IndexingButton.
function IndexingButton_Callback(hObject, eventdata, handles)
% hObject    handle to IndexingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmg_gui;

% --- Executes on button press in DRButton.
function DRButton_Callback(hObject, eventdata, handles)
% hObject    handle to DRButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dr_gui;

% --- Executes on button press in RetrievalButton.
function RetrievalButton_Callback(hObject, eventdata, handles)
% hObject    handle to RetrievalButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
retrieval_gui;

% --- Executes on button press in ClusteringButton.
function ClusteringButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClusteringButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clustering_gui;

% --- Executes on button press in ClassificationButton.
function ClassificationButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClassificationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
classification_gui;

% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);

% --------------------------------------------------------------------
function WindowMenu_Callback(hObject, eventdata, handles)
% hObject    handle to WindowMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function IndexingMenu_Callback(hObject, eventdata, handles)
% hObject    handle to IndexingMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmg_gui;

% --------------------------------------------------------------------
function DRMenu_Callback(hObject, eventdata, handles)
% hObject    handle to DRMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dr_gui;

% --------------------------------------------------------------------
function NNMFMenu_Callback(hObject, eventdata, handles)
% hObject    handle to NNMFMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nnmf_gui;

% --------------------------------------------------------------------
function RetrievalMenu_Callback(hObject, eventdata, handles)
% hObject    handle to RetrievalMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
retrieval_gui;

% --------------------------------------------------------------------
function ClusteringMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ClusteringMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clustering_gui;

% --------------------------------------------------------------------
function ClassificationMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ClassificationMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
classification_gui;

% --------------------------------------------------------------------
function HelpMenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function DocMenu_Callback(hObject, eventdata, handles)
current_path=strcat(fileparts(mfilename('fullpath')));
if exist(strcat(current_path, '/documentation/index.html')),
    open(strcat(current_path, '/documentation/index.html'));
else,
    msgbox('Documentation is not available...', 'Error', 'modal');
    return;
end

% --------------------------------------------------------------------
function OnlineHelp_Callback(hObject, eventdata, handles)
web('http://scgroup6.ceid.upatras.gr:8000/wiki/index.php/Main_Page'); 

% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
about_tmg_gui;

% --- Executes on button press in NNMFButton.
function NNMFButton_Callback(hObject, eventdata, handles)
% hObject    handle to NNMFButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nnmf_gui;