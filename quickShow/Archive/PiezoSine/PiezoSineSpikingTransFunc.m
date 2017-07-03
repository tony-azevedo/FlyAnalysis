function varargout = PiezoSineSpikingTransFunc(fig,handles,savetag,varargin)
% see also AverageLikeSongs

p = inputParser;
p.PartialMatching = 0;
p.addParameter('closefig',1,@isnumeric);
parse(p,varargin{:});

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(fig) && p.Results.closefig 
    fig = figure(101); clf
elseif isempty(fig) || ~ishghandle(fig) 
    fig = figure(100+trials(1)); clf
else
end

set(fig,'tag',mfilename);
if strcmp(get(fig,'type'),'figure'), set(fig,'name',mfilename);end
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
    y_name = 'spikes';
    y_units = 'mV';
elseif sum(strcmp('VClamp',trial.params.mode))
    error('This function doesnt work on current data')
end
outname = 'sgsmonitor';
outunits = 'V';

y = zeros(length(x),length(trials));
u = zeros(length(x),length(trials));
f = zeros(1,length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    if ~isfield(trial,y_name)
        trial = extractSpikes(handtrial);
    end
    y(:,t) = trial.voltage(1:length(x));
    u(:,t) = trial.(outname)(1:length(x));
    f(t) = trial.params.stimDurInSec * (sum(trial.spikes>0 & trial.spikes<=trial.params.stimDurInSec)/trial.params.stimDurInSec - sum(trial.spikes<0)/trial.params.preDurInSec);
end

% bindist = 1/4/trial.params.freq;
% bins = 0:bindist:trial.params.stimDurInSec + trial.params.postDurInSec;
% bins = [-fliplr(bindist:bindist:trial.params.preDurInSec) bins];
% psth = zeros(length(bins),length(trials));
% y = zeros(length(x),length(trials));
% for t = 1:length(trials)
%     trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
%     y(:,t) = trial.voltage;
% 
%     spikes = trial.(y_name);
%     for sp_idx = 1:length(spikes)
%         t_idx = spikes(sp_idx);
%         t_idx = (bins-bindist)<t_idx & bins>=t_idx;
%         psth(t_idx,t) = psth(t_idx,t)+1;
%     end
% end

% yc = mean(y,2);
% base = mean(yc(x<0));
% yc = yc-base;
% 
% response_area = trapz(...
%     x(x>=0 & x <trial.params.stimDurInSec-eps),...
%     yc(x>=0 & x <trial.params.stimDurInSec-eps));
% response_area = response_area/trial.params.stimDurInSec;
% 
% response_area_ext = trapz(x(x>=0),yc(x>=0));

% find the max, average a few points around it
% avewin = [-30:30];
% [response_amp,tpk] = max(...
%     yc(x>=0 & x <trial.params.stimDurInSec-eps));
% tpk = tpk + sum(x<0);
% response_amp = mean(yc(tpk+avewin));

% make the ideal stimulus, once the piezo response is accounted for

ax = subplot(3,1,1,'parent',fig);
cla(ax,'reset')
plot(ax,x,y,'color',[1 .7 .7],'tag',savetag); hold on
plot(ax,x,mean(y,2),'color',[.7 .0 0],'tag',savetag); hold on
% plot(ax,x(tpk),response_amp+base,'o','tag',savetag); hold on

axis(ax,'tight');
ylims = get(ax,'ylim');
ylims = [ylims(1)-.05*(ylims(2)-ylims(1)) ylims(2)+.05*(ylims(2)-ylims(1)) ];
ylim(ax,ylims);

xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

title([handles.currentPrtcl ' - ' num2str(handles.trial.params.freq) ' Hz, ' num2str(handles.trial.params.displacement) ' V'])
box(ax,'off');
set(ax,'TickDir','out');

ax = subplot(3,1,2,'parent',fig);
cla(ax,'reset')
H = x;
H(:) = 0;
H(x>0&x<=trial.params.stimDurInSec) = 1;
H_ = repmat(H(:)',length(trials),1);
for i = 1:length(f)
    H_(i,:) = H_(i,:)*f(i);
end

plot(ax,x,H_,'tag',savetag); hold on
plot(ax,x,H*mean(f),'color',[0 .0 0],'tag',savetag); hold on
% plot(ax,x(tpk),response_amp+base,'o','tag',savetag); hold on

axis(ax,'tight');
ylims = get(ax,'ylim');
ylims = [ylims(1)-.05*(ylims(2)-ylims(1)) ylims(2)+.05*(ylims(2)-ylims(1)) ];
ylim(ax,ylims);

xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
box(ax,'off');
set(ax,'TickDir','out');

ax = subplot(3,1,3,'parent',fig);
cla(ax)
plot(ax,x,mean(u,2),'color',[0 0 1],'tag',savetag); hold on
axis(ax,'tight')
xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

title([])
box(ax,'off');
set(ax,'TickDir','out');

xlim(ax,[-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
drawnow

varargout = {mean(f)};