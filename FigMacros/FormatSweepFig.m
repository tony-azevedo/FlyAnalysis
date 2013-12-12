f = gcf;
ax = subplot(3,1,3);
xlabe = get(get(ax,'xlabel'),'string');
axs = get(f, 'children');
delete(axs(axs==ax))
ax = get(f, 'children');
xlabel(ax,xlabe);
set(ax,'fontsize',18)
set(findall(ax,'type','text'),'fontsize',18)
set(findall(ax,'type','line'),'color',[0 0 0])
set(ax,'position',[0.2 0.2 0.75 0.6]);

tite = get(get(ax,'title'),'string');
set(f,'FileName',regexprep(tite,'\.','_'));
tagstr = get(findobj(ax,'type','text'),'string');
if ~isempty(tagstr)
    set(f,'FileName',[regexprep(tite,'\.','_') '_' regexprep(tagstr,';','_')]);
end

% % ylims = [Inf, -Inf]
% ylims_temp = get(ax,'ylim');

%%
ylims_temp = get(gca,'ylim');
ylims = [min([ylims(1),ylims_temp(1)]),max([ylims(2),ylims_temp(2)])];
%%
set(gca,'ylim',ylims)


