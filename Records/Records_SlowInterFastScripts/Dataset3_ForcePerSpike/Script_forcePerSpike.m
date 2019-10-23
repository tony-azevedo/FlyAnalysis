%% Peak Force vs spike number (min of 2 examples)
spike_idx = T_FperSpike_0.NumSpikes<=30 & T_FperSpike_0.PeakErr>0 & T_FperSpike_0.Position == 0;
nospike_idx = T_FperSpike_0.NumSpikes<1 & T_FperSpike_0.PeakErr>0 & T_FperSpike_0.Position == 0;

T_FS = T_FperSpike_0(spike_idx,:);
T_0 = T_FperSpike_0(nospike_idx,:);

ForcePerSpikeFig = figure;
ax0 = subplot(1,5,1); hold(ax0,'on')
ax = subplot(1,5,2:5); hold(ax,'on')

cids = unique(T_FS.CellID);
l = gobjects(length(cids),1);
for i = 1:length(cids)
    cid = cids{i};
    T_cid = T_FS(strcmp(T_FS.CellID,cid),:);
    l(i) = errorbar(ax,T_cid.NumSpikes,T_cid.Peak,T_cid.PeakErr,'CapSize',0,'DisplayName',cid,'tag',[T_cid.Cell_label{1} '_' cid]);
end
ax.XLim = [.5 60];
 
ylabel(ax0,'pixels'); 

ForcePerSpikeAx = ax;
ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

fastpoints = findobj(ax,'-regexp', 'tag', 'fast_'); 
for c = 1:length(fastpoints)
    fastpoints(c).Color = [0 0 0];
end
interpoints = findobj(ax,'-regexp', 'tag', 'intermediate_');
for c = 1:length(interpoints)
    interpoints(c).Color = [1 0 1];
end

NoSpikeAx = ax0;
NoSpikeAx.YScale = 'linear';
NoSpikeAx.XScale = 'linear';
cids = unique(T_0.CellID);
l = gobjects(length(cids),1);
for i = 1:length(cids)
    cid = cids{i};
    T_cid = T_0(strcmp(T_0.CellID,cid),:);
    l(i) = errorbar(ax0,T_cid.NumSpikes+i*.1,T_cid.Peak,T_cid.PeakErr,'CapSize',0,'DisplayName',cid,'tag',[T_cid.Cell_label{1} '_' cid],'marker','.');
end
fastpoints = findobj(ax0,'-regexp', 'tag', 'fast_'); 
for c = 1:length(fastpoints)
    fastpoints(c).Color = [0 0 0];
end
interpoints = findobj(ax0,'-regexp', 'tag', 'intermediate_');
for c = 1:length(interpoints)
    interpoints(c).Color = [1 0 1];
end

ax0.YLim = [-10 120];

%% add slow neurons to F per Spike axis

% ax = ForcePerSpikeAx;
% maxspikenum = 0;
% for cidx = 1:length(T_FperNSpikes_0.CellID)
%     numspikes = T_FperNSpikes_0.NumSpikes{cidx};
%     peak = T_FperNSpikes_0.Peak{cidx};
%     
%     % fit line through 0 to peak vs numspikes
%     % m(cidx) = nlinfit(numspikes,peak,@linethrough0,.1);
%     
%     plot(ax,numspikes(numspikes>=20),peak(numspikes>=20),'.','tag',['slow_' T_FperNSpikes_0.CellID{cidx}]);
%     maxspikenum = max([maxspikenum max(numspikes)]);
% end
% ax.XLim = [0, 60+1];
% 
% slowpoints = findobj(ax,'-regexp', 'tag', 'slow_');
% x = []; y = [];
% for i = 1:length(slowpoints)
%     x = cat(2,x,slowpoints(i).XData);
%     y = cat(2,y,slowpoints(i).YData);
% end
% m = nlinfit(x,y,@linethrough0,.1);
% plot(ax,[min(x),max(x)],m*([min(x),max(x)]),'k');
% text(ax,15,.15,sprintf('m = %.3f pixels/spike',m),'HorizontalAlignment','right');
% 
% ForcePerSpikeAx.YScale = 'log';
% ForcePerSpikeAx.XScale = 'log';
% 
% ForcePerSpikeAx.XLim = [.85 61]';
% 
% for c = 1:length(slowpoints)
%     slowpoints(c).Color = [.7 1 .7];
% end

%% Add MLA versions of the same

% ax = ForcePerSpikeAx;
% maxspikenum = 0;
% for cidx = 1:length(T_FperNSpikes_mla.CellID)
%     numspikes = T_FperNSpikes_mla.NumSpikes{cidx};
%     peak = T_FperNSpikes_mla.Peak{cidx};
%     
%     % fit line through 0 to peak vs numspikes
%     % m(cidx) = nlinfit(numspikes,peak,@linethrough0,.1);
%     
%     plot(ax,numspikes(numspikes>=15),peak(numspikes>=15),'.','tag',['slow_mla' T_FperNSpikes_mla.CellID{cidx}]);
%     maxspikenum = max([maxspikenum max(numspikes)]);
% end
% ax.XLim = [0, 60+1];
% 
% slowpoints = findobj(ax,'-regexp', 'tag', 'slow_mla');
% x = []; y = [];
% for i = 1:length(slowpoints)
%     x = cat(2,x,slowpoints(i).XData);
%     y = cat(2,y,slowpoints(i).YData);
% end
% m = nlinfit(x,y,@linethrough0,.1);
% plot(ax,[min(x),max(x)],m*([min(x),max(x)]),'color',[.7 .2 .5]);
% text(ax,15,.2,sprintf('m = %.3f pixels/spike',m),'HorizontalAlignment','right');
% 
% 
% ForcePerSpikeAx.YScale = 'log';
% ForcePerSpikeAx.XScale = 'log';
% 
% ForcePerSpikeAx.XLim = [.85 61]';
% 
% for c = 1:length(slowpoints)
%     delete(slowpoints(c));
% %     slowpoints(c).Color = [.7 .2 .5];
% end


%% add slow neurons to F vs Spikerate to axis
k = 0.2234; %N/m;

ax = ForcePerSpikeAx;
cellids = unique(T_FvsFiringRate_0.CellID);
for cididx = 1:length(cellids)
    cellid = cellids{cididx};
    T_cell = T_FvsFiringRate_0(contains(T_FvsFiringRate_0.CellID,cellid),:);
    
    plot(ax,(T_cell.FiringRate-T_cell.Rest)*.5,T_cell.Peak,'Tag',cellid,'Marker','.','color',[0 .7 0])
    plot(ax0,T_cell.FiringRate(1)*.5,T_cell.Peak(1),'Tag',cellid,'Marker','.','color',[0 .7 0])
end

fr = T_FvsFiringRate_0.FiringRate-T_FvsFiringRate_0.Rest;
peak = T_FvsFiringRate_0.Peak(T_FvsFiringRate_0.Step>13);
n_up_0 = fr(T_FvsFiringRate_0.Step>13)*0.5; % number of spikes is firing rate *stim dur

m_relationship = nlinfit(n_up_0,peak,@linethrough0,.1);

plot(ax,[min(n_up_0),max(n_up_0)],m_relationship*([min(n_up_0),max(n_up_0)]),'k');

text(ax,70,.15,sprintf('m = %.3f uN/spike',m_relationship*k),'HorizontalAlignment','right');

ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

ForcePerSpikeAx.XLim = [.85 71]';


ax0.YLim = [-10 120];


%% add mla neurons F vs Spikerate to axis

% ax = ForcePerSpikeAx;
% cellids = unique(T_FvsFiringRate_mla.CellID);
% % for cididx = 1:length(cellids)
% %     cellid = cellids{cididx};
% %     T_cell = T_FvsFiringRate_mla(contains(T_FvsFiringRate_mla.CellID,cellid),:);
% %     
% %     plot(ax,(T_cell.FiringRate-T_cell.Rest)*.5,T_cell.Peak,'Tag',cellid,'Marker','.','color',[1 0 0])
% % end
% 
% fr = T_FvsFiringRate_mla.FiringRate-T_FvsFiringRate_mla.Rest;
% peak = T_FvsFiringRate_mla.Peak(T_FvsFiringRate_mla.Step>13);
% n_up = fr(T_FvsFiringRate_mla.Step>13)*0.5; % number of spikes is firing rate *stim dur
% 
% m_relationship = nlinfit(n_up,peak,@linethrough0,.1);
% 
% plot(ax,[min(n_up_0),max(n_up_0)],m_relationship*([min(n_up_0),max(n_up_0)]),'k');
% 
% text(ax,70,.2,sprintf('m = %.3f pixels/spike',m_relationship),'HorizontalAlignment','right');
% 
% ForcePerSpikeAx.YScale = 'log';
% ForcePerSpikeAx.XScale = 'log';

ForcePerSpikeAx.XLim = [.85 71]';
ForcePerSpikeAx.YLim = [.08 130]';

%% Scale the y-axis nicely
k = 0.2234; %N/m;
forceticks = [.1 1 10 40]/k;
ylabel(ax0,'Force (uN)')
ForcePerSpikeAx.YTick = forceticks;
ForcePerSpikeAx.YTickLabel = {'0.1' '1' '10' '40'};
ForcePerSpikeAx.YLim = [.1 180];
ForcePerSpikeAx.YMinorTick = 'off';
ForcePerSpikeAx.XMinorTick = 'off';

ForcePerSpikeAx.XTick = [1 10 60];
ForcePerSpikeAx.XTickLabel = {'1' '10' '60'};

forceticks = [-2 0]/k;

NoSpikeAx.YTick = forceticks;
NoSpikeAx.YTickLabel = {'-2' '0'};

NoSpikeAx.XLim = [-4 24];
NoSpikeAx.YLim = [-10 120];

%%
filename = 'ForcePerSpike';
export_fig(ForcePerSpikeFig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');