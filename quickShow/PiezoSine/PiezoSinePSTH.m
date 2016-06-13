function h = PiezoSinePSTH(h,handles,savetag,varargin)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('trials',[],@isnumeric);
parse(p,varargin{:});

if isempty(p.Results.trials)
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);

    if isempty(h) || ~ishghandle(h)
        h = figure(100+trials(1)); clf
    else
    end
end

set(h,'tag',mfilename);

trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if isempty(regexp(trial.params.mode(end),'\w+'))
    trial.params.mode = trial.params.mode(1:end-1);
    data = trial;
    save(regexprep(data.name,'Acquisition','Raw_Data'), '-struct', 'data');
end

y_name = 'spikes';
y_units = 'N';

bindist = 1/4/trial.params.freq;
bins = 0:bindist:trial.params.stimDurInSec + trial.params.postDurInSec;
bins = [-fliplr(bindist:bindist:trial.params.preDurInSec) bins];
psth = zeros(length(bins),length(trials));
y = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.voltage;

    spikes = trial.(y_name);
    for sp_idx = 1:length(spikes)
        t_idx = spikes(sp_idx);
        t_idx = (bins-bindist)<t_idx & bins>=t_idx;
        psth(t_idx,t) = psth(t_idx,t)+1;
    end
end

x_win = x>= -.2 & x<trial.params.stimDurInSec+ min(.2,trial.params.postDurInSec);
b_win = bins>= -.2 & bins<trial.params.stimDurInSec+ min(.2,trial.params.postDurInSec);

ax = subplot(3,1,1,'parent',h);
plot(ax,x(x_win),y(x_win,:),'color',[1, .7 .7],'tag',savetag); hold on
y_ = mean(y,2);
plot(ax,x(x_win),y_(x_win),'color',[.7 0 0],'tag',savetag);

axis(ax,'tight')
% xlim([-.1 trial.params.stimDurInSec+ min(.25,trial.params.postDurInSec)])
text(-.09,mean(mean(y_(x<0),2),1),...
    [num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement*3) ' \mum'],...
    'fontsize',7,'parent',ax,'tag',savetag,'verticalAlignment','bottom')

ax = subplot(3,1,2,'parent',h);
plot(ax,bins(b_win),psth(b_win,:),'tag',savetag); hold on
psth_ = mean(psth,2);
plot(ax,bins(b_win),psth_(b_win,:),'color',[0 0 0],'tag',savetag); hold on

[prot,d,fly,cell,trialnum] = extractRawIdentifiers(trial.name);
title(ax,sprintf('%s - %d Hz %.2f \\mum', [prot '.' d '.' fly '.' cell '.' trialnum], trial.params.freq,trial.params.displacement*3));
box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);
set(ax,'tag','response_ax');

ax = subplot(3,1,3,'parent',h);

y_ = trial.sgsmonitor(1:length(x));

plot(ax,x(x_win),y_(x_win),'color',[0 0 1],'tag',savetag); hold on;

box(ax,'off');
axis(ax,'tight');
bin_x = bins(b_win) - bindist/2;
bin_x = bin_x(2:end);
%plot(ax,[bin_x;bin_x],repmat(get(ax,'ylim')',1,length(bin_x)),'color',[1 1 1]*.8,'tag',savetag); hold on;


set(ax,'TickDir','out');
set(ax,'tag','stimulus_ax');

