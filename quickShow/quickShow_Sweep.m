function plotcanvas = quickShow_Sweep(plotcanvas,obj,savetag)
% setupStimulus
obj.x = makeInTime(obj.trial.params);

% displayTrial
ax1 = subplot(3,1,3,'parent',plotcanvas);
if isfield(obj.trial.params,'recmode');
    obj.trial.params.mode = obj.trial.params.recmode(1:6);
    data = obj.trial;
    save(data.name, '-struct', 'data');
end

if sum(strcmp({'IClamp','IClamp_fast'},obj.trial.params.mode))
    yname = 'current';
    units = 'I (pA)';
elseif sum(strcmp('VClamp',obj.trial.params.mode))
    yname = 'voltage';
    units = 'V_m (mV)';
end
if ~exist('yname','var')
    error('Mode is wrong: %s',obj.trial.params.mode)
end
%line(obj.x(obj.x>=0 & obj.x<=1),obj.trial.(yname)(obj.x>=0 & obj.x<=1),'color',[.7 .7 .7],'linewidth',1,'parent',ax1,'tag',savetag);
line(downsample(obj.x,10),downsample(obj.trial.(yname),10),'color',[.7 .7 .7],'linewidth',1,'parent',ax1,'tag',savetag);
box(ax1,'off'); set(ax1,'TickDir','out'); axis(ax1,'tight');
ylabel(ax1,units);


[prot,d,fly,cell,trial] = extractRawIdentifiers(obj.trial.name);
xlims = get(ax1,'xlim');
ylims = get(ax1,'ylim');
text(xlims(1)+.05*diff(xlims),ylims(1)+.05*diff(ylims),...
    sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]),...
    'parent',ax1,'fontsize',7,'tag','delete');

ax2 = subplot(3,1,[1 2],'parent',plotcanvas);
if sum(strcmp({'IClamp','IClamp_fast'},obj.trial.params.mode))
    yname = 'voltage';
    units = 'V_m (mV)';
elseif sum(strcmp('VClamp',obj.trial.params.mode))
    yname = 'current';
    units = 'I (pA)';
end
% line(obj.x(obj.x>=0 & obj.x<=1),obj.trial.(yname)(obj.x>=0 & obj.x<=1),'color',[1 0 0],'linewidth',1,'parent',ax2,'tag',savetag);
line(downsample(obj.x,10),downsample(obj.trial.(yname),10),'color',[1 0 0],'linewidth',1,'parent',ax2,'tag',savetag);
box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');
ylabel(ax2,units);
title(ax2,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));

if ~isempty(obj.prtclData(obj.prtclTrialNums==obj.currentTrialNum).tags)
    tags = obj.prtclData(obj.prtclTrialNums==obj.currentTrialNum).tags;
    tagstr = tags{1};
    for i = 2:length(tags)
        tagstr = [tagstr ';' tags{i}];
    end
    xlims = get(ax2,'xlim');
    ylims = get(ax2,'ylim');
    text(xlims(1)+.05*diff(xlims),ylims(1)+.05*diff(ylims),tagstr,'parent',ax2,'tag','delete');
end