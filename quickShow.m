function varargout = quickShow(varargin)
% QUICKSHOW MATLAB code for quickShow.fig
%      QUICKSHOW, by itself, creates a new QUICKSHOW or raises the existing
%      singleton*.
%
%      H = QUICKSHOW returns the handle to a new QUICKSHOW or the handle to
%      the existing singleton*.
%
%      QUICKSHOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUICKSHOW.M with the given input arguments.
%
%      QUICKSHOW('Property','Value',...) creates a new QUICKSHOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before quickShow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to quickShow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 28-Jun-2013 17:53:05

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @quickShow_OpeningFcn, ...
                   'gui_OutputFcn',  @quickShow_OutputFcn, ...
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

% --- Executes just before quickShow is made visible.
function quickShow_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

guidata(hObject, handles);
if strcmp(get(hObject,'Visible'),'off')

end
% uiwait(handles.figure1);

% current folder is the folder of interest
handles.dir = pwd;

% use a linking variable, like a trial or a data struct
if nargin>3
    linkvariable = varargin{1};
    if ischar(linkvariable)
        if ~isempty(strfind(linkvariable,'C:\Users\Anthony Azevedo\Acquisition'))
            dir = linkvariable;
        end
    elseif isstruct(linkvariable) && ...
            isfield(linkvariable,'flygenotype') && ...
            isfield(linkvariable,'flynumber') && ...
            isfield(linkvariable,'cellnumber') && ...
            isfield(linkvariable,'date')
        dir = ['C:\Users\Anthony Azevedo\Acquisition\',linkvariable(1).date,'\',...
            linkvariable(1).date,...
            '_F',linkvariable(1).flynumber,...
            '_C',linkvariable(1).cellnumber];

    end
    handles.dir = regexprep(dir,'Acquisition','Raw_Data');
end
guidata(hObject,handles);
handles.dir;
[~, handles] = isInCellDir;
if ~isInCellDir;
    folderButton_Callback(handles.folderButton, eventdata, handles)
else
    loadCellFromDir(handles);
end
% Is this an appropriate folder? 
    % set handles.cellfolderLogical
    % call the protocol chooser function
    % no: make that visible in the protocol menu, and move on 
    
    % yes: make it the current folder and run the rest of the setup
    % routine


function varargout = quickShow_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function OpenMenuItem_Callback(hObject, eventdata, handles)
% call the open folder button menu

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% call the print fig button

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


function folderButton_Callback(hObject, eventdata, handles)
handles.dir = uigetdir('C:\Users\Anthony Azevedo\Raw_Data\','Choose cell folder');
if ~handles.dir
    handles.dir = pwd;
end
loadCellFromDir(handles);

function loadCellFromDir(handles)
if ~isInCellDir(handles)
    set(handles.figure1,'name','quickShow - Choose a cell directory');
    set(handles.protocolMenu, 'String', {'Choose a cell directory'});
    set(handles.protocolMenu,'Enable','off')
    set(handles.leftButton,'Enable','off')
    set(handles.rightButton,'Enable','off')
    set(handles.trialnum,'Enable','off')
    set(handles.showMenu, 'String', {'Choose a cell directory'});
    set(handles.showMenu,'Enable','off')
    delete(get(handles.quickShow_Panel,'children'));
else
    set(handles.figure1,'name',sprintf('quickShow - %s',handles.dir));
    disp('NOW BEGIN TO LOAD STUFF');
    set(handles.protocolMenu,'Enable','on')
    set(handles.leftButton,'Enable','on')
    set(handles.rightButton,'Enable','on')
    set(handles.trialnum,'Enable','on')
    set(handles.showMenu,'Enable','on')

    a = dir(handles.dir);
    protocols = {};
    for i = 1:length(a)
        ind = regexpi(a(i).name,'_');
        if ~isempty(strfind(char(65:90),a(i).name(1))) && ...
            ~isempty(ind) && ...
            ~sum(strcmp(protocols,a(i).name(1:ind(1)-1)))
            protocols{end+1} = a(i).name(1:ind(1)-1);
        end
    end
    set(handles.protocolMenu, 'String', protocols);
    guidata(hObject,handles)
    protocolMenu_Callback(handles.protocolMenu, [], handles);
end


function protocolMenu_Callback(hObject, eventdata, handles)
% Hints: contents = get(hObject,'String') returns protocolMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from protocolMenu
% TODO: populate this with the quickShow routines

protocols = get(hObject,'String');
protocol = protocols{get(hObject,'value')};
set(handles.showMenu, 'String', {sprintf('quickShow_%s',protocols{get(hObject,'value')})});

% give handles the information on the Trials involved
rawfiles = dir([handles.dir '\' protocol '_Raw*']);
prtclTrialNums = nan(size(rawfiles));
for i = 1:length(rawfiles)
    ind_ = regexp(rawfiles(i).name,'_');
    indDot = regexp(rawfiles(i).name,'\.');
    prtclTrialNums(i) = str2double(rawfiles(i).name(ind_(end)+1:indDot(1)-1));
end
dfile = rawfiles(i).name(~(1:length(rawfiles(i).name) >= ind_(end) & 1:length(rawfiles(i).name) < indDot(1)));
dfile = regexprep(dfile,'_Raw','');
d = load([handles.dir '\' dfile]);

handles.prtclTrialNums = prtclTrialNums;
handles.currentTrialNum = prtclTrialNums(1);
handles.prtclData = d.data;

set(handles.trialnum,'string',num2str(handles.currentTrialNum));
guidata(hObject,handles)
trialnum_Callback(handles.trialnum,[],handles)
% Call the function labelled in the showMenu

% right button increases the current Trial number
%


% --- Executes during object creation, after setting all properties.
function protocolMenu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

% function gets run before the main creation function?
set(hObject, 'String', {'Choose a cell folder'});
%set(hObject, 'String', {'Choose a cell folder'});

function leftButton_Callback(hObject, eventdata, handles)

function rightButton_Callback(hObject, eventdata, handles)


% --- Executes on selection change in showMenu.
function showMenu_Callback(hObject, eventdata, handles)
% hObject    handle to showMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns showMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from showMenu


% --- Executes during object creation, after setting all properties.
function showMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function trialnum_Callback(hObject, eventdata, handles)
trialnum = str2double(get(hObject,'string'));
if isnan(trialnum)
    error('bad trial number');
end
if ~sum(handles.trialnums==trialnum)
    error('bad trial number');
end
handles.currentTrialNum = trialnum;



% --- Executes during object creation, after setting all properties.
function trialnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in figButton.
function figButton_Callback(hObject, eventdata, handles)
% hObject    handle to figButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in epsButton.
function epsButton_Callback(hObject, eventdata, handles)
% hObject    handle to epsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% --- Sub functions
function varargout = isInCellDir(varargin)
if nargin<1
    handles = guidata(gcf);
else
    handles = varargin{1};
end

hasnotes = false;
hasmats = false;
files = dir(handles.dir);
for f = 1:length(files)
    if ~isempty(strfind(files(f).name,'notes')) && ~isempty(strfind(files(f).name,'.txt'))
        hasnotes = true;
    end
    if ~isempty(strfind(files(f).name,'.mat'))
        hasmats = true;
    end
end
if ~isempty(strfind(handles.dir,'Raw_Data')) && hasnotes && hasmats
% test if folder is in Acquisition, has a data, contains mat files and
    % a notes file
    handles.isInCellDirLogical = true;
else
    handles.isInCellDirLogical = false;
end
l = handles.isInCellDirLogical;

guidata(gcf,handles);
varargout = {l,handles};
