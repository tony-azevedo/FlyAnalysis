function pnls = PF_CurrentChirpZAPFam(pnls,obj,savetag,varargin)
% works on Current Sine, there for the blocks have a rang of amps and freqs
% see also CurrentChirpZAPFam

% for each displacement example, get all the trials
blocktrials = findBlockTrials(obj.trial,obj.prtclData);
cnt = 1;
for bt = blocktrials;
    obj.trial = load(fullfile(obj.dir,sprintf(obj.trialStem,bt)));
    trials = findLikeTrials('name',obj.trial.name,'datastruct',obj.prtclData);

    x = makeTime(obj.trial.params);
    xwindow = x>=0+obj.trial.params.ramptime & x< obj.trial.params.stimDurInSec -obj.trial.params.ramptime;
        
    y = zeros(length(x),length(trials));
    protocolInstance = eval(obj.trial.params.protocol);
    pr = obj.trial.params;
    pr.amps = pr.amp;
    protocolInstance.setParams('-q',pr);
    u = protocolInstance.getStimulus().current;
    for t = 1:length(trials)
        trial = load(fullfile(obj.dir,sprintf(obj.trialStem,trials(t))));
        y(:,t) = trial.voltage;
    end
    y = mean(y,2);
    
    y = y - mean(y);
    u = u - mean(u(x<=0));
    
    % ZAP calculation
    Z = fft(y(xwindow)) ./ fft(u(xwindow));
    f = trial.params.sampratein/length(x(xwindow))*[0:length(x(xwindow))/2]; f = [f, fliplr(f(2:end-1))];
    
    colr = (cnt-.99)/(length(blocktrials)-.99) * [0 -1 1] + [0 1 0];
    Z_mag = sqrt(real(Z.*conj(Z)));
    Z_phase = angle(Z);
    
    %freqBins = logspace(log10(handles.trial.params.freqStart),log10(handles.trial.params.freqEnd),100);
    freqBins = obj.trial.params.freqStart:2.5:obj.trial.params.freqEnd;
    freqBins = sort(freqBins);
    fsampled = freqBins(1:end-1);
    Z_mag_sampled = freqBins(1:end-1);
    for fb = 1:length(freqBins)-1
        f_wind = f >= freqBins(fb) & f<freqBins(fb+1);
        fsampled(fb) = 10^(mean(log10(f(f_wind))));
        Z_mag_sampled(fb) = mean(Z_mag(f_wind));
    end
    
    ax = pnls(1);
    line(fsampled,Z_mag_sampled,...
        'parent',ax,'color',colr,...
        'displayname',[num2str(obj.trial.params.amp) ' pA'],...
        'tag',savetag);
    
    set(ax,'xlim',[...
        max(min(obj.trial.params.freqStart,obj.trial.params.freqEnd),3),...
        max(obj.trial.params.freqStart,obj.trial.params.freqEnd),...
        ])
    
    ax = pnls(2);
    line(f(1:length(f)/2),Z_phase(1:length(f)/2)/(2*pi)*360,...
        'parent',ax,...
        'linestyle','none',...
        'displayname',[num2str(obj.trial.params.amp) ' pA'],...
        'marker','.',...
        'markerfacecolor',colr,...
        'markeredgecolor',colr,...
        'markersize',2);
    
    set(ax,'xlim',[...
        max(min(obj.trial.params.freqStart,obj.trial.params.freqEnd),3),...
        max(obj.trial.params.freqStart,obj.trial.params.freqEnd),...
        ])
    
    %set(pnls,'xscale','log');
    %set(p.de.axis,'tickdir','out')

    cnt = cnt+1;
end
ax = pnls(1);
legend(ax,'show')
legend(ax,'boxoff')