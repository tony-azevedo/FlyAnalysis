function varargout = PiezoChirpZAP(fig,handles,savetag,varargin)
% works on Current Sine, there for the blocks have a rang of amps and freqs
% see also TransferFunctionOfLike

ip = inputParser;
ip.PartialMatching = 0;
ip.addParameter('plot',1,@isnumeric);

parse(ip,varargin{:});

% for each displacement example, get all the trials
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
u = 3*mean(u,2); %3 um /V stimulus

y = y - mean(y);
u = u - mean(u);

% ZAP calculation
Z = fft(y(xwindow)) ./ fft(u(xwindow));
f = trial.params.sampratein/length(x(xwindow))*[0:length(x(xwindow))/2]; f = [f, fliplr(f(2:end-1))];

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
varargout = {Z,f,Z_mag_sampled,fsampled};

if ip.Results.plot
    if (isempty(fig) || ~ishghandle(fig)) && ip.Results.plot
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

    ax = p(1).select();
    line(f,Z_mag,...
        'parent',ax,'color',[0 1 0],...
        'tag',savetag);
    line(fsampled,Z_mag_sampled,...
        'parent',ax,'color',[0 1/length(handles.trial.params.displacements) 0],...
        'tag',savetag);
    ylabel(ax,'Magnitude (mV/\mum)')
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
        'marker','o',...
        'markerfacecolor',[0 1/length(handles.trial.params.displacements) 0],...
        'markeredgecolor',[0 1/length(handles.trial.params.displacements) 0],...
        'markersize',4);
    
    ylabel(ax,'phase (deg)')
    xlabel(ax,'Frequency (Hz)')
    set(ax,'xlim',[...
        max(min(handles.trial.params.freqStart,handles.trial.params.freqEnd),3),...
        max(handles.trial.params.freqStart,handles.trial.params.freqEnd),...
        ])
    
    %     set(get(fig,'children'),'xscale','log');
    set(get(fig,'children'),'xscale','linear');
end
