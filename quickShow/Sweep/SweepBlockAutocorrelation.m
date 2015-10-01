function plotcanvas = SweepBlockAutocorrelation(plotcanvas,obj,savetag,varargin)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('BGCorrectImages',false,@islogical);
parse(p,varargin{:});

if sum(strcmp({'IClamp','IClamp_fast'},obj.trial.params.mode))
    yname = 'voltage';
    outname = 'current';
    units = 'V_m (mV)';
    outunits = 'mV';
    units2 = 'mV^2';
elseif sum(strcmp('VClamp',obj.trial.params.mode))
    yname = 'current';
    outname = 'current';
    units = 'I (pA)';
    outunits = 'mV';
    units2 = 'pA^2';
end
if ~exist('yname','var')
    error('Mode is wrong: %s',obj.trial.params.mode)
end

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile,notesfile] = extractRawIdentifiers(obj.trial.name);

trials = findLikeTrials('name',obj.trial.name);
p_p = .08; % Go after the prepulse

x = makeInTime(obj.trial.params);

x_cor_mean = [];
for t_ind = 1:length(trials)
    trial = load(sprintf(trialStem,trials(t_ind)));
    [xcor, lags] = xcorr(trial.(yname)(x>p_p)-mean(trial.(yname)(x>p_p)),'unbiased');
    if isempty(x_cor_mean); x_cor_mean=xcor; else x_cor_mean = x_cor_mean+xcor; end
end
x_cor_mean = x_cor_mean/length(trials);

% displayTrial
if strcmp(get(plotcanvas,'type'),'uipanel')
    ax1 = subplot(2,1,1,'parent',plotcanvas);
    ax2 = subplot(2,1,2,'parent',plotcanvas);
elseif numel(plotcanvas) > 1
    ax1 = plotcanvas(1); hold on
    ax2 = plotcanvas(2); hold on
else
    ax1 = subplot(2,1,1,'parent',plotcanvas);
    ax2 = subplot(2,1,2,'parent',plotcanvas); 
end
tags = sprintf('%s ',trial.tags{:});

plot(ax1,x(x>p_p),trial.(yname)(x>p_p),'displayname',tags,'tag',savetag);
ylabel(ax1,units);
xlabel(ax1,'300 ms snippet');
box(ax1,'off'); set(ax1,'TickDir','out'); axis(ax1,'tight');
set(ax1,'xlim',[2,2.3])
legend(ax1,'toggle')
legend(ax1,'boxoff')

plot(ax2,lags/trial.params.sampratein,x_cor_mean,'displayname',tags,'tag',savetag);
ylabel(ax2,['auto corr. (' units2 ')']);
xlabel(ax2,'Lag (s)');
box(ax2,'off'); set(ax2,'TickDir','out'); axis(ax2,'tight');
set(ax2,'xlim',[-.04,0.04])

set(ax1,'tag','unlink');
set(ax2,'tag','unlink');


