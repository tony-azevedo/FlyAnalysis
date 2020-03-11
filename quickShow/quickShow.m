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

% Last Modified by GUIDE v2.5 20-Mar-2019 11:05:48

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
        ~contains(str2test,getacqpref('USERDIRECTORY','MAC')) &&...
        ~contains(str2test,getacqpref('USERDIRECTORY','PC'))
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
        error('This code needs updating');
        if ~isempty(strfind(linkvariable,'C:\Users\Anthony Azevedo\')) || ~isempty(strfind(linkvariable,'/Users/tony/'))
            dir = linkvariable;
        end
    elseif isstruct(linkvariable) && ...
            isfield(linkvariable,'flygenotype') && ...
            isfield(linkvariable,'flynumber') && ...
            isfield(linkvariable,'cellnumber') && ...
            isfield(linkvariable,'date')
        error('This code needs updating');

        dir = ['C:\Users\Anthony Azevedo\Acquisition\',linkvariable(1).date,'\',...
            linkvariable(1).date,...
            '_F',linkvariable(1).flynumber,...
            '_C',linkvariable(1).cellnumber];

    end
    handles.dir = dir;
end
guidata(hObject,handles);
handles.dir;
[l, handles] = isInCellDir;
if ~l
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
if ~isempty(strfind(pwd,'E:\Data\'))
    [~, remain] = strtok(fliplr(pwd),'\');
    curdir = fliplr(remain);
else
    curdir = 'E:\Data\';
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
        if contains(char(65:90),a(i).name(1)) && ...
            ~isempty(ind) && ...
            ~sum(strcmp(protocols,a(i).name(1:ind(1)-1)))
            protocols{end+1} = a(i).name(1:ind(1)-1); %#ok<AGROW>
        end
    end
    handles = reload_notes([],'loadCellFromDir',handles);

    a = dir([handles.dir filesep '*_ContRaw*']);
    for i = 1:length(a)
        ind = regexpi(a(i).name,'_');
        if contains(char(65:90),a(i).name(1)) && ...
                ~isempty(ind) && ...
                ~sum(strcmp(protocols,a(i).name(1:ind(1)-1)))
            protocols{end+1} = a(i).name(1:ind(1)-1); %#ok<AGROW>
        end
    end
    set(handles.protocolMenu, 'String', protocols,'value',1);
    guidata(handles.protocolMenu,handles)
    
    % Update 181016: 
    % Previously, quickshow would assume that the files are in RawData, in some specified folder. Now
    % I'm making it more general, the files can be anywhere as long as it
    % is a cell folder (has Acquisition file, has raw data files, has notes
    
    % But now I will test the correctness of the directory explicitly,
    % before going into the protocol menu callback
    
    rawfiles = dir(fullfile(handles.dir,[protocols{1} '_Raw*']));
    % test that the rawfiles have the correct directory name:
    cnt = 0;
    while cnt < length(rawfiles) && cnt < 10
        cnt = cnt+1;
        trialname = load(fullfile(handles.dir,rawfiles(cnt).name),'name');
        if ~contains(trialname.name,handles.dir)
            butt = questdlg(sprintf('Trial.name (%s) does not point to the raw file.\nChange file paths to %s?',trialname.name,handles.dir),'Change paths','Yes');
            switch butt
                case 'No'
                    error('Rawfiles have the wrong path, not proceeding')
                case 'Cancel'
                    error('Rawfiles have the wrong path, not proceeding')
                case 'Yes'
                    CorrectFileNames(handles)
            end
        end
    end
    
    ind_ = regexp(rawfiles(1).name,'_');
    indDot = regexp(rawfiles(1).name,'\.');
    handles.trialStem = [rawfiles(1).name((1:length(rawfiles(1).name)) <= ind_(end)) '%d' rawfiles(1).name(1:length(rawfiles(1).name) >= indDot(1))];
    dfile = rawfiles(1).name(~(1:length(rawfiles(1).name) >= ind_(end) & 1:length(rawfiles(1).name) < indDot(1)));
    dfile = regexprep(dfile,'_Raw_','_');
    handles.prtclDataFileName = fullfile(handles.dir,dfile);
    
    if exist(handles.prtclDataFileName,'file')
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
    if ~exist(handles.prtclDataFileName,'file') || length(d.data) ~= length(rawfiles) || changeFileNames
        createDataFileFromRaw(handles.prtclDataFileName);
        %FlySoundDataStruct2csv(handles.prtclDataFileName);
    end    
    protocolMenu_Callback(handles.protocolMenu, [], handles);
end

function CorrectFileNames(handles)

rawfiles = dir(fullfile(handles.dir,'*_Raw*.mat'));

for f = 1:length(rawfiles)
    trial = load(fullfile(handles.dir,rawfiles(f).name));
    trial.name = fullfile(handles.dir,rawfiles(f).name);
    % trial = setRawFilePath(trial);
    save(trial.name,'-struct','trial');
    
    if mod(f,20)==0
        fprintf('%d: Saving %s\n',f,trial.name);
    end
end


    

function protocolMenu_Callback(hObject, eventdata, handles)
protocols = get(hObject,'String');
handles.currentPrtcl = protocols{get(hObject,'value')};

set(handles.Spikes,'Value',0);
set(handles.probetrace_button,'Value',0);
set(handles.showmenu_chkbx,'Value',0);

% give handles the information on the Trials involved
rawfiles = dir(fullfile(handles.dir,[handles.currentPrtcl '_Raw*']));
if isempty(rawfiles)
    
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
if ~isempty(dataFileExist)
    d = load(handles.prtclDataFileName);
else
    createDataFileFromRaw(handles.prtclDataFileName,'one');
    error('Should have created a Data File in loadCellFromDir function above')
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
    save(trial.name, '-struct', 'trial');
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
    set(handles.image_info,'String','','Enable','off');
elseif isfield(handles.trial,'imageFile') && ~isempty(handles.trial.imageFile)
    [yn,imdir] = imageFileExist(handles.trial);
    if yn
        [imdir,imfile,ext] = fileparts(imdir);
    end
    if ~yn
        
    elseif yn && ~strcmp(handles.trial.imageFile,[imfile,ext]) && ~contains(handles.trial.imageFile,imdir)
        trialnum_Callback(hObject, eventdata, handles)
        handles = guidata(hObject);
    elseif yn && (strcmp(handles.trial.imageFile,[imfile,ext]) || contains(handles.trial.imageFile,imdir))
        try exp = postHocExposure(handles.trial);
        catch e
            guidata(hObject,handles)
            quickShow_Protocol(hObject, eventdata, handles)
            error(e.message)
        end
        [~,imfdir] = imageFileExist(handles.trial);
        a = dir(imfdir);
        samprate = handles.trial.params.sampratein;
        imstr = sprintf('Exp: %d - rate: %.2f - size: %dMB (R click for more)',...
            sum(exp.exposure),...
            samprate/mean(diff(find(exp.exposure))),...
            round(a.bytes/1E6));
        set(handles.image_info,'String',imstr,'fontsize',7,'Enable','on','ButtonDownFcn',@image_button_Callback);
    end
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
delete(findobj(handles.quickShowPanel,'tag','annotations'));

guidata(hObject,handles)
updateInfoPanel(handles);
handles = guidata(hObject);
if get(handles.showmenu_chkbx,'value')
    showMenu_Callback(hObject, eventdata, handles)
else
    feval(str2func(handles.quickShowFunction),handles.quickShowPanel,handles,savetag);
    if isfield(handles.trial,'exposure') && (isfield(handles.trial,'imageNum') || 7 == exist(regexprep(handles.trial.name(1:end-4),'Raw','Images')))
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
    
    if isfield(handles.trial,'spikes') 
        handles.Spikes.FontWeight = 'bold';
        if ~isfield(handles.trial,'spikeSpotChecked') 
            handles.spike_spot_check_button.Enable = 'on';
            handles.spike_spot_check_button.FontWeight = 'normal';
        elseif ~handles.trial.spikeSpotChecked
            handles.spike_spot_check_button.Enable = 'on';
            handles.spike_spot_check_button.FontWeight = 'Bold';
        else
            handles.spike_spot_check_button.Enable = 'off';
            handles.spike_spot_check_button.FontWeight = 'Bold';
        end
    else
        handles.Spikes.FontWeight = 'normal';
        handles.spike_spot_check_button.Enable = 'off';
        handles.spike_spot_check_button.FontWeight = 'normal';
    end
    
    if get(handles.Spikes,'value')
        Spikes_Callback(handles.Spikes, [], handles)
    end
    
    if isfield(handles.trial,'forceProbeStuff')
        handles.probetrace_button.String = 'Probe';
        handles.probetrace_button.FontWeight = 'bold';
    elseif isfield(handles.trial,'legPositions')
        handles.probetrace_button.String = 'Leg Pose';
        handles.probetrace_button.FontWeight = 'bold';
    else
        handles.probetrace_button.FontWeight = 'normal';
        handles.probetrace_button.String = 'Probe';
    end
    
    if get(handles.probetrace_button,'value')
        probetrace_button_Callback(handles.probetrace_button, [], handles)
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



function SimpleSpikeSpotCheckCheck(fig, eventdata)
if eventdata.Button == 3
    h = guidata(eventdata.Source);
    if ~isfield(h.trial,'spikeSpotChecked') || ~h.trial.spikeSpotChecked
        trial = h.trial;
        trial.spikeSpotChecked = 1;
        save(trial.name, '-struct', 'trial');
        
        trialnum_Callback(h.trialnum, eventdata, h)
    end
end

function SimpleEMGSpikeSpotCheckCheck(fig, eventdata)
if eventdata.Button == 3
    h = guidata(eventdata.Source);
    if ~isfield(h.trial,'EMGspikeSpotChecked') || ~h.trial.EMGspikeSpotChecked
        trial = h.trial;
        trial.EMGspikeSpotChecked = 1;
        save(trial.name, '-struct', 'trial');
        
        trialnum_Callback(h.trialnum, eventdata, h)
    end
end

function Spikes_Callback(spikebutt, eventdata, h)

if ~spikebutt.Value
    s = findobj(h.quickShowPanel,'type','line','tag','Spikes','-or','tag','EMGspikes','-or','tag','FastEMGspikes');
    if ~isempty(s)
        delete(s);
    end
    
    ax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_inax');
    ax.ButtonDownFcn = '';
    ax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_inax2');
    ax.ButtonDownFcn = '';

    guidata(spikebutt,h)
    return
end
s = findobj(h.quickShowPanel,'type','line','tag','Spikes','-or','tag','EMGSpikes','-or','tag','FastEMGSpikes');
if ~isempty(s)
    delete(s);
end

% Check if this trial has spikes
if isfield(h.trial,'excluded') && h.trial.excluded
    fprintf('Trial is excluded, not interested in spikes\n')
    beep
elseif isfield(h.trial,'spikes') && isfield(h.trial,'spikeDetectionParams')
    ax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_inax');
    if isempty(ax)
        error('Clear panel, go to quickShow visualization\n')
    end
    if isempty(h.trial.spikes)
        t = findobj(ax,'type','text','String','Spike detection has run: 0 spikes');
        delete(t);
        text(ax,ax.XLim(1)+0.05*diff(ax.XLim), ax.YLim(1)+0.05*diff(ax.YLim),sprintf('Spike detection has run: 0 spikes'))

        ax.ButtonDownFcn = @SimpleSpikeSpotCheckCheck;
        guidata(spikebutt,h)
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
    ax.ButtonDownFcn = @SimpleSpikeSpotCheckCheck;

    % contains(fieldnames(h.trial),'EMGspikes')
    if any(contains(fieldnames(h.trial),'EMGspikes')) && ...
            any(contains(fieldnames(h.trial),'EMGspikeDetectionParams'))
        flds = fieldnames(h.trial);
        emgspkfld = flds(contains(flds,'EMGspikes'));
        emgspkfld = emgspkfld{1};
        emgspkfld = emgspkfld(1:regexp(emgspkfld,'EMGspikes','end'));
        emgspkfl = emgspkfld(1:end-1);
        
        ax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_inax2');
        if isempty(h.trial.(emgspkfld))
            t = findobj(ax,'type','text','String','Spike detection has run: 0 spikes');
            delete(t);
            text(ax,ax.XLim(1)+0.05*diff(ax.XLim), ax.YLim(1)+0.05*diff(ax.YLim),sprintf('Spike detection has run: 0 spikes'))
            
            ax.ButtonDownFcn = @SimpleEMGSpikeSpotCheckCheck;
            guidata(spikebutt,h)
            return
        end
        y = ax.YLim(2);
        t = makeInTime(h.trial.params);
                
        if ~any(isnan(h.trial.(emgspkfld)))
            ticks = raster(ax,t(h.trial.(emgspkfld)),y);
            set(ticks,'Tag',emgspkfld);
            if isfield(h.trial,[emgspkfl 'SpotChecked']) && ~h.trial.([emgspkfl 'SpotChecked'])
                set(ticks,'Color',[0    1    0.7410]);
            end
        else
            raster(ax,t(h.trial.spikes(~isnan(h.trial.(emgspkfld)))),y);
            ticks = raster(ax,t(h.trial.EMGspikes_uncorrected(isnan(h.trial.(emgspkfld)))),y);
            set(ticks,'Color',[0    1    0.7410]);
        end
        ax.ButtonDownFcn = @SimpleEMGSpikeSpotCheckCheck;
    end
    
    guidata(spikebutt,h)

    % enable for other trials
    % If not, find out if the spike detection has been run for the cell
else 
    % Go through other trials, first check nearby ones in this protocol
    % beep
    if isfield(h.trial,'excluded') && h.trial.excluded
        fprintf(' * Bad trial: %s\n',h.trial.name)
        return
    elseif isempty(eventdata)
        butt = questdlg('Get spikes?','Spike detection', 'Cancel');
        switch butt
            case 'Yes'            
            case 'No'
                spikebutt.Value = 0;
                guidata(spikebutt,h)
                return
            case 'Cancel'
                spikebutt.Value = 0;
                guidata(spikebutt,h)
                return
        end
    end

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
    % Then go through all protocol files
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
    
    switch h.trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end
    if ~exist('spikevars','var') 
        fstag = ['fs' num2str(h.trial.params.sampratein)];
        spikevars = getacqpref('FlyAnalysis',['Spike_params_' invec1 '_' fstag]);
    end 
    if max(spikevars.spikeTemplate)>.98 % Old trials have normalized spike templates, rplace it if there is a better one
        fstag = ['fs' num2str(h.trial.params.sampratein)];
        spikevars_temp = getacqpref('FlyAnalysis',['Spike_params_' invec1 '_' fstag]);
        if strcmp(spikevars_temp.lastfilename(1:28),h.trialStem(1:28))
            spikevars.spikeTemplate = spikevars_temp.spikeTemplate;
        end
    end

    % run the spike filter GUI with these prefs., select example spikes.
    
    % may need to allow for different versions of spike analysis
    [h.trial,~] = spikeDetection(h.trial,invec1,spikevars);
    guidata(spikebutt,h)
    trialnum_Callback(h.trialnum, eventdata, h)
end
spikebutt.ButtonDownFcn = @protocol_spike_button_alternative;

function protocol_spike_button_alternative(spikebutt_right, eventdata, h)
% run through all the trials for this protocol and process the spikes
h = guidata(spikebutt_right);
if strcmp(h.figure1.SelectionType,'alt')
    % run through all the trials for the protocol and use the params from
    % this trial to detect spikes.
    butt = questdlg('Detect spikes in protocol trials?','Batch spike detection', 'Cancel');
    switch butt
        case 'Yes'
        case 'No'
            guidata(spikebutt_right,h)
            return
        case 'Cancel'
            guidata(spikebutt_right,h)
            return
    end

    fprintf('\n\t***** Detecting spikes for %s trials **** \n',h.trial.params.protocol);    
    [~,~,~,~,~,D,trialStem,datastructfile] = extractRawIdentifiers(h.trial.name);
    data = load(datastructfile); data = data.data;
    spikevars = h.trial.spikeDetectionParams;
    switch h.trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end
    
    % Go through all trials
    REDODETECTION = 1;
    
    for tidx = 1:length(data)
        tnum = data(tidx).trial;
        if tnum == h.trial.params.trial
            continue
        end
                
        trial = load(fullfile(D,sprintf(trialStem,tnum)));
            
        if (~isfield(trial,'spikes') || REDODETECTION) %&& (~isfield(trial,'spikeSpotChecked') || ~trial.spikeSpotChecked)
            spikeDetection(trial,invec1,spikevars,'interact','no'); % fieldname will be 'spikes'
        else
            fprintf('Skipping %d\n',tnum)
        end
    end
    
end


% --- Executes on button press in probetrace_button.
function probetrace_button_Callback(probebutt, eventdata, h)
if ~probebutt.Value
    s = findobj(h.quickShowPanel,'type','line','tag','ProbeTrace');
    if ~isempty(s)
        delete(s);
    end
    guidata(probebutt,h)
    trialnum_Callback(h.trialnum, eventdata, h)
    probebutt.ButtonDownFcn = [];
    return
end
s = findobj(h.quickShowPanel,'type','line','tag','ProbeTrace');
if ~isempty(s)
    delete(s);
end

% Check if this trial has a video
if ~isfield(h.trial,'imageFile')
    fprintf('No video for %s\n',h.trial.name)
    probebutt.Value = 0;
    guidata(probebutt,h)

    return
end

% Check if this trial has a probe vector
if isfield(h.trial,'forceProbeStuff')
    ax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_outax');
    if isempty(ax)
        error('Clear panel, go to quickShow visualization\n')
    end
    delete(ax.Children)
    t = makeInTime(h.trial.params);
    h2 = postHocExposure(h.trial,length(h.trial.forceProbeStuff.CoM));
    frame_times = t(h2.exposure);
    
    if isfield(h.trial.forceProbeStuff,'ZeroForce')
        plot(ax.XLim,[1 1]*h.trial.forceProbeStuff.ZeroForce,'color',.9 *[1 1 1],'tag','ProbeTrace'); hold(ax,'on');
    end
    plot(ax,frame_times,h.trial.forceProbeStuff.CoM(:,1:length(frame_times)),'color',[0 .2 0],'tag','ProbeTrace'), hold(ax,'on');

    inax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_inax');
    ax.XLim = inax.XLim;
    
    % enable for other trials
    if isfield(h.trial,'arduino_output')
        ardo = plot(ax,t,h.trial.arduino_output*max(h.trial.forceProbeStuff.CoM(1,:)-h.trial.forceProbeStuff.CoM(1,1))+h.trial.forceProbeStuff.CoM(1,1),'color',[1 .5 0],'tag','ProbeTrace');
    end
    if isfield(h.trial.forceProbeStuff,'ArduinoThresh')
        plot(ax,[t(1) t(end)],[1 1]*h.trial.forceProbeStuff.ArduinoThresh,'color',[.5 .1 .5],'tag','arduinothresh');
    end
    if isfield(h.trial.forceProbeStuff,'ProbeLimits')
        ax.YLim = h.trial.forceProbeStuff.ProbeLimits;
        ardo.YData = h.trial.arduino_output*...
            (h.trial.forceProbeStuff.ProbeLimits(2) - h.trial.forceProbeStuff.Neutral) + ...
            h.trial.forceProbeStuff.Neutral;
    end

    if isempty(eventdata) || isempty(eventdata.Source.UserData)
        probebutt.ButtonDownFcn = @probeButton_alternative;
    elseif ~isempty(eventdata) && strcmp(eventdata.Source.UserData,'DetectionRun')
        probebutt.ButtonDownFcn = @protocol_probe_button_alternative;
    end

elseif isfield(h.trial,'legPositions')
    ax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_outax');
    if isempty(ax)
        error('Clear panel, go to quickShow visualization\n')
    end
    delete(ax.Children)
    t = makeInTime(h.trial.params);
    h2 = postHocExposure(h.trial,length(h.trial.legPositions.Tibia_Angle));
    frame_times = t(h2.exposure);
    plot(ax,frame_times,h.trial.legPositions.Tibia_Angle(1:length(frame_times)),'color',[.3 .4 1],'tag','ProbeTrace'), hold(ax,'on');
    inax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_inax');
    ax.XLim = inax.XLim;

else 
    beep
    if isfield(h.trial,'excluded') && h.trial.excluded
        fprintf(' * Bad movie: %s\n',h.trial.name)
    else
        butt = questdlg('Track Probe?','Track probe', 'Cancel');
        switch butt
            case 'Yes'
                vertbutt = questdlg('Vertical Probe?','Track probe', 'Yes');
                switch vertbutt
                    case 'Yes'
                        frcprbline = [536    0
                            536  890];
                        tngntpnt = [536 256];
                        h.trial.forceProbe_line = frcprbline;
                        h.trial.forceProbe_tangent = tngntpnt;
                        
%                         showProbeLocation(h.trial)

                    case 'No'
                        [h.trial,response] = probeLineROI(h.trial);
                        h.trial = smoothOutBrightPixels(h.trial);
                        if strcmp(response,'Cancel')
                            return
                        end
                        
                    case 'Cancel'
                        return
                end
                
            case 'No'
                h.probetrace_button.Value = 0;
                guidata(probebutt,h)
                return
            case 'Cancel'
                h.probetrace_button.Value = 0;
                guidata(probebutt,h)
                return
        end
    end
    [~,~,~,~,~,~,barbar] = probeCoordinates(h.trial);

    if isfield(h.trial ,'forceProbe_line') && isfield(h.trial,'forceProbe_tangent') && (~isfield(h.trial,'excluded') || ~h.trial.excluded) && ~isfield(h.trial,'forceProbeStuff')
        fprintf('%s\n',h.trial.name);
        %fprintf('%s\n','Need to figure out if this is a 2X or 5X objective');
        trial = h.trial;
        if barbar(1)==0
            probeTrackWithShape
            zeroOutStimArtifactsVertical
            % zeroOutStimArtifactsAssumefast
            % zeroOutStimArtifactsAssumeTranslate
        else
            probeTrackROI_IR;
            zeroOutStimArtifactsAssumeTranslate
        end
        h.trial = trial;
        guidata(probebutt,h)
        eventdata.Source.UserData = 'DetectionRun';
        probetrace_button_Callback(probebutt,eventdata, h)
        % trialnum_Callback(h.trialnum, eventdata, h)

    elseif isfield(h.trial,'forceProbeStuff')
        fprintf('\t* Already detected the probe (delete probe stuff from quickshow window): %s\n',h.trial.name);
    else
        fprintf('\t* Bad movie: No line or tangent: %s\n',h.trial.name);
    end

end

guidata(probebutt,h)
%quickShow_Protocol(h.trialnum, eventdata, h)


function probeButton_alternative(probebutt, eventdata, h)
% An earlier version printed the script for the quickShow function 4/27/15
h = guidata(probebutt);
fig = figure('color',[1 1 1]);
set(fig,'Units',get(h.quickShowPanel,'Units'));
set(fig,'Position',get(h.quickShowPanel,'position'));
set(fig,'Units','points');

ax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_outax');
p = copyobj(ax,fig);
p.Units = 'normalized';
p.Position(2) = .15;
p.Position(4) = .8;
fig.Position = [273.0000  351.0000 fig.Position(3) 2/5*fig.Position(4)];
p.Units = 'points';
p.Position(2) = 40;
p.Position(4) = fig.Position(4)*.85 - 40;

[prot,d,fly,cell,trial] = extractRawIdentifiers(h.trial.name);

title(ax,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]))


function protocol_probe_button_alternative(probe_butt_right, eventdata, h)
% run through all the trials for this protocol and process the spikes
h = guidata(probe_butt_right);
if strcmp(h.figure1.SelectionType,'alt')
    % run through all the trials for the protocol and use the params from
    % this trial to detect probe.
    butt = questdlg('Detect probe in protocol trials?','Batch probe detection', 'Cancel');
    switch butt
        case 'Yes'
        case 'No'
            h.probetrace_button.ButtonDownFcn = @probeButton_alternative;
            guidata(probe_butt_right,h)
            return
        case 'Cancel'
            h.probetrace_button.ButtonDownFcn = @probeButton_alternative;
            guidata(probe_butt_right,h)
            return
    end

    fprintf('\n\t***** Detecting probe for %s trials **** \n',h.trial.params.protocol);    
    [~,~,~,~,~,D,trialStem,datastructfile] = extractRawIdentifiers(h.trial.name);
    data = load(datastructfile); data = data.data;    
    % Go through all trials
    REDODETECTION = 1;
    havaskedaboutdetection = 0;
    
    for tidx = 1:length(data)
        tnum = data(tidx).trial;
        if tnum == h.trial.params.trial
            continue
        end
            
        trial = load(fullfile(D,sprintf(trialStem,tnum)));
        if isfield(h.trial,'forceProbeStuff') && havaskedaboutdetection == 0
            butt = questdlg('Re-Detect probe if already found?','Batch probe detection', 'Cancel');
            switch butt
                case 'Yes'
                    REDODETECTION = 1;
                case 'No'
                    REDODETECTION = 0;
                case 'Cancel'
                    guidata(probe_butt_right,h)
                    return
            end
            havaskedaboutdetection = 1;
            
        end
        if (~isfield(h.trial,'forceProbeStuff') || REDODETECTION)
            trial.forceProbe_line = h.trial.forceProbe_line;
            trial.forceProbe_tangent = h.trial.forceProbe_tangent;
            
            [~,~,~,~,~,~,barbar] = probeCoordinates(h.trial);
            
            fprintf('%s\n',trial.name);
            if barbar(1)==0
                %probeTrackWithShape
                zeroOutStimArtifactsVertical
            else
                probeTrackROI_IR;
                zeroOutStimArtifactsAssumeTranslate
            end
            % h.trial = trial;
        else 
            fprintf('Skipping %d\n',tnum)
        end
    end
end



% --- Executes on button press in showroitraces.
function showroitraces_Callback(roibutt, eventdata, h) %#ok<*INUSL>
s = findobj(h.quickShowPanel,'type','line','tag','roiTrace');
if ~isempty(s)
    delete(s);
end
if ~roibutt.Value
    return
end

% Check if this trial has a probe vector
if isfield(h.trial,'clustertraces')
    ax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_outax');
    if isempty(ax)
        error('Clear panel, go to quickShow visualization\n')
    end
    delete(ax.Children)
    t = makeInTime(h.trial.params);
    h2 = postHocExposure(h.trial,length(h.trial.forceProbeStuff.CoM));
    frame_times = t(h2.exposure);
    
    if isfield(h.trial.forceProbeStuff,'ZeroForce')
        plot(ax.XLim,[1 1]*h.trial.forceProbeStuff.ZeroForce,'color',.9 *[1 1 1],'tag','ProbeTrace'); hold(ax,'on');
    end
    plot(ax,frame_times,h.trial.forceProbeStuff.CoM(1:length(frame_times)),'color',[0 .2 0],'tag','ProbeTrace'), hold(ax,'on');

    inax = findobj(h.quickShowPanel,'type','axes','tag','quickshow_inax');
    ax.XLim = inax.XLim;
    
    % enable for other trials
else 
    beep
    if isfield(h.trial,'excluded') && h.trial.excluded
        fprintf(' * Bad movie: %s\n',h.trial.name)
    end
   
    if isfield(h.trial ,'forceProbe_line') && isfield(h.trial,'forceProbe_tangent') && (~isfield(h.trial,'excluded') || ~h.trial.excluded) && ~isfield(h.trial,'forceProbeStuff')
        fprintf('%s\n',h.trial.name);
        %fprintf('%s\n','Need to figure out if this is a 2X or 5X objective');
        trial = h.trial;
        probeTrackROI_IR;
        h.trial = trial;
        guidata(roibutt,h)
        trialnum_Callback(h.trialnum, eventdata, h)

    elseif isfield(h.trial,'forceProbeStuff')
        fprintf('\t* Already detected the probe (delete probe stuff from quickshow window): %s\n',h.trial.name);
    else
        fprintf('\t* Bad movie: No line or tangent: %s\n',h.trial.name);
    end

end

guidata(roibutt,h)
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
hasAcq = false;
if ~isempty(dir(fullfile(handles.dir,'notes*.txt')))
    hasnotes = true;
end
if ~isempty(dir(fullfile(handles.dir,'Acquisition*.mat')))
    hasAcq = true;
end
if ~isempty(dir(fullfile(handles.dir,'*_Raw_*.mat')))
    hasmats = true;
end

%% Shouln't matter where the folder is, the file names should just match the location
if hasAcq && hasnotes && hasmats
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
evalin('base', ['trial = load(''' handles.trial.name ''')']);
clipboard('copy',sprintf('trial = load(''%s'');\n',(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum)))));
hObject.ButtonDownFcn = @loadstr_button_alternative;

function loadstr_button_alternative(hObject, eventdata, handles)
% An earlier version printed the script for the quickShow function 4/27/15
handles = guidata(hObject);
if strcmp(handles.figure1.SelectionType,'alt')
    clipboard('copy',sprintf('''%s''\n',(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum)))));
    fprintf('''%s''\n',(fullfile(handles.dir, sprintf(handles.trialStem,handles.currentTrialNum))));
end

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

% % --- Executes button press in Combine Blocks.
function parameterTable_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
parameterTable = datastruct2table(handles.prtclData,'DataStructFileName',handles.prtclDataFileName);
[parameterTable, drugs] = addDrugsToDataTable(parameterTable);
openvar('parameterTable')

% Legacy code that would allow you to combine blocks. Replaced by function
% creating parameter table and allowing you to browse it.
% function combineblocks_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% fns = fieldnames(handles.trial.params);
% plurals = {};
% for fn_ind = 1:length(fns)
%     if strcmp('s',fns{fn_ind}(end))
%         plurals{end+1} = fns{fn_ind};
%     end
% end
% % Create figure
% h.f = figure('units','pixels','position',[200,200,100,30+16*length(plurals)+10],...
%              'toolbar','none','menu','none');
% for pl_ind = 1:length(plurals)
%     % Create yes/no checkboxes
%     h.c(pl_ind) = uicontrol('style','checkbox','units','pixels','parent',h.f,...
%         'position',[10,30+16*(pl_ind-1),100,15],'string',plurals{pl_ind});
%     % left bottom width height
% end
% 
% % Create OK pushbutton
% h.p = uicontrol('style','pushbutton','units','pixels','parent',h.f,...
%                 'position',[10,5,80,20],'string','OK',...
%                 'callback',@(x,y,z)uiresume);
% uiwait(h.f);
% 
% excluded = {'trialBlock','combinedTrialBlock','gain','secondary_gain','randomize'};
% for pl_ind = 1:length(plurals)
%     if get(h.c(pl_ind),'value')
%         excluded{end+1} = plurals{pl_ind};
%     end
% end
% close(h.f);
% clear h
% blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',excluded);
% 
% blocks = zeros(1,length(blocktrials));
% combinedblocks = [];
% combinedblocksnums = [];
% if isfield(handles.prtclData(blocktrials(1)),'combinedTrialBlock')
%     combinedblocks = zeros(1,length(blocktrials));
%     combinedblocksnums = zeros(1,length(blocktrials));
% end
% tags = cell(size(blocks));
% for bt_ind = 1:length(blocktrials)
%     tags{bt_ind} = handles.prtclData(bt_ind).tags;
%     blocks(bt_ind) = handles.prtclData(blocktrials(bt_ind)).trialBlock;
%     if isfield(handles.prtclData(blocktrials(bt_ind)),'combinedTrialBlock') && handles.prtclData(blocktrials(bt_ind)).combinedTrialBlock>0
%         combinedblocks(bt_ind) = handles.prtclData(blocktrials(bt_ind)).trialBlock;
%         combinedblocksnums(bt_ind) = handles.prtclData(blocktrials(bt_ind)).combinedTrialBlock;
%     end
% end
% 
% [blocks,ind] = unique(blocks);
% if ~isempty(combinedblocks)
%     combinedblocks = combinedblocks(ind);
%     combinedblocks = combinedblocks(combinedblocks>0);
%     combinedblocksnums = combinedblocksnums(ind);
%     combinedblocksnums = combinedblocksnums(combinedblocksnums>0);
%     disp(['Blocks ' sprintf('%d ', blocks) 'constitute combined blocks ' sprintf('%d ',combinedblocksnums)])
% end
% tags = tags(ind);
% 
% % make a little dialog that creates checkboxes and populates the window
% % with choices
% 
% blocks2combine = selectFromCheckBoxes(blocks,tags,'title','select blocks, dbl click to continue','prechecked',ismember(blocks,combinedblocks));
% if isempty(blocks2combine)
%     error('No block pairs selected for combination');
% end
% 
% blocks2combine = blocks(logical(blocks2combine));
% fprintf('(Un)Combining Blocks: ')
% fprintf('%d, ', blocks2combine);
% fprintf('\n');
% 
% for prt_ind = 1:length(handles.prtclData)
%     if sum(blocks2combine==handles.prtclData(prt_ind).trialBlock)
%         handles.prtclData(prt_ind).combinedTrialBlock = handles.trial.params.trialBlock;
%         trial = load(fullfile(handles.dir,sprintf(handles.trialStem,handles.prtclData(prt_ind).trial)));
%         trial.params.combinedTrialBlock = handles.trial.params.trialBlock;
%         save(trial.name, '-struct', 'trial');
%     else 
%         handles.prtclData(prt_ind).combinedTrialBlock = 0;
%         trial = load(fullfile(handles.dir,sprintf(handles.trialStem,handles.prtclData(prt_ind).trial)));
%         if isfield('trial.params','combinedTrialBlock')
%             trial.params = rmfield(trial.params,'combinedTrialBlock');
%         end
%         save(trial.name, '-struct', 'trial');
%     end
% 
% end
% data = handles.prtclData; %#ok<NASGU>
% save(handles.prtclDataFileName,'data');
% guidata(hObject,handles)


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
save(trial.name, '-struct', 'trial');
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
vid = VideoReader(handles.trial.imageFile);
imstr = sprintf('Video Reader Info, trial %d:\nDuration: %.2f\nFrameRate: %.2f\nSize: %d x %d x %.0f',...
    handles.trial.params.trial,...
    vid.Duration,...
    vid.FrameRate,...
    vid.Width,...
    vid.Height,...
    vid.FrameRate*vid.Duration);
msgbox(imstr,'VideoReader Info')


% --- Executes on button press in spike_spot_check_button.
function spike_spot_check_button_Callback(hObject, eventdata, handles)
global cmd

handles = guidata(hObject);
imstr = sprintf('Spike Vars, trial %d:\nHighpass: %.2f - Lowpass: %.2f - Diff: %d\nPeak: %.2f - Distance: %.2f\nLast Trial: %s\n',...
    handles.trial.params.trial,...
    handles.trial.spikeDetectionParams.hp_cutoff,...
    handles.trial.spikeDetectionParams.lp_cutoff,...
    handles.trial.spikeDetectionParams.diff,...
    handles.trial.spikeDetectionParams.peak_threshold,...
    handles.trial.spikeDetectionParams.Distance_threshold,...
    handles.trial.spikeDetectionParams.lastfilename(end-19:end-4));
% msgbox(imstr,'Spike Vars')
fprintf(imstr)

switch handles.trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end

if ~isempty(handles.trial.spikes)
    cmd = [];
end
spikeSpotCheck(handles.trial,invec1,handles.trial.spikeDetectionParams);
if ~isempty(handles.trial.spikes)
    uiwait();
else 
    butt = questdlg('No spikes detected. Spot check OK?','Spot checking no spike','Yes');
    switch butt
        case 'Yes'
            handles.trial.spikeSpotChecked = 1;
        otherwise
            handles.trial.spikeSpotChecked = 0;
    end
    trial = handles.trial;
    save(trial.name, '-struct', 'trial');
end

guidata(hObject,handles)
trialnum_Callback(handles.trialnum, eventdata, handles)
handles = guidata(hObject);

if isempty(cmd)
elseif strcmp(cmd,'next')
    while isfield(handles.trial,'spikeSpotChecked') && handles.trial.spikeSpotChecked
        cur = str2double(handles.trialnum.String);
        handles.trialnum.String = num2str(cur+1);
        trialnum_Callback(handles.trialnum, eventdata, handles)
        handles = guidata(hObject);
    end
    spike_spot_check_button_Callback(hObject, eventdata, handles)
end    


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
        'exclude',{'step','amp','displacement','freq','speed','ndf'});
    for n_ind = 1:length(nums)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,nums(n_ind))));
        trial.tags = s;
        save(trial.name, '-struct', 'trial');
    end
else
    trial = handles.trial;
    save(trial.name, '-struct', 'trial');
end
guidata(hObject, handles);
trialnum_Callback(handles.trialnum, eventdata, handles)



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
        save(trial.name, '-struct', 'trial');
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
    for a = 1:size(handles.trial.annotation,1)
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

fprintf('Edit raw_folder_location_Callback to find the video file location\n')
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
      %clc
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
'reCheckSpikes'
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
            save(trial.name, '-struct', 'trial');
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
    save(trial.name, '-struct', 'trial');
    guidata(hObject, handles);
    return
end

function add_tags_to_subplots(hObject, eventdata, handles)  
ax1 = findobj(handles.quickShowPanel,'tag','quickshow_outax');
ax2 = findobj(handles.quickShowPanel,'tag','quickshow_inax');

[prot,d,fly,cell,trialnum] = extractRawIdentifiers(handles.trial.name);

xlims = get(ax2,'xlim');
ylims = get(ax2,'ylim');
if ~isempty(xlims)
    text(xlims(1)+.05*diff(xlims),ylims(1)+.05*diff(ylims),...
        sprintf('%s', [prot '.' d '.' fly '.' cell '.' trialnum]),...
        'parent',ax1,'fontsize',7,'tag','delete');
    if isfield(handles.trial,'tags') && ~isempty(handles.trial.tags)
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
if strcmp(button,'Cancel') || strcmp(button,'No'), return, end

handles = guidata(hObject);
if strcmp(button,'Yes')
    nums = findLikeTrials_includingExcluded('name',handles.trial.name,'datastruct',handles.prtclData,...
        'exclude',{'step','amp','displacement','freq','speed','ndf'});
    ex = handles.trial.excluded;
    switch ex
        case 1 
            fprintf('Trial is excluded, excluding others in block\n');
        case 0
            fprintf('Trial is included, including others in block\n');
    end
    
    for n_ind = 1:length(nums)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,nums(n_ind))));
        trial.excluded = ex;
        save(trial.name, '-struct', 'trial');
    end
else
    trial = handles.trial;
    save(trial.name, '-struct', 'trial');
end

guidata(hObject, handles);

function removeSpikes(hObject,eventdata,handles)
button = questdlg('RemoveSpikes for entire block?','Remove Spikes','No');
if strcmp(button,'Cancel'), return, end

handles = guidata(hObject);
if strcmp(button,'Yes')
    nums = findLikeTrials_includingExcluded('name',handles.trial.name,'datastruct',handles.prtclData,...
        'exclude',{'step','amp','displacement','freq','ndf'});
    for n_ind = 1:length(nums)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,nums(n_ind))));
        d = 0;
        if isfield(trial,'spikes')
            d = length(trial.spikes);
            trial = rmfield(trial,'spikes');
        end
        if isfield(trial,'spikes_uncorrected')
            trial = rmfield(trial,'spikes_uncorrected');
        end
        if isfield(trial,'spikeDetectionParams')
            trial = rmfield(trial,'spikeDetectionParams');
        end
        if isfield(trial,'spikeSpotChecked')
            trial = rmfield(trial,'spikeSpotChecked');
        end

        save(trial.name, '-struct', 'trial');
        fprintf('%d spikes removed from trial %d\n',d,trial.params.trial);
        
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
    save(trial.name, '-struct', 'trial');
    handles.trial = trial;
    fprintf('Spikes removal complete\n');
        
    set(handles.Spikes,'Value',0);
    guidata(handles.Spikes,handles)
    trialnum_Callback(handles.trialnum, eventdata,handles)
end

guidata(hObject, handles);


function reDetectSpikes(hObject,eventdata,handles)

handles = guidata(hObject);
trial = handles.trial;
switch handles.trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end

button = questdlg('Use params from preferences?','Preferences','No');
% button = 'No';
if strcmp(button,'No')
    spikeDetection(trial,invec1,trial.spikeDetectionParams);
elseif strcmp(button,'Yes')
    fstag = ['fs' num2str(trial.params.sampratein)];
    spikevars = getacqpref('FlyAnalysis',['Spike_params_' invec1 '_' fstag]);
    [~,spikevars] = spikeDetection(trial,invec1,spikevars);
end
figure(gcbf);
guidata(hObject, handles);
trialnum_Callback(handles.trialnum, eventdata, handles)


function reCheckSpikes(hObject,eventdata,handles)

handles = guidata(hObject);
handles.trial.spikeSpotChecked = 0;
trial = handles.trial;
save(trial.name, '-struct', 'trial');

handles.spike_spot_check_button.Enable = 'on';

guidata(hObject, handles);


function removeKmeansStuff(hObject,eventdata,handles)
button = questdlg('Remove Kmeans stuff for entire block?','Remove Kmeans','Yes');
if strcmp(button,'Cancel'), return, end

handles = guidata(hObject);
if strcmp(button,'Yes')
    nums = findLikeTrials_includingExcluded('name',handles.trial.name,'datastruct',handles.prtclData,...
        'exclude',{'step','amp','displacement','freq'});
    for n_ind = 1:length(nums)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,nums(n_ind))));
        trial = rmfield(trial,'kmeans_ROI');
        trial = rmfield(trial,'kmeans_threshold');
        trial = rmfield(trial,'clmask');
        trial = rmfield(trial,'clustertraces');
        save(trial.name, '-struct', 'trial');
    end
else
    trial = handles.trial;
    trial = rmfield(trial,'kmeans_ROI');
    trial = rmfield(trial,'kmeans_threshold');
    trial = rmfield(trial,'clmask');
    trial = rmfield(trial,'clustertraces');
    save(trial.name, '-struct', 'trial');
    handles.trial = trial;
end

guidata(hObject, handles);


function removeProbeLine(hObject,eventdata,handles)
button = questdlg('Remove Probe Line for entire block?','Remove Probe','Yes');
if strcmp(button,'Cancel'), return, end

handles = guidata(hObject);
if strcmp(button,'Yes')
    nums = findLikeTrials_includingExcluded('name',handles.trial.name,'datastruct',handles.prtclData,...
        'exclude',{'step','amp','ndf','displacement','freq','speed'});
    for n_ind = 1:length(nums)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,nums(n_ind))));
        try trial = rmfield(trial,'forceProbe_line'); 
        catch e, fprintf('%s\n',e.message); 
        end
        try trial = rmfield(trial,'forceProbe_tangent'); catch e, fprintf('%s\n',e.message); end
        save(trial.name, '-struct', 'trial');
    end
else
    trial = handles.trial;
        try trial = rmfield(trial,'forceProbe_line'); catch e, fprintf('%s\n',e.message); end
        try trial = rmfield(trial,'forceProbe_tangent'); catch e, fprintf('%s\n',e.message); end
    save(trial.name, '-struct', 'trial');
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
        save(trial.name, '-struct', 'trial');
    end
else
    trial = handles.trial;
    try
        trial = rmfield(trial,'forceProbeStuff');
    catch e
        if strcmp(e.identifier,'MATLAB:rmfield:InvalidFieldname')
            fprintf('No forceProbeStuff\n');
        else
            error(e)
        end
    end
    save(trial.name, '-struct', 'trial');
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
    save(trial.name, '-struct', 'trial');
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
    
