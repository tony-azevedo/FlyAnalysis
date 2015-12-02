function varargout = PF_PiezoSineOsciRespVsFreq(fig,handles,savetag,varargin)
% works on Current Sine, there for the blocks have a range of amps and freqs
% see also TransferFunctionOfLike
ip = inputParser;
ip.PartialMatching = 0;
ip.addParameter('plot',1,@isnumeric);
parse(ip,varargin{:});

if ip.Results.plot
    
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
    p.margin = [20 20 2 10];
    p(1).marginbottom = 2;
    p(2).marginleft = 12; 
end

transfer = nan(length(handles.trial.params.freqs),length(handles.trial.params.displacements));

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'displacement'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

% change the order of the block trials
dispexamples = blocktrials;
exampledisp = dispexamples;
for ii = 1:length(dispexamples)
    params = load(fullfile(handles.dir,sprintf(handles.trialStem,dispexamples(ii))),'params');
    exampledisp(ii) = params.params.displacement;
end
[~,o] = sort(exampledisp);
dispexamples = dispexamples(o);

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
        transfer(jj,ii) = PiezoSineOsciTransFunc([],handles,savetag,'plot',0) * handles.trial.params.displacement;
    end
    
    if ip.Results.plot
        ax = p(1).select();
        line(handles.trial.params.freqs',abs(transfer(:,ii)),...
            'parent',ax,'color',[0 1/length(handles.trial.params.displacements) 0]*ii,...
            'displayname',[num2str(handles.trial.params.displacement) ' V'],...
            'tag',savetag);
        if sum(strcmp({'IClamp','IClamp_fast'},handles.trial.params.mode))
            y_units = 'mV'; %ylims = [0 5.6];
        elseif sum(strcmp('VClamp',handles.trial.params.mode))
            y_units = 'pA'; %ylims = [0 25];
        end

        ylabel(ax,['Magnitude (' y_units ')'])
        set(ax,'tag','magnitude_ax');
        
        ax = p(2).select();
        line(handles.trial.params.freqs',unwrap(angle(transfer(:,ii)))/(2*pi)*360,...
            'parent',ax,...
            'linestyle','none',...
            'displayname',[num2str(handles.trial.params.displacement) ' V'],...
            'marker','o',...
            'markerfacecolor',[0 1/length(handles.trial.params.displacements) 0]*ii,...
            'markeredgecolor',[0 1/length(handles.trial.params.displacements) 0]*ii,...
            'markersize',4);
        set(ax,'tag','phase_ax');
        
        ylabel(ax,'phase (deg)')
        xlabel(ax,'Frequency (Hz)')
        
    end
    
end
varargout{1} = fig;
varargout{2} = transfer;
varargout{3} = handles.trial.params.freqs;
varargout{4} = handles.trial.params.displacements;

if ip.Results.plot
    axis(get(fig,'children'),'tight')
    set(get(fig,'children'),'xscale','log','xlim',[10 600]);
    ax = p(1).select();
    %set(ax,'ylim',ylims)
    legend(ax,'show')
    legend(ax,'boxoff')

    [protocol,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(handles.trial.name);
    p.title(['PSne_RespVFreq_' dateID '_' flynum '_' cellnum])
    set(fig,'name',['PSne_RespVFreq_' dateID '_' flynum '_' cellnum])
end