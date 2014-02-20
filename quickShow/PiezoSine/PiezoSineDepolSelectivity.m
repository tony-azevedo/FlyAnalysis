function varargout = PiezoSineDepolSelectivity(fig,handles,savetag)
% see also AverageLikeSongs

trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);
if isempty(fig) || ~ishghandle(fig)
    fig = figure(100+trials(1)); clf
else
end

set(fig,'tag',mfilename);
if strcmp(get(fig,'type'),'figure'), set(fig,'name',mfilename);end
trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(1))));
x = makeTime(trial.params);

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
    y_name = 'voltage';
    y_units = 'mV';
elseif sum(strcmp('VClamp',trial.params.mode))
    y_name = 'current';
    y_units = 'pA';
end
outname = 'sgsmonitor';
outunits = 'V';

y = zeros(length(x),length(trials));
u = zeros(length(x),length(trials));
for t = 1:length(trials)
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
    y(:,t) = trial.(y_name)(1:length(x));
    u(:,t) = trial.(outname)(1:length(x));
end

yc = mean(y,2);
base = mean(yc(x<0));
yc = yc-base;

response_area = trapz(...
    x(x>=0 & x <trial.params.stimDurInSec-eps),...
    yc(x>=0 & x <trial.params.stimDurInSec-eps));

response_area_ext = trapz(x(x>=0),yc(x>=0));

[response_amp,tpk] = max(...
    yc(x>=0 & x <trial.params.stimDurInSec-eps));
tpk = tpk + sum(x<0);

% make the ideal stimulus, once the piezo response is accounted for

ax = subplot(3,1,[1 2],'parent',fig);
cla(ax,'reset')
plot(ax,x,y,'color',[1 .7 .7],'tag',savetag); hold on
plot(ax,x,mean(y,2),'color',[.7 .0 0],'tag',savetag); hold on
plot(ax,x(tpk),response_amp+base,'o','tag',savetag); hold on

axis(ax,'tight');
ylims = get(ax,'ylim');
ylims = [ylims(1)-.05*(ylims(2)-ylims(1)) ylims(2)+.05*(ylims(2)-ylims(1)) ];
ylim(ax,ylims);

xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])

title([handles.currentPrtcl ' - ' num2str(handles.trial.params.freq) ' Hz, ' num2str(handles.trial.params.displacement) ' V'])
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

varargout = {response_area,response_amp,response_area_ext};