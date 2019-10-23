function plotcanvas = quickShow_Sweep2T(plotcanvas,obj,savetag)
% setupStimulus
h = guidata(plotcanvas);

[prot,d,fly,cell,trial] = extractRawIdentifiers(obj.trial.name);
x = makeInTime(obj.trial.params);

% displayTrial
ax1 = subplot(3,1,3,'parent',plotcanvas);
set(ax1,'tag','quickshow_outax');

if strcmp('IClamp',obj.trial.params.mode_1)
    yname = 'current';
    units = 'I (pA)';
elseif strcmp('VClamp',obj.trial.params.mode_1)
    yname = 'voltage';
    units = 'V_m (mV)';
end
if ~exist('yname','var')
    error('Mode is wrong: %s',obj.trial.params.mode_1)
end

%line(obj.x(obj.x>=0 & obj.x<=1),obj.trial.(yname)(obj.x>=0 & obj.x<=1),'color',[.7 .7 .7],'linewidth',1,'parent',ax1,'tag',savetag);
line(downsample(x,10),downsample(obj.trial.([yname '_1']),10),'color',[.6 0 0],'linewidth',1,'parent',ax1,'tag',savetag);
line(downsample(x,10),downsample(obj.trial.([yname '_2']),10),'color',[1 .6 .6],'linewidth',1,'parent',ax1,'tag',savetag);
box(ax1,'off'); set(ax1,'TickDir','out'); axis(ax1,'tight');
ylabel(ax1,units);

% Trode 1
xlims = get(ax1,'xlim');
ylims = get(ax1,'ylim');
text(xlims(1)+.05*diff(xlims),ylims(1)+.05*diff(ylims),...
    sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]),...
    'parent',ax1,'fontsize',7,'tag','delete');

ax2 = subplot(3,1,1,'parent',plotcanvas);
set(ax2,'tag','quickshow_inax');

if strcmp('IClamp',obj.trial.params.mode_1)
    yname = 'voltage';
    units = 'V_m (mV)';
elseif strcmp('VClamp',obj.trial.params.mode_1)
    yname = 'current';
    units = 'I (pA)';
end

line(downsample(x,10),downsample(obj.trial.([yname '_1']),10),'color',[.6 0 0],'linewidth',1,'parent',ax2,'tag',savetag);
axis(ax2,'tight');
if exist('xlims','var')
    set(ax2,'xlim',xlims)
end
ylabel(ax2,units);
title(ax2,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));
box(ax2,'off'); 
set(ax2,'TickDir','out'); 

% Trode 2 
ax2 = subplot(3,1,2,'parent',plotcanvas);
set(ax2,'tag','quickshow_inax2');

if strcmp('IClamp',obj.trial.params.mode_2)
    yname = 'voltage';
    units = 'V_m (mV)';
elseif strcmp('VClamp',obj.trial.params.mode_2)
    yname = 'current';
    units = 'I (pA)';
end

line(downsample(x,10),downsample(obj.trial.([yname '_2']),10),'color',[1 .6 .6],'linewidth',1,'parent',ax2,'tag',savetag);
axis(ax2,'tight');
if exist('xlims','var')
    set(ax2,'xlim',xlims)
end
ylabel(ax2,units);
title(ax2,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));
box(ax2,'off'); 
set(ax2,'TickDir','out'); 

% Tags
if isfield(obj,'prtclData') && isfield(obj,'prtclTrialNums') && ~isempty(obj.prtclData(obj.prtclTrialNums==obj.currentTrialNum).tags)
    tags = obj.prtclData(obj.prtclTrialNums==obj.currentTrialNum).tags;
    tagstr = tags{1};
    for i = 2:length(tags)
        tagstr = [tagstr ';' tags{i}];
    end
    xlims = get(ax2,'xlim');
    ylims = get(ax2,'ylim');
    text(xlims(1)+.05*diff(xlims),ylims(1)+.05*diff(ylims),tagstr,'parent',ax2,'tag','delete');
end
drawnow
%guidata(plotcanvas,h);
