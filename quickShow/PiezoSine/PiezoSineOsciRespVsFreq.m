function transfer = PiezoSineOsciRespVsFreq(fig,handles,savetag)
% works on Current Sine, there for the blocks have a rang of amps and freqs
% see also TransferFunctionOfLike

if isempty(fig) || ~ishghandle(fig)
    fig = figure(200); clf
else
end
set(fig,'tag',mfilename);
if strcmp(get(fig,'type'),'figure')
    set(fig,'color',[1 1 1])
else
    delete(get(fig,'children'));
end
p = panel(fig);
p.pack('v',{2/3  1/3})  % response panel, stimulus panel
p.margin = [13 10 2 10];
p(1).marginbottom = 2;
p(2).marginleft = 12;


transfer = nan(length(handles.trial.params.freqs),length(handles.trial.params.displacements));

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'displacement'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

dispexamples = blocktrials;
for ii = 1:length(dispexamples)
    blocktrials = findLikeTrials('trial',dispexamples(ii),'datastruct',handles.prtclData,'exclude',{'freq'});
    t = 1;
    while t <= length(blocktrials)
        trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
        blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
        t = t+1;
    end
    
    freqexamples = blocktrials;
    for jj = 1:length(freqexamples)
        handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,freqexamples(jj))));
        transfer(jj,ii) = PiezoSineOsciTransFunc([],handles,savetag) * handles.trial.params.displacement;
    end
    
    ax = p(1).select();
    line(handles.trial.params.freqs',abs(transfer(:,ii)),...
        'parent',ax,'color',[0 1/length(handles.trial.params.displacements) 0]*ii,...
        'tag',savetag);
    ylabel(ax,'Magnitude (mV)')
    title(ax,'Stim to V transfer function')

    ax = p(2).select();
    line(handles.trial.params.freqs',angle(transfer(:,ii))/(2*pi)*360,...
        'parent',ax,...
        'linestyle','none',...
        'marker','o',...
        'markerfacecolor',[0 1/length(handles.trial.params.displacements) 0]*ii,...
        'markeredgecolor',[0 1/length(handles.trial.params.displacements) 0]*ii,...
        'markersize',4);
    
    ylabel(ax,'phase (deg)')
    xlabel(ax,'Frequency (Hz)')
end
axis(get(fig,'children'),'tight')
set(get(fig,'children'),'xscale','log');
