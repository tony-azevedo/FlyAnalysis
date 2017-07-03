function h = VoltageSineAverage(h,handles,savetag)
% see also AverageLikeSongs

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
end

set(h,'tag',mfilename);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if isfield(trial.params,'mode_1')
    end1 = '_1';
    end2 = '_2';   
else
    end1 = '';
end
dual = exist('end2','var');

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.(['mode' end1])))
    y_name = 'voltage';
    y_units = 'mV';
    outname = 'current';
    outunits = 'pA';
elseif sum(strcmp('VClamp',trial.params.(['mode' end1])))
    y_name = 'current';
    y_units = 'pA';
    outname = 'voltage';
    outunits = 'mV';
end
if dual
    if sum(strcmp({'IClamp','IClamp_fast'},trial.params.(['mode' end2])))
        y_name2 = 'voltage';
        y_units2 = 'mV';
        outname2 = 'current';
        outunits2 = 'pA';
    elseif sum(strcmp('VClamp',trial.params.(['mode' end2])))
        y_name2 = 'current';
        y_units2 = 'pA';
        outname2 = 'voltage';
        outunits2 = 'mV';
    end
end

y = zeros(length(x),length(trials));
if dual, y2 = y; end

for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.([y_name end1])(1:length(x));
    if dual
        y2(:,t) = trial.([y_name2 end2])(1:length(x));
    end
end

if dual
    ax = subplot(3,1,1,'parent',h);
else
    ax = subplot(3,1,[1 2],'parent',h);
end
y_ = mean(y,2);
x_win = x>= trial.params.ramptime & x<trial.params.stimDurInSec-trial.params.ramptime;

s = VoltageSineStim(trial.params)/trial.params.amp;
[cyclemat,ascd,peak,desc,vall] = findSineCycle(s(x_win),0,[]);
r = min(diff(ascd));
x_ = x(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1)); 
x_ = x_-x_(1);
s_ = s(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
y = zeros(r,length(diff(ascd)));
y_inwin = y_(x_win);
for c = 1:length(diff(ascd))
    y(:,c) = y_inwin(ascd(c):ascd(c)+r-1);
end

plot(ax,x_,y,'color',[1, .7 .7],'tag',savetag); hold on
y_ = mean(y,2);
plot(ax,x_,y_,'color',[.7 0 0],'tag',savetag);

axis(ax,'tight')
% xlim([-.1 trial.params.stimDurInSec+ min(.25,trial.params.postDurInSec)])
text(0,mean(y_),...
    [num2str(trial.params.freq) ' Hz ' num2str(trial.params.amp) ' mV'],...
    'fontsize',7,'parent',ax,'tag',savetag,'verticalAlignment','bottom')

[prot,d,fly,cell,trialnum] = extractRawIdentifiers(trial.name);
title(ax,sprintf('%s - %d Hz %.1f mV', [prot '.' d '.' fly '.' cell '.' trialnum], trial.params.freq,trial.params.amp));
box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);
set(ax,'tag','response_ax');

ax = subplot(3,1,3,'parent',h);
plot(ax,x_,s_,'color',[0 0 1],'tag',savetag); hold on;

box(ax,'off');
axis(ax,'tight');

set(ax,'TickDir','out');
set(ax,'tag','stimulus_ax');