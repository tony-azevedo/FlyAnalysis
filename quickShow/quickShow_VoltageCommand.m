function plotcanvas = quickShow_VoltageCommand(plotcanvas,obj,savetag,varargin)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('BGCorrectImages',false,@islogical);
parse(p,varargin{:});


% setupStimulus
if isfield(obj.trial,'voltage_1')
    plotcanvas = quickShow_Sweep2T(plotcanvas,obj,savetag);
    return
end
h = guidata(plotcanvas);
obj.x = makeInTime(obj.trial.params);

% displayTrial
ax1 = subplot(3,1,3,'parent',plotcanvas);
set(ax1,'tag','quickshow_outax');

if isfield(obj.trial.params,'recmode');
    obj.trial.params.mode = obj.trial.params.recmode(1:min(6,length(obj.trial.params.recmode)));
    data = obj.trial;
    save(regexprep(data.name,'Acquisition','Raw_Data'), '-struct', 'data');
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
obj.trial.(yname) = obj.trial.(yname)(1:length(obj.x));

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

if isfield(obj.trial,'roiFluoTrace')
    if p.Results.BGCorrectImages
        dFF_t = dFoverF_bgcorr_trace(obj.trial);
    else
        dFF_t = dFoverF_withbg_trace(obj.trial);
    end
    ax2 = subplot(3,1,2,'parent',plotcanvas);
    set(ax2,'tag','quickshow_dFoverF_ax');
    line(obj.trial.exposure_time,dFF_t,'color',[0 .7 0],'linewidth',1,'parent',ax2,'tag',savetag);
    
    ylabel(ax2,'%\DeltaF / F');
    axis(ax2,'tight')
    xlims = get(ax2,'xlim');
    box(ax2,'off');
    set(ax2,'TickDir','out');
    
    set(ax1,'xlim',xlims)

    ax2 = subplot(3,1,1,'parent',plotcanvas);

else
    ax2 = subplot(3,1,[1 2],'parent',plotcanvas);
end
set(ax2,'tag','quickshow_inax');

if sum(strcmp({'IClamp','IClamp_fast'},obj.trial.params.mode))
    yname = 'voltage';
    units = 'V_m (mV)';
elseif sum(strcmp('VClamp',obj.trial.params.mode))
    yname = 'current';
    units = 'I (pA)';
end

obj.trial.(yname) = obj.trial.(yname)(1:length(obj.x));

% line(obj.x(obj.x>=0 & obj.x<=1),obj.trial.(yname)(obj.x>=0 & obj.x<=1),'color',[1 0 0],'linewidth',1,'parent',ax2,'tag',savetag);
line(downsample(obj.x,10),downsample(obj.trial.(yname),10),'color',[1 0 0],'linewidth',1,'parent',ax2,'tag',savetag);
axis(ax2,'tight');
if exist('xlims','var')
        set(ax2,'xlim',xlims)
end
ylabel(ax2,units);
title(ax2,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));
box(ax2,'off'); 
set(ax2,'TickDir','out'); 


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
