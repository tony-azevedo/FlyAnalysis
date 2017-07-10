function varargout = PiezoSineDepolRespVsFreq(fig,handles,savetag)
% works on Current Sine, there for the blocks have a rang of amps and freqs
% see also TransferFunctionOfLike

if isempty(fig) || ~ishghandle(fig)
    fig = figure(200); clf
else
    delete(get(fig,'children'));
end
set(fig,'tag',mfilename);

p = panel(fig);
p.pack('v',{1})  % response panel, stimulus panel
p.margin = [20 20 2 10];

area = nan(length(handles.trial.params.freqs),length(handles.trial.params.displacements));
amp = area;

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
        [area(jj,ii),amp(jj,ii)] = PiezoSineDepolTransFunc([],handles,savetag);
    end

    ax = p(1).select();
    line(handles.trial.params.freqs', area(:,ii),...abs(area(:,ii)),... amp(:,ii),...
        'parent',ax,'color',[0 1/length(handles.trial.params.displacements) 0]*ii,...
        'tag',savetag);
    ylabel(ax,'Peak (mV)') % 'Area (mV s)'
    title(ax,'Freq Selectivity')
    set(ax,'tag','magnitude_ax');

    xlabel(ax,'Frequency (Hz)')
end
axis(get(fig,'children'),'tight')
set(get(fig,'children'),'xscale','log');

varargout{1} = area;
varargout{2} = handles.trial.params.freqs;
varargout{3} = handles.trial.params.displacements;
varargout{4} = amp;
