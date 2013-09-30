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

% Last Modified by GUIDE v2.5 13-Sep-2013 09:01:44

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
fclose('all');
delete(handles.figure1)


function folderButton_Callback(hObject, eventdata, handles)
handles.dir = uigetdir('C:\Users\Anthony Azevedo\Raw_Data\','Choose cell folder');
if ~handles.dir
    handles.dir = pwd;
end
cd(handles.dir); 
loadCellFromDir(handles);

function loadCellFromDir(handles)
if ~isInCellDir(handles)
    set(handles.figure1,'name','quickShow - Choose a cell directory');
    set(handles.protocolMenu, 'String', {'Choose a cell directory'},'value',1);
    set(handles.protocolMenu,'Enable','off')
    set(handles.leftButton,'Enable','off')
    set(handles.rightButton,'Enable','off')
    set(handles.trialnum,'Enable','off')
    set(handles.showMenu, 'String', {'Choose a cell directory'});
    set(handles.showMenu,'Enable','off')
    delete(get(handles.quickShowPanel,'children'));
    guidata(handles.protocolMenu,handles)
else
    set(handles.figure1,'name',sprintf('quickShow - %s',handles.dir));
    set(handles.protocolMenu,'Enable','on')
    set(handles.leftButton,'Enable','on')
    set(handles.rightButton,'Enable','on')
    set(handles.trialnum,'Enable','on')
    set(handles.showMenu,'Enable','on')

    a = dir([handles.dir '\*_Raw*']);
    
    protocols = {};
    for i = 1:length(a)
        ind = regexpi(a(i).name,'_');
        if ~isempty(strfind(char(65:90),a(i).name(1))) && ...
            ~isempty(ind) && ...
            ~sum(strcmp(protocols,a(i).name(1:ind(1)-1)))
            protocols{end+1} = a(i).name(1:ind(1)-1);
        end
    end
    a = dir([handles.dir '\notes_*']);

    fclose('all');
    handles.notesfilename = fullfile(handles.dir,a.name);
    handles.notesfid = fopen(handles.notesfilename,'r');

    set(handles.infoPanel,'userdata',fileread(handles.notesfilename))
    set(handles.protocolMenu, 'String', protocols,'value',1);
    guidata(handles.protocolMenu,handles)
    protocolMenu_Callback(handles.protocolMenu, [], handles);
end


function protocolMenu_Callback(hObject, eventdata, handles)
protocols = get(hObject,'String');
handles.currentPrtcl = protocols{get(hObject,'value')};

% give handles the information on the Trials involved
rawfiles = dir(fullfile(handles.dir,[handles.currentPrtcl '_Raw*']));
ind_ = regexp(rawfiles(1).name,'_');
indDot = regexp(rawfiles(1).name,'\.');
handles.trialStem = [rawfiles(1).name((1:length(rawfiles(1).name)) <= ind_(end)) '%d' rawfiles(1).name(1:length(rawfiles(1).name) >= indDot(1))];
dfile = rawfiles(1).name(~(1:length(rawfiles(1).name) >= ind_(end) & 1:length(rawfiles(1).name) < indDot(1)));
dfile = regexprep(dfile,'_Raw','');
handles.prtclDataFileName = fullfile(handles.dir,dfile);

dataFileExist = dir(handles.prtclDataFileName);
if length(dataFileExist)
    d = load(handles.prtclDataFileName);
end
if ~length(dataFileExist) || length(d.data) ~= length(rawfiles)
    createDataFileFromRaw(handles.prtclDataFileName);
    d = load(handles.prtclDataFileName);
end

handles.prtclData = d.data;
prtclTrialNums = nan(size(rawfiles));
for i = 1:length(handles.prtclData)
    prtclTrialNums(i) = handles.prtclData(i).trial;
end
handles.prtclTrialNums = prtclTrialNums;
handles.currentTrialNum = prtclTrialNums(1);

set(handles.trialnum,'string',num2str(handles.currentTrialNum));
guidata(hObject,handles)
showMenu_CreateFcn(handles.showMenu, eventdata, handles);
handles = guidata(hObject);
trialnum_Callback(handles.trialnum,[],handles)


function protocolMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Choose a cell folder'});


function leftButton_Callback(hObject, eventdata, handles)
trialnum = str2double(get(handles.trialnum,'string'));
trialnum = trialnum-1;
if trialnum < min(handles.prtclTrialNums)
    trialnum = trialnum+1;
elseif ~sum(handles.prtclTrialNums==trialnum)
    trialnum = trialnum-1;
end
set(handles.trialnum,'string',num2str(trialnum));
handles = guidata(hObject);
trialnum_Callback(handles.trialnum,[],handles)

    
function rightButton_Callback(hObject, eventdata, handles)
trialnum = str2double(get(handles.trialnum,'string'));
trialnum = trialnum+1;
if trialnum > max(handles.prtclTrialNums)
    trialnum = trialnum-1;
elseif ~sum(handles.prtclTrialNums==trialnum)
    trialnum = trialnum+1;
end
set(handles.trialnum,'string',num2str(trialnum));
handles = guidata(hObject);
trialnum_Callback(handles.trialnum,[],handles)



function trialnum_Callback(hObject, eventdata, handles)
trialnum = str2double(get(hObject,'string'));
if isnan(trialnum)
    error('Bad trial number, enter integer');
end
if ~sum(handles.prtclTrialNums==trialnum)
    if trialnum > max(handles.prtclTrialNums)
        error('Trial number too large (>%d)',max(handles.prtclTrialNums));
    elseif trialnum < min(handles.prtclTrialNums)
        error('Trial number too small (<%d)',min(handles.prtclTrialNums));
    else
        error('Trial number within range but does not exist');
    end
end
handles.currentTrialNum = trialnum;
handles.trial = load(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum)));
handles.params = handles.prtclData(handles.prtclTrialNums==handles.currentTrialNum);

guidata(hObject,handles)
quickShow_Protocol(hObject, eventdata, handles)


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

function quickShow_Protocol(hObject, eventdata, handles)
handles = guidata(hObject);
a = what('quickShow');
a = dir([a.path '\quickShow_' handles.currentPrtcl '.m']);
if isempty(a)
    error('No quickShow for %s\n',handles.currentPrtcl)
end
handles.quickShowFunction = regexprep(a.name,'\.m','');
if get(handles.savetraces_button,'value')
    savetag = 'save';
    delete(findobj(handles.quickShowPanel,'tag','delete'));
else
    savetag = 'delete';
    delete(findobj(handles.quickShowPanel,'tag','delete'));
end

guidata(hObject,handles)
updateInfoPanel(handles);
handles = guidata(hObject);
feval(str2func(handles.quickShowFunction),handles.quickShowPanel,handles,savetag);


function showMenu_Callback(hObject, eventdata, handles)
showfunctions = get(handles.showMenu,'string');
handles.quickShowFunction = showfunctions{get(handles.showMenu,'value')};
if isempty(which(handles.quickShowFunction))
    return
end
if get(handles.savetraces_button,'value')
    savetag = 'save';
    delete(findobj(handles.quickShowPanel,'tag','delete'));
else
    savetag = 'delete';
    delete(findobj(handles.quickShowPanel,'tag','delete'));
end
guidata(hObject,handles)
updateInfoPanel(handles);
handles = guidata(hObject);
feval(str2func(handles.quickShowFunction),handles.quickShowPanel,handles,savetag);
% quickShow_Protocol(hObject, eventdata, handles)



function showMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    % Hint: popupmenu controls usually have a white background on Windows. See ISPC and COMPUTER.
    set(hObject,'BackgroundColor','white');
end
if ~isfield(handles,'currentPrtcl');
    set(hObject, 'String', {'Choose a cell directory'});
    return
end
handles = guidata(hObject);
a = what(handles.currentPrtcl);
if isempty(a) || length(a.m)==0
    set(hObject, 'String', {'No Protocol Show Functions'});
else
    for i = 1:length(a.m)
        a.m{i} = regexprep(a.m{i},'\.m','');
    end
    set(hObject, 'String', a.m);
end
guidata(hObject,handles)


function clearcanvas_Callback(hObject, eventdata, handles)
delete(get(handles.quickShowPanel,'children'))


function figButton_Callback(hObject, eventdata, handles)
fig = figure('color',[1 1 1]);
childs = get(handles.quickShowPanel,'children');
copyobj(childs,repmat(fig,size(childs)));
% cp = uipanel('Title',handles.currentPrtcl,'FontSize',12,...
%                 'BackgroundColor',[1 1 1],...
%                 'Position',[0 0 .75 1],'parent',fig,'bordertype','none');
% copyobj(childs,repmat(cp,size(childs)));

infoStr = get(handles.infoPanel,'string');
fprintf('%s\n',infoStr{:});
 %celldisp(infoStr)
% ip = uicontrol('BackgroundColor',[1 1 1],'style','text',...
%                 'units','normalized',...
%                 'Position',[.75 0 .25 .9],'parent',fig,...
%                 'horizontalAlignment','left');
% set(ip,'units','pixels');            
% infoStr = textwrap(ip,infoStr);
% 
% set(ip,'string',infoStr)%,'position',position);

%orient(fig,'landscape');
trialnum_Callback(handles.trialnum,[],handles)


% --- Executes on button press in epsButton.
function epsButton_Callback(hObject, eventdata, handles)
% hObject    handle to epsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in savetraces_button.
function savetraces_button_Callback(hObject, eventdata, handles)
% hObject    handle to savetraces_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of savetraces_button
if get(handles.savetraces_button,'value')
    lines = findobj(handles.quickShowPanel,'type','line');
    set(lines,'tag','save');
    redlines = findobj(handles.quickShowPanel,'Color',[1, 0, 0]);
    set(redlines,'color',[1 .75 .75]);
    bluelines = findobj(handles.quickShowPanel,'Color',[0, 0, 1]);
    set(bluelines,'color',[.75 .75 1]);
else
    redlines = findobj(handles.quickShowPanel,'Color',[1, 0, 0]);
    set(redlines,'color',[1 .75 .75]);
    bluelines = findobj(handles.quickShowPanel,'Color',[0, 0, 1]);
    set(bluelines,'color',[.75 .75 1]);
end
guidata(hObject,handles);


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


function updateInfoPanel(handles)

notes = get(handles.infoPanel,'userdata');

trln = regexp(notes,[handles.currentPrtcl ' trial ' num2str(handles.params.trial)]);
trialinfo = notes(trln:trln+regexp(notes(trln:end),'\n','once')-1);
trialinfo = regexprep(trialinfo,'(?=\d)\s',',');

prtclln = regexp(notes(1:trln),[handles.currentPrtcl ' - ']);
prtclln = prtclln(end);
prtclinfo = notes(prtclln:prtclln+regexp(notes(prtclln(end):trln),'\n\t\t','once'));
prtclinfo = regexprep(prtclinfo,'(?=\d)\s',',');

expression = '\n\t';
[~,lines1] = regexp(prtclinfo,expression,'tokens','split');
if isempty(lines1{end})
    lines1 = lines1(1:end-1);
end
lines1 = [lines1,{trialinfo}];

infoStr = {lines1{:};lines1{:}};
infoStr(2,:) = {'  '};
infoStr = infoStr(:);

% comments = regexp(notes(1:trln),'\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\n','end');
% if ~isempty(comments)
%     cmln = regexp(notes(comments(end-1)+1:trln),'\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\n','start');
%     comment = notes(comments(end-1)+1:comments(end-1)+cmln-1);
%     expression = '\n\t';
%     [~,lines2] = regexp(comment,expression,'tokens','split');
%     if isempty(lines2{end})
%         lines2 = lines2(1:end-1);
%     end
%     lines1 = [lines1,lines2];
% end
% infoStr = {lines1{:};lines1{:}};
% infoStr(2,:) = {'  '};
% infoStr = infoStr(:);

[out, position] = textwrap(handles.infoPanel,infoStr);
%set(handles.infoPanel,'horizontalAlignment','left','string',out,'position',position);

set(handles.infoPanel,'string',out)%,'position',position);


function loadstr_button_Callback(hObject, eventdata, handles)
fprintf('%%*********************\n');
fprintf('obj.trial = load(''%s'');\n',(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum))))
fprintf('load(''%s'')\n',handles.prtclDataFileName)
fprintf('plotcanvas = fig;\n');
fprintf('obj.params = data(%d);\n',handles.currentTrialNum);
fprintf('savetag = ''delete'';\n');
s = fileread([handles.quickShowFunction '.m']);
s = regexprep(s,'%','%%');
s = regexprep(s,'ax[\d]+','ax');
newlines = regexp(s,'\n');
s(newlines) = '';
fprintf(s(newlines(1):end));

notes = get(handles.infoPanel,'userdata');

trln = regexp(notes,[handles.currentPrtcl ' trial ' num2str(handles.params.trial)]);
trialinfo = notes(trln:trln+regexp(notes(trln:end),'\n','once'));
trialinfo = regexprep(trialinfo,'(?=\d)\s',',');

fprintf('title(ax,''%s'')\n',trialinfo(1:end-3));


% --- Executes on selection change in analysis_popup.
function analysis_popup_Callback(hObject, eventdata, handles)
funcs = get(hObject,'string');
func = str2func(funcs{get(hObject,'value')});
feval(func,handles.trial,handles.trial.params);

% --- Executes during object creation, after setting all properties.
function analysis_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to analysis_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
analyses = what('Analysis');
for i = 1:length(analyses.m)
    analyses.m{i} = regexprep(analyses.m{i},'\.m','');
end

funcs = analyses.m;
set(hObject,'String',funcs);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
