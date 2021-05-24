function [fig] = plotCommandVsActualMovemnt(T,varargin)
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
panl.pack('h',{1/2 1/2})  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';
panl.marginbottom = 12;
panl.title('Actual Movement vs. command')

loclr = [.7 0 .7];
hiclr = [1 .8 1];

axlo = panl(1).select();
axlo.NextPlot = 'add';
title(axlo,'Lo');

for i = 1:length(steps)
    
    stp = steps(i);
    idx = T.outcome == 1 & ~T.hiforce & T.displacement == stp;
    plot(axlo,stp+.1,-T.cue_mvmt(idx),'.','color',loclr)    

    y_bar = mean(-T.cue_mvmt(idx));
    y_std = std(T.cue_mvmt(idx));
    plot(axlo,stp+[-1 1],y_bar*[1 1],'color',[0 0 0])
    plot(axlo,stp*[1 1],y_bar+y_std*[-1 1],'color',[0 0 0])

end

ylabel(axlo,'probe position')
xlabel(axlo,'command')

axhi = panl(2).select();
axhi.NextPlot = 'add';
title(axhi,'Hi');

for i = 1:length(steps)
    
    stp = steps(i);
    idx = T.outcome == 1 & T.hiforce & T.displacement == stp;
    plot(axhi,stp,-T.cue_mvmt(idx),'.','color',hiclr)    

    y_bar = mean(-T.cue_mvmt(idx));
    y_std = std(T.cue_mvmt(idx));
    plot(axhi,stp+[-1 1],y_bar*[1 1],'color',[0 0 0])
    plot(axhi,stp*[1 1],y_bar+y_std*[-1 1],'color',[0 0 0])

end

xlabel(axhi,'command')

linkaxes([axlo, axhi])

