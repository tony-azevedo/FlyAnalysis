%% Plotting scraps


[earlytrax,latetrax] = blckTrcFig;

title(earlytrax,'Block 4','color',[1 1 1])
for tr = block{4}
    trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
    ft = makeFrameTime(trial);
    plot(earlytrax,ft,trial.forceProbeStuff.CoM,'color',earlyclr);
end

title(latetrax,'Block 6','color',[1 1 1])
for tr = 222:231
    trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
    ft = makeFrameTime(trial);
    plot(latetrax,ft,trial.forceProbeStuff.CoM,'color',lateclr);
end

l1 = plot(earlytrax,[ft(1), ft(end)],neutral*[1, 1]);
l2 = plot(latetrax,[ft(1), ft(end)],trial.forceProbeStuff.ArduinoThresh*[1, 1],'color',lowclr);

ylims = [min([earlytrax.YLim,latetrax.YLim]), max([earlytrax.YLim,latetrax.YLim])];
earlytrax.YLim = ylims; latetrax.YLim = ylims;
xlabel('Time (s)')
ylabel('Probe')
    
[earlytrax,latetrax] = blckTrcFig;




%% Finally, compare sets 4 and 6.

% bhpax = blckHistFig();
% xlabel(bhpax, 'Force Probe');
% ylabel(bhpax, 'Counts');
% btrs = block{b};
% 
% % take snippets of the time frames
% ft_win = true(size(ft));
% 
% histogram(bhpax,forceProbe(ft_win,btrs),ubins,'Normalization','count','DisplayStyle','stairs','displayname',['block ' num2str(b) ' pt 1'],'EdgeColor',earlyclr);
% 
% plot(bhpax,[lowthrsh lowthrsh],[0 bhpax.YLim(2)],'displayname','low','color',lowclr);
% plot(bhpax,[highthrsh highthrsh],[0 bhpax.YLim(2)],'displayname','high','color',hiclr);
% plot(bhpax,[neutral neutral],[0 bhpax.YLim(2)],'displayname','neutral','color',hiclr);
% 
% l = legend('show');
% l.Box = 'off';
% l.TextColor = [1 1 1];