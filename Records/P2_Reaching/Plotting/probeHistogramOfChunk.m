function [fig] = probeHistogramOfChunk(T,varargin)
% f = plotChunkOfTrials(T,title)


if isempty(T)
    fprintf('No trials\n')
end
Dir = T.Properties.UserData.Dir;
trialStem = T.Properties.UserData.trialStem;

ttl = varargin{1};

fig = figure;
fig.Position = [500   320   960   600];
panl = panel(fig);
panl.pack('v',{1/7 3/7 3/7})  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';
panl(1).margintop = 2;
panl(2).margintop = 10;
panl(3).margintop = 10;

diax = panl(1).select();
posax = panl(2).select();
aiax = panl(3).select();
linkaxes([aiax,posax,diax],'x')

diax.NextPlot = 'add';                
diax.XAxis.Visible = 'off';
posax.NextPlot = 'add';
posax.XAxis.Visible = 'off';
aiax.NextPlot = 'add';

    
    function bhpax = blckHistFig()
block_fphistfig = figure;
set(block_fphistfig,'Color',[0 0 0])
bhpax = subplot(1,1,1,'parent',block_fphistfig); bhpax.NextPlot = 'add';
bhpax.Color = [0 0 0];
bhpax.YColor = [1 1 1];
bhpax.XColor = [1 1 1];

end

function [ax1, ax2] = blckTrcFig()
block_fphistfig = figure;
set(block_fphistfig,'Color',[0 0 0])
ax1 = subplot(2,1,1,'parent',block_fphistfig); ax1.NextPlot = 'add';
ax2 = subplot(2,1,2,'parent',block_fphistfig); ax2.NextPlot = 'add';

ax1.Color = [0 0 0];
ax1.YColor = [1 1 1];
ax1.XColor = [1 1 1];

ax2.Color = [0 0 0];
ax2.YColor = [1 1 1];
ax2.XColor = [1 1 1];

end
