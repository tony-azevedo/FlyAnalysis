f = gcf;
ax = subplot(3,1,3);
axs = get(f, 'children');
delete(axs(axs==ax))
ax = get(f, 'children');
set