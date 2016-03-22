function h = PF_PiezoStepAverage(h,handles,savetag)

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
end

set(h,'tag',mfilename);
ax = subplot(3,1,[1 2],'parent',h);  cla(ax,'reset')
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
    y_name = 'voltage';
    y_units = 'mV';
elseif sum(strcmp('VClamp',trial.params.mode))
    y_name = 'current';
    y_units = 'pA';
end

if length(trial.(y_name))<length(x)
    x = x(1:length(trial.(y_name)));
end

y = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name)(1:length(x));
end

x_win = x>= -.2 & x<trial.params.stimDurInSec+ min(.2,trial.params.postDurInSec);
% plot(ax,x(x_win),y(x_win,:),'color',[1, .7 .7],'tag',savetag); hold on

y_ = mean(y,2);

if sum(strcmp('VClamp',trial.params.mode))
    % lpFilt = designfilt('lowpassiir','FilterOrder',8,'PassbandFrequency',2e3,'PassbandRipple',0.2,'SampleRate',50e3);
    % setpref('FigureMaking','CurrentFilter',lpFilt);
    d1 = getpref('FigureMaking','CurrentFilter');
    if d1.SampleRate ~= trial.params.sampratein
        d1 = designfilt('lowpassiir','FilterOrder',8,'PassbandFrequency',2e3,'PassbandRipple',0.2,'SampleRate',trial.params.sampratein);
    end
    y_ = filtfilt(d1,y_);
    for c = 1:size(y,2)
        y(:,c) = filtfilt(d1,y(:,c));
    end
end

sem_up = std(y,[],2)/sqrt(length(trials));
sem_down = y_-sem_up;
sem_up = y_+sem_up;
% x_ptch = [x(x_win); flipud(x(x_win))];
% y_ptch = [sem_up(x_win); flipud(sem_down(x_win))];
%ptch = fill(x_ptch,y_ptch,[1, .7 .7],'parent',ax); hold on
%ptch.EdgeColor = [1 .7 .7];
%ptch.EdgeAlpha = 0;

line(x(x_win),sem_down(x_win),'parent',ax,'color',[1 .7 .7],'tag',savetag);
line(x(x_win),sem_up(x_win),'parent',ax,'color',[1 .7 .7],'tag',savetag);

line(x(x_win),y_(x_win),'parent',ax,'color',[.7 0 0],'tag',savetag);



xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
text(-.09,mean(mean(y(x<0),2),1),...
    [num2str(trial.params.displacement *3) ' \mum'],...
    'fontsize',7,'parent',ax,'tag',savetag)
box(ax,'off');
set(ax,'TickDir','out');
ylabel(ax,y_units);
[prot,d,fly,cell,trialnum] = extractRawIdentifiers(handles.trial.name);
%title(ax,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trialnum]));
set(ax,'tag','response_ax');

ax = subplot(3,1,3,'parent',h); cla(ax,'reset')
plot(ax,x,trial.sgsmonitor(1:length(x)),'color',[0 0 1],'tag',savetag); hold on;
box(ax,'off');
set(ax,'TickDir','out');
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
set(ax,'tag','stimulus_ax');
