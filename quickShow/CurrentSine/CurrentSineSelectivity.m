function transfer = CurrentSineSelectivity(fig,handles,savetag)
% works on Current Sine, there for the blocks have a rang of amps and freqs
% see also TransferFunctionOfLike

if isempty(fig) || ~ishghandle(fig)
    fig = figure(200); clf
else
end
set(fig,'tag',mfilename);
ax = subplot(3,1,[1 2],'parent',fig);
ax = subplot(3,1,3,'parent',fig);
cellID = regexp(handles.dir,'\\');
cellID = handles.dir(cellID(end)+1:end);
cellID = regexprep(cellID,'_','\.');

transfer = nan(length(handles.trial.params.freqs),length(handles.trial.params.amps));
blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'amp'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

ampexamples = blocktrials;
for ii = 1:length(ampexamples)
    blocktrials = findLikeTrials('trial',ampexamples(ii),'datastruct',handles.prtclData,'exclude',{'freq'});
    t = 1;
    while t <= length(blocktrials)
        trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
        blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
        t = t+1;
    end
    
    freqexamples = blocktrials;
    for jj = 1:length(freqexamples)
        handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,freqexamples(jj))));
        transfer(jj,ii) = CurrentSineTransFunc([],handles,savetag);
    end

    ax = subplot(3,1,[1 2],'parent',fig);
    line(handles.trial.params.freqs',abs(transfer(:,ii)),...
        'parent',ax,'color',[0 1/length(handles.trial.params.amps) 0]*ii,...
        'tag',savetag);
    ylabel(ax,'Magnitude (mV/pA)')
    title(ax,[cellID ': I to V transfer function'])
    xlabel(ax,'')

    ax = subplot(3,1,3,'parent',fig);
    line(handles.trial.params.freqs',angle(transfer(:,ii))/(2*pi)*360,...
        'parent',ax,'color',[0 1/length(handles.trial.params.amps) 0]*ii,...
        'tag',savetag);
    ylabel(ax,'phase (deg)')
    xlabel(ax,'Frequency (Hz)')
end
axis(get(fig,'children'),'tight')
set(get(fig,'children'),'xscale','log');
