%% Record, fucking around with the fluctuation-dissipation Theorem

% some cells where I have both a sweep and a current chirp:
trial = SweepTrial1;

time = makeInTime(trial.params);
t_1sec = time(time<1);
f = trial.params.sampratein/length(t_1sec)*[0:length(t_1sec)/2];
f = [f, fliplr(f(2:end-1))];

%%
[~,~,~,~,~,D,trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

prtclData = load(dfile);
trials = findLikeTrials('name',trial.name,'datastruct',prtclData);
sweep_snippets = [];

for t = 1:length(trials)
    trial = load(fullfile(D,sprintf(trialStem,trials(t))));
    sweep = trial.voltage;
    sweep = reshape(sweep,trial.params.sampratein,[]);
    sweep_snippets = [sweep_snippets,sweep];
end

%%
fig = figure(1);
set(fig,'color',[1 1 1])
panl = panel(fig);

panl.pack('v',{1/5 1/5 1/5 1/5 1/5})  % response panel, stimulus panel
panl.margin = [18 10 2 10];
panl.fontname = 'Arial';
panl(1).marginbottom = 2;
panl(2).marginbottom = 2;
panl(3).marginbottom = 2;
panl(4).marginbottom = 2;
panl(5).marginbottom = 2;

panl(1).pack('h',{1/2 1/2})  % response panel, stimulus panel
panl(2).pack('h',{1/2 1/2})  % response panel, stimulus panel

ax = panl(2,1).select();
set(ax,'tag',[mfilename 'ax'],'xscale','linear','yscale','log');
xlim(ax,[17,300]);

PSD_snippets = sweep_snippets;

for c = 1:size(sweep_snippets,2)
    snip = sweep_snippets(:,c) - mean(sweep_snippets(:,c));
    
    AveragePower_or_Variance = sum(snip.^2)/(length(snip));%*diff(t(1:2)));
    PSD = real(fft(snip) .* conj(fft(snip)))/length(snip);
    PSD_Ave_Power = sum(PSD)/(length(snip));%*diff(f(1:2)));

    line(f,PSD,...
        'parent',ax,'linestyle','none','marker','o',...
        'markerfacecolor',[.8 .8 1],'markeredgecolor',[.8 .8 1],'markersize',2);
    
    PSD_snippets(:,c) = PSD;
end

PSD = mean(PSD_snippets,2);
line(f,PSD,...
    'parent',ax,'linestyle','none','marker','o',...
    'markerfacecolor',[0 0 1],'markeredgecolor',[0 0 1],'markersize',2);

ylabel(ax,'V^2 s');
xlabel(ax,'Hz');

% set(ax,'tag',[mfilename 'ax'],'xscale','linear','yscale','log');
% xlim(ax,[17,300]);
% 
PSD(1) = 0;
autocorrelation = fftshift(real(ifft(sqrt(PSD))));
autocorrelation = autocorrelation((-2000+1:2000)+length(autocorrelation)/2);
auto_t = time(1:2000);
auto_t = [-flipud(auto_t(1:end-1)); 0; auto_t];

ax = panl(1,1).select();
cla(ax)
line(auto_t,autocorrelation,...
    'parent',ax,'color',[0 0 1]);


%% CurrentChirps
trial = ChirpTrial;

% Time
x = makeInTime(trial.params);

obj.trial = trial;

[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;

[Z,f_Z,x,y,u] = CurrentChirpZAP([],obj,[],'plot',0);
Z_mag = sqrt(real(Z.*conj(Z)));
Z_phase = angle(Z);
Z_sucept_imag = imag(Z);
Z_sucept_real = real(Z);

freqBins = trial.params.freqStart:2.5:trial.params.freqEnd;
freqBins = sort(freqBins);

fZsampled = freqBins(1:end-1);
fsampled = fZsampled;
C = freqBins(1:end-1);
Z_p = freqBins(1:end-1);
Z_dp = freqBins(1:end-1);
Z_dp_n = Z_dp;
Z_power = Z_dp;
Z_angle = Z_dp;

for fb = 1:length(freqBins)-1
    f_wind = f_Z >= freqBins(fb) & f_Z<freqBins(fb+1);
    fZsampled(fb) = 10^(mean(log10(f_Z(f_wind))));
    Z_p(fb) = mean(Z_sucept_real(f_wind));
    Z_power(fb) = mean(Z_mag(f_wind));
    
    f_wind(length(f_wind)/2+1:end) = 0;
    Z_dp(fb) = mean(Z_sucept_imag(f_wind));
    Z_angle(fb) = mean(Z_phase(f_wind));
    
    f_wind = f_Z >= freqBins(fb) & f_Z<freqBins(fb+1);
    f_wind(1:length(f_wind)/2) = 0;
    Z_dp_n(fb) = mean(Z_sucept_imag(f_wind));
    
    % While I'm at it, resample the PSD as well
    f_wind = f >= freqBins(fb) & f<freqBins(fb+1);
    fsampled(fb) = 10^(mean(log10(f(f_wind))));
    C(fb) = mean(PSD(f_wind));
end

ax = panl(1,2).select();
plot(x(x>0&x<6),u(x>0&x<6),'b'), hold on
plot(x(x>0&x<6),y(x>0&x<6),'r'), hold off
panl(1,2).ylabel('A.u.')
panl(1,2).xlabel('s')

% panl(2,2).pack('v',{1/2 1/2})  % response panel, stimulus panel
% ax = panl(2,2,1).select();
% plot(f_Z,Z_mag,'b'), hold on
% ax = panl(2,2,2).select();
% plot(f_Z,Z_phase,'r'), hold off
% % panl(1,2).ylabel('A.u.')
% % panl(1,2).xlabel('s')

panl(3).pack('h',{1/2 1/2})  % response panel, stimulus panel
ax1 = panl(3,1).select();
plot(fZsampled,Z_power,'g')
xlim(ax1,[17,300]);
panl(3,1).ylabel('V^2/pA^2')
panl(3,1).xlabel('Hz')

ax2 = panl(3,2).select();
plot(fZsampled,Z_angle/(2*pi)*360,'m'), hold on
xlim(ax2,[17,300]);
panl(3,2).ylabel('phase')
panl(3,2).xlabel('Hz')

panl(4).pack('h',{1/2 1/2})  % response panel, stimulus panel
ax1 = panl(4,1).select();
plot(fZsampled,Z_p,'g')
xlim(ax1,[17,300]);
panl(4,1).ylabel('\chi''(\omega)')
panl(4,1).xlabel('Hz')

ax2 = panl(4,2).select();
plot(fZsampled,Z_dp,'m'), hold on
plot(-fZsampled,Z_dp_n,'color',[1 .7 1]);
xlim(ax2,[17,300]);
panl(4,2).ylabel('\chi''''(\omega)')
panl(4,2).xlabel('Hz')

linkaxes([ax1,ax2],'x')

%% Effective Temperature

kBT = 4.11e-21;

T_over_Teff = kBT * Z_dp ./ 2*pi .* fZsampled .* C;
Teff_over_T = 1./T_over_Teff;

panl(5).pack('h',{1/2 1/2})  % response panel, stimulus panel

ax1 = panl(5,1).select();
plot(fZsampled,Z_dp/max(abs(Z_dp)),'m'), hold on
plot(fsampled,C/max(C),'b'), hold off
xlim(ax1,[17,300]);
panl(5,1).ylabel('Norm.')
panl(5,1).xlabel('Hz')
grid(ax1,'on')

ax2 = panl(5,2).select();
plot(fsampled,Teff_over_T,'k'), hold on
xlim(ax2,[17,300]);
panl(5,2).ylabel('T_{eff}/T')
panl(5,2).xlabel('Hz')
grid(ax2,'on')

