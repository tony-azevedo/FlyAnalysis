function [fig] = plotCoT_aligned2LEDOff(T,varargin)
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
panl.pack('v',{1/7 3/7 3/7})  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';
panl(1).margintop = 2;
panl(2).margintop = 10;
panl(3).margintop = 10;
panl.marginbottom = 12;

diax = panl(1).select();
posax = panl(2).select();
aiax = panl(3).select();
linkaxes([aiax,posax,diax],'x')

diax.NextPlot = 'add';                
diax.XAxis.Visible = 'off';
posax.NextPlot = 'add';
posax.XAxis.Visible = 'off';
aiax.NextPlot = 'add';


for r = 1:size(T,1)
    T_row = T(r,:);    
    trial = load(fullfile(Dir,sprintf(trialStem,T_row.trial)));
    x = makeInTime(trial.params);
    plot(diax,x-T_row.arduino_duration,trial.arduino_output);
    plot(posax,x-T_row.arduino_duration,-trial.probe_position,'tag',num2str(T_row.trial));
    plot(aiax,x-T_row.arduino_duration,trial.voltage_1,'tag',num2str(T_row.trial));
end    
axis(aiax,'tight');
xlims = aiax.XLim;

if all(T.hiforce) || all(~T.hiforce)
    %all(T.target1==T.target1(1)) && all(T.target2==T.target2(1))

    patch('XData',[x(1) x(end) x(end) x(1)], ...
        'YData',-(T.target1(end)*[1 1 1 1] + diff([T.target1(end) T.target2(end)])*[0 0 1 1]),...
        'FaceColor',[1 1 1]*.9,'EdgeColor','none','parent',posax,'Tag','target')
    posax.Children = circshift(posax.Children,-1);
    
    prestim = (T.preDurInSec(1)-T.cueDelayDurInSec(1)-T.cueStimDurInSec(1));
    if ~T.hiforce(1)
        trgclr = [.7 0 .7];
    else
        trgclr = [1 .8 1];
    end
    rectangle(posax,'Position',[x(1) -T.target2(end) .05 diff([T.target1(end) T.target2(end)])],'FaceColor',trgclr,'EdgeColor','none','LineWidth',2)
end
if all(T.blueToggle)
    ptch = findobj(posax,'Tag','target');
    ptch.FaceColor = [.9 .9 1];
end


aiax.XLim = [x(1) x(end)];

title(diax,ttl);
ylabel(diax,'LED state')
ylabel(posax,'Probe position (flipped)')
ylabel(aiax,'V_m (mV)')
xlabel(aiax,'Time (s)')

if ~isempty(fplims)
    posax.YLim = -[fplims(2),fplims(1)];
end
