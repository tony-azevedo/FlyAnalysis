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

% Last Modified by GUIDE v2.5 05-Dec-2017 16:42:25

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @quickShow_OpeningFcn, ...
                   'gui_OutputFcn',  @quickShow_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);

% setpref('USERDIRECTORY','MAC','/Users/tony')
% setpref('USERDIRECTORY','PC','C:\Users\tony')

if nargin
    str2test = varargin{1};
end
               
if nargin && ischar(varargin{1}) &&...
        isempty(strfind(str2test,getpref('USERDIRECTORY','MAC'))) &&...
        isempty(strfind(str2test,getpref('USERDIRECTORY','PC')))
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
        if ~isempty(strfind(linkvariable,'C:\Users\Anthony Azevedo\')) || ~isempty(strfind(linkvariable,'/Users/tony/'))
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
if ~isempty(strfind(pwd,'B:\Raw_Data\'))
    [~, remain] = strtok(fliplr(pwd),'\');
    curdir = fliplr(remain);
else
    curdir = 'B:\Raw_Data\';
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
    handles = reload_notes([],'loadCellFromDir',handles);

    a = dir([handles.dir filesep '*_ContRaw*']);
    for i = 1:length(a)
        ind = regexpi(a(i).name,'_');
        if ~isempty(strfind(char(65:90),a(i).name(1))) && ...
                ~isempty(ind) && ...
                ~sum(strcmp(protocols,a(i).name(1:ind(1)-1)))
            protocols{end+1} = a(i).name(1:ind(1)-1);
        end
    end
    set(handles.protocolMenu, 'String', protocols,'value',1);
    guidata(handles.protocolMenu,handles)
    protocolMenu_Callback(handles.protocolMenu, [], handles);
end


function protocolMenu_Callback(hObject, eventdata, handles)
protocols = get(hObject,'String');
handles.currentPrtcl = protocols{get(hObject,'value')};

% give handles the information on the Trials involved
rawfiles = dir(fullfile(handles.dir,[handles.currentPrtcl '_Raw*']));
if length(rawfiles)==0
    
    contProtocolMenu_callback(hObject,eventdata,handles);
    return
end
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

trial = load(fullfile(handles.dir,rawfiles(1).name));
changeFileNames = isempty(strfind(trial.name,filesep)); %|| ~isfield(trial,'name_mac');
if changeFileNames
    error('On the wrong system');
end
% once all cells have been examined, next line can be commented out.
% changeFileNames = true;

% Creating the data file and testing what platform I'm on and what the name should be
if ~length(dataFileExist) || length(d.data) ~= length(rawfiles) || changeFileNames
    createDataFileFromRaw(handles.prtclDataFileName);
    %FlySoundDataStruct2csv(handles.prtclDataFileName);
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


function contProtocolMenu_callback(hObject,eventdata,handles)
rawfiles = dir(fullfile(handles.dir,[handles.currentPrtcl '_ContRaw*']));
if length(rawfiles)==0
    error('No continuous raw files either')
end
ind_ = regexp(rawfiles(1).name,'_');
indDot = regexp(rawfiles(1).name,'\.');
handles.trialStem = [rawfiles(1).name((1:length(rawfiles(1).name)) <= ind_(end)) '%d' rawfiles(1).name(1:length(rawfiles(1).name) >= indDot(1))];
dfile = rawfiles(1).name(~(1:length(rawfiles(1).name) >= ind_(end) & 1:length(rawfiles(1).name) < indDot(1)));
dfile = regexprep(dfile,'_ContRaw','');
handles.prtclDataFileName = fullfile(handles.dir,dfile);

dataFileExist = dir(handles.prtclDataFileName);
if length(dataFileExist)
    d = load(handles.prtclDataFileName);
end

% Creating the data file and testing what platform I'm on and what the name should be
if ~length(dataFileExist) || length(d.data) ~= length(rawfiles)
    createDataFileFromContRaw(handles.prtclDataFileName);
    %FlySoundDataStruct2csv(handles.prtclDataFileName);
    d = load(handles.prtclDataFileName);
end


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
tic
trialnum = str2double(get(hObject,'string'));
if isnan(trialnum)
    error('Bad trial number, enter integer');
end
if ~sum(handles.prtclTrialNums==trialnum)
    if trialnum > max(handles.prtclTrialNums)
        warning('Trial number too large (>%d)',max(handles.prtclTrialNums));
        set(hObject,'string',num2str(max(handles.prtclTrialNums)));
        trialnum = str2double(get(hObject,'string'));
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
if ismac
    if handles.trial.excluded
        set(handles.exclude,'FontWeight','bold');
    else
        set(handles.exclude,'FontWeight','normal');
    end
end
set(handles.allow_excluding,'value',0);
set(handles.exclude,'enable','off');

% imdir = regexprep(handles.trial.name,{'_Raw_','.mat'},{'_Images_',''});

if ~isfield(handles.trial,'imageFile') || isempty(handles.trial.imageFile)
    set(handles.image_button,'enable','off');
    set(handles.image_info,'String','');
elseif isfield(handles.trial,'imageFile') && ~isempty(handles.trial.imageFile) && exist(handles.trial.imageFile,'file')
    set(handles.image_button,'enable','on');
    exp = postHocExposure(handles.trial);
    a = dir(regexprep(handles.trial.imageFile,'Acquisition','Raw_Data'));
    samprate = handles.trial.params.sampratein;
    imstr = sprintf('Exp: %d - rate: %.2f - size: %dMB',...
        sum(exp.exposure),...
        samprate/mean(diff(find(exp.exposure))),...
        round(a.bytes/1E6));
    set(handles.image_info,'String',imstr,'fontsize',7);
end
if ~isfield(handles.trial,'ROI')
    set(handles.clear_ROI_button,'enable','off');
elseif isfield(handles.trial,'ROI')
    set(handles.clear_ROI_button,'enable','on');
end
guidata(hObject,handles)
quickShow_Protocol(hObject, eventdata, handles)


function trialnum_CreateFcn(hObject, eventdata, handles)
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
set(findobj(get(handles.quickShowPanel,'children'),'type','axes'),'xscale','linear');

guidata(hObject,handles)
updateInfoPanel(handles);
handles = guidata(hObject);
if get(handles.showmenu_chkbx,'value')
    showMenu_Callback(hObject, eventdata, handles)
else
    feval(str2func(handles.quickShowFunction),handles.quickShowPanel,handles,savetag);
    if isfield(handles.trial,'exposure') && (isfield(handles.trial,'imageNum') || 7 == exist(regexprep(regexprep(handles.trial.name(1:end-4),'Raw','Images'),'Acquisition','Raw_Data')))
        if isempty(findobj('String','Image','Style','pushbutton'))
            obj = copyobj(handles.loadstr_button,get(handles.loadstr_button,'parent'));
            pos = get(obj,'position');
            set(obj,'position',get(obj,'position')+([0 pos(4) 0 0]))
            set(obj,'callback',@(hObject,eventdata)quickShow('trialImages_Callback',hObject,eventdata,handles))
            set(obj,'tag','image','String','Image');
        end
        
        if isempty(findobj('String','avi+ephz','Style','pushbutton'))
            obj = copyobj(handles.Spikes,get(handles.Spikes,'parent'));
            pos = get(obj,'position');
            set(obj,'position',get(obj,'position')+([0 pos(4) 0 0]))
            set(obj,'callback',@(hObject,eventdata)quickShow('aviMoviesAndData_Callback',hObject,eventdata,handles))
            set(obj,'tag','aviAndEphys','String','avi+ephz');
        end

        drawnow
        addClickableExposureTimeline(handles,savetag);
    else
        obj2 = findobj(get(handles.clearcanvas,'parent'),'tag','image');
        delete(obj2);
        obj2 = findobj(get(handles.clearcanvas,'parent'),'tag','aviAndEphys');
        delete(obj2);
    end
    if get(handles.analyses_chckbox,'value')
        analysis_popup_Callback(hObject, eventdata, handles)
    end
    if isfield(handles.trial,'spikes') && isfield(handles.trial,'spikes')
        handles.Spikes.FontWeight = 'bold';
    else
        handles.Spikes.FontWeight = 'normal';
    end
    if get(handles.Spikes,'value')
        Spikes_Callback(handles.Spikes, [], handles)
    end
    
end
add_tags_to_subplots(hObject, eventdata, handles)  
showAnnotations(hObject)  
    
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
legends = findobj(handles.quickShowPanel,'type','legend');
if ~isempty(legends)
    delete(legends)
end
set(get(handles.quickShowPanel,'children'),'xscale','linear');

guidata(hObject,handles)
updateInfoPanel(handles);
handles = guidata(hObject);
feval(str2func(handles.quickShowFunction),handles.quickShowPanel,handles,savetag);
add_tags_to_subplots(hObject, eventdata, handles)  

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


% --- Executes on selection change in analysis_popup.
function analysis_popup_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
funcs = get(handles.analysis_popup,'string');
func = str2func(funcs{get(handles.analysis_popup,'value')});
feval(func,handles.trial,handles.trial.params);
handles.trial = load(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum)));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function analysis_popup_CreateFcn(hObject, eventdata, handles)
analyses = what('postHocAnalysis');
for i = 1:length(analyses.m)
    analyses.m{i} = regexprep(analyses.m{i},'\.m','');
end

funcs = analyses.m;
set(hObject,'String',funcs);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cellDiagnosticsMenu.
function cellDiagnosticsMenu_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
funcs = get(handles.cellDiagnosticsMenu,'string');
func = str2func(funcs{get(handles.cellDiagnosticsMenu,'value')});
feval(func,handles.trial);
handles.trial = load(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum)));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function cellDiagnosticsMenu_CreateFcn(hObject, eventdata, handles)
analyses = what('CellDiagnostics');
for i = 1:length(analyses.m)
    analyses.m{i} = regexprep(analyses.m{i},'\.m','');
end

funcs = analyses.m;
set(hObject,'String',funcs);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function clearcanvas_Callback(hObject, eventdata, handles)
delete(get(handles.quickShowPanel,'children'))


%% helper button callbacks
function figButton_Callback(hObject, eventdata, handles)
fig = figure('color',[1 1 1]);
set(fig,'Units',get(handles.quickShowPanel,'Units'));
set(fig,'Position',get(handles.quickShowPanel,'position'));

childs = get(handles.quickShowPanel,'children');
copyobj(childs,fig);
findobj(fig,'ButtonDownFcn',@showClickedImage);

% cp = uipanel('Title',handles.currentPrtcl,'FontSize',12,...
%                 'BackgroundColor',[1 1 1],...
%                 'Position',[0 0 .75 1],'parent',fig,'bordertype','none');
% copyobj(childs,repmat(cp,size(childs)));
linax = findobj(fig,'xscale','linear','-not','tag','unlink');
if length(linax)>1
    linkaxes(linax,'x');
end

for chi = length(childs):-1:1
    if ~isempty(get(get(childs(1),'title'),'string'))
        set(fig,'fileName',regexprep(get(get(childs(1),'title'),'string'),'\.','_'))
        set(fig,'name',regexprep(get(get(childs(1),'title'),'string'),'\.','_'))
    end
end

infoStr = get(handles.infoPanel,'string');
fprintf('%s\n',infoStr{:});

orient(fig,'tall');
trialnum_Callback(handles.trialnum,[],handles)


function Spikes_Callback(spikebutt, eventdata, h)

if ~spikebutt.Value
    s = findobj(h.quickShowPanel,'type','line','tag','Spikes');
    if ~isempty(s)
        delete(s);
    end
    return
end
s = findobj(h.quickShowPanel,'type','line','tag','Spikes');
if ~isempty(s)
    delete(s);
end

% Check if this trial has spikes
if isfield(h.trial,'spikes') && isfield(h.trial,'spikeDetectionParams')
    ax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_inax');
    if isempty(ax)
        error('Clear panel, go to quickShow visualization\n')
    end
    if isempty(h.trial.spikes)
        text(ax,ax.XLim(1)+0.05*diff(ax.XLim), ax.YLim(1)+0.05*diff(ax.YLim),sprintf('Spike detection has run: 0 spikes'))
        return
    end
    y = ax.YLim(2);
    t = makeInTime(h.trial.params);
    if ~any(isnan(h.trial.spikes))
        ticks = raster(ax,t(h.trial.spikes),y);
        set(ticks,'Tag','Spikes');
    else
        raster(ax,t(h.trial.spikes(~isnan(h.trial.spikes))),y);
        ticks = raster(ax,t(h.trial.spikes_uncorrected(isnan(h.trial.spikes))),y);
        ticks.Color = [0    0.4470    0.7410];
    end
    
    % enable for other trials
% If not, find out if the spike detection has been run for the cell
else 
    % Go through other trials, first check nearby ones in this protocol
    nums = h.trial.params.trial+[-1 1 -2 2 -3 3 -4 4];
    nums = nums(nums>0&nums<h.prtclData(end).trial);
    gotone = 0;
    for t = nums
        mtfl = matfile(sprintf(h.trialStem,t));
        if ~isempty(whos(mtfl,'spikeDetectionParams'))
            gotone = 1;
            break
        end
    end
    % The go through all protocol files
    if ~gotone
        for t = 1:length(h.prtclData)
            mtfl = matfile(sprintf(h.trialStem,h.prtclData(t).trial));
            if ~isempty(whos(mtfl,'spikeDetectionParams'))
                gotone = 1;
                break
            end
        end
    end
    if ~gotone
        % warn if no other protocol trials have been run
        warning('No other protocol trials have spikes')
    else
        spikevars = mtfl.spikeDetectionParams;
    end
    % optional: then check other protocols
    
    % If no spike detection has been run, get vars from
    % prefs('FlyAnalysis')
        % vars_skeleton = rmfield(vars,'unfiltered_data'); vars_skeleton =
        % rmfield(vars_skeleton,'filtered_data'); vars_skeleton =
        % rmfield(vars_skeleton,'piezo');
        % setpref('FlyAnalysis','Spike_params',vars_skeleton);
    if ~exist('spikevars','var')
        fstag = ['fs' num2str(h.trial.params.sampratein)];
        spikevars = getacqpref('FlyAnalysis',['Spike_params_' fstag]);
    end 
    % run the spike filter GUI with these prefs., select example spikes.
    
    switch h.trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end
    %     switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end

    % may need to allow for different versions of spike analysis
    [h.trial,spikevars] = spikeDetection(h.trial,invec1,spikevars);
    if ~isempty(spikevars)
        fstag = ['fs' num2str(h.trial.params.sampratein)];
        setacqpref('FlyAnalysis',['Spike_params_' fstag],spikevars);
    else
        warning('Spike detection is canceled');
    end
end
guidata(spikebutt,h)
%quickShow_Protocol(h.trialnum, eventdata, h)


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
% An earlier version printed the script for the quickShow function 4/27/15
handles = guidata(hObject);
evalin('base', ['trial = load(''' regexprep(handles.trial.name,'Acquisition','Raw_Data') ''')']);
clipboard('copy',sprintf('trial = load(''%s'');\n',(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum)))));


function trialImages_Callback(hObject, eventdata, handles,varargin)
handles = guidata(hObject);
if strcmp(get(hObject,'type'),'line')
    exposureNum = get(hObject,'userData');
else
    exposureNum = 1;
end
feval(@playAviMovies,handles.trial,handles.trial.params,exposureNum);

function aviMoviesAndData_Callback(hObject, eventdata, handles,varargin)
handles = guidata(hObject);
if strcmp(get(hObject,'type'),'line')
    exposureNum = get(hObject,'userData');
else
    exposureNum = 1;
end
feval(@playAviAndData,handles.trial,handles.trial.params,exposureNum);

    
function addClickableExposureTimeline(handles,savetag)
% x = (1:handles.trial.params.sampratein*handles.params.durSweep)/handles.trial.params.sampratein;
% if isfield(handles.trial.params,'preDurInSec')
%     x = ((1:handles.trial.params.sampratein*handles.params.durSweep) - handles.trial.params.preDurInSec*handles.trial.params.sampratein)/handles.trial.params.sampratein;
% end
% ax = findobj('tag','quickshow_outax','parent',handles.quickShowPanel);
% exposure = handles.trial.exposure(1:length(x));
% expostimes = x(logical(exposure));
% lims = get(ax,'ylim');
% for t= 1:length(expostimes)
%     l = line([expostimes(t) expostimes(t)],lims,'parent',ax,'color',[1 1 1] *.8,'tag',savetag,'userdata',t);
%     set(l,'ButtonDownFcn',@showClickedImage);
% end
% set(ax,'children',flipud(get(ax,'Children')));

ax1 = findobj(handles.quickShowPanel,'tag','quickshow_outax');
ax2 = findobj(handles.quickShowPanel,'tag','quickshow_inax');

xlims = get(ax1,'xlim');
ylims = get(ax1,'ylim');
str = sprintf('%d Exposures, %.1f fps', sum(handles.trial.exposure),handles.trial.params.sampratein/mean(diff(find(handles.trial.exposure))));
if ~isempty(xlims)
    text(xlims(1)+.05*diff(xlims),ylims(2)-.05*diff(ylims),...
        str,...
        'parent',ax1,'fontsize',7,'tag','delete');
end

function showClickedImage(l,eventdata,handles)
handles = guidata(l);
trialImages_Callback(l, eventdata, handles)


% --- Executes on button press in showmenu_chkbx.
function showmenu_chkbx_Callback(hObject, eventdata, handles) %#ok<*INUSD>
handles = guidata(hObject);
set(handles.analyses_chckbox,'value',0);
guidata(hObject, handles);

% --- Executes on button press in trialpath.
function trialpath_Callback(hObject, eventdata, handles) %#ok<*INUSL>
fprintf('%%*********************\n');
fprintf('''%s'';\n',(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum))))
clipboard('copy',sprintf('''%s'';\n',(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum)))));


% --- Executes button press in Combine Blocks.
function combineblocks_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
fns = fieldnames(handles.trial.params);
plurals = {};
for fn_ind = 1:length(fns)
    if strcmp('s',fns{fn_ind}(end))
        plurals{end+1} = fns{fn_ind};
    end
end
% Create figure
h.f = figure('units','pixels','position',[200,200,100,30+16*length(plurals)+10],...
             'toolbar','none','menu','none');
for pl_ind = 1:length(plurals)
    % Create yes/no checkboxes
    h.c(pl_ind) = uicontrol('style','checkbox','units','pixels','parent',h.f,...
        'position',[10,30+16*(pl_ind-1),100,15],'string',plurals{pl_ind});
    % left bottom width height
end

% Create OK pushbutton
h.p = uicontrol('style','pushbutton','units','pixels','parent',h.f,...
                'position',[10,5,80,20],'string','OK',...
                'callback',@(x,y,z)uiresume);
uiwait(h.f);

excluded = {'trialBlock','combinedTrialBlock','gain','secondary_gain','randomize'};
for pl_ind = 1:length(plurals)
    if get(h.c(pl_ind),'value')
        excluded{end+1} = plurals{pl_ind};
    end
end
close(h.f);
clear h
blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',excluded);

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


% --- Executes on button press in image_button.
function image_button_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
vid = VideoReader(regexprep(handles.trial.imageFile,'Acquisition','Raw_Data'));
imstr = sprintf('Video Reader Info, trial %d:\nDuration: %.2f\nFrameRate: %.2f\nSize: %d x %d x %.0f',...
    handles.trial.params.trial,...
    vid.Duration,...
    vid.FrameRate,...
    vid.Width,...
    vid.Height,...
    vid.FrameRate*vid.Duration);
msgbox(imstr,'VideoReader Info')


% --- Executes on button press in tag_button.
function tag_button_Callback(hObject, eventdata, handles)
button = questdlg('Edit for entire block?','Tag Block','Yes');
if strcmp(button,'Cancel'), return, end

handles = guidata(hObject);
tags = handles.trial.tags;
def = '';

for t_ind = 1:length(tags)
    def = [def tags{t_ind} '; '];
end
prompt = {'Edit trial tags ('';''-delimited, '';'' to clear tags):'};
dlg_title = 'Tag Trial';
num_lines = 1;
def = {def};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    return
end   
pat = ';\s*';
s = regexp(answer, pat, 'split');
s = s{1};
if isempty(s{end}) || isempty(regexp(s{end},'\S'))
    s = s(1:end-1);
end
handles.trial.tags = s;

if strcmp(button,'Yes')
    nums = findLikeTrials_includingExcluded('name',handles.trial.name,'datastruct',handles.prtclData,...
        'exclude',{'step','amp','displacement','freq'});
    for n_ind = 1:length(nums);
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,nums(n_ind))));
        trial.tags = s;
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    end
else
    trial = handles.trial;
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
end
guidata(hObject, handles);
trialnum_Callback(handles.trialnum, eventdata, handles)


% --- Executes on button press in clear_ROI_button.
function clear_ROI_button_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
if strcmp(get(handles.image_button,'enable'),'on') && isfield(handles.trial,'ROI')
    handles.trial = rmfield(handles.trial,'ROI');
    trial = handles.trial;
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
end
button = questdlg('Clear ROI for block?','Clear ROI','Yes');
if ~(strcmp(button,'No') || strcmp(button,'Cancel'))
    blockTrials = findLikeTrials('name',trial.name,'datastruct',handles.prtclData);
    for bt = blockTrials
        data_block = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
        if isfield(data_block,'ROI')
            data_block = rmfield(data_block,'ROI');
            trial = data_block;
            save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
        end
    end
end
guidata(hObject,handles);

trialnum_Callback(handles.trialnum,[],handles)



% --- Executes on button press in analyses_chckbox.
function analyses_chckbox_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
set(handles.showmenu_chkbx,'value',0);
guidata(hObject, handles);


% --- Executes on button press in notes_button.
function notes_button_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
edit(handles.notesfilename);


function annotate_button_Callback(hObject, eventdata, handles)
% Bring up a message
clr0 = get(hObject,'BackgroundColor');
set(hObject,'String','Slct Pnt','BackgroundColor',[.8 .1 .1])

% pos = hObject.Position;
% tx = uicontrol('Style','text','position',pos+[0 pos(4) 2*pos(3) 0],'String','Select a point on an axis','parent',hObject.Parent);
button = waitforbuttonpress;
switch button
    case 0
        set(hObject,'String','Annot8','BackgroundColor',clr0);

        curraxes = hObject.Parent.CurrentAxes;
        currpoint = curraxes.CurrentPoint;
        x = currpoint(1,1);
        y = currpoint(1,2);
        
        trial = handles.trial;
        if isfield(trial,'annotation')
            annotation = trial.annotation;
            idx = size(annotation,1)+1;
        else
            annotation = cell(1,3);
            idx = 1;
        end
        annotation{idx,1} = curraxes.Tag;
        annotation{idx,2} = [x,y];
        answer{1} = inputdlg('Annotation','Annotation',2,{'e.g. leg slips here'});
        annotation{idx,3} = answer{1}{1};
        handles.trial.annotation = annotation;
        trial.annotation = annotation;
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
        guidata(hObject,handles)
        showAnnotations(hObject);
    otherwise
        set(hObject,'String','Annot8','BackgroundColor',clr0);
        guidata(hObject,handles)
        return
end

guidata(hObject,handles)


function showAnnotations(hObject)
handles = guidata(hObject);
if ~isfield(handles.trial,'annotation')
    return
end
if handles.showannotations.Value
    for a = 1:size(handles.trial.annotation,1);
        ax = findobj(handles.figure1,'type','axes','tag',handles.trial.annotation{a,1});
        if isempty(ax)
            continue
        end
        xy = handles.trial.annotation{a,2};
        line(xy(1),xy(2),'marker','d','markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0],'parent',ax,'tag','annotations');
        text(xy(1),xy(2),handles.trial.annotation{a,3},'parent',ax,'fontsize',7,'tag','annotations','verticalalignment','bottom');
    end
end
guidata(hObject,handles);


% --- Executes on button press in raw_folder_location.
function raw_folder_location_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
winopen(handles.dir);


% --------------------------------------------------------------------
function quickShowPanel_ButtonDownFcn(hObject, eventdata, handles)
persistent chk
if isempty(chk)
      chk = 1;
      pause(0.5); %Add a delay to distinguish single click from a double click
      if chk == 1
          fprintf(1,'\nI am doing a single-click.\n\n');
          chk = [];
      end
else
      chk = [];
      figs = findobj('type','figure');
      figs = figs(figs ~= get(hObject,'parent'));
      close(figs);
end

function helperFunctionMenu_Callback(hObject, eventdata, handles)
handles = guidata(hObject);
hfs = get(hObject,'string');
hfv = get(hObject,'value');
hf = hfs{hfv};
feval(hf,hObject,eventdata,handles);


function helperFunctionMenu_CreateFcn(hObject, eventdata, handles)
helperfuncs = ...
{
'edit_analysis'
'save_data_struct'
'reload_notes'
'skootch_exposure'
'bad_movie'
'addTagsToSubplots'
'clicky_on_image'
'rename_tag'
'cleanuptags'
'excludeBlock_toggle'
'removeSpikes'
'reDetectSpikes'
'removeKmeansStuff'
'removeProbeTrackStuff'
'removeProbeLine'
'removeAnnotations'
};
set(hObject,'String',helperfuncs);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ----------- helper functions ---------------
function edit_analysis(hObject, eventdata, handles)
handles = guidata(hObject);
eval(['edit ' handles.showMenu.String{handles.showMenu.Value}])

function save_data_struct(hObject, eventdata, handles)
handles = guidata(hObject);
createDataFileFromRaw(handles.prtclDataFileName);
d = load(handles.prtclDataFileName);
handles.prtclData = d.data;
guidata(hObject, handles);

function handles = reload_notes(hObject, eventdata, handles)
% a = dir([handles.dir '\notes_*']);
a = dir(fullfile(handles.dir,'notes_*'));

fclose('all');
handles.notesfilename = fullfile(handles.dir,a.name);
handles.notesfid = fopen(handles.notesfilename,'r');
set(handles.infoPanel,'userdata',fileread(handles.notesfilename))

if ~isempty(eventdata) && ischar(eventdata) && strcmp(eventdata,'loadCellFromDir')
else
    updateInfoPanel(handles);   
end
if ~isempty(hObject)
    guidata(hObject, handles);
end

function handles = skootch_exposure(hObject, eventdata, handles)
handles.trial = skootchExposureNFrames(handles.trial);
guidata(hObject, handles);

function handles = bad_movie(hObject, eventdata, handles)
if isfield(handles.trial,'badmovie')
    button = questdlg('No longer bad movie?','Good Movie?','Yes');
    switch button
        case 'Yes'
            trial = rmfield(handles.trial,'badmovie');
            trial = rmfield(trial,'badmoviecomment');
            save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
            handles.trial = trial;
            guidata(hObject, handles);
            return
        case 'No'
            fprintf('Still bad movie: %s\n',handles.trial.badmoviecomment);
        case 'Cancel'
            return
    end
    
else
    reason = inputdlg('Why is this a bad movie?','Bad Movie Comment',2,{'e.g. Bad probe position'});
    handles.trial.badmovie = 1;
    handles.trial.badmoviecomment = reason;
    trial = handles.trial;
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    guidata(hObject, handles);
    return
end

function add_tags_to_subplots(hObject, eventdata, handles)  
ax1 = findobj(handles.quickShowPanel,'tag','quickshow_outax');
ax2 = findobj(handles.quickShowPanel,'tag','quickshow_inax');

[prot,d,fly,cell,trialnum] = extractRawIdentifiers(handles.trial.name);

xlims = get(ax1,'xlim');
ylims = get(ax1,'ylim');
if ~isempty(xlims)
    text(xlims(1)+.05*diff(xlims),ylims(1)+.05*diff(ylims),...
        sprintf('%s', [prot '.' d '.' fly '.' cell '.' trialnum]),...
        'parent',ax1,'fontsize',7,'tag','delete');
    if isfield(handles.trial,'tags') && ~isempty(handles.trial.tags);
        tags = handles.trial.tags;
        tagstr = tags{1};
        for i = 2:length(tags)
            tagstr = [tagstr ';' tags{i}];
        end
        xlims = get(ax2,'xlim');
        ylims = get(ax2,'ylim');
        text(xlims(1)+.05*diff(xlims),ylims(1)+.05*diff(ylims),tagstr,'parent',ax2,'tag','delete');
    end
end

function clicky_on_image(hObject, eventdata, handles)
handles = guidata(hObject);
I = getScimImageStack(handles.trial,handles.trial.params);
clicky(I);

function rename_tag(hObject, eventdata, handles)  
handles = guidata(hObject);
button = questdlg('Replace all?','Rename All','Yes');
if strcmp(button,'Cancel'), return, end

tags = handles.trial.tags;
def = '';

for t_ind = 1:length(tags)
    def = [def tags{t_ind} '; '];
end
prompt = {'Current name','New tag name'};
dlg_title = 'Rename Tag';
num_lines = 1;
def = {def,def};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
    return
end   
pat = ';\s*';
oldtag = regexp(answer{1}, pat, 'split');
if isempty(oldtag{end}) || isempty(regexp(oldtag{end},'\S'))
    oldtag = oldtag(1:end-1);
end
oldtag = oldtag{1};

newtag = regexp(answer{2}, pat, 'split');
if isempty(newtag{end}) || isempty(regexp(newtag{end},'\S'))
    newtag = newtag(1:end-1);
end
newtag = newtag{1};

loopThroughRawFilesTags(handles.trial.name,oldtag,newtag);

createDataFileFromRaw(handles.prtclDataFileName);
d = load(handles.prtclDataFileName);
handles.prtclData = d.data;
guidata(hObject, handles);

function cleanuptags(hObject, eventdata, handles)  
handles = guidata(hObject);
loopThroughRawFilesTags_cleanup(handles.dir);

createDataFileFromRaw(handles.prtclDataFileName);
d = load(handles.prtclDataFileName);
handles.prtclData = d.data;
guidata(hObject, handles);

function excludeBlock_toggle(hObject,eventdata,handles)
button = questdlg('Exclude entire block?','Exclude Block','Yes');
if strcmp(button,'Cancel'), return, end

handles = guidata(hObject);
if strcmp(button,'Yes')
    nums = findLikeTrials_includingExcluded('name',handles.trial.name,'datastruct',handles.prtclData,...
        'exclude',{'step','amp','displacement','freq'});
    ex = handles.trial.excluded;
    for n_ind = 1:length(nums);
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,nums(n_ind))));
        trial.excluded = ex;
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    end
else
    trial = handles.trial;
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
end

guidata(hObject, handles);

function removeSpikes(hObject,eventdata,handles)
button = questdlg('RemoveSpikes for entire block?','Remove Spikes','No');
if strcmp(button,'Cancel'), return, end

handles = guidata(hObject);
if strcmp(button,'Yes')
    nums = findLikeTrials_includingExcluded('name',handles.trial.name,'datastruct',handles.prtclData,...
        'exclude',{'step','amp','displacement','freq'});
    for n_ind = 1:length(nums)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,nums(n_ind))));
        if isfield(trial,'spikes')
            trial = rmfield(trial,'spikes');
        end
        if isfield(trial,'spikeDetectionParams')
            trial = rmfield(trial,'spikeDetectionParams');
        end
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
        fprintf('Spikes removed\n');
        
    end
else
    trial = handles.trial;
    if isfield(trial,'spikes')
        trial = rmfield(trial,'spikes');
        fprintf('Spikes removed\n');
    end
    if isfield(trial,'spike_uncorrected')
        trial = rmfield(trial,'spikes_uncorrected');
        fprintf('Uncorrected spikes removed\n');
    end
    if isfield(trial,'spikeDetectionParams')
        trial = rmfield(trial,'spikeDetectionParams');
        fprintf('Spike params removed\n');
    end
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    handles.trial = trial;
    fprintf('Spikes removal complete\n');
        
end

guidata(hObject, handles);


function reDetectSpikes(hObject,eventdata,handles)

handles = guidata(hObject);
trial = handles.trial;
switch handles.trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end

button = questdlg('Use params from preferences?','Preferences','No');
if strcmp(button,'No')
    spikeDetection(trial,invec1,trial.spikeDetectionParams);
elseif strcmp(button,'Yes')
    fstag = ['fs' num2str(h.trial.params.sampratein)];
    spikevars = getacqpref('FlyAnalysis',['Spike_params_' fstag]);
    [~,spikevars] = spikeDetection(trial,invec1,spikevars);
    setacqpref('FlyAnalysis',['Spike_params_' fstag],spikevars);
end

figure(gcbf);
guidata(hObject, handles);


function removeKmeansStuff(hObject,eventdata,handles)
button = questdlg('Remove Kmeans stuff for entire block?','Remove Kmeans','Yes');
if strcmp(button,'Cancel'), return, end

handles = guidata(hObject);
if strcmp(button,'Yes')
    nums = findLikeTrials_includingExcluded('name',handles.trial.name,'datastruct',handles.prtclData,...
        'exclude',{'step','amp','displacement','freq'});
    for n_ind = 1:length(nums);
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,nums(n_ind))));
        trial = rmfield(trial,'kmeans_ROI');
        trial = rmfield(trial,'kmeans_threshold');
        trial = rmfield(trial,'clmask');
        trial = rmfield(trial,'clustertraces');
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    end
else
    trial = handles.trial;
    trial = rmfield(trial,'kmeans_ROI');
    trial = rmfield(trial,'kmeans_threshold');
    trial = rmfield(trial,'clmask');
    trial = rmfield(trial,'clustertraces');
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    handles.trial = trial;
end

guidata(hObject, handles);

function removeProbeLine(hObject,eventdata,handles)
button = questdlg('Remove Probe Line for entire block?','Remove Probe','Yes');
if strcmp(button,'Cancel'), return, end

handles = guidata(hObject);
if strcmp(button,'Yes')
    nums = findLikeTrials_includingExcluded('name',handles.trial.name,'datastruct',handles.prtclData,...
        'exclude',{'step','amp','displacement','freq','speed'});
    for n_ind = 1:length(nums)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,nums(n_ind))));
        try trial = rmfield(trial,'forceProbe_line'); 
        catch e, fprintf('%s\n',e.message); 
        end
        try trial = rmfield(trial,'forceProbe_tangent'); catch e, fprintf('%s\n',e.message); end
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    end
else
    trial = handles.trial;
        try trial = rmfield(trial,'forceProbe_line'); catch e, fprintf('%s\n',e.message); end
        try trial = rmfield(trial,'forceProbe_tangent'); catch e, fprintf('%s\n',e.message); end
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    handles.trial = trial;
end

guidata(hObject, handles);


function removeProbeTrackStuff(hObject,eventdata,handles)
button = questdlg('Remove Probe profile stuff for entire block?','Remove Probe','Yes');
if strcmp(button,'Cancel'), return, end

handles = guidata(hObject);
if strcmp(button,'Yes')
    nums = findLikeTrials_includingExcluded('name',handles.trial.name,'datastruct',handles.prtclData,...
        'exclude',{'step','amp','displacement','freq'});
    for n_ind = 1:length(nums)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,nums(n_ind))));
        trial = rmfield(trial,'forceProbeStuff');
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    end
else
    trial = handles.trial;
        trial = rmfield(trial,'forceProbeStuff');
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    handles.trial = trial;
end

guidata(hObject, handles);


function removeAnnotations(hObject,eventdata,handles)
button = questdlg('Remove all annotations?','Remove Annotations','Yes');
if strcmp(button,'Cancel'), return, end

handles = guidata(hObject);
if strcmp(button,'Yes')
    trial = handles.trial;
    trial = rmfield(trial,'annotation');
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    handles.trial = trial;
end

guidata(hObject, handles);

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
key = eventdata.Key;
switch key
    case 'rightarrow'
        fprintf('->\n')
        rightButton_Callback(hObject, eventdata, handles)
    case 'leftarrow'
        fprintf('<-\n')
        leftButton_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in showannotations.
function showannotations_Callback(hObject, eventdata, handles)
if hObject.Value
    showAnnotations(hObject)
else 
    delete(findobj('tag','annotations'))
end
    
