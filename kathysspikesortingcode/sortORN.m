function data = sortORN(event,value)

global gd

if nargin==0
    event = 'startup';
end

switch lower(event)
    case {'startup'}
        startup
    case('next')
        next
    case('prev')
        prev
    case('nextbit')
        nextbit
    case('prevbit')
        prevbit
    case('chspontth')
        chspontth
    case('chstimth')
        chstimth
    case('add')
        add
    case('delete')
        delete
    case {'keyboard'}
        keyboardHandler;
    case('done')
        done
end

%% startup
function startup
    global gd

    % define gd subfields
    gd.date =date;             % date to analyse
    gd.expnumber = 1;          % experiment number to analyse
    gd.n = 1;                  % trial to analyse
    gd.v = 0;                  % raw voltage trace
    gd.hp = 0;                 % high-pass filtered voltage
    gd.d = 0;                  % voltage derivative
    gd.s = 0;                  % odor stimulus
    gd.t = 0;                  % time vector 
    gd.thspont = -0.3;           % threshold during spontaneous activity;
    gd.thstim = 0.12;           % threshold during stimulus
    gd.sparray = 0;                 % spike array for current trial
    
    gd.info = struct([]);           % data structure of data to analyse
    
    gd.zoomfig = 0;        % pointer to zoom window
    gd.trialfig = 0;       % pointer to overview figure
    
    % select data to analyse
    prompt = {'Date','Exp Number','Trial number'};
    defaultAns = {date,'1','1'};
    sizevect = [ones(length(prompt),1) 25*ones(length(prompt),1)];
    inputStr = inputdlg(prompt,'Choose experiment to analyse',1,defaultAns,'on');
    gd.date = inputStr{1};
    gd.expnumber = inputStr{2};
    gd.n = str2num(inputStr{3});
    
    % check input and load file
    fid = fopen([gd.date,'/SortedORN_',gd.date,'_E',gd.expnumber,'.mat']);
    if fid == -1
        [gd.date,'\WCwaveform_',gd.date,'_E',gd.expnumber,'.mat']
        fid2 = fopen([gd.date,'/WCwaveform_',gd.date,'_E',gd.expnumber,'.mat']);
        if fid2 == -1
            fprintf('Could not find data\n');
            return;
        else
            fclose(fid2);
            gd.info = load([gd.date,'/WCwaveform_',gd.date,'_E',gd.expnumber,'.mat'],'data');
        end
    else
        fid = fopen([gd.date,'/Peaks_',gd.date,'_E',gd.expnumber,'.mat']);
        if fid == -1
            fprintf('Loading previous sort...\n');
            
            gd.info = load([gd.date,'/SortedORN_',gd.date,'_E',gd.expnumber,'.mat'],'data');
        else
            fprintf('Loading peaks data...\n');
            fclose(fid);
            gd.info = load([gd.date,'/Peaks_',gd.date,'_E',gd.expnumber,'.mat'],'data');
        end
    end

    
    plotFigs;
        
    % load trial
    loadTrial(gd.n);

    
%% load trial
function loadTrial(n)

    global gd
    
    load([gd.date,'/Raw_WCwaveform_',gd.date,'_E',gd.expnumber,'_',num2str(n)]);
    gd.v = voltage;
    %gd.s = odor;
    odor = gd.info.data(gd.n).odor+gd.info.data(gd.n).odor2;
    odor = repmat(odor',10,1); gd.s = odor(:);
    gd.t = [1:gd.info.data(gd.n).nsampin]'/gd.info.data(gd.n).sampratein; 
    
    % smooth and differentiate
	[b a] = butter(2,15/5000,'high');
	gd.hp = filtfilt(b,a,gd.v);
    gd.d = conv(diff(gd.hp),hanning(7)); gd.d = gd.d(4:end-2);
    
%     [b a] = butter(2,[150/5000 1000/5000],'bandpass');
%     gd.d = filtfilt(b,a,gd.v);
    
    
    sortTrial;
    
%% sort trial (apply new threshold)    
function sortTrial

    global gd

    % detect threshold crossings
    ind = gettimestamps(gd.thspont,gd.d,'-');
    indstim = gettimestamps(gd.thstim,gd.d,'-');
    indstim2 = gettimestamps(0.05,gd.d,'-');
    
    %eliminate double-crossings 
    ind(find(diff(ind)<20)) = [];
    indstim(find(diff(indstim)<20)) = [];
    indstim2(find(diff(indstim2)<20)) = [];
    
    % combine thresholds
    gd.sparray = sparse(ind,1,1,length(gd.v),1);
    sparraystim = sparse(indstim,1,1,length(gd.v),1);
    sparraystim2 = sparse(indstim2,1,1,length(gd.v),1);
    gd.sparray(1600+find(gd.s~=0)) = sparraystim(1600+find(gd.s~=0));
    gd.sparray(3400+find(gd.s~=0)) = sparraystim(3400+find(gd.s~=0));
    gd.sparray(4000+find(gd.s~=0)) = sparraystim(4000+find(gd.s~=0));
     gd.sparray(4500+find(gd.s~=0)) = sparraystim(4500+find(gd.s~=0));
     gd.sparray(5500+find(gd.s~=0)) = sparraystim(5500+find(gd.s~=0));
 %    gd.sparray(6500+find(gd.s~=0)) = sparraystim(6500+find(gd.s~=0));
%     gd.sparray(7500+find(gd.s~=0)) = sparraystim(7500+find(gd.s~=0));
%     gd.sparray(8500+find(gd.s~=0)) = sparraystim(8500+find(gd.s~=0))
    
    on = gettimestamps(0.5,gd.s,'+');
%    up = [1:6000]+on(1);
%    up = repmat([1:6000],length(on(1:3)),1)'+repmat(on(1:3),1,6000)';
    %up = up(:);
%         gd.sparray(2250+find(gd.s~=0)) = sparraystim(2250+find(gd.s~=0));
%     gd.sparray(2800+find(gd.s~=0)) = sparraystim2(2800+find(gd.s~=0));
 %     gd.sparray(2800+up) = sparraystim2(2800+up);
%     gd.sparray(4200+find(gd.s~=0)) = sparraystim(4200+find(gd.s~=0));
%     %gd.sparray(7400+find(gd.s~=0)) = sparraystim2(7400+find(gd.s~=0));
    
    updateOverview([0 0.5]);
    updateZoom([0 0.5]);

    
%% update figures 
function updateOverview(a)
    global gd
    
    % overview figure
     gd.trialfig.fig = figure(1);
%     set(gcf,'Position',[7  6   994   210]);
%     set(gcf,'PaperPositionMode','auto');

    psth = 1000*hanningsmooth(full(sparse(ceil(find(gd.sparray)/10),1,1,ceil(length(gd.v)/10),1)),50);
    tpsth = [1:length(psth)]/1000;
    subplot(2,1,1); hold off; plot(tpsth,psth,'k'); 
        set(gca,'Xlim',[0 max(gd.t)]);
        box off; set(gca,'TickDir','out');
        ylabel('PSTH (Hz)');
        
    subplot(2,1,2); hold off; plot(gd.t,gd.d,'b'); ylabel('d1');
        hold on; plot([0 max(gd.t)],[gd.thspont gd.thspont],'b:');
        hold on; plot([0 max(gd.t)],[gd.thstim gd.thstim],'r:');
        set(gca,'Xlim',[0 max(gd.t)]);
        box off; set(gca,'TickDir','out');
        set(gca,'Ylim',[1.8*min(gd.d(1:20000)) 1.8*max(gd.d(1:20000))]);
        xlabel('time (seconds)'); 
    
function updateZoom(a)
    global gd
    % zoom figure
    gd.zoomfig.fig = figure(2);
%     set(gcf,'Position',[0         259        1017         438]);
%     set(gcf,'PaperPositionMode','auto');
        t=[1:gd.info.data(gd.n).nsampin]'/gd.info.data(gd.n).sampratein;    
    xlim = a*10000+1;    
    temparray = gd.sparray(xlim(1):min(xlim(2),length(gd.sparray)));
    v = gd.v(xlim(1):min(xlim(2),length(gd.sparray)));
    d = gd.d(xlim(1):min(xlim(2),length(gd.sparray)));

    gd.zoomfig.raw = subplot(2,1,1); hold off; plot(t,gd.v,'b','lineWidth',1); ylabel('V(mV)');
        y = v(find(temparray)); 
        y = [y(:)'-1; y(:)'+1];
        x = a(1)+[find(temparray)';find(temparray)']/10000;
        hold on; plot(x,y,'k');
        set(gca,'Xlim',[0 max(t)]);
        %set(gca,'Ylim',[-90 10]);
        box off; set(gca,'TickDir','out'); 
        set(gca,'Xlim',a);
        title(sprintf('%s Exp %s, trial %d of %d',gd.date,gd.expnumber,gd.n,length(gd.info.data)));
        

    gd.zoomfig.d = subplot(2,1,2); hold off; plot(t,gd.d,'r'); ylabel('d1');
        y = d(find(temparray)); 
        y = [y(:)'-0.1; y(:)'+0.1];
        hold on; plot(x,y,'k','lineWidth',2);
        hold on; plot([0 max(gd.t)],[gd.thspont gd.thspont],'b:');
        hold on; plot([0 max(gd.t)],[gd.thstim gd.thstim],'r:');
        set(gca,'Xlim',[0 max(gd.t)]);
        box off; set(gca,'TickDir','out');
        set(gca,'Ylim',[1.8*min(gd.d(1:20000)) 1.8*max(gd.d(1:20000))]);
        set(gca,'Xlim',a);

function saveData  
    global gd
    ind = find(gd.sparray);
    gd.info.data(gd.n).sparray = sparse(ceil(ind/10),1,1,ceil(length(gd.v)/10),1);
    gd.info.data(gd.n).psth = 1000*hanningsmooth(full(gd.info.data(gd.n).sparray),50);
    data = gd.info.data;
    save([gd.date,'/SortedORN_',gd.date,'_E',gd.expnumber,'.mat'],'data');

function next    
global gd
if gd.n==length(gd.info.data)
    fprintf('last trial\n');
else
    saveData;
    gd.n = gd.n+1;    
    loadTrial(gd.n);
end
    
function prev    
global gd
if gd.n==0
    fprintf('already on first trial\n');
else
    saveData;
    gd.n = gd.n-1;
    loadTrial(gd.n);
end
    
function nextbit
global gd
    a = get(gd.zoomfig.raw,'Xlim');
    set(gd.zoomfig.raw,'Xlim',[a(2) a(2)+0.5]);
    set(gd.zoomfig.d,'Xlim',[a(2) a(2)+0.5]);
    updateZoom([a(2) a(2)+0.5]);
    
function prevbit
global gd
    a = get(gd.zoomfig.raw,'Xlim');
    set(gd.zoomfig.raw,'Xlim',[a(1)-0.5 a(1)]);
    set(gd.zoomfig.d,'Xlim',[a(1)-0.5 a(1)]);
    updateZoom([a(1)-0.5 a(1)]);
    
function chspontth
global gd
    gd.thspont = str2num(get(gd.trialfig.spthresh,'String'));
    sortTrial;

function chstimth
global gd
    gd.thstim = str2num(get(gd.trialfig.stthresh,'String'));
    sortTrial;

function add
global gd
    x = ginput(1);
    ind = [find(gd.sparray); round(x(1)*10000)];
    gd.sparray = sparse(ind,1,1,length(gd.v),1);
    a = get(gd.zoomfig.raw,'Xlim');
    updateOverview(a);
    updateZoom(a);
    
function delete
global gd
    x = ginput(1);
    ind = find(gd.sparray);
    [indmin i] = min(abs(ind-round(x(1)*10000)));
    ind(i) = [];
    gd.sparray = sparse(ind,1,1,length(gd.v),1);
    a = get(gd.zoomfig.raw,'Xlim');
    updateOverview(a);
    updateZoom(a);

function keyboardHandler

global gd;
leftarrow = 28;
rightarrow = 29;

% get the character
c = get(gcbf,'CurrentCharacter');

switch c
  case {leftarrow,'p'}
    prevbit;
  case {rightarrow,'n'}
    nextbit;
  case {'a'}
      add;
  case {'d'}
      delete;
end
    
function done    
global gd
    saveData;
    close all;
    clear all;
    clear global;
    
%% plot figures 
function plotFigs
    global gd
    
    % overview figure
    gd.trialfig.fig = figure(1);
    set(gcf,'Position',[15          26        1230         203]);
    set(gcf,'PaperPositionMode','auto');
    set(gd.trialfig.fig,'KeyPressFcn','sortORN(''keyboard'')');

   nextbutton = uicontrol(...
        'Parent',gd.trialfig.fig,...
        'Units','characters',...
        'Callback','sortORN(''next'')',...
        'Position',[160 3 8 2.6],...
        'String',{'Next' },...
        'Tag','NextButton');

    prevbutton = uicontrol(...
        'Parent',gd.trialfig.fig,...
        'Units','characters',...
        'Callback','sortORN(''prev'')',...
        'Position',[8 3 8 2.6],...
        'String',{'Previous' },...
        'Tag','PrevButton');
    
    gd.trialfig.spthresh = uicontrol(...
        'Parent',gd.trialfig.fig,...
        'Units','characters',...
        'Callback','sortORN(''chspontth'')',...
        'Position',[160 9.5 10 2.6],...
        'String',num2str(gd.thspont),...
        'Style','edit');

    gd.trialfig.stthresh = uicontrol(...
        'Parent',gd.trialfig.fig,...
        'Units','characters',...
        'Callback','sortORN(''chstimth'')',...
        'Position',[160 12.5 10 2.6],...
        'String',num2str(gd.thstim),...
        'Style','edit');



    % zoom figure
    gd.zoomfig.fig = figure(2);
    set(gcf,'Position',[15         284        1231         434]);
    set(gcf,'PaperPositionMode','auto');
    set(gd.zoomfig.fig,'KeyPressFcn','sortORN(''keyboard'')');
        t=[1:gd.info.data(gd.n).nsampin]'/gd.info.data(gd.n).sampratein; 

    gd.zoomfig.raw = subplot(2,1,1); hold off; 
    gd.zoomfig.d = subplot(2,1,2); hold off; 

    nextbitbutton = uicontrol(...
        'Parent',gd.zoomfig.fig,...
        'Units','characters',...
        'Callback','sortORN(''nextbit'')',...
        'Position',[160 3 10 2.6],...
        'String',{'Next' },...
        'Tag','NextButton');

    prevbitbutton = uicontrol(...
        'Parent',gd.zoomfig.fig,...
        'Units','characters',...
        'Callback','sortORN(''prevbit'')',...
        'Position',[8 3 10 2.6],...
        'String',{'Previous' },...
        'Tag','PrevButton');

    addbutton = uicontrol(...
        'Parent',gd.zoomfig.fig,...
        'Units','characters',...
        'Callback','sortORN(''add'')',...
        'Position',[160 26 10 2.6],...
        'String',{'Add' },...
        'Tag','AddButton');

    deletebutton = uicontrol(...
        'Parent',gd.zoomfig.fig,...
        'Units','characters',...
        'Callback','sortORN(''delete'')',...
        'Position',[160 22 10 2.6],...
        'String',{'Delete' },...
        'Tag','DeleteButton');

    donebutton = uicontrol(...
        'Parent',gd.zoomfig.fig,...
        'Units','characters',...
        'Callback','sortORN(''done'')',...
        'Position',[160 14 10 2.6],...
        'String',{'DONE' },...
        'Tag','DoneButton');