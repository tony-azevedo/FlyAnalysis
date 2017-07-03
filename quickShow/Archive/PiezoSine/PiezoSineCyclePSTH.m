function h = PiezoSineCyclePSTH(h,handles,savetag,varargin)

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
ax = subplot(3,1,[1 2],'parent',h); hold on
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
y_ = mean(y,2);
base = mean(y_(x>=-trial.params.preDurInSec+.08 &x<0));

x_win = x>= trial.params.ramptime & x<trial.params.stimDurInSec-trial.params.ramptime;

s = PiezoSineStim(trial.params)/trial.params.displacement;
[cyclemat,ascd,peak,desc,vall] = findSineCycle(s(x_win),0,[]);
r = min(diff(ascd));
x_ = x(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1)); 
x_ = x_-x_(1);
s_ = s(sum(x<trial.params.ramptime)+(ascd(1):ascd(1)+r-1));
y_c = zeros(r,length(diff(ascd)));
y_t = zeros(r,length(diff(ascd))*length(trials));
y_inwin = y_(x_win);
y = y(x_win,:);
for y_t_ind = 1:length(trials);
    for c = 1:length(diff(ascd))
        y_t(:,(y_t_ind-1)*length(diff(ascd))+c) = y(ascd(c):ascd(c)+r-1,y_t_ind);
    end
end
% for c = 1:length(diff(ascd))
%     y_c(:,c) = y_inwin(ascd(c):ascd(c)+r-1);
% end

y_ = mean(y_t,2);

%plot(ax,x_,y_t,'color',[.9, .9 .9],'tag',savetag); hold on
% plot(ax,x_,y_t,'color',[1 .7 .7],'tag',savetag); hold on
sem_up = std(y_t,[],2);%/sqrt(size(y_t,2));
sem_down = y_-sem_up;
sem_up = y_+sem_up;
line(x_,sem_down,'parent',ax,'color',[1 .7 .7],'tag',savetag);
line(x_,sem_up,'parent',ax,'color',[1 .7 .7],'tag',savetag);

plot(ax,x_,y_,'color',[.7 0 0],'tag',savetag);
plot(ax,x_,base*ones(size(x_)),'color',[.8 .8 .8],'tag',savetag);

axis(ax,'tight')
% xlim([-.1 trial.params.stimDurInSec+ min(.25,trial.params.postDurInSec)])
text(0,mean(y_),...
    [num2str(trial.params.freq) ' Hz ' num2str(trial.params.displacement*3) ' \mum'],...
    'fontsize',7,'parent',ax,'tag',savetag,'verticalAlignment','bottom')

[prot,d,fly,cell,trialnum] = extractRawIdentifiers(trial.name);
title(ax,sprintf('%s - %d Hz %.2f \\mum', [prot '.' d '.' fly '.' cell '.' trialnum], trial.params.freq,trial.params.displacement*3));
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

