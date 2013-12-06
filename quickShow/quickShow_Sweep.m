function plotcanvas = quickShow_Sweep(plotcanvas,obj,savetag)
% setupStimulus
obj.x = makeInTime(obj.trial.params);

% displayTrial
ax1 = subplot(3,1,3,'parent',plotcanvas);

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
line(obj.x,obj.trial.(yname),'color',[.7 .7 .7],'linewidth',1,'parent',ax1,'tag',savetag);
box(ax1,'off'); set(ax1,'TickDir','out'); axis(ax1,'tight');
ylabel(ax1,units);

[prot,d,fly,cell,trial] = extractRawIdentifiers(obj.trial.name);
text(.01,mean(obj.trial.(yname)),...
    sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]),'parent',ax1,...
    'fontsize',7,'tag',savetag);

ax2 = subplot(3,1,[1 2],'parent',plotcanvas);
if sum(strcmp({'IClamp','IClamp_fast'},obj.trial.params.mode))
    yname = 'voltage';
    units = 'V_m (mV)';
elseif sum(strcmp('VClamp',obj.trial.params.mode))
    yname = 'current';
    units = 'I (pA)';
end
line(obj.x,obj.trial.(yname),'color',[1 0 0],'linewidth',1,'parent',ax2,'tag',savetag);
box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');
ylabel(ax2,units);
title(ax2,sprintf('%s', [prot '.' d '.' fly '.' cell '.' trial]));


