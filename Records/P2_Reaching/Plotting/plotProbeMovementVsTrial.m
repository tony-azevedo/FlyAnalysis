function [fig] = plotProbeMovementVsTrial(T,varargin)
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


steps = sort(T.displacements{1});

fig = figure;
fig.Position = [178 499 733 420];
panl = panel(fig);
panl.pack('v',{1/2 1/2})  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';
panl.marginbottom = 12;
panl.title('Actual Movement vs. trial')

loclr = [.7 0 .7];
hiclr = [1 .8 1];

loax = panl(1).select();
loax.NextPlot = 'add';
% plot Big movements vs trial for low or high force
idx = T.outcome==1 & T.displacement == -5 & T.hiforce;
plot(loax,T.trial(idx),ones(sum(idx),1)*-5,'--','color',hiclr);
plot(loax,T.trial(idx),-T.cue_mvmt(idx),'.','color',hiclr);

% plot Big movements vs trial for low or high force
idx = T.outcome==1 & T.displacement == 5 & T.hiforce;
plot(loax,T.trial(idx),ones(sum(idx),1)*5,'--','color',hiclr);
plot(loax,T.trial(idx),-T.cue_mvmt(idx),'+','color',hiclr);


hiax = panl(2).select();
hiax.NextPlot = 'add';
% plot Big movements vs trial for low or high force
idx = T.outcome==1 & T.displacement == -5 & ~T.hiforce;
plot(hiax,T.trial(idx),ones(sum(idx),1)*-5,'--','color',loclr);
plot(hiax,T.trial(idx),-T.cue_mvmt(idx),'.','color',loclr);

% plot Big movements vs trial for low or high force
idx = T.outcome==1 & T.displacement == 5 & ~T.hiforce;
plot(hiax,T.trial(idx),ones(sum(idx),1)*5,'--','color',loclr);
plot(hiax,T.trial(idx),-T.cue_mvmt(idx),'+','color',loclr);

xlabel(hiax,'Trial #');
panl.ylabel('cue movement')
panl.marginleft = 18;

linkaxes([loax,hiax])
