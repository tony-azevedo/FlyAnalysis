%% Record_FS - take from the different types and agreggate here
close all
savedir = '/Users/tony/Dropbox/RAnalysis_Data/Record_FS';
if ~isdir(savedir)
    mkdir(savedir)
end

%Record_FS_LowPassB1s
%Record_FS_BandPassLowB1s
%Record_FS_BandPassHiB1s
%Record_FS_HighFreqDepolB1s

% Script_FrequencySelectivity
% Script_FS_f1_f2
% Script_FS_CurrentChirpAndSteps % and others
% Script_FS_Vm

%% Figure 1c: Stimulus Examples - large 2 column figure
% example amplitude 0.15 V

Record_FS_HighFreqDepolB1s
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure1/';

% ax_hi = findobj(fig_hi,'type','axes','tag','mag_0.15');
trial = load(example_cell.PiezoSineTrial);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[1 3 getpref('FigureSizes','NeuronTwoColumn') 1.5])

p = panel(fig);

freqs = h.trial.params.freqs(2:2:length(h.trial.params.freqs));
fnum = length(freqs);
p.pack('h', fnum)  % response panel, stimulus panel

trialnummatrix = nan(1,fnum);
pnl_hs = trialnummatrix;

for bt = blocktrials;
    params = load(fullfile(h.dir,sprintf(h.trialStem,bt)),'params');
    
    if sum(freqs == params.params.freq);
        c = find(freqs == params.params.freq);
        trialnummatrix(1,c) = bt;
    end    
end

ylims = [Inf, -Inf];
slims = [Inf, -Inf];

ylims = [Inf, -Inf];
slims = [Inf, -Inf];
for c = 1:size(trialnummatrix,2)
    trial = load(fullfile(h.dir,sprintf(h.trialStem,trialnummatrix(1,c))));
    h = getShowFuncInputsFromTrial(trial);
    
    stim = PiezoSineStim(h.trial.params);
    x = makeInTime(h.trial.params);
    x_win = x>= -.2 & x<trial.params.stimDurInSec+ min(.2,trial.params.postDurInSec);
    
    pnl_hs(1,c) = p(c).select();
    line(x(x_win),stim(x_win),'parent',pnl_hs(1,c),'color',[0 0 1],'tag',[num2str(h.trial.params.freq), 'Hz']);
    
    set(pnl_hs(1,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[]);
    axis(pnl_hs(1,c),'tight')
    
    slims_from = get(pnl_hs(1,c),'ylim');
    slims = [min(slims(1),slims_from(1)),...
        max(slims(2),slims_from(2))];
    
end
set(pnl_hs(:),'ylim',slims)
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure1Xlims'))
set(pnl_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
p(1).ylabel(['Stimulus (V)']);
p(1).de.fontsize = 18;

savePDF(fig,savedir,[],'Figure1cStim')

set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure1XlimsShort'))
savePDF(fig,savedir,[],'Figure1cStimShort')


%% Figure 1c: Example A2 Neuron - A large full 2 column figure.
% example neuron 151121_F1_C1, 
% example amplitude 0.15 V
% example frequencies [25 50 100 200 400]

Record_FS_HighFreqDepolB1s
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure1/';

% ax_hi = findobj(fig_hi,'type','axes','tag','mag_0.15');
trial = load(example_cell.PiezoSineTrial);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[1 3 getpref('FigureSizes','NeuronTwoColumn') 4])

p = panel(fig);

freqs = h.trial.params.freqs(2:2:length(h.trial.params.freqs));
fnum = length(freqs);
p.pack('h', fnum)  % response panel, stimulus panel
p.margin = [20 4 8 4];  % response panel, stimulus panel

trialnummatrix = nan(2,fnum);
pnl_hs = trialnummatrix;

for bt = blocktrials;
    params = load(fullfile(h.dir,sprintf(h.trialStem,bt)),'params');
    
    if sum(freqs == params.params.freq);
        c = find(freqs == params.params.freq);
        trialnummatrix(1,c) = bt;
        trialnummatrix(2,c) = bt;
    end    
end

ylims = [Inf, -Inf];
slims = [Inf, -Inf];
for c = 1:size(trialnummatrix,2)
    h.trial = load(fullfile(h.dir,sprintf(h.trialStem,trialnummatrix(1,c))));
    averagefig = PiezoSineAverage_A2filter([],h,'');
        
    ax_from = findobj(averagefig,'tag','response_ax');
    
    ylabe = get(get(ax_from,'ylabel'),'string');
    delete(get(ax_from,'xlabel'));
    delete(get(ax_from,'ylabel'));
    delete(get(ax_from,'zlabel'));
    delete(get(ax_from,'title'));
    
    ylims_from = get(ax_from,'ylim');
    xlims_from = get(ax_from,'xlim');
    ylims = [min(ylims(1),ylims_from(1)),...
        max(ylims(2),ylims_from(2))];

    p(c).pack('v',2)  % response panel, stimulus panel
    pnl_hs(1,c) = p(c,1).select();
    pnl_hs(2,c) = p(c,2).select();
    copyobj(get(ax_from,'children'),pnl_hs(2,c));
    
    l = findobj(pnl_hs(2,c),'type','line','color',[1 .7 .7]);
    copyobj(l(1),pnl_hs(1,c));
    
    set(pnl_hs(:,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
        
        
    % drawnow;
    close(averagefig)
end

set(pnl_hs(:),'ylim',ylims)
set(pnl_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
p(1,1).ylabel(['Response (' ylabe ')']);
p(1,2).ylabel(['Response (' ylabe ')']);
p(1).de.fontsize = 18;

set(pnl_hs(:),'ylim',getpref('FigureMaking','Figure1Ylims'))
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure1Xlims'))
%savePDF(fig,savedir,[],'Figure1cFull')

delete(findobj(pnl_hs(2,:),'color',[1 .7 .7]))
delete(findobj(pnl_hs(:),'type','text'))
% savePDF(fig,savedir,[],'Figure1c')
savePDF(fig,savedir,[],'Figure1c_SD')

%set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure1XlimsShort'))
%savePDF(fig,savedir,[],'Figure1cShort')

%% Figure 1d: Example Band Pass High - A large full 2 column figure.
% example neuron 151201_F1_C1 (possibly 151201_F1_C2)
% example amplitude 0.15 V
% example frequencies [25 50 100 200 400]

Record_FS_BandPassHiB1s
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure1/';

% ax_hi = findobj(fig_hi,'type','axes','tag','mag_0.15');
trial = load(example_cell.PiezoSineTrial);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[1 3 getpref('FigureSizes','NeuronTwoColumn') 4])

p = panel(fig);

freqs = h.trial.params.freqs(2:2:length(h.trial.params.freqs));
fnum = length(freqs);
p.pack('h', fnum)  % response panel, stimulus panel
p.margin = [20 4 8 4];  % response panel, stimulus panel

trialnummatrix = nan(2,fnum);
pnl_hs = trialnummatrix;

for bt = blocktrials;
    params = load(fullfile(h.dir,sprintf(h.trialStem,bt)),'params');
    
    if sum(freqs == params.params.freq);
        c = find(freqs == params.params.freq);
        trialnummatrix(1,c) = bt;
        trialnummatrix(2,c) = bt;
    end    
end

ylims = [Inf, -Inf];
slims = [Inf, -Inf];
for c = 1:size(trialnummatrix,2)
    h.trial = load(fullfile(h.dir,sprintf(h.trialStem,trialnummatrix(1,c))));
    averagefig = PiezoSineAverage_B1SEM([],h,'');
        
    ax_from = findobj(averagefig,'tag','response_ax');
    
    ylabe = get(get(ax_from,'ylabel'),'string');
    delete(get(ax_from,'xlabel'));
    delete(get(ax_from,'ylabel'));
    delete(get(ax_from,'zlabel'));
    delete(get(ax_from,'title'));
    
    ylims_from = get(ax_from,'ylim');
    xlims_from = get(ax_from,'xlim');
    ylims = [min(ylims(1),ylims_from(1)),...
        max(ylims(2),ylims_from(2))];

    p(c).pack('v',2)  % response panel, stimulus panel
    pnl_hs(1,c) = p(c,1).select();
    pnl_hs(2,c) = p(c,2).select();
    copyobj(get(ax_from,'children'),pnl_hs(2,c));
    
    l = findobj(pnl_hs(2,c),'type','line','color',[1 .7 .7]);
    copyobj(l(1),pnl_hs(1,c));
    
    set(pnl_hs(:,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
        
        
    % drawnow;
    close(averagefig)
end

set(pnl_hs(:),'ylim',ylims)
set(pnl_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
p(1,1).ylabel(['Response (' ylabe ')']);
p(1,2).ylabel(['Response (' ylabe ')']);
p(1).de.fontsize = 18;

set(pnl_hs(:),'ylim',getpref('FigureMaking','Figure1Ylims'))
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure1Xlims'))
%savePDF(fig,savedir,[],'Figure1cFull')

delete(findobj(pnl_hs(2,:),'color',[1 .7 .7]))
delete(findobj(pnl_hs(:),'type','text'))
% savePDF(fig,savedir,[],'Figure1d')
savePDF(fig,savedir,[],'Figure1d_SD')

%set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure1XlimsShort'))
%savePDF(fig,savedir,[],'Figure1cShort')


%% Figure 1e: Example Band Pass Low - A large full 2 column figure.
% example neuron , 
% example amplitude 0.15 V
% example frequencies [25 50 100 200 400]

Record_FS_BandPassLowB1s
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure1/';

% ax_hi = findobj(fig_hi,'type','axes','tag','mag_0.15');
trial = load(example_cell.PiezoSineTrial);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[1 3 getpref('FigureSizes','NeuronTwoColumn') 4])

p = panel(fig);

freqs = h.trial.params.freqs(2:2:length(h.trial.params.freqs));
fnum = length(freqs);
p.pack('h', fnum)  % response panel, stimulus panel
p.margin = [20 4 8 4];  % response panel, stimulus panel

trialnummatrix = nan(2,fnum);
pnl_hs = trialnummatrix;

for bt = blocktrials;
    params = load(fullfile(h.dir,sprintf(h.trialStem,bt)),'params');
    
    if sum(freqs == params.params.freq);
        c = find(freqs == params.params.freq);
        trialnummatrix(1,c) = bt;
        trialnummatrix(2,c) = bt;
    end    
end

ylims = [Inf, -Inf];
slims = [Inf, -Inf];
for c = 1:size(trialnummatrix,2)
    h.trial = load(fullfile(h.dir,sprintf(h.trialStem,trialnummatrix(1,c))));
    averagefig = PiezoSineAverage_B1SEM([],h,'');
        
    ax_from = findobj(averagefig,'tag','response_ax');
    
    ylabe = get(get(ax_from,'ylabel'),'string');
    delete(get(ax_from,'xlabel'));
    delete(get(ax_from,'ylabel'));
    delete(get(ax_from,'zlabel'));
    delete(get(ax_from,'title'));
    
    ylims_from = get(ax_from,'ylim');
    xlims_from = get(ax_from,'xlim');
    ylims = [min(ylims(1),ylims_from(1)),...
        max(ylims(2),ylims_from(2))];

    p(c).pack('v',2)  % response panel, stimulus panel
    pnl_hs(1,c) = p(c,1).select();
    pnl_hs(2,c) = p(c,2).select();
    copyobj(get(ax_from,'children'),pnl_hs(2,c));
    
    l = findobj(pnl_hs(2,c),'type','line','color',[1 .7 .7]);
    copyobj(l(1),pnl_hs(1,c));
    
    set(pnl_hs(:,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
        
        
    % drawnow;
    close(averagefig)
end

set(pnl_hs(:),'ylim',ylims)
set(pnl_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
p(1,1).ylabel(['Response (' ylabe ')']);
p(1,2).ylabel(['Response (' ylabe ')']);
p(1).de.fontsize = 18;

set(pnl_hs(:),'ylim',getpref('FigureMaking','Figure1Ylims'))
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure1Xlims'))
%savePDF(fig,savedir,[],'Figure1cFull')

delete(findobj(pnl_hs(2,:),'color',[1 .7 .7]))
delete(findobj(pnl_hs(:),'type','text'))
% savePDF(fig,savedir,[],'Figure1e')
savePDF(fig,savedir,[],'Figure1e_SD')

%% Figure 1f: Example Low Pass  - A large full 2 column figure.
% example neuron 151121_F1_C1, 
% example amplitude 0.15 V
% example frequencies [25 50 100 200 400]

Record_FS_LowPassB1s
savedir = '/Users/tony/Dropbox/AzevedoWilson_B1_MS/Figure1/';

% ax_hi = findobj(fig_hi,'type','axes','tag','mag_0.15');
trial = load(example_cell.PiezoSineTrial);
h = getShowFuncInputsFromTrial(trial);

blocktrials = findLikeTrials('name',h.trial.name,'datastruct',h.prtclData,'exclude',{'freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',h.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

fig = figure;
fig.Units = 'inches';
set(fig,'color',[1 1 1],'position',[1 3 getpref('FigureSizes','NeuronTwoColumn') 4])

p = panel(fig);

freqs = h.trial.params.freqs(2:2:length(h.trial.params.freqs));
fnum = length(freqs);
p.pack('h', fnum)  % response panel, stimulus panel
p.margin = [20 4 8 4];  % response panel, stimulus panel

trialnummatrix = nan(2,fnum);
pnl_hs = trialnummatrix;

for bt = blocktrials;
    params = load(fullfile(h.dir,sprintf(h.trialStem,bt)),'params');
    
    if sum(freqs == params.params.freq);
        c = find(freqs == params.params.freq);
        trialnummatrix(1,c) = bt;
        trialnummatrix(2,c) = bt;
    end    
end

ylims = [Inf, -Inf];
slims = [Inf, -Inf];
for c = 1:size(trialnummatrix,2)
    h.trial = load(fullfile(h.dir,sprintf(h.trialStem,trialnummatrix(1,c))));
    averagefig = PiezoSineAverage_B1SEM([],h,'');
        
    ax_from = findobj(averagefig,'tag','response_ax');
    
    ylabe = get(get(ax_from,'ylabel'),'string');
    delete(get(ax_from,'xlabel'));
    delete(get(ax_from,'ylabel'));
    delete(get(ax_from,'zlabel'));
    delete(get(ax_from,'title'));
    
    ylims_from = get(ax_from,'ylim');
    xlims_from = get(ax_from,'xlim');
    ylims = [min(ylims(1),ylims_from(1)),...
        max(ylims(2),ylims_from(2))];

    p(c).pack('v',2)  % response panel, stimulus panel
    pnl_hs(1,c) = p(c,1).select();
    pnl_hs(2,c) = p(c,2).select();
    copyobj(get(ax_from,'children'),pnl_hs(2,c));
    
    l = findobj(pnl_hs(2,c),'type','line','color',[1 .7 .7]);
    copyobj(l(1),pnl_hs(1,c));
    
    set(pnl_hs(:,c),'TickDir','out','YColor',[1 1 1],'YTick',[],'XColor',[1 1 1],'XTick',[],'xlim',xlims_from,'ylim',ylims_from);
        
        
    % drawnow;
    close(averagefig)
end

set(pnl_hs(:),'ylim',ylims)
set(pnl_hs(:,1),'ytickmode','auto','ycolor',[0 0 0])
p(1,1).ylabel(['Response (' ylabe ')']);
p(1,2).ylabel(['Response (' ylabe ')']);
p(1).de.fontsize = 18;

set(pnl_hs(:),'ylim',getpref('FigureMaking','Figure1Ylims'))
set(pnl_hs(:),'xlim',getpref('FigureMaking','Figure1Xlims'))
%savePDF(fig,savedir,[],'Figure1cFull')

delete(findobj(pnl_hs(2,:),'color',[1 .7 .7]))
delete(findobj(pnl_hs(:),'type','text'))
% savePDF(fig,savedir,[],'Figure1f')
savePDF(fig,savedir,[],'Figure1f_SD')

