function fig = AverageLikeSines(plotcanvas,handles,savetag)

if isfield(handles,'infoPanel')
    notes = get(handles.infoPanel,'userdata');
else
    a = dir([handles.dir '\notes_*']);

    fclose('all');
    handles.notesfilename = fullfile(handles.dir,a.name);
    handles.notesfid = fopen(handles.notesfilename,'r');

    notes = fileread(handles.notesfilename);
end

% block beginning
trlnnum = regexp(notes,[handles.currentPrtcl ' trial ' num2str(handles.params.trial) ','],'end');
trln = notes(1:trlnnum);
comments = regexp(trln,['\t' handles.currentPrtcl ' - '],'end');
comtxt = trln(comments(end):end);
if ~isempty(comtxt)
    bllnnum = regexp(comtxt,[handles.currentPrtcl ' trial\s\d*,'],'end');
    blln = comtxt(1:bllnnum(1));
    cm1 = regexp(blln,'trial\s\d*,','start');
    cm2 = regexp(blln,'trial\s\d*,','end');
    starttrnm = str2double(blln(cm1(1)+6:cm2(1)-1));
end

% block end
trlnnum = regexp(notes,[handles.currentPrtcl ' trial ' num2str(handles.params.trial) ',']);
trln = notes(trlnnum:end);
comments = regexp(trln,'\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\n','end');
comtxt = trln(1:comments(1));
if ~isempty(comtxt)
    bllnnum = regexp(comtxt,[handles.currentPrtcl ' trial '],'start');
    blln = comtxt(bllnnum(length(bllnnum)):end);
    newlnnum = regexp(blln,'\n');
    blln = blln(1:newlnnum(1));
    cm1 = regexp(blln,'\s\d*,','start');
    cm2 = regexp(blln,'\s\d*,','end');
    endtrnm = str2double(blln(cm1(1)+1:cm2(1)-1));
end

%% find like trials
for d = 1:length(handles.prtclData)
    if handles.prtclData(d).trial == handles.params.trial
        compare = handles.prtclData(d);
    end
end

likenums = [];
for d = 1:length(handles.prtclData)
    if handles.prtclData(d).trial < starttrnm || handles.prtclData(d).trial > endtrnm
        continue
    end
    fn = fieldnames(compare);
    e = true;
    for f = 1:length(fn)
        if strcmp('trial',fn{f})
            continue
        end
        switch isnumeric(handles.prtclData(d).(fn{f}))
            case true
                if handles.prtclData(d).(fn{f}) ~= compare.(fn{f})
                    e = false;
                    break
                end
            case false
                if handles.prtclData(d).(fn{f}) ~= compare.(fn{f})
                    e = false;
                    break
                end
        end
    end
    if e
        likenums(end+1) = handles.prtclData(d).trial;
    end
end

stem = [handles.dir '\' sprintf(handles.trialStem,handles.params.trial)];
[prot,d,fly,cell,trial,D] = extractRawIdentifiers(stem);


trials = likenums;

h(trials(1)) = figure(100+trials(1));
set(h,'tag',mfilename);
ax = subplot(3,1,[1 2],'parent',h(trials(1)));
trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(1))]);
x = makeTime(trial.params);
voltage = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load([D prot '_Raw_' d '_' fly '_' cell '_' num2str(trials(t))]);
    voltage(:,t) = trial.voltage;
end
plot(ax,x,voltage,'color',[1, .7 .7]); hold on
plot(ax,x,mean(voltage,2),'color',[.7 0 0]);

xlim([-.1 handles.params.stimDurInSec+ .15])

%title([d ' ' fly ' ' cell ' ' prot ' '  num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *.3) ' \mum'])
box(ax,'off');
set(ax,'TickDir','out');

% set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
% set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');

ax = subplot(3,1,3,'parent',h(trials(1)));
plot(ax,x,trial.sgsmonitor,'color',[0 0 1]); hold on;
text(-.1,5.2,[num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement *3) ' \mum'],'fontsize',7)

box(ax,'off');
set(ax,'TickDir','out');

% set(ax,'TickDir','out','XColor',[1 1 1],'XTick',[],'XTickLabel','');
% set(ax,'TickDir','out','YColor',[1 1 1],'YTick',[],'YTickLabel','');

xlim([-.1 handles.params.stimDurInSec+ .15])
%ylim([4.5 5.5])
