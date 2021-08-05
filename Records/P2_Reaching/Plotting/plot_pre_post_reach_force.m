function [fig,idx] = plot_pre_post_reach_force(T,varargin)
% f = plotChunkOfTrials(T,title)


if isempty(T)
    fprintf('No trials\n')
    fig = [];
    return
end
Dir = T.Properties.UserData.Dir;
trialStem = T.Properties.UserData.trialStem;

if nargin > 1
ttl = varargin{1};
else
    ttl = '';
end
if nargin>2
    fplims = varargin{2};
else
    fplims = [];
end

fig = figure;
fig.Position = [500   320   960   600];
panl = panel(fig);
panl.pack('v',{1/2, 1/2})  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';
panl(1).margintop = 2;
panl(2).margintop = 2;
panl.marginbottom = 12;

panl(1).pack('h',{1/2, 1/2})  % response panel, stimulus panel
panl(2).pack('h',{1/2, 1/2})  % response panel, stimulus panel

forceax2 = panl(1,1).select();
spikeax2 = panl(2,1).select();
forceax3 = panl(1,2).select();
spikeax3 = panl(2,2).select();

% forceax3.NextPlot = 'add';                
% spikeax3.NextPlot = 'add';                
%forceax.XAxis.Visible = 'off';

rpre = T.arduino_duration;
fpre = rpre;
rmax = rpre;
fmax = rpre;
rpost = rpre;
fpost = rpre;
idx = rpre;

for r = 1:size(T,1)
    T_row = T(r,:);    
    trial = load(fullfile(Dir,sprintf(trialStem,T_row.trial)));
    
    x = makeInTime(trial.params);
    y = -trial.probe_position;
    spikes = x(trial.spikes(trial.spikes<length(x)));
    rpre(r) = sum(spikes>-.4 & spikes<0)/.4;
    fpre(r) = mean(y(x>-.2 & x<0));
    [fmax(r),idx(r)] = max(y);
    rmax(r) = sum(spikes>x(idx(r))-.4 & spikes<x(idx(r)))/.4;
    
    trial = load(fullfile(Dir,sprintf(trialStem,T_row.trial+1)));
    
    x = makeInTime(trial.params);
    spikes = x(trial.spikes);
    y = -trial.probe_position;
    rpost(r) = sum(spikes>-.4 & spikes<0)/.4;
    fpost(r) = mean(y(x>-.2 & x<0));
end

plot(forceax2,[1 2],[fpre,fpost],'-o');

plot(forceax3,[1 2 3],[fpre,fmax,fpost],'-o');
plot(spikeax3,[1 2 3],[rpre,rmax,rpost],'-o');

plot(spikeax2,rmax,fmax,'.');

% title(forceax,ttl);
% ylabel(forceax,'LED state')
% ylabel(posax,'Probe position (flipped)')
% ylabel(aiax,'V_m (mV)')
% xlabel(aiax,'Time (s)')

% if ~isempty(fplims)
%     posax.YLim = -[fplims(2),fplims(1)];
% end
    
