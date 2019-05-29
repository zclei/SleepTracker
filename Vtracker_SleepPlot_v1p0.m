function varargout = Vtracker_SleepPlot_v1p0(varargin)
% Vtracker_SleepPlot_v1p0 MATLAB code for Vtracker_SleepPlot_v1p0.fig
%      Vtracker_SleepPlot_v1p0, by itself, creates a new Vtracker_SleepPlot_v1p0 or raises the existing
%      singleton*.
%
%      H = Vtracker_SleepPlot_v1p0 returns the handle to a new Vtracker_SleepPlot_v1p0 or the handle to
%      the existing singleton*.
%
%      Vtracker_SleepPlot_v1p0('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Vtracker_SleepPlot_v1p0.M with the given input arguments.
%
%      Vtracker_SleepPlot_v1p0('Property','Value',...) creates a new Vtracker_SleepPlot_v1p0 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Vtracker_SleepPlot_v1p0_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Vtracker_SleepPlot_v1p0_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Vtracker_SleepPlot_v1p0

% Last Modified by GUIDE v2.5 13-May-2019 21:54:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Vtracker_SleepPlot_v1p0_OpeningFcn, ...
                   'gui_OutputFcn',  @Vtracker_SleepPlot_v1p0_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Vtracker_SleepPlot_v1p0 is made visible.
function Vtracker_SleepPlot_v1p0_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Vtracker_SleepPlot_v1p0 (see VARARGIN)

% Choose default command line output for Vtracker_SleepPlot_v1p0
handles.output = hObject;
handles.FileName = [];
handles.FileName_full = [];
handles.groupName = [];
handles.idxplot= 0;
handles.head = {'File','Arena','quality','copulation','courtship'};

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Vtracker_SleepPlot_v1p0 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Vtracker_SleepPlot_v1p0_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in addVideo.
function addVideo_Callback(hObject, eventdata, handles)
% hObject    handle to addVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FN,FP] = uigetfile('.avi','select index files','C:\','MultiSelect','on');

if isnumeric(FP)
    set(handles.list_msg,'string','Files not selected');
    return
end

if ~iscell(FN(1))
    FN = {FN};
end
FN_full = cellfun(@(x)([FP x]),FN,'UniformOutput',false);

% check and remove duplicated index files
set(handles.list_msg,'string','Checking duplicates');
pause(1);
[dup_file,~, dup_ind] = intersect(handles.FileName_full,FN_full);
dup_no = length(dup_file);
if ~isempty(dup_ind)
    FN_full(dup_ind) = [];
    set(handles.list_msg,'string',[{[num2str(dup_no),' duplicates are removed:']}, dup_file]);
else
    set(handles.list_msg,'string','No duplicates found');
end

if ~isempty(FN)
    % add video to list
    handles.FileName = [handles.FileName, FN];
    handles.FileName_full = [handles.FileName_full, FN_full];

    file_no = length(handles.FileName);
    set(handles.list_videoAdded,'string',...
        [{[num2str(file_no) ' files loaed']},handles.FileName_full]);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function list_videoAdded_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_videoAdded (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_tracking.
function plot_tracking_Callback(hObject, eventdata, handles)
% hObject    handle to plot_tracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 set(hObject,'BackgroundColor','red');
 set(hObject,'string','wait');

if isempty(handles.FileName)
    set(handles.list_msg,'string','No video added');
    set(hObject,'BackgroundColor',[.941 .941 .941]);
    set(hObject,'Value',0);
    handles.idxplot = 0;
    guidata(hObject,handles);
    return
end
    
    handles.idxplot = get(hObject,'value');
 if ~handles.idxplot
     
     set(hObject,'BackgroundColor',[.941 .941 .941]);
     set(hObject,'Value',0);
     set(hObject,'string','Fly Tracking');
     handles.idxplot = 0;
     guidata(hObject,handles);
     return
 end
     

 set(handles.list_msg,'string','Tracking flies...');
 
 arenaTypes = get(handles.pop_arenaType,'string');
 handles.arenaType = arenaTypes{get(handles.pop_arenaType,'Value')};
 arenaType = handles.arenaType;
 
 handles.plotsave2 = get(handles.ed_plotsave2,'string');
 saveDir = handles.plotsave2;
 
 handles.binSize = str2num(get(handles.ed_binSize,'string'));
 binSize = handles.binSize;
 
 poolobj = gcp('nocreate');
 handles.N_workers = str2num(get(handles.ed_workers,'string'));
 if handles.N_workers>12
     handles.N_workers = 12;
 end % If no pool, do not create new one.
 
 if isempty(poolobj)&& handles.idxplot
     parpool('local', handles.N_workers);
 end

 FN = handles.FileName;
 FN_full = handles.FileName_full;
 fnNo = size(FN,2);

for i = 1:fnNo
    PN = fileparts(FN_full{i});
    PN = [PN,'\'];
    set(handles.list_msg,'string',['Procesing video #',num2str(i)]);
    try
    VsleepTracking_singleVideo(FN{i},PN,...
        binSize,arenaType,...
        saveDir);
    catch ME
        set(handles.list_msg,'string',{'errors:',ME.identifier});
    end
    
end

 set(hObject,'Value',0);
 set(hObject,'BackgroundColor',[.941 .941 .941]);
 set(hObject,'string','Fly Tracking');

 
 handles.idxplot = 0;

set(handles.list_msg,'string',['Tracking completed: ',num2str(i),'/',num2str(fnNo)]);

guidata(hObject,handles);

function ed_plotsave2_Callback(hObject, eventdata, handles)
% hObject    handle to ed_plotsave2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_plotsave2 as text
%        str2double(get(hObject,'String')) returns contents of ed_plotsave2 as a double
handles.plotsave2 = get(hObject,'string');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ed_plotsave2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_plotsave2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ed_workers_Callback(hObject, eventdata, handles)
% hObject    handle to ed_workers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_workers as text
%        str2double(get(hObject,'String')) returns contents of ed_workers as a double


% --- Executes during object creation, after setting all properties.
function ed_workers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_workers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_saveto.
function pb_saveto_Callback(hObject, eventdata, handles)
% hObject    handle to pb_saveto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveDir = uigetdir();
saveDir = [saveDir,'\'];
if saveDir~=0
    handles.plotsave2 = saveDir;
    set(handles.ed_plotsave2,'string',saveDir);
    if ~exist(saveDir,'dir')
        mkdir(saveDir);
    end
    
end
guidata(hObject, handles);


% --- Executes on selection change in listbox_arenaType.
function listbox_arenaType_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_arenaType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_arenaType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_arenaType


% --- Executes during object creation, after setting all properties.
function listbox_arenaType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_arenaType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_arenaType.
function pop_arenaType_Callback(hObject, eventdata, handles)
% hObject    handle to pop_arenaType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_arenaType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_arenaType


% --- Executes during object creation, after setting all properties.
function pop_arenaType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_arenaType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_clear.
function pb_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pb_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.FileName = [];
handles.FileName_full = [];

set(handles.list_videoAdded,'string',{'Video list cleared'});

guidata(hObject, handles);

function list_videoAdded_Callback(hObject, eventdata, handles)
% hObject    handle to pop_arenaType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function ed_binSize_Callback(hObject, eventdata, handles)
% hObject    handle to ed_binSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_binSize as text
%        str2double(get(hObject,'String')) returns contents of ed_binSize as a double


% --- Executes during object creation, after setting all properties.
function ed_binSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_binSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_arenaDetection.
function pb_arenaDetection_Callback(hObject, eventdata, handles)
% hObject    handle to pb_arenaDetection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pb_addGN.
function pb_addGN_Callback(hObject, eventdata, handles)
% hObject    handle to pb_addGN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
groupNames = get(handles.tb_groupNames,'data');
gNo = size(groupNames,1);
handles.groupNames = cell(gNo+1,3);
handles.groupNames(1:gNo,:) = groupNames;
set(handles.tb_groupNames,'data',handles.groupNames);
handles.selectedRow=[];
guidata(hObject, handles);




% --- Executes on button press in pb_deleteGN.
function pb_deleteGN_Callback(hObject, eventdata, handles)
% hObject    handle to pb_deleteGN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
groupNames = get(handles.tb_groupNames,'data');
gNo = size(groupNames,1);
if gNo<2
    handles.msg = get(handles.list_msg,'String');
   handles.msg = [handles.msg;{'Last group, deletion ignored'}]; 
   set(handles.list_msg,'String',handles.msg);
   return
end

if isempty(handles.selectedRow)
    handles.msg = get(handles.list_msg,'String');
   handles.msg = [handles.msg;{'No group selected'}]; 
   set(handles.list_msg,'String',handles.msg);
   return
end

groupNames(handles.selectedRow,:) = [];
handles.groupNames = groupNames;
set(handles.tb_groupNames,'data',handles.groupNames);
handles.selectedRow=[];
guidata(hObject, handles);

% --- Executes on button press in pb_resetGN.
function pb_resetGN_Callback(hObject, eventdata, handles)
% hObject    handle to pb_resetGN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GNreset = questdlg('Would you like to reset the GroupNames table?', ...
	'reset GroupNames', ...
	'Yes','No thanks','No thanks');
% Handle response
switch GNreset
    case 'Yes'
        handles.groupNames = {'Group1',1,100};
        set(handles.tb_groupNames,'data',handles.groupNames);
        handles.selectedRow = [];
    case 'No thanks'
        return
end

% --- Executes during object creation, after setting all properties.
function tb_groupNames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_groupNames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Data', {'Group1',1,100});
handles.selectedRow = [];
guidata(hObject, handles);

% --- Executes when selected cell(s) is changed in tb_groupNames.
function tb_groupNames_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tb_groupNames (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
% eventdata.Indices
if size(eventdata.Indices,1)>0
    handles.selectedRow = eventdata.Indices(1);
end
guidata(hObject, handles);
