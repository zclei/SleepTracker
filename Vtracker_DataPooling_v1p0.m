function varargout = Vtracker_DataPooling_v1p0(varargin)
% Vtracker_DataPooling_v1p0 MATLAB code for Vtracker_DataPooling_v1p0.fig
%      Vtracker_DataPooling_v1p0, by itself, creates a new Vtracker_DataPooling_v1p0 or raises the existing
%      singleton*.
%
%      H = Vtracker_DataPooling_v1p0 returns the handle to a new Vtracker_DataPooling_v1p0 or the handle to
%      the existing singleton*.
%
%      Vtracker_DataPooling_v1p0('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Vtracker_DataPooling_v1p0.M with the given input arguments.
%
%      Vtracker_DataPooling_v1p0('Property','Value',...) creates a new Vtracker_DataPooling_v1p0 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Vtracker_DataPooling_v1p0_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Vtracker_DataPooling_v1p0_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Vtracker_DataPooling_v1p0

% Last Modified by GUIDE v2.5 27-May-2019 23:37:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Vtracker_DataPooling_v1p0_OpeningFcn, ...
                   'gui_OutputFcn',  @Vtracker_DataPooling_v1p0_OutputFcn, ...
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


% --- Executes just before Vtracker_DataPooling_v1p0 is made visible.
function Vtracker_DataPooling_v1p0_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Vtracker_DataPooling_v1p0 (see VARARGIN)

% Choose default command line output for Vtracker_DataPooling_v1p0
handles.output = hObject;
handles.FileName = [];
handles.FileName_full = [];
handles.FileNameGP_full = [];
% handles.data.SS = [];
handles.data.SSb = [];
handles.aFNmtx = [];
handles.idxplot= 0;
handles.curDir = 'C:\';
handles.head = {'File','Arena','quality','copulation','courtship'};

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Vtracker_DataPooling_v1p0 wait for user response (see UIRESUME)
% uiwait(handles.VtrackerDataPooling);


% --- Outputs from this function are returned to the command line.
function varargout = Vtracker_DataPooling_v1p0_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pb_addData.
function pb_addData_Callback(hObject, eventdata, handles)
% hObject    handle to pb_addData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FN,FP] = uigetfile('.mat','select index files',handles.curDir,'MultiSelect','on');

if isnumeric(FP)
    set(handles.list_msg,'string','Files not selected');
    return
end

handles.curDir = FP;

if ~iscell(FN(1))
    FN = {FN};
end
FN_full = cellfun(@(x)([FP x]),FN,'UniformOutput',false);
FNgp_full = cellfun(@(x)([FP,x(1:end-4),'.xlsx']),FN,'Uni',0);

% check and remove duplicated index files
set(handles.list_msg,'Value',1);
set(handles.list_msg,'string','Checking duplicates');

pause(1);
[dup_file,~, dup_ind] = intersect(handles.FileName_full,FN_full);
dup_no = length(dup_file);
if ~isempty(dup_ind)
    FN_full(dup_ind) = [];
    FNgp_full(dup_ind) = [];
    set(handles.list_msg,'string',[{[num2str(dup_no),' duplicates are removed:']}, dup_file]);
else
    set(handles.list_msg,'string','No duplicates found');
end

if ~isempty(FN)
    % add video to list
    handles.FileName = [handles.FileName, FN];
    handles.FileName_full = [handles.FileName_full, FN_full];
    handles.FileNameGP_full = [handles.FileNameGP_full, FNgp_full];

    file_no = length(handles.FileName);
    set(handles.list_DataAdded,'min',0,'max',2,'Value',[]);
    set(handles.list_DataAdded,'string',...
        [{[num2str(file_no) ' files loaded']},handles.FileName_full]);
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function list_DataAdded_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_DataAdded (see GCBO)
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
    set(handles.list_msg,'string','No data added');
    set(hObject,'BackgroundColor',[.941 .941 .941]);
    set(hObject,'Value',0);
    handles.idxplot = 0;
    guidata(hObject,handles);
    return
end
    
if isempty(handles.aFNmtx)
    set(handles.list_msg,'string','data not grouped');
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
     set(hObject,'string','Data Plot');
     handles.idxplot = 0;
     guidata(hObject,handles);
     return
 end
     
 gtype = get(handles.bg_pooling.SelectedObject,'string');
 saveDir = get(handles.ed_saveDir,'String');
   if ~exist(saveDir,'dir')
       mkdir(saveDir);
   end
 aFNmtx = handles.aFNmtx;
 data = handles.data;
 FileName = handles.FileName;
 FIleNameGP_full = handles.FileNameGP_full;
 
 posd = str2num(get(handles.ed_dpos,'string'));
 posp = str2num(get(handles.ed_ppos,'string'));
 posg = str2num(get(handles.ed_gpos,'string'));
 
 Ggeno = handles.aFNmtx(:,posg);
 [NamesG,~,idxG] = unique(Ggeno);
 Nog = size(NamesG,1);
 
 Gdate = handles.aFNmtx(:,posd);
  [NamesD,~,idxD] = unique(Gdate);
 Nod = size(NamesD,1);
 
 Gprot = handles.aFNmtx(:,posp);
 [NamesP,~,idxP] = unique(Gprot);
 Nop = size(NamesP,1);
 timestamp = datestr(now,30);
 switch(gtype)
     
     case('Date')
         
         for i=1:Nod
             if ~get(hObject,'value')
                 set(hObject,'BackgroundColor',[.941 .941 .941]);
                 set(hObject,'string','Data Plot');
                 set(handles.list_msg,'string','Aborted');
                 handles.idxplot = 0;
                 guidata(hObject,handles);
                 return
                 %                  error('Aborted');
             end
             % go by date
             
             curDate = NamesD{i};
             errors = cell(1,1);error_no = 0;
             for ii = 1:Nop % go by protocol
                 curProt = NamesP{ii};
                 curTitle = [curProt,'_',curDate];
                  hp = figure('position',[100,100,800,1000]);
                  h = figure('position',[100,100,1800,1000]);
                  for iii = 1:Nog % go by geno
                     curGeno = NamesG{iii};
                     curSSb = data.SSb(idxD==i&idxP==ii&idxG==iii,:);
                     curFNmtx = aFNmtx(idxD==i&idxP==ii&idxG==iii,:);
                     curData = strjoin(curFNmtx(1,:),'_');
                     Nof = size(curSSb,1);
                     
                     if Nof==0
                         continue
                     end
                     
                     aSSb{i,ii,iii} = curSSb;
                     Gmn{i,ii,iii} = [nanmean(curSSb(:,1:2),2),nanmean(curSSb(:,3:4),2)];
                     [p(i,ii,iii),q(i,ii,iii)]=ranksum(Gmn{i,ii,iii}(:,1),...
                                                       Gmn{i,ii,iii}(:,2));
                     
                     set(0, 'currentfigure', h);
                     subplot(2,ceil(Nog/2),iii),plot(curSSb','k');
                     hold on;errorbar(nanmean(curSSb),nansem(curSSb),'LineWidth',3);
                     xticks((1:4));
                     xlim([0.5 4.5]);
                     xticklabels((.5:.5:2));
                     xlabel('Time (hr)');
                     ylabel('Sleep');
%                      ylim([0 1]);
                     title({curData;...
                         ['p=',num2str(p(i,ii,iii))];...
                         ['n=',num2str(Nof)]},'interpreter','none');
                                         
                     set(0, 'currentfigure', hp);
                     hold on;
                     errorbar(nanmean(curSSb),nansem(curSSb),'LineWidth',3);
                     
                  end
                  
                  set(0, 'currentfigure', h);
                  if exist([saveDir,curTitle,'_genoSingles.png'],'file')
                      saveas (h, [saveDir,curTitle,'_genoSingles(1).png']);
                  else
                      saveas (h, [saveDir,curTitle,'_genoSingles.png']);
                  end
                  close(gcf);
                  
                  set(0, 'currentfigure', hp);
                     title(curTitle,'interpreter','none');
                     legend(NamesG,'interpreter','none');
                     xticks((1:4));
                     xlim([0.5 4.5]);
                     xticklabels((.5:.5:2));
                     xlabel('Time (hr)');
                     ylabel('Sleep');
                     if exist([saveDir,curData,'_genos.png'],'file')
                         saveas (hp, [saveDir,curTitle,'_genos(1).png']);
                     else
                         saveas (hp, [saveDir,curTitle,'_genos.png']);
                     end
                     close(gcf);
             end
         end
         
     case('AS_on/off')

         for ii = 1:Nop 
              drawnow;
              if ~get(hObject,'value')
                  set(hObject,'BackgroundColor',[.941 .941 .941]);
                  set(hObject,'string','Data Plot');
                  set(handles.list_msg,'string','Aborted');
                  handles.idxplot = 0;
                  guidata(hObject,handles);
                  return
                  
              end
              
              % go by protocol
              curProt = NamesP{ii};
              curTitle = curProt;
              hp = figure('position',[100,100,800,1000]);
              h = figure('position',[100,100,1800,1000]);
              for iii = 1:Nog % go by geno
                  curGeno = NamesG{iii};
                  curSSb = data.SSb(idxP==ii&idxG==iii,:);
%                   curSSb = curSSbor(:,10:14);
                  curFNmtx = aFNmtx(idxP==ii&idxG==iii,:);
                  curData = [curGeno,'_',curProt];
                  Nof = size(curSSb,1);
                  
                  if Nof==0
                      continue
                  end
                  
                  aSSb{ii,iii} = curSSb;
                  Gmn{ii,iii} = [nanmean(curSSb(:,1:2),2),nanmean(curSSb(:,3:4),2)];
                  [p(ii,iii),q(ii,iii)]=ranksum(Gmn{ii,iii}(:,1),...
                      Gmn{ii,iii}(:,2));
                  
                  set(0, 'currentfigure', h);
                  subplot(2,ceil(Nog/2),iii),plot(curSSb','k');
                  hold on;errorbar(nanmean(curSSb),nansem(curSSb),'LineWidth',3);
                  xticks((1:4));
                  xlim([0.5 4.5]);
                  xticklabels((.5:.5:2));
                  xlabel('Time (hr)');
                  ylabel('Sleep');
                  %                      ylim([0 1]);
                  title({curData;...
                      ['p=',num2str(p(ii,iii)),', n=',num2str(Nof)]},'interpreter','none');
                  
                  set(0, 'currentfigure', hp);
                  hold on;
                  errorbar(nanmean(curSSb),nansem(curSSb),'LineWidth',3);
                  
              end
              
              set(0, 'currentfigure', h);
%               if exist([saveDir,curTitle,'_genoSingles.png'],'file')
%                   saveas (h, [saveDir,curTitle,'_genoSingles(1).png']);
%               else
                  saveas (h, [saveDir,curTitle,'_',timestamp,'_genoSingles.png']);
%               end
              close(gcf);
              
              set(0, 'currentfigure', hp);
              title(curTitle,'interpreter','none');
              legend(NamesG,'interpreter','none');
              xticks((1:4));
              xlim([0.5 4.5]);
              xticklabels((.5:.5:2));
              xlabel('Time (hr)');
              ylabel('Sleep');
%               if exist([saveDir,curTitle,'_genos.png'],'file')
%                   saveas (hp, [saveDir,curTitle,'_genos(1).png']);
%               else
                  saveas (hp, [saveDir,curTitle,'_',timestamp,'_genos.png']);
%               end
              close(gcf);
          end
   
 end
 
set(hObject,'BackgroundColor',[.941 .941 .941]);
     set(hObject,'Value',0);
     set(hObject,'string','Data Plot');
     handles.idxplot = 0;
 
clear h hp;
save([saveDir,'Pooled_',timestamp,'.mat'], '-regexp',...
    '^(?!(hObject|handles|eventdata)$).');

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function VtrackerDataPooling_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VtrackerDataPooling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when VtrackerDataPooling is resized.
function VtrackerDataPooling_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to VtrackerDataPooling (see GCBO)
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



% --- Executes on button press in pb_clear.
function pb_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pb_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.FileName = [];
handles.FileName_full = [];
handles.FileNameGP_full = [];
set(handles.list_DataAdded,'Value',[]);
set(handles.list_DataAdded,'string',{'Sleep data list cleared'});

guidata(hObject, handles);

function list_DataAdded_Callback(hObject, eventdata, handles)
% hObject    handle to pop_arenaType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pb_pooling.
function pb_pooling_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pooling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gtype = get(handles.bg_pooling.SelectedObject,'string');
if handles.idxplot
     handles.msg = get(handles.list_msg,'String');
   handles.msg = [handles.msg;{'Data in plotting,Re-group later'}]; 
   set(handles.list_msg,'String',handles.msg);

    return
end

if isempty(handles.FileName)
    set(handles.list_msg,'string',{'No Data loaded'});
    return
end

[~,FN] = cellfun(@fileparts,handles.FileName,'Uni',0);
FNmtx_c = cellfun(@(x)strsplit(x,'_'),FN,'Uni',0);
fno = size(FN,2);
FNmtx = reshape([FNmtx_c{:}],[],fno);
FNmtx = FNmtx';
cno = size(FNmtx,2);
% if cno>4
%     FNmtx(:,2)= cellfun(@(x)[x{1},'_',x{2}],FNmtx_c,'Uni',0);
% end
posd = str2num(get(handles.ed_dpos,'string'));
posp = str2num(get(handles.ed_ppos,'string'));
posg = str2num(get(handles.ed_gpos,'string'));
%% Load data
handles.aFNmtx = [];
% handles.data.SS =[];
handles.data.SSb =[];
% load and pooling data
for i=1:fno
    load(handles.FileName_full{i},'SSb','Arenas');

    % get geno type for each arena
    ano = size(Arenas,1);
    aFNmtx = repmat(FNmtx(i,:),ano,1);
    aGeno = aFNmtx(:,posg);
    try
        if exist(handles.FileNameGP_full{i},'file') % loading genotype file if exist
            [pos,gtxt] = xlsread(handles.FileNameGP_full{i},1);
            pos(:,3) = pos(:,2)-pos(:,1)+1;
            for ii =2: size(gtxt,1)
                aGeno(pos(ii-1,1):pos(ii-1,2)) = repmat(gtxt(ii),pos(ii-1,3),1);
            end
        end
    catch ME
        aGeno = aFNmtx(:,posg);
        set(handles.list_msg,'string',{'errors in genoType loading:',ME.identifier});
    end
    aFNmtx(:,posg) = aGeno;
    handles.aFNmtx = [handles.aFNmtx;aFNmtx];
%     handles.data.SS = [handles.data.SS;SS];
    handles.data.SSb = [handles.data.SSb;SSb];
    
end
%%
% group # cal

Ggeno = handles.aFNmtx(:,posg);
Gdate = handles.aFNmtx(:,posd);
Gprot = handles.aFNmtx(:,posp);
% cellfun(@(x,y)([x,'_',y]),Ggeno,aFNmtx(:,dpos),'UniformOutput',false);

GroupGenos = unique(Ggeno);
GroupDates = unique(Gdate);
N_d = size(GroupDates,1);
N_g = size(GroupGenos,1);

handles.msg = get(handles.list_msg,'String');
set(handles.list_msg,'Value',1);
switch(gtype)
    case('Date')
        handles.msg = [handles.msg;...
            {[num2str(N_d) ' day(s) to plot']};GroupDates];
        set(handles.list_msg,'String',handles.msg);
    case('GenoType_TNT')
        handles.msg = [handles.msg;...
            {[num2str(N_g), ' genotype(s) for ',gtype]};GroupGenos];
        set(handles.list_msg,'String',handles.msg);
    case('AS_on/off')
        handles.msg = [handles.msg;...
            {[num2str(N_g) ' genotype(s) for ',gtype]};GroupGenos];
        set(handles.list_msg,'String',handles.msg);
    case('AS_TrpA1')
        handles.msg = [handles.msg;...
            {[num2str(N_g) ' genotype(s) for ',gtype]};GroupGenos];
        set(handles.list_msg,'String',handles.msg);
end
% set(handles.list_msg,'string',['Data grouped by ',gtype]); 
index = size(get(handles.list_msg,'string'), 1);
set(handles.list_msg,'Value',index);
guidata(hObject,handles);

% --- Executes on button press in pb_dataDelete.
function pb_dataDelete_Callback(hObject, eventdata, handles)
% hObject    handle to pb_dataDelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataSelected = get(handles.list_DataAdded,'Value')-1;
dataSelected (dataSelected ==0) = [];
if isempty(dataSelected)
    handles.msg = get(handles.list_msg,'String');
   handles.msg = [handles.msg;{'No sleep data selected'}]; 
   set(handles.list_msg,'String',handles.msg);
   return
end  
removed = handles.FileName_full(dataSelected);
handles.FileName(dataSelected) = [];
handles.FileName_full (dataSelected) = [];
handles.FileNameGP_full (dataSelected) = [];
file_no = size(handles.FileName,2);

dataSelected(dataSelected>file_no)=[];
% if isempty(dataSelected)
%     set(handles.list_DataAdded,'Value',file_no+1);
% else
    set(handles.list_DataAdded,'Value',dataSelected);
% end

list = [{[num2str(file_no) ' files added']},handles.FileName_full];
set(handles.list_DataAdded,'string',list);

handles.msg = get(handles.list_msg,'String');
handles.msg = [handles.msg;{'Sleep data removed:'};removed'];
set(handles.list_msg,'Value',[]);
set(handles.list_msg,'String',handles.msg);
   
guidata(hObject, handles);
    



function ed_gpos_Callback(hObject, eventdata, handles)
% hObject    handle to ed_gpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_gpos as text
%        str2double(get(hObject,'String')) returns contents of ed_gpos as a double


% --- Executes during object creation, after setting all properties.
function ed_gpos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_gpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_ppos_Callback(hObject, eventdata, handles)
% hObject    handle to ed_ppos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_ppos as text
%        str2double(get(hObject,'String')) returns contents of ed_ppos as a double


% --- Executes during object creation, after setting all properties.
function ed_ppos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_ppos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ed_dpos_Callback(hObject, eventdata, handles)
% hObject    handle to ed_dpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_dpos as text
%        str2double(get(hObject,'String')) returns contents of ed_dpos as a double


% --- Executes during object creation, after setting all properties.
function ed_dpos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_dpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in rb_saveData.
function rb_saveData_Callback(hObject, eventdata, handles)
% hObject    handle to rb_saveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_saveData


% --- Executes on button press in pb_saveDir.
function pb_saveDir_Callback(hObject, eventdata, handles)
% hObject    handle to pb_saveDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FP = uigetdir(handles.curDir,'select a folder to save data');
if FP
    set(handles.ed_saveDir,'String',[FP,'\']);
end

guidata(hObject, handles);


function ed_saveDir_Callback(hObject, eventdata, handles)
% hObject    handle to ed_saveDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_saveDir as text
%        str2double(get(hObject,'String')) returns contents of ed_saveDir as a double


% --- Executes during object creation, after setting all properties.
function ed_saveDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_saveDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% % --- Executes on button press in pb_addGN.
% function pb_addGN_Callback(hObject, eventdata, handles)
% % hObject    handle to pb_addGN (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% groupNames = get(handles.tb_groupNames,'data');
% gNo = size(groupNames,1);
% handles.groupNames = cell(gNo+1,3);
% handles.groupNames(1:gNo,:) = groupNames;
% set(handles.tb_groupNames,'data',handles.groupNames);
% handles.selectedRow=[];
% guidata(hObject, handles);
% 
% 
% 
% 
% % --- Executes on button press in pb_deleteGN.
% function pb_deleteGN_Callback(hObject, eventdata, handles)
% % hObject    handle to pb_deleteGN (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% groupNames = get(handles.tb_groupNames,'data');
% gNo = size(groupNames,1);
% if gNo<2
%     handles.msg = get(handles.list_msg,'String');
%    handles.msg = [handles.msg;{'Last group, deletion ignored'}]; 
%    set(handles.list_msg,'String',handles.msg);
%    return
% end
% 
% if isempty(handles.selectedRow)
%     handles.msg = get(handles.list_msg,'String');
%    handles.msg = [handles.msg;{'No group selected'}]; 
%    set(handles.list_msg,'String',handles.msg);
%    return
% end
% 
% groupNames(handles.selectedRow,:) = [];
% handles.groupNames = groupNames;
% set(handles.tb_groupNames,'data',handles.groupNames);
% handles.selectedRow=[];
% guidata(hObject, handles);
% 
% % --- Executes on button press in pb_resetGN.
% function pb_resetGN_Callback(hObject, eventdata, handles)
% % hObject    handle to pb_resetGN (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% GNreset = questdlg('Would you like to reset the GroupNames table?', ...
% 	'reset GroupNames', ...
% 	'Yes','No thanks','No thanks');
% % Handle response
% switch GNreset
%     case 'Yes'
%         handles.groupNames = {'Group1',1,100};
%         set(handles.tb_groupNames,'data',handles.groupNames);
%         handles.selectedRow = [];
%     case 'No thanks'
%         return
% end
% 
% % --- Executes during object creation, after setting all properties.
% function tb_groupNames_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to tb_groupNames (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% set(hObject, 'Data', {'Group1',1,100});
% handles.selectedRow = [];
% guidata(hObject, handles);
% 
% % --- Executes when selected cell(s) is changed in tb_groupNames.
% function tb_groupNames_CellSelectionCallback(hObject, eventdata, handles)
% % hObject    handle to tb_groupNames (see GCBO)
% % eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
% %	Indices: row and column indices of the cell(s) currently selecteds
% % handles    structure with handles and user data (see GUIDATA)
% % eventdata.Indices
% if size(eventdata.Indices,1)>0
%     handles.selectedRow = eventdata.Indices(1);
% end
% guidata(hObject, handles);
