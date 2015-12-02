% Script for looking at the threshold of voltage gated Na currents

figs = [1 2 3 4 5 6];

fig = figure;
pnlhs(1) = subplot(3,4,[1 2 3 5 6 7]);
pnlhs(4) = subplot(3,4,[9 10 11]);
pnlhs(2) = subplot(2,4,4);
pnlhs(3) = subplot(2,4,8);

clrs = parula(length(figs));

for f =1:length(figs)
    l_ = findobj(figs(f),'type','line','color',[.7 0 0]);
    l = copyobj(l_,pnlhs(1));
    set(l,'color',clrs(f,:))
    
    x = get(l,'xdata');
    v = get(l,'ydata');
    [peak,ttpk] = min(v(x>.1+.0001&x<.15));
    ttpk = x(sum(x<=.1)+ttpk)-.1;
    
    v_ = findobj(figs(f),'type','line','color',[0 0 1]);
    v_ = copyobj(v_,pnlhs(4));
    
    x = get(v_,'xdata');
    v = get(v_,'ydata');
    Vtest = mean(v(x>.15 &x<.2));
    
    line(Vtest,ttpk*1000,'parent',pnlhs(2),'marker','o','markeredgecolor',clrs(f,:),'markerfacecolor',clrs(f,:))
    line(Vtest,peak,'parent',pnlhs(3),'marker','o','markeredgecolor',clrs(f,:),'markerfacecolor',clrs(f,:))
    set(l,'userdata',Vtest);
    set(v_,'userdata',Vtest);
end
linkaxes(pnlhs([1 4]),'x');
linkaxes(pnlhs([2 3]),'x');
set(pnlhs(1),'ylim',[-370 31],'xlim',[.095 .107]);

ls = findobj(pnlhs(1),'type','line');
V_test = cell2mat(get(ls,'userdata'));
[v_,o] = sort(V_test);
ls = ls(o);

set(pnlhs(2),'xlim',[min(v_) max(v_)]);

for l = 1:length(v_)
    set(ls(l),'color',clrs(l,:));
    set(findobj(pnlhs(2),'xdata',v_(l)),'markeredgecolor',clrs(l,:),'markerfacecolor',clrs(l,:));
    set(findobj(pnlhs(3),'xdata',v_(l)),'markeredgecolor',clrs(l,:),'markerfacecolor',clrs(l,:));
    set(findobj(pnlhs(4),'userdata',v_(l)),'color',clrs(l,:));
end

ylabel(pnlhs(1),'pA')
ylabel(pnlhs(4),'mV')
xlabel(pnlhs(4),'s')

ylabel(pnlhs(2),'ms')
xlabel(pnlhs(2),'mV')

ylabel(pnlhs(3),'pA')
xlabel(pnlhs(3),'mV')

title(pnlhs(1),'151117_F1_C1') 
