function h = ManipulatorLegPosition(h,handles,savetag)

if isempty(h) || ~ishghandle(h)
    h = figure(100+trials(1)); clf
else
end

set(h,'tag',mfilename);
trial = handles.trial;
x = makeTime(trial.params);

if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
    y_name = 'voltage';
    y_units = 'mV';
elseif sum(strcmp('VClamp',trial.params.mode))
    y_name = 'current';
    y_units = 'pA';
end

lp = trial.legposition;
lpi = squeeze(lp(:,1,:) + 1i*lp(:,2,:));
clrs = parula(size(lp,3));

[fe,ti,ta] = legAngles(lpi,'rad');

lpi = lpi(:,:) - repmat(lpi(1,:),size(lpi,1),1);
% align femur along the x axis into natural coordinates
lpi = lpi .* repmat(exp(-1i*fe),size(lpi,1),1);

legax = subplot(2,2,1,'parent',h); hold(legax,'on');
for l = 1:size(lpi,2)
    plot(legax,lpi(:,l),'color',clrs(l,:))
end

[fe,ti,ta] = legAngles(lp,'deg');

legax = subplot(2,2,2,'parent',h); hold(legax,'on');
for l = 1:size(lpi,2)
    plot(legax,l,fe(l),...
        'marker','o','markersize',5,'markerfacecolor',clrs(l,:),'markeredgecolor',clrs(l,:))
end
 
legax = subplot(2,2,3,'parent',h); hold(legax,'on');
for l = 1:size(lpi,2)
    plot(l,ti(l),...
        'marker','o','markersize',5,'markerfacecolor',clrs(l,:),'markeredgecolor',clrs(l,:))
end
legax = subplot(2,2,4,'parent',h); hold(legax,'on');
for l = 1:size(lpi,2)
    plot(l,ta(l),...
        'marker','o','markersize',5,'markerfacecolor',clrs(l,:),'markeredgecolor',clrs(l,:))
end




% plot(ax,x,y,'color',[1, .7 .7],'tag',savetag); hold on
% plot(ax,x,mean(y,2),'color',[.7 0 0],'tag',savetag);
% %xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
% xlim([-2 2])
% % text(-.09,mean(mean(y(x<0),2),1),...
% %     [num2str(trial.params.displacement *3) ' \mum'],...
% %     'fontsize',7,'parent',ax,'tag',savetag)
% box(ax,'off');
% set(ax,'TickDir','out');
% ylabel(ax,y_units);
% [prot,d,fly,cell,trialnum] = extractRawIdentifiers(handles.trial.name);
% %title(ax,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trialnum]));
% set(ax,'tag','response_ax');
% 
% ax = subplot(3,1,3,'parent',h); cla(ax,'reset')
% plot(ax,x,trial.sgsmonitor(1:length(x)),'color',[0 0 1],'tag',savetag); hold on;
% box(ax,'off');
% set(ax,'TickDir','out');
% xlim([-.1 trial.params.stimDurInSec+ min(.15,trial.params.postDurInSec)])
% set(ax,'tag','stimulus_ax');
