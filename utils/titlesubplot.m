function ax = titlesubplot(p)
axs = get(p,'children');
for i = 1:length(axs)
    pos(i,:) = get(axs(i),'position');
end
ind = find(pos(:,2) == max(pos(:,2)));
ax = axs(ind);