figure
clrs = parula(size(trial.clustertraces,2));

for cl = 1:size(trial.clustertraces,2)
    alphamask(trial.clmask==cl,clrs(cl,:),.5);
end

%%
figure
clrs = parula(size(trial.clustertraces,2));
ax = subplot(1,1,1);
for cl = 1:size(trial.clustertraces,2)
    plot(trial.clustertraces(:,cl),'color',clrs(cl,:),'parent',ax)
    hold(ax,'on')
end
