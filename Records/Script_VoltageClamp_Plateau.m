platfig = figure;
pnl = panel(platfig);

set(platfig,'color',[1 1 1],'position',[382 508 1064 459]);
pnl.pack('h',{2/3 1/3})
pnl(1).pack('v',{3/4 1/4})
pnl(2).pack('v',{3/4 1/4})
pnl.margin = [18 18 10 10];

for fig = 1:3
    figure(fig)
    resp(fig) = copyobj(findobj(fig,'color',[.7 0 0]),pnl(1,1).select());
    vcommands(fig) = copyobj(findobj(fig,'color',[0 0 1]),pnl(1,2).select());
end
    

resp = resp(:);
vcommands = vcommands(:);

for v_ind = 1:length(vcommands);
    l = vcommands(v_ind);
    x = get(l,'xdata');    
    v = get(l,'ydata');
    
    dur = x(find(x>0&v<mean(v(x>0)),1,'last'));
    l = copyobj(resp(v_ind),pnl(2,1).select());
    set(l,'xdata',get(l,'xdata')-dur,'color',(v_ind-1)*[1 1 1]/length(vcommands));
end
x = get(l,'xdata');
cur = get(l,'ydata');
set(pnl(2,1).select(),'xlim',[-.001,.005],'ylim',[min(cur(x>0)) 100])
set(pnl(1,1).select(),'xlim',[-.05,dur+.05],'ylim',[min(cur(x>0)) 100])
set(pnl(1,2).select(),'xlim',[-.05,dur+.05])