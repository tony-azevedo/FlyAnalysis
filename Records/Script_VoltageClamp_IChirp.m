% Script_VoltageClamp_VStep

[currentPrtcl,dateID,flynum,cellnum,currentTrialNum,Dir,trialStem,dfile] = ...
    extractRawIdentifiers(IClamptrial.name);
data = load(dfile); data = data.data;

blocktrials = findLikeTrials('name',IClamptrial.name,'datastruct',data,'exclude',{'amp'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',data);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

x = makeInTime(IClamptrial.params);
voltage = zeros(length(x),length(blocktrials));
current = voltage;
xwindow = x>=0+IClamptrial.params.ramptime & x< IClamptrial.params.stimDurInSec -IClamptrial.params.ramptime;

for bt_ind = length(blocktrials):-1:1;
    IClamptrial = load([Dir sprintf(trialStem,blocktrials(bt_ind))]);
    Itrials = findLikeTrials('name',IClamptrial.name,'datastruct',data);
    for it_ind = 1:length(Itrials)
        IClamptrial = load([Dir sprintf(trialStem,Itrials(it_ind))]);
        voltage(:,bt_ind) = voltage(:,bt_ind)+IClamptrial.voltage;
        current(:,bt_ind) = current(:,bt_ind)+IClamptrial.current;
    end
    voltage(:,bt_ind) = voltage(:,bt_ind)/length(Itrials);
    current(:,bt_ind) = current(:,bt_ind)/length(Itrials);
    plot(ax_trace,x,voltage(:,bt_ind),'color',[0 1 0] + [0 -1  1]* (bt_ind-1)/(length(blocktrials)-1));
    
    voltage(:,bt_ind) = voltage(:,bt_ind) - mean(voltage(:,bt_ind));
    current(:,bt_ind) = current(:,bt_ind) - mean(current(:,bt_ind));

    Z = fft(voltage(xwindow,bt_ind)) ./ fft(current(xwindow,bt_ind));
    f = IClamptrial.params.sampratein/length(x(xwindow))*[0:length(x(xwindow))/2]; f = [f, fliplr(f(2:end-1))];
    Z_mag = sqrt(real(Z.*conj(Z)));
    Z_phase = angle(Z);
    freqBins = IClamptrial.params.freqStart:2.5:IClamptrial.params.freqEnd;
    freqBins = sort(freqBins);
    fsampled = freqBins(1:end-1);
    Z_mag_sampled = freqBins(1:end-1);
    for fb = 1:length(freqBins)-1
        f_wind = f >= freqBins(fb) & f<freqBins(fb+1);
        fsampled(fb) = 10^(mean(log10(f(f_wind))));
        Z_mag_sampled(fb) = mean(Z_mag(f_wind));
    end
    % line(f,Z_mag,...
    %    'parent',ax_zap,'color',[0 1 0],...
    %    'tag',savetag);
    line(fsampled,Z_mag_sampled,...
        'parent',ax_zap,...
        'color',[0 1 0] + [0 -1  1]* (bt_ind-1)/(length(blocktrials)-1),...
        'tag','mag');
    ylabel(ax_zap,'Magnitude')
    xlabel(ax_zap,'Frequency (Hz)')
    set(ax_zap,'xlim',[...
        max(min(IClamptrial.params.freqStart,IClamptrial.params.freqEnd),3),...
        max(IClamptrial.params.freqStart,IClamptrial.params.freqEnd),...
        ])

end
xlim(ax_trace,[-.2 IClamptrial.params.stimDurInSec+0.2])
xlabel(ax_trace,'s');
ylabel(ax_trace,'mV');

%     line(f(1:length(f)/2),Z_phase(1:length(f)/2)/(2*pi)*360,...
%         'parent',ax,...
%         'linestyle','none',...
%         'marker','o',...
%         'markerfacecolor',[0 1/length(handles.trial.params.amps) 0],...
%         'markeredgecolor',[0 1/length(handles.trial.params.amps) 0],...
%         'markersize',2);
%     
%     ylabel(ax,'phase (deg)')
%     xlabel(ax,'Frequency (Hz)')
%     set(ax,'xlim',[...
%         max(min(handles.trial.params.freqStart,handles.trial.params.freqEnd),3),...
%         max(handles.trial.params.freqStart,handles.trial.params.freqEnd),...
%         ])


