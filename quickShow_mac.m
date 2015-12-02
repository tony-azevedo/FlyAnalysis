function varargout = quickShow_mac(varargin)
% QUICKSHOW_MAC MATLAB code for quickShow_mac.fig
%      QUICKSHOW_MAC, by itself, creates a new QUICKSHOW_MAC or raises the existing
%      singleton*.
%
%      H = QUICKSHOW_MAC returns the handle to a new QUICKSHOW_MAC or the handle to
%      the existing singleton*.
%
%      QUICKSHOW_MAC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUICKSHOW_MAC.M with the given input arguments.
%
%      QUICKSHOW_MAC('Property','Value',...) creates a new QUICKSHOW_MAC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before quickShow_mac_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to quickShow_mac_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 02-Jul-2014 15:30:15

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @quickShow_mac_OpeningFcn, ...
                   'gui_OutputFcn',  @quickShow_mac_OutputFcn, ...
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

% --- Executes just before quickShow_mac is made visible.
function quickShow_mac_OpeningFcn(hObject, eventdata, handles, varargin)
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


function varargout = quickShow_mac_OutputFcn(hObject, eventdata, handles)

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
if ~isempty(strfind(pwd,'C:\Users\Anthony Azevedo\Raw_Data\'))
    [~, remain] = strtok(fliplr(pwd),'\');
    curdir = fliplr(remain);
else
    if ispc
    curdir = 'C:\Users\Anthony Azevedo\Raw_Data\';
    elseif ismac
    curdir = '/Users/tony/HMS/Raw_Data/';
    end        
end
handles.dir = uigetdir(curdir,'Choose cell folder');
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
    a = dir([handles.dir filesep '*_Raw*']); 
    if length(a)==0
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
        error('No raw data here')
    end
    set(handles.figure1,'name',sprintf('quickShow - %s',handles.dir));
    set(handles.protocolMenu,'Enable','on')
    set(handles.leftButton,'Enable','on')
    set(handles.rightButton,'Enable','on')
    set(handles.trialnum,'Enable','on')
    set(handles.showMenu,'Enable','on')

    protocols = {};
    for i = 1:length(a)
        ind = regexpi(a(i).name,'_');
        if ~isempty(strfind(char(65:90),a(i).name(1))) && ...
            ~isempty(ind) && ...
            ~sum(strcmp(protocols,a(i).name(1:ind(1)-1)))
            protocols{end+1} = a(i).name(1:ind(1)-1);
        end
    end
    a = dir([handles.dir filesep 'notes_*']);

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
    FlySoundDataStruct2csv(handles.prtclDataFileName);
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
if ~isfield(handles.trial,'excluded')
    handles.trial.excluded = 0;
    trial = handles.trial;
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
end
set(handles.exclude,'value',handles.trial.excluded);
set(handles.allow_excluding,'value',0);
set(handles.exclude,'enable','off');

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
a = dir([a.path filesep 'quickShow_' handles.currentPrtcl '.m']);
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
set(get(handles.quickShowPanel,'children'),'xscale','linear');

guidata(hObject,handles)
updateInfoPanel(handles);
handles = guidata(hObject);
if get(handles.showmenu_chkbx,'value')
    showMenu_Callback(hObject, eventdata, handles)
else
    feval(str2func(handles.quickShowFunction),handles.quickShowPanel,handles,savetag);
    if isfield(handles.trial,'exposure') && (isfield(handles.trial,'imageNum') || 7 == exist(regexprep(regexprep(handles.trial.name(1:end-4),'Raw','Images'),'Acquisition','Raw_Data')))
        obj = copyobj(handles.clearcanvas,get(handles.clearcanvas,'parent'));
        pos = get(obj,'position');
        set(obj,'position',get(obj,'position')+([0 pos(4) 0 0]))
        set(obj,'callback',@(hObject,eventdata)quickShow('trialImages_Callback',hObject,eventdata,handles))
        set(obj,'tag','image','String','Image');
        
        drawnow
        addClickableExposureTimeline(handles,savetag);
    else
        obj2 = findobj(get(handles.clearcanvas,'parent'),'tag','image');
        delete(obj2);
    end
    ax = titlesubplot(handles.quickShowPanel);
    [prot,d,fly,cell,trial] = extractRawIdentifiers(handles.trial.name);
    title(ax,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));
    
end
    
    


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
set(get(handles.quickShowPanel,'children'),'xscale','linear');

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
    set(hObject,'Value',1);
    set(hObject, 'String', a.m);
end
guidata(hObject,handles)


function clearcanvas_Callback(hObject, eventdata, handles)
delete(get(handles.quickShowPanel,'children'))


function figButton_Callback(hObject, eventdata, handles)
fig = figure('color',[1 1 1]);
childs = get(handles.quickShowPanel,'children');
copyobj(childs,repmat(fig,size(childs)));
findobj(fig,'ButtonDownFcn',@showClickedImage);

% cp = uipanel('Title',handles.currentPrtcl,'FontSize',12,...
%                 'BackgroundColor',[1 1 1],...
%                 'Position',[0 0 .75 1],'parent',fig,'bordertype','none');
% copyobj(childs,repmat(cp,size(childs)));
linax = findobj(fig,'xscale','linear');
if length(linax)>1
    linkaxes(linax,'x');
end

for chi = length(childs):-1:1
    if ~isempty(get(get(childs(1),'title'),'string'))
        set(fig,'fileName',regexprep(get(get(childs(1),'title'),'string'),'\.','_'))
    end
end

infoStr = get(handles.infoPanel,'string');
fprintf('%s\n',infoStr{:});

orient(fig,'tall');
trialnum_Callback(handles.trialnum,[],handles)


function epsButton_Callback(hObject, eventdata, handles)


function savetraces_button_Callback(hObject, eventdata, handles)
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
handles.trial = load(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum)));
guidata(hObject,handles);


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

function trialImages_Callback(hObject, eventdata, handles,varargin)
handles = guidata(hObject);
if strcmp(get(hObject,'type'),'line')
    exposureNum = get(hObject,'userData');
else
    exposureNum = 1;
end
feval(@playImages,handles.trial,handles.trial.params,exposureNum);

    
function addClickableExposureTimeline(handles,savetag)
x = (1:handles.trial.params.sampratein*handles.params.durSweep)/handles.trial.params.sampratein;
if isfield(handles.trial.params,'preDurInSec')
    x = ((1:handles.trial.params.sampratein*handles.params.durSweep) - handles.trial.params.preDurInSec*handles.trial.params.sampratein)/handles.trial.params.sampratein;
end
ax = findobj('tag','quickshow_outax','parent',handles.quickShowPanel);
exposure = handles.trial.exposure(1:length(x));
expostimes = x(logical(exposure));
lims = get(ax,'ylim');
for t= 1:length(expostimes)
    l = line([expostimes(t) expostimes(t)],lims,'parent',ax,'color',[1 1 1] *.8,'tag',savetag,'userdata',t);
    set(l,'ButtonDownFcn',@showClickedImage);
end
set(ax,'children',flipud(get(ax,'Children')));


function showClickedImage(l,eventdata,handles)
handles = guidata(l);
trialImages_Callback(l, eventdata, handles)


% --- Executes on button press in showmenu_chkbx.
function showmenu_chkbx_Callback(hObject, eventdata, handles) %#ok<*INUSD>


% --- Executes on button press in trialpath.
function trialpath_Callback(hObject, eventdata, handles) %#ok<*INUSL>
fprintf('%%*********************\n');
fprintf('''%s'';\n',(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum))))
clipboard('copy',sprintf('''%s'';\n',(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum)))));


% --- Executes button press in Combine Blocks.
function combineblocks_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'trialBlock','combinedTrialBlock','gain','secondary_gain','randomize'});

blocks = zeros(1,length(blocktrials));
combinedblocks = [];
combinedblocksnums = [];
if isfield(handles.prtclData(blocktrials(1)),'combinedTrialBlock')
    combinedblocks = zeros(1,length(blocktrials));
    combinedblocksnums = zeros(1,length(blocktrials));
end
tags = cell(size(blocks));
for bt_ind = 1:length(blocktrials)
    tags{bt_ind} = handles.prtclData(bt_ind).tags;
    blocks(bt_ind) = handles.prtclData(blocktrials(bt_ind)).trialBlock;
    if isfield(handles.prtclData(blocktrials(bt_ind)),'combinedTrialBlock') && handles.prtclData(blocktrials(bt_ind)).combinedTrialBlock>0
        combinedblocks(bt_ind) = handles.prtclData(blocktrials(bt_ind)).trialBlock;
        combinedblocksnums(bt_ind) = handles.prtclData(blocktrials(bt_ind)).combinedTrialBlock;
    end
end

[blocks,ind] = unique(blocks);
if ~isempty(combinedblocks)
    combinedblocks = combinedblocks(ind);
    combinedblocks = combinedblocks(combinedblocks>0);
    combinedblocksnums = combinedblocksnums(ind);
    combinedblocksnums = combinedblocksnums(combinedblocksnums>0);
    disp(['Blocks ' sprintf('%d ', blocks) 'constitute combined blocks ' sprintf('%d ',combinedblocksnums)])
end
tags = tags(ind);

% make a little dialog that creates checkboxes and populates the window
% with choices

blocks2combine = selectFromCheckBoxes(blocks,tags,'title','select blocks, dbl click to continue','prechecked',ismember(blocks,combinedblocks));
if isempty(blocks2combine)
    error('No block pairs selected for combination');
end

blocks2combine = blocks(logical(blocks2combine));
fprintf('(Un)Combining Blocks: ')
fprintf('%d, ', blocks2combine);
fprintf('\n');

for prt_ind = 1:length(handles.prtclData)
    if sum(blocks2combine==handles.prtclData(prt_ind).trialBlock)
        handles.prtclData(prt_ind).combinedTrialBlock = handles.trial.params.trialBlock;
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,handles.prtclData(prt_ind).trial)));
        trial.params.combinedTrialBlock = handles.trial.params.trialBlock;
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    else 
        handles.prtclData(prt_ind).combinedTrialBlock = 0;
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,handles.prtclData(prt_ind).trial)));
        if isfield('trial.params','combinedTrialBlock')
            trial.params = rmfield(trial.params,'combinedTrialBlock');
        end
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    end

end
data = handles.prtclData; %#ok<NASGU>
save(handles.prtclDataFileName,'data');
guidata(hObject,handles)


% --- Executes on button press in exclude.
function exclude_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
val = get(handles.exclude,'value');
if val==1
    handles.trial.excluded = 1;
    fprintf('Trial %g excluded\n',handles.trial.params.trial);
else
    handles.trial.excluded = 0;
    fprintf('Trial %g included\n',handles.trial.params.trial);
end
trial = handles.trial;
save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
guidata(hObject,handles)

% --- Executes on button press in allow_excluding.
function allow_excluding_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
val = get(handles.allow_excluding,'value');
if val==1
    set(handles.exclude,'Enable','on')
else
    set(handles.exclude,'enable','off')
end
guidata(hObject,handles)
