%% Peak Force vs spike number (min of 2 examples)
ForcePerSpikeFig = figure;
ForcePerSpikeFig.Position = [680    32   560   964];
ax = subplot(2,1,1); hold(ax,'on')
ForcePerSpikeAx = ax;

ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

%% Show slow neuron spike counts
ax = ForcePerSpikeAx;
maxspikenum = 0;
for cidx = 1:length(T_FperNSpikes_0.CellID)
    numspikes = T_FperNSpikes_0.NumSpikes{cidx};
    peak = T_FperNSpikes_0.Peak{cidx};
    
    % fit line through 0 to peak vs numspikes
    % m(cidx) = nlinfit(numspikes,peak,@linethrough0,.1);
    
    plot(ax,numspikes(numspikes>=20),peak(numspikes>=20),'.','tag',['slow_' T_FperNSpikes_0.CellID{cidx}]);
    maxspikenum = max([maxspikenum max(numspikes)]);
end
ax.XLim = [0, 60+1];

slowpoints = findobj(ax,'-regexp', 'tag', 'slow_');
x = []; y = [];
for i = 1:length(slowpoints)
    x = cat(2,x,slowpoints(i).XData);
    y = cat(2,y,slowpoints(i).YData);
end
m = nlinfit(x,y,@linethrough0,.1);
plot(ax,[min(x),max(x)],m*([min(x),max(x)]),'k');
text(ax,15,.15,sprintf('m = %.3f pixels/spike',m),'HorizontalAlignment','right');

ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

ForcePerSpikeAx.XLim = [5 91]';

for c = 1:length(slowpoints)
    slowpoints(c).Color = [.7 1 .7];
end

%% Add MLA versions of the same

ax = ForcePerSpikeAx;
maxspikenum = 0;
for cidx = 1:length(T_FperNSpikes_mla.CellID)
    numspikes = T_FperNSpikes_mla.NumSpikes{cidx};
    peak = T_FperNSpikes_mla.Peak{cidx};
    
    % fit line through 0 to peak vs numspikes
    % m(cidx) = nlinfit(numspikes,peak,@linethrough0,.1);
    
    plot(ax,numspikes(numspikes>=15),peak(numspikes>=15),'.','tag',['slow_mla' T_FperNSpikes_mla.CellID{cidx}]);
    maxspikenum = max([maxspikenum max(numspikes)]);
end
ax.XLim = [0, 60+1];

slowpoints = findobj(ax,'-regexp', 'tag', 'slow_mla');
x = []; y = [];
for i = 1:length(slowpoints)
    x = cat(2,x,slowpoints(i).XData);
    y = cat(2,y,slowpoints(i).YData);
end
m = nlinfit(x,y,@linethrough0,.1);
plot(ax,[min(x),max(x)],m*([min(x),max(x)]),'color',[.7 .2 .5]);
text(ax,15,.2,sprintf('m = %.3f pixels/spike',m),'HorizontalAlignment','right');


ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

ForcePerSpikeAx.XLim = [5 91]';

for c = 1:length(slowpoints)
%     delete(slowpoints(c));
     slowpoints(c).Color = [.7 .2 .5];
end


%% add slow neurons to F vs Spikerate to axis

ax = subplot(2,1,2); hold(ax,'on')
ForcePerSpikeAx = ax;

ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

cellids = unique(T_FvsFiringRate_0.CellID);
for cididx = 1:length(cellids)
    cellid = cellids{cididx};
    T_cell = T_FvsFiringRate_0(contains(T_FvsFiringRate_0.CellID,cellid),:);
    
    plot(ax,(T_cell.FiringRate-T_cell.Rest)*.5,T_cell.Peak,'Tag',cellid,'Marker','.','color',[0 .7 0])
end

fr = T_FvsFiringRate_0.FiringRate-T_FvsFiringRate_0.Rest;
peak = T_FvsFiringRate_0.Peak(T_FvsFiringRate_0.Step>13);
n_up = fr(T_FvsFiringRate_0.Step>13)*0.5; % number of spikes is firing rate *stim dur

m_relationship = nlinfit(n_up,peak,@linethrough0,.1);

plot(ax,[min(n_up),max(n_up)],m_relationship*([min(n_up),max(n_up)]),'k');

text(ax,70,.15,sprintf('m = %.3f pixels/spike',m_relationship),'HorizontalAlignment','right');

ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

ForcePerSpikeAx.XLim = [5 91]';



%% add mla neurons F vs Spikerate to axis

ax = ForcePerSpikeAx;
cellids = unique(T_FvsFiringRate_mla.CellID);
for cididx = 1:length(cellids)
    cellid = cellids{cididx};
    T_cell = T_FvsFiringRate_mla(contains(T_FvsFiringRate_mla.CellID,cellid),:);
    
    plot(ax,(T_cell.FiringRate-T_cell.Rest)*.5,T_cell.Peak,'Tag',cellid,'Marker','.','color',[.7 .2 .5])
end

fr = T_FvsFiringRate_mla.FiringRate-T_FvsFiringRate_mla.Rest;
peak = T_FvsFiringRate_mla.Peak(T_FvsFiringRate_mla.Step>13);
n_up = fr(T_FvsFiringRate_mla.Step>13)*0.5; % number of spikes is firing rate *stim dur

m_relationship = nlinfit(n_up,peak,@linethrough0,.1);

plot(ax,[min(n_up),max(n_up)],m_relationship*([min(n_up),max(n_up)]),'color',[.7 .2 .5]);

text(ax,70,.2,sprintf('m = %.3f pixels/spike',m_relationship),'HorizontalAlignment','right');

ForcePerSpikeAx.YScale = 'log';
ForcePerSpikeAx.XScale = 'log';

ForcePerSpikeAx.XLim = [5 91]';

xlabel(ax,'\Delta Firing Rate (Hz)');