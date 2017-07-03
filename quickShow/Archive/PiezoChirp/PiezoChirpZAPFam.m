function varargout = PiezoChirpZAPFam(fig,handles,savetag,varargin)
% works on Current Sine, there for the blocks have a rang of amps and freqs
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
    p.margin = [16 16 2 10];
    p(1).marginbottom = 2;
    p(2).marginleft = 13;
end
% for each displacement example, get all the trials
blocktrials = findBlockTrials(handles.trial,handles.prtclData);
cnt = 1;
for bt = blocktrials;
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);

    x = makeTime(handles.trial.params);
    xwindow = x>=0+handles.trial.params.ramptime & x< handles.trial.params.stimDurInSec -handles.trial.params.ramptime;
    
    if sum(strcmp({'IClamp','IClamp_fast'},handles.trial.params.mode))
        y_name = 'voltage';
        y_units = 'mV';
    elseif sum(strcmp('VClamp',handles.trial.params.mode))
        y_name = 'current';
        y_units = 'pA';
    end
    
    if length(handles.trial.(y_name))<length(x)
        x = x(1:length(handles.trial.(y_name)));
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
    
    y = y - mean(y);
    u = u - mean(u(x<=0));
    
    % ZAP calculation
    Z = fft(y(xwindow)) ./ fft(u(xwindow));
    f = trial.params.sampratein/length(x(xwindow))*[0:length(x(xwindow))/2]; f = [f, fliplr(f(2:end-1))];
    varargout = {Z,f,x,y,u};
    
    if ip.Results.plot
        colr = (cnt-1)/(length(blocktrials)-1) * [0 1 -1] + [0 0 1];
        Z_mag = sqrt(real(Z.*conj(Z)));
        Z_phase = angle(Z);
        
        %freqBins = logspace(log10(handles.trial.params.freqStart),log10(handles.trial.params.freqEnd),100);
        freqBins = handles.trial.params.freqStart:2.5:handles.trial.params.freqEnd;
        freqBins = sort(freqBins);
        fsampled = freqBins(1:end-1);
        Z_mag_sampled = freqBins(1:end-1);
        for fb = 1:length(freqBins)-1
            f_wind = f >= freqBins(fb) & f<freqBins(fb+1);
            fsampled(fb) = 10^(mean(log10(f(f_wind))));
            Z_mag_sampled(fb) = mean(Z_mag(f_wind));
        end
        
        ax = p(1).select();
        line(fsampled,Z_mag_sampled,...
            'parent',ax,'color',colr,...
            'displayname',[num2str(handles.trial.params.displacement)  ' V'],...
            'tag',savetag);
        ylabel(ax,'Magnitude (mV/V)')
        [prot,d,fly,cell,trialnum] = extractRawIdentifiers(handles.trial.name);
        title(ax,sprintf('%s : %s',...
            [prot '.' d '.' fly '.' cell '.' trialnum],...
            'Stim to V transfer function'));
        
        set(ax,'xlim',[...
            max(min(handles.trial.params.freqStart,handles.trial.params.freqEnd),3),...
            max(handles.trial.params.freqStart,handles.trial.params.freqEnd),...
            ])
        
        ax = p(2).select();
        line(f(1:length(f)/2),Z_phase(1:length(f)/2)/(2*pi)*360,...
            'parent',ax,...
            'linestyle','none',...
            'displayname',[num2str(handles.trial.params.displacement) ' V'],...
            'marker','.',...
            'markerfacecolor',colr,...
            'markeredgecolor',colr,...
            'markersize',2);
        
        ylabel(ax,'phase (deg)')
        xlabel(ax,'Frequency (Hz)')
        set(ax,'xlim',[...
            max(min(handles.trial.params.freqStart,handles.trial.params.freqEnd),3),...
            max(handles.trial.params.freqStart,handles.trial.params.freqEnd),...
            ])
        
        %set(get(fig,'children'),'xscale','log');
        set(get(fig,'children'),'xscale','linear');
        set(p.de.axis,'tickdir','out')
    end
    cnt = cnt+1;
end
ax = p(1).select();
legend(ax,'show')
legend(ax,'boxoff')