function data = sortPN(event,value)

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
    gd.thspont = 0.3;           % threshold during spontaneous activity;
    gd.thstim = 0.3;           % threshold during stimulus
    gd.sparray = 0;                 % spike array for current trial
    
    gd.info = struct([]);           % data structure of data to analyse
    
    gd.zoomfig = 0;        % pointer to zoom window
    gd.trialfig = 0;       % pointer to overview figure
    
    % select data to analyse
    prompt = {'Date','Exp Number','Trial number'};
    defaultAns = {date,'1','1'};
    sizevect = [ones(length(prompt),1) 25*ones(length(prompt),1)];
    inputStr = inputdlg(prompt,'Choose experiment to analyse',sizevect,defaultAns,'on');
    gd.date = inputStr{1};
    gd.expnumber = inputStr{2};
    gd.n = str2num(inputStr{3});
    
    % check input and load file
    fid = fopen([gd.date,'/SortedPN_',gd.date,'_E',gd.expnumber,'.mat']);
    if fid == -1
        fid = fopen([gd.date,'/PIDPeaks_',gd.date,'_E',gd.expnumber,'.mat']);
        if fid== -1
            fid2 = fopen([gd.date,'/WCwaveform_',gd.date,'_E',gd.expnumber,'.mat']);
            if fid2 == -1
                fprintf('Could not find data\n');
                return;
            else
                fclose(fid2);
                gd.info = load([gd.date,'/WCwaveform_',gd.date,'_E',gd.expnumber,'.mat'],'data');
            end
        else
            fprintf('Loading peaks data...\n');
            fclose(fid);
            gd.info = load([gd.date,'/PIDPeaks_',gd.date,'_E',gd.expnumber,'.mat'],'data');
        end
    else
            fprintf('Loading previous sort...\n');   
            gd.info = load([gd.date,'/SortedPN_',gd.date,'_E',gd.expnumber,'.mat'],'data');
    end

    
    plotFigs;
        
    % load trial
    loadTrial(gd.n);

    
%% load trial
function loadTrial(n)

    global gd
    
    load([gd.date,'/Raw_WCwaveform_',gd.date,'_E',gd.expnumber,'_',num2str(n)]);
    gd.v = voltage;
    gd.s = odor;
    gd.t = [1:gd.info.data(gd.n).nsampin]'/gd.info.data(gd.n).sampratein; 
    
    % smooth and differentiate
	[b a] = butter(2,25/5000,'high');
	gd.hp = filtfilt(b,a,gd.v);   
    gd.d = conv(diff(gd.hp),hanning(7)); gd.d = gd.d(4:end-2);
    gd.d2 = gd.d;
    %gd.d2 = conv(diff(gd.d),hanning(5)); gd.d2 = gd.d2(3:end-1);
    
    sortTrial;
    
%% sort trial (apply new threshold)    
function sortTrial

    global gd

    % detect threshold crossings
    ind = gettimestamps(gd.thspont,gd.d,'-');
    indstim = gettimestamps(gd.thstim,gd.d2,'-');
    
    %eliminate double-crossings 
    ind(find(diff(ind)<20)) = [];
    indstim(find(diff(indstim)<10)) = [];
    
    % combine thresholds
    gd.sparray = sparse(ind,1,1,length(gd.v),1);
    sparraystim = sparse(indstim,1,1,length(gd.v),1);
    gd.sparray(1500+find(gd.s~=0)) = sparraystim(1500+find(gd.s~=0));
    gd.sparray(3000+find(gd.s~=0)) = sparraystim(3000+find(gd.s~=0));
    
    updateFigs([0 0.5]);

    
%% update figures 
function updateFigs(a)
    global gd
    
    % overview figure
    gd.trialfig.fig = figure(1);
    %set(gcf,'Position',[22 152 1200  242]);
    %set(gcf,'PaperPositionMode','auto');

    psth = 1000*hanningsmooth(full(sparse(ceil(find(gd.sparray)/10),1,1,ceil(length(gd.v)/10),1)),50);
    tpsth = [1:length(psth)]/1000;
    subplot(2,1,1); hold off; plot(tpsth,psth,'k'); 
        set(gca,'Xlim',[0 max(gd.t)]);
        box off; set(gca,'TickDir','out');
        ylabel('PSTH (Hz)');
        
    subplot(2,1,2); hold off; plot(gd.t,gd.d,'g'); ylabel('d1');
        hold on; plot([0 max(gd.t)],[gd.thspont gd.thspont],'b:');
        hold on; plot([0 max(gd.t)],[gd.thstim gd.thstim],'r:');
        set(gca,'Xlim',[0 max(gd.t)]);
        box off; set(gca,'TickDir','out');
        set(gca,'Ylim',[1.2*min(gd.d) 1.2*max(gd.d)]);
        xlabel('time (seconds)'); 


    % zoom figure
    gd.zoomfig.fig = figure(2);
    %set(gcf,'Position',[22         485        1200         454]);
    %set(gcf,'PaperPositionMode','auto');
        t=[1:gd.info.data(gd.n).nsampin]'/gd.info.data(gd.n).sampratein; 

    gd.zoomfig.raw = subplot(2,1,1); hold off; plot(t,gd.v,'b','lineWidth',1); ylabel('V(mV)');
        y = gd.v(find(gd.sparray)); 
        y = [y(:)'-5; y(:)'+5];
        x = [find(gd.sparray)';find(gd.sparray)']/10000;
        hold on; plot(x,y,'k');
        set(gca,'Xlim',[0 max(t)]);
        %set(gca,'Ylim',[-90 10]);
        box off; set(gca,'TickDir','out'); 
        set(gca,'Xlim',a);
        title(sprintf('%s Exp %s, trial %d of %d',gd.date,gd.expnumber,gd.n,length(gd.info.data)));
        

    gd.zoomfig.d = subplot(2,1,2); hold off; plot(t,gd.d,'r'); ylabel('d1');
        y = gd.d(find(gd.sparray)); 
        y = [y(:)'-0.5; y(:)'+0.5];
        hold on; plot(x,y,'k');
        hold on; plot([0 max(gd.t)],[gd.thspont gd.thspont],'b:');
        hold on; plot([0 max(gd.t)],[gd.thstim gd.thstim],'r:');
        set(gca,'Xlim',[0 max(gd.t)]);
        box off; set(gca,'TickDir','out');
        set(gca,'Ylim',[1.2*min(gd.d) 1.2*max(gd.d)]);
        set(gca,'Xlim',a);

function saveData  
    global gd
    ind = find(gd.sparray);
    gd.info.data(gd.n).sparray = sparse(ceil(ind/10),1,1,ceil(length(gd.v)/10),1);
    gd.info.data(gd.n).psth = 1000*hanningsmooth(full(gd.info.data(gd.n).sparray),50);
    data = gd.info.data;
    save([gd.date,'/SortedPN_',gd.date,'_E',gd.expnumber,'.mat'],'data');

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
    
function prevbit
global gd
    a = get(gd.zoomfig.raw,'Xlim');
    set(gd.zoomfig.raw,'Xlim',[a(1)-0.5 a(1)]);
    set(gd.zoomfig.d,'Xlim',[a(1)-0.5 a(1)]);
    
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
    updateFigs(a);
    
function delete
global gd
    x = ginput(1);
    ind = find(gd.sparray);
    [indmin i] = min(abs(ind-round(x(1)*10000)));
    ind(i) = [];
    gd.sparray = sparse(ind,1,1,length(gd.v),1);
    a = get(gd.zoomfig.raw,'Xlim');
    updateFigs(a);

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
    set(gd.trialfig.fig,'KeyPressFcn','sortPN(''keyboard'')');

   nextbutton = uicontrol(...
        'Parent',gd.trialfig.fig,...
        'Units','characters',...
        'Callback','sortPN(''next'')',...
        'Position',[160 3 8 2.6],...
        'String',{'Next' },...
        'Tag','NextButton');

    prevbutton = uicontrol(...
        'Parent',gd.trialfig.fig,...
        'Units','characters',...
        'Callback','sortPN(''prev'')',...
        'Position',[8 3 8 2.6],...
        'String',{'Previous' },...
        'Tag','PrevButton');
    
    gd.trialfig.spthresh = uicontrol(...
        'Parent',gd.trialfig.fig,...
        'Units','characters',...
        'Callback','sortPN(''chspontth'')',...
        'Position',[160 9.5 10 2.6],...
        'String',num2str(gd.thspont),...
        'Style','edit');

    gd.trialfig.stthresh = uicontrol(...
        'Parent',gd.trialfig.fig,...
        'Units','characters',...
        'Callback','sortPN(''chstimth'')',...
        'Position',[160 12.5 10 2.6],...
        'String',num2str(gd.thstim),...
        'Style','edit');



    % zoom figure
    gd.zoomfig.fig = figure(2);
    set(gcf,'Position',[15         284        1231         434]);
    set(gcf,'PaperPositionMode','auto');
        t=[1:gd.info.data(gd.n).nsampin]'/gd.info.data(gd.n).sampratein; 
    set(gd.zoomfig.fig,'KeyPressFcn','sortPN(''keyboard'')');

    gd.zoomfig.raw = subplot(2,1,1); hold off; 
    gd.zoomfig.d = subplot(2,1,2); hold off; 

    nextbitbutton = uicontrol(...
        'Parent',gd.zoomfig.fig,...
        'Units','characters',...
        'Callback','sortPN(''nextbit'')',...
        'Position',[160 3 10 2.6],...
        'String',{'Next' },...
        'Tag','NextButton');

    prevbitbutton = uicontrol(...
        'Parent',gd.zoomfig.fig,...
        'Units','characters',...
        'Callback','sortPN(''prevbit'')',...
        'Position',[8 3 10 2.6],...
        'String',{'Previous' },...
        'Tag','PrevButton');

    addbutton = uicontrol(...
        'Parent',gd.zoomfig.fig,...
        'Units','characters',...
        'Callback','sortPN(''add'')',...
        'Position',[160 26 10 2.6],...
        'String',{'Add' },...
        'Tag','AddButton');

    deletebutton = uicontrol(...
        'Parent',gd.zoomfig.fig,...
        'Units','characters',...
        'Callback','sortPN(''delete'')',...
        'Position',[160 22 10 2.6],...
        'String',{'Delete' },...
        'Tag','DeleteButton');

    donebutton = uicontrol(...
        'Parent',gd.zoomfig.fig,...
        'Units','characters',...
        'Callback','sortPN(''done'')',...
        'Position',[160 14 10 2.6],...
        'String',{'DONE' },...
        'Tag','DoneButton');