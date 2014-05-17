function transfer = CurrentSineVvsFreq(fig,handles,savetag)
% works on Current Sine, there for the blocks have a rang of amps and freqs
% see also TransferFunctionOfLike

[protocol,datestr,flynum,cellnum,~,~] = extractRawIdentifiers(handles.trial.name);
cellID = [datestr '.' flynum '.' cellnum '.'];

if isempty(fig) || ~ishghandle(fig)
    fig = figure(200); clf
else
    delete(get(fig,'children'))
end
set(fig,'tag',mfilename);

p = panel(fig);
p.pack('v',{3/4,1/4})
p.margin = [12 10 2 10];
%p(1).marginbottom = 2;
ax = p(1).select();
title(ax,[cellID ': I to V transfer function'])

if isfield(handles.trial.params,'mode_1')
    multi = 1;
else
    multi = 0;
end

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
        if ~multi
            transfer(jj,ii) = CurrentSineTransFunc([],handles,savetag) * handles.trial.params.amp;
        elseif multi
            transfer(jj,ii) = CurrentSineTransFuncSingleTrode([],handles,savetag,'trode','1') * handles.trial.params.amp;
        end
    end
    
    ax = p(1).select();
    line(handles.trial.params.freqs',abs(transfer(:,ii)),...
        'parent',ax,'color',[0 1/length(handles.trial.params.amps) 0]*ii,...
        'tag',savetag);
    ylabel(ax,'Magnitude (mV/pA)')
    xlabel(ax,'')

    ax = p(2).select();
    line(handles.trial.params.freqs',angle(transfer(:,ii))/(2*pi)*360,...
        'parent',ax,'tag',savetag,...
        'linestyle','none',...
        'marker','o',...
        'markerfacecolor',[0 1/length(handles.trial.params.amps) 0]*ii,...
        'markeredgecolor',[0 1/length(handles.trial.params.amps) 0]*ii,...
        'markersize',4);

    ylabel(ax,'phase (deg)')
    xlabel(ax,'Frequency (Hz)')
end
axis(get(fig,'children'),'tight')
set(get(fig,'children'),'xscale','log');

if multi
    beep
    fprintf('%s does not currently deal with second electrode\n',mfilename);
end
