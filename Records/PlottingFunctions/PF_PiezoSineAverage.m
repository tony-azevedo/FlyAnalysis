function h = PF_PiezoSineAverage(h,handles,savetag,varargin)

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
ax = subplot(3,1,[1 2],'parent',h);
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if isempty(regexp(trial.params.mode(end),'\w+'))
    trial.params.mode = trial.params.mode(1:end-1);
    data = trial;
    save(regexprep(data.name,'Acquisition','Raw_Data'), '-struct', 'data');
end

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

%plot(ax,x(x_win),y(x_win,:),'color',[1, .7 .7],'tag',savetag); hold on
y_ = mean(y,2);

if sum(strcmp('VClamp',trial.params.mode))
    d1 = getpref('FigureMaking','CurrentFilter');
    % lpFilt = designfilt('lowpassiir','FilterOrder',8,'PassbandFrequency',2e3,'PassbandRipple',0.2,'SampleRate',50e3);
    % setpref('FigureMaking','CurrentFilter',lpFilt);
    if d1.SampleRate ~= trial.params.sampratein
        d1 = designfilt('lowpassiir','FilterOrder',8,'PassbandFrequency',2e3,'PassbandRipple',0.2,'SampleRate',trial.params.sampratein);
    end

    for c = 1:size(y,2)
        y(:,c) = filtfilt(d1,y(:,c));
    end
    y_ = filtfilt(d1,y_);
end

sem_up = std(y,[],2)/sqrt(length(trials));
sem_down = y_-sem_up;
sem_up = y_+sem_up;
% x_ptch = [x(x_win); flipud(x(x_win))];
% y_ptch = [sem_up(x_win); flipud(sem_down(x_win))];

% ptch = fill(x_ptch,y_ptch,[1, .7 .7],'parent',ax); hold on
% ptch.EdgeColor = [1 .7 .7];
% ptch.EdgeAlpha = 0;
line(x(x_win),sem_down(x_win),'parent',ax,'color',[1 .7 .7],'tag',savetag);
line(x(x_win),sem_up(x_win),'parent',ax,'color',[1 .7 .7],'tag',savetag);

line(x(x_win),y_(x_win),'parent',ax,'color',[.7 0 0],'tag',savetag);


axis(ax,'tight')
% xlim([-.1 trial.params.stimDurInSec+ min(.25,trial.params.postDurInSec)])
text(-.09,mean(mean(y_(x<0),2),1),...
    [num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement*3) ' \mum'],...
    'fontsize',7,'parent',ax,'tag',savetag,'verticalAlignment','bottom')

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

set(ax,'TickDir','out');
set(ax,'tag','stimulus_ax');

