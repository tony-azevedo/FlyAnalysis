function [fig] = plotCompareLoHiFeedbackResponses(T,varargin)
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
pck = num2cell(ones(1,length(steps))/length(steps));
panl.pack('v',{1/2 1/2})  % response panel, stimulus panel
panl(1).pack('h',pck)  % response panel, stimulus panel
panl(2).pack('h',pck)  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';
panl.marginbottom = 12;

loclr = [.7 0 .7];
hiclr = [1 .8 1];


for i = 1:length(steps)
    ax = panl(1,i).select();
    ax.NextPlot = 'add';
    axs(i) = ax;
    
    stp = steps(i);
    idx = T.outcome == 1 & ~T.hiforce & T.displacement == stp;
    plot(ax,-T.probe_position_init(idx),T.Vm_stim_on(idx),'.','color',loclr)
    x_bar = mean(-T.probe_position_init(idx));
    y_bar = mean(T.Vm_stim_on(idx));
    x_std = std(-T.probe_position_init(idx));
    y_std = std(T.Vm_stim_on(idx));
    plot(ax,x_bar+x_std*[-1 1],y_bar*[1 1],'color',[0 0 0])
    plot(ax,x_bar*[1 1],y_bar+y_std*[-1 1],'color',[0 0 0])

    idx = T.outcome == 1 & T.hiforce & T.displacement == stp;
    plot(ax,-T.probe_position_init(idx),T.Vm_stim_on(idx),'.','color',hiclr)
    title(sprintf('Stim on: %g',stp))   
    x_bar = mean(-T.probe_position_init(idx));
    y_bar = mean(T.Vm_stim_on(idx));
    x_std = std(-T.probe_position_init(idx));
    y_std = std(T.Vm_stim_on(idx));
    plot(ax,x_bar+x_std*[-1 1],y_bar*[1 1],'color',[1 1 1]*.5)
    plot(ax,x_bar*[1 1],y_bar+y_std*[-1 1],'color',[1 1 1]*.5)

    
end
%xlabel(axs(1),'Init probe pos. (flipped)')
ylabel(axs(1),'Feedback Amp. (mV)')

linkaxes(axs)


for i = 1:length(steps)
    ax = panl(2,i).select();
    ax.NextPlot = 'add';
    axs(i) = ax;
    
    stp = steps(i);
    idx = T.outcome == 1 & ~T.hiforce & T.displacement == stp;
    plot(ax,-T.probe_position_init(idx),T.Vm_stim_off(idx),'.','color',loclr)
    x_bar = mean(-T.probe_position_init(idx));
    y_bar = mean(T.Vm_stim_off(idx));
    x_std = std(-T.probe_position_init(idx));
    y_std = std(T.Vm_stim_off(idx));
    plot(ax,x_bar+x_std*[-1 1],y_bar*[1 1],'color',[0 0 0])
    plot(ax,x_bar*[1 1],y_bar+y_std*[-1 1],'color',[0 0 0])

    idx = T.outcome == 1 & T.hiforce & T.displacement == stp;
    plot(ax,-T.probe_position_init(idx),T.Vm_stim_off(idx),'.','color',hiclr)
    title(sprintf('Stim off: %g',stp))   
    x_bar = mean(-T.probe_position_init(idx));
    y_bar = mean(T.Vm_stim_off(idx));
    x_std = std(-T.probe_position_init(idx));
    y_std = std(T.Vm_stim_off(idx));
    plot(ax,x_bar+x_std*[-1 1],y_bar*[1 1],'color',[1 1 1]*.5)
    plot(ax,x_bar*[1 1],y_bar+y_std*[-1 1],'color',[1 1 1]*.5)

    
end
xlabel(axs(1),'Init probe pos. (flipped)')
ylabel(axs(1),'Feedback Amp. (mV)')

linkaxes(axs)


