function [ax1] = fpHm(ft,trials,forceProbe,ad,bT,H,varargin)

if isnumeric(H)
    lims = H;
elseif contains(class(H),'Histogram')
    % If there are bins in which the histogram of maxes is 0, throw any higher
    % values out, the point at which the fly lets go is likely lower
    bins = H.BinEdges(1:end-1)+H.BinWidth/2;
    bins = bins(1:find(H.Values==0 & [diff(H.Values)==0 0],1,'first'));
    lims = [bins(1) bins(end)];
end

forceProbe(forceProbe>max(lims)) = max(lims);
forceProbe(forceProbe<min(lims)) = min(lims);


% for now, reverse the colors
% forceProbe = -(forceProbe - lims(2));

figure;
set(gcf,'Position',[65    32   826   964])
ax1 = subplot(1,1,1);
s1 = pcolor(ax1,ft,trials,forceProbe');
s1.EdgeColor = 'flat';
colormap(ax1,'parula')
oldclrmap = colormap;
colormap(ax1,flipud(oldclrmap));
clrbr = colorbar(ax1);
xlabel(ax1,'Time (s)');
ylabel(ax1,'Trial #');

ax1.YDir = 'reverse';
ax1.NextPlot = 'add';
if nargin > 3
    plot(ax1,ad,trials,'.','color',[1,1,1])
end

% draw blocks and what color
cmap = colormap(ax1);
for b = 1:size(bT,1)
    ti = bT(b,:);
    if ~bT.HiForce(b)
        trgclr = [.7 0 .7];
    else
        trgclr = [1 .3 1];
    end
    % trgclr = cmap(indx,:);
    rectangle(ax1,'Position',[ax1.XLim(1) ti.b_start .05 diff([ti.b_start ti.b_end])],'FaceColor',trgclr,'EdgeColor','none','LineWidth',2)
    %rectangle(ax1,'Position',[ax1.XLim(1) ti(1) diff(ax1.XLim) diff(ti)],'EdgeColor',[.2 .2 .2],'LineWidth',.5)
end

ax1.Parent.Color = [1 1 1]*0;
ax1.YColor = [1 1 1];
ax1.XColor = [1 1 1];
clrbr.Color = [1 1 1];
clrbr.Label.String = '\mum';
end
