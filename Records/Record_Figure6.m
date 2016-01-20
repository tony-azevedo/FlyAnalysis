
%% Vm 
savedir = '/Users/tony/Dropbox/RAnalysis_Data/Record_FS';

fig = figure;
set(fig,'color',[1 1 1],'units','inches','position',[1 3 10 3.7],'name','Summary_Vm');
pnl = panel(fig);
pnl.margin = [20 18 6 12];
pnl.pack(1);
pnl.de.margin = [4 4 4 4];

Vm = [];
Vm_group = [];

x = 1;
uiopen('/Users/tony/Dropbox/RAnalysis_Data/Record_FS/Vm/LP_Vm.fig',1)
fig_low = gcf;
ax_low = findobj(fig_low,'type','axes');
l = copyobj(get(ax_low,'children'),pnl(1).select());  
set(l,'xdata',x); 
v_ = cell2mat(get(l,'ydata')); 
Vm = [Vm;v_];
Vm_group = [Vm_group;x*ones(size(v_,1),1)];
line(x+[-.2 .2],[mean(v_) mean(v_)],'parent',pnl(1).select());
text(x,-28,['N=' num2str(length(l))],'parent',pnl(1).select(),'horizontalalignment','center');

x = 2;
uiopen('/Users/tony/Dropbox/RAnalysis_Data/Record_FS/Vm/BPL_Vm.fig',1)
fig_bpl = gcf; 
ax_bpl = findobj(fig_bpl,'type','axes');
l = copyobj(get(ax_bpl,'children'),pnl(1).select());  
set(l,'xdata',x); 
v_ = cell2mat(get(l,'ydata')); 
Vm = [Vm;v_];
Vm_group = [Vm_group;x*ones(size(v_,1),1)];
line(x+[-.2 .2],[mean(v_) mean(v_)],'parent',pnl(1).select());
text(x,-28,['N=' num2str(length(l))],'parent',pnl(1).select(),'horizontalalignment','center');

x = 3;
uiopen('/Users/tony/Dropbox/RAnalysis_Data/Record_FS/Vm/BPH_Vm.fig',1); 
fig_bph = gcf; 
ax_bph  = findobj(fig_bph,'type','axes');
l = copyobj(get(ax_bph,'children'),pnl(1).select());  
set(l,'xdata',x); 
v_ = cell2mat(get(l,'ydata')); 
Vm = [Vm;v_];
Vm_group = [Vm_group;x*ones(size(v_,1),1)];
line(x+[-.2 .2],[mean(v_) mean(v_)],'parent',pnl(1).select());
text(x,-28,['N=' num2str(length(l))],'parent',pnl(1).select(),'horizontalalignment','center');

x = 4;
uiopen('/Users/tony/Dropbox/RAnalysis_Data/Record_FS/Vm/HP_Vm.fig',1)
fig_hi = gcf; 
ax_hi = findobj(fig_hi,'type','axes');
l = copyobj(get(ax_hi,'children'),pnl(1).select());  
set(l,'xdata',x); 
v_ = cell2mat(get(l,'ydata')); 
Vm = [Vm;v_];
Vm_group = [Vm_group;x*ones(size(v_,1),1)];
line(x+[-.2 .2],[mean(v_) mean(v_)],'parent',pnl(1).select());
text(x,-28,['N=' num2str(length(l))],'parent',pnl(1).select(),'horizontalalignment','center');


set(pnl(1).select(),'xlim',[.5 4.5],'ylim',[-50 -25],'xtick',[1 2 3 4],'xticklabel',{'LP' 'BPL' 'BHP' 'HP-A2'})
ylabel(pnl(1).select(),'V_m (mV)');
savePDFandFIG(fig,savedir,[],'Summary_Vm')

barfig = figure;
set(barfig,'color',[1 1 1],'units','inches','position',[1 3 10 3.7],'name','Summary_Vm_Box');

pnl = panel(barfig);
pnl.margin = [20 20 10 10];
pnl.pack('h',1);

to_ax = pnl(1).select(); hold(to_ax,'on');
boxplot(to_ax,Vm,Vm_group,'plotstyle','traditional','notch','on');
savePDFandFIG(barfig,savedir,[],'Summary_Vm_Box')


