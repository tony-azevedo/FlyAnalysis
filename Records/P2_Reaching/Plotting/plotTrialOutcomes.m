function [fig] = plotTrialOutcomes(T,outcomes,varargin)
% f = plotChunkOfTrials(T,title)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('Simple','No',@(x)any(ismember({'Yes','yes','No','no'},x)));
p.addParameter('Title','',@ischar);

parse(p,varargin{:});

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

outcomevec = T.outcome;
if any(strcmp(p.Results.Simple,{'Yes','yes'}))
    outcomevec(outcomevec==2) = 1;
    outcomevec(outcomevec==4) = 3;
    outcomevec(outcomevec==6) = 5;
end


plot(outcomeax,T.trial,outcomevec,'+r');
outcomeax.NextPlot = 'add';
plot(outcomeax,T.trial(T.blueToggle==1),outcomevec(T.blueToggle==1),'+b');

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

