function displayf = showLegClusters(mask)

wh = size(mask);
wh = wh(1:2);

displayf = figure;
displayf.Position = [40 40 fliplr(wh)];
displayf.ToolBar = 'none';
dispax = axes('parent',displayf,'units','pixels','position',[0 0 fliplr(wh)]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

clstnum = unique(mask(:));
clstnum = clstnum(clstnum>0);
clrs = parula(length(clstnum));
clrs = clrs(1:end,:);

% clrs = parula(N_cl);
hexclrs = [
    '3C489E'
    'D64C90'
    'F9A61A'
    '00FF00'
    '47DDFF'
    'ED4545'
    '03AC72'
    '3304AC'
    ];

clrs = hex2rgb(hexclrs);
% clrs = clrs(1:N_cl,:);% 4.8982 in 6.1249 in

imshow(mask*0,[0 255],'parent',dispax);
for cl = 1:length(clstnum)
    alphamask(mask==clstnum(cl),clrs(cl,:),1,dispax);
end

