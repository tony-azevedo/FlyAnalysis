function varargout = CurrentChirpZAP_Z(fig,handles,savetag,varargin)
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
    p.pack('v',{1})  % response panel, stimulus panel
    p.margin = [16 16 2 10];
%     p(1).marginbottom = 2;
%     p(2).marginleft = 13;
end
% for each displacement example, get all the trials
blocktrials = findBlockTrials(handles.trial,handles.prtclData);
cnt = 1;
for bt = blocktrials;
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    trials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData);

    x = makeTime(handles.trial.params);
    xwindow = x>=0+handles.trial.params.ramptime & x< handles.trial.params.stimDurInSec -handles.trial.params.ramptime;
    stimx = x(x>=0& x< handles.trial.params.stimDurInSec);% -handles.trial.params.ramptime);
    f = stimx/handles.trial.params.stimDurInSec * ...
        (handles.trial.params.freqEnd-handles.trial.params.freqStart) + ...
        handles.trial.params.freqStart;
    f = f(stimx>handles.trial.params.ramptime & stimx<handles.trial.params.stimDurInSec-handles.trial.params.ramptime);
    
    if sum(strcmp({'IClamp','IClamp_fast'},handles.trial.params.mode))
        y_name = 'voltage';
        out_name = 'current';
    elseif sum(strcmp('VClamp',handles.trial.params.mode))
        y_name = 'current';
        out_name = 'voltage';
    end
    
    if length(handles.trial.(y_name))<length(x)
        x = x(1:length(handles.trial.(y_name)));
    end
    y = zeros(length(x),length(trials));
    protocolInstance = eval(handles.trial.params.protocol);
    pr = handles.trial.params;
    pr.amps = pr.amp;
    protocolInstance.setParams('-q',pr);
    u = protocolInstance.getStimulus().current;
    for t = 1:length(trials)
        trial = load(fullfile(handles.dir,sprintf(handles.trialStem,trials(t))));
        y(:,t) = trial.(y_name)(1:length(x));
    end
    y = mean(y,2);
    
    y = y-mean(y(x>trial.params.preDurInSec+.06));
    u = u - mean(u(x<=0));
    
    % ZAP calculation
    Vz = hilbert(y);
    Iz = hilbert(u);
    Z = 1E-3*Vz(xwindow)./(Iz(xwindow)*1E-12);
    
    
    %Z = fft(y(xwindow)) ./ fft(u(xwindow));
    varargout = {Z,f,x,y,u};
    
    if ip.Results.plot
        
        %freqBins = logspace(log10(handles.trial.params.freqStart),log10(handles.trial.params.freqEnd),100);
        freqBins = handles.trial.params.freqStart:2.5:handles.trial.params.freqEnd;
        freqBins = sort(freqBins);
        fsampled = freqBins(1:end-1);
        Z_sampled = freqBins(1:end-1);
        for fb = 1:length(freqBins)-1
            f_wind = f >= freqBins(fb) & f<freqBins(fb+1);
            fsampled(fb) = mean(f(f_wind));
            Z_sampled(fb) = mean(Z(f_wind));
        end
        r_sampled = real(Z_sampled);
        x_sampled = imag(Z_sampled);
        
        ax = p(1).select();
        clrs = parula(length(r_sampled));
        plot(Z,'color',[1 1 1]*.9);
        for r_ind = sum(fsampled<4)+1:length(r_sampled)
            line(r_sampled(r_ind),x_sampled(r_ind),...
                'parent',ax,'color',clrs(r_ind,:),...
                'marker','o','markersize',6,'markerfacecolor',clrs(r_ind,:),'markeredgecolor',clrs(r_ind,:),...
                'tag',savetag);
        end
        ylabel(ax,'Resistance (Ohms)')
        xlabel(ax,'Reactance (Ohms)')
        
        [prot,d,fly,cell,trialnum] = extractRawIdentifiers(handles.trial.name);
        title(ax,sprintf('%s : %s',...
            [prot '.' d '.' fly '.' cell '.' trialnum],...
            'Stim to V transfer function'));
                
    end
    cnt = cnt+1;
end
ax = p(1).select();
axis(ax,'equal')
% legend(ax,'show')
% legend(ax,'boxoff')