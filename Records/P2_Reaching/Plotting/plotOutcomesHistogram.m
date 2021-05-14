function [fig] = plotOutcomesHistogram(T,outcomes,varargin)
% f = plotChunkOfTrials(T,title)

if isempty(T)
    fprintf('No trials\n')
    fig = [];
    return
end
Dir = T.Properties.UserData.Dir;
trialStem = T.Properties.UserData.trialStem;

if nargin>1
    ttl = varargin{1};
end

fig = figure;
fig.Position = [500   701   960   219];
panl = panel(fig);
panl.pack('v',{1})  % response panel, stimulus panel
panl.margin = [32 12 2 10];
panl.fontname = 'Arial';
panl.marginbottom = 12;

outcomeax = panl(1).select();

plot(outcomeax,T.trial,T.outcome,'.');

outcomeax.YTick = 0:6;
outcomeax.YTickLabel = {'rest',outcomes{:}};
outcomeax.YLim = [-.2 6.2];
outcomeax.XLim = [-5 max(T.trial)+5];

blcks = unique(T.block);
for b = 1:max(blcks)

    bl_i = find(T.block==b,1,'first');
    bl_f = find(T.block==b,1,'last');

    if ~T.hiforce(bl_i)
        trgclr = [.92 .6 .7];
    else
        trgclr = [1 .9 1];
    end

    patch('XData',T.trial([bl_i bl_f bl_f bl_i]), ...
        'YData',[-.2 -.2 6.2 6.2],...
        'FaceColor',trgclr,'EdgeColor','none','parent',outcomeax,'Tag','target')
    
end
outcomeax.Children = flipud(outcomeax.Children);

title(outcomeax,ttl);
xlabel(outcomeax,'Trial #')

