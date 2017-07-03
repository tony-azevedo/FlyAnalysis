function transfer = PiezoChirpRespVsFreq(fig,handles,savetag)
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

x = makeOutTime(handles.trial.params);
xwindow = x(x>=0+handles.trial.params.ramptime & x<= handles.trial.params.stimDurInSec -handles.trial.params.ramptime);

freqBins = logspace(log10(handles.trial.params.freqStart),log10(handles.trial.params.freqEnd),25);
freqramp = (handles.trial.params.freqEnd - handles.trial.params.freqStart)/...
    handles.trial.params.stimDurInSec * x + ...
    handles.trial.params.freqStart;
freqramp(~xwindow) = 0;

% find a single trial for each displacement
blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'displacement'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

dispexamples = blocktrials;
for ii = 1:length(dispexamples)    
    
    % for each displacement example, get all the trials
    trial = load(fullfile(handles.dir,sprintf(handles.trialStem,dispexamples(ii))));        
    trials = findLikeTrials('name',trial.name,'datastruct',handles.prtclData);
    x = makeTime(trial.params);
    
    if sum(strcmp({'IClamp','IClamp_fast'},trial.params.mode))
        y_name = 'voltage';
        y_units = 'mV';
    elseif sum(strcmp('VClamp',trial.params.mode))
        y_name = 'current';
        y_units = 'pA';
    end
    
    if length(trial.(y_name))<length(x)
        x = x(1:length(trial.(y_name)));
    end
    y = zeros(length(x),length(trials));
    u = y;
    for t = 1:length(trials)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
        y(:,t) = trial.(y_name)(1:length(x));
        u(:,t) = trial.sgsmonitor(1:length(x));
    end
    y = mean(y,2); 
    u = mean(u,2); 
    
    % ZAP calculation
    Z = fft(y(xwindow)) ./ fft(u(xwindow));
    z = ifft(Z);
    
    Z_mag = sqrt(real(Z.*conj(Z)));
    Z_phase = angle(Z);
    
    for jj = 1:length(freqBins)-1
        freqWin = freqramp>=freqBins(jj) & freqramp<=freqBins(jj);
        
        
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
