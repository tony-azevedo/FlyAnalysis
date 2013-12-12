f = gcf;
axs = get(f, 'children');
set(axs,'fontsize',18)
set(findall(f,'type','text'),'fontsize',18)
set(findall(ax,'type','line'),'color',[0 0 0])
% set(axs(1),'position',[0.2 0.2 0.75 0.6]);


%%
f = gcf;
axs = get(f, 'children');
pos1 = get(axs(1),'position');
pos2 = get(axs(2),'position');
set(axs(2),'position',[pos1(1) pos2(2) pos1(3) pos2(4)])