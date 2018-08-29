%% ForceProbe patcing workflow 180807_F1_C1
trial = load('B:\Raw_Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_26.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% epi flash Twitch movements

trial = load('B:\Raw_Data\180807\180807_F1_C1\EpiFlash2T_Raw_180807_F1_C1_26.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd (D)

clear trials 
trials{1} = 25:204; % Low
trials{2} = 205:273; % High 

examplespiketrials{1} = [168 199 150];
examplespiketrials{2} = [];

Nsets = length(trials);
    
trial = load(sprintf(trialStem,43));
% showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };

%% Sweep, random movments

trial = load('B:\Raw_Data\180807\180807_F1_C1\Sweep2T_Raw_180807_F1_C1_10.mat');
[~,~,~,~,~,D,trialStem,~] = extractRawIdentifiers(trial.name); cd (D)

clear trials 
% Trials 1:5 show twitches in the muscle 
trials{1} = 6:10; % Low

Nsets = length(trials);
    
routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    };


%% Set probe line 

close all
% Go through all the sets of trials
for st = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',st,Nsets);
    trialnumlist = trials{st};
    
    br = waitbar(0,sprintf('Batch %d of %d',st,Nsets));
    br.Position =  [1050    251    270    56];
    
    % set probeline for a few test movies
    for tr_idx = trialnumlist(1:4) 
        trial = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1)+1)/6,br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        fprintf('%s\n',trial.name);
        if isfield(trial,'excluded') && trial.excluded
            fprintf(' * Bad movie: %s\n',trial.name)
            continue
        end
        trial = probeLineROI(trial);
    end
    
    % just set the line for the rest of the trials
    temp.forceProbe_line = getacqpref('quickshowPrefs','forceProbeLine');
    temp.forceProbe_tangent = getacqpref('quickshowPrefs','forceProbeTangent');

    for tr_idx = trialnumlist(5:end)
        trial = load(sprintf(trialStem,tr_idx));
        trial.forceProbe_line = temp.forceProbe_line;
        trial.forceProbe_tangent = temp.forceProbe_tangent;
        fprintf('Saving bar and tangent in trial %s\n',num2str(tr_idx))
        save(trial.name,'-struct','trial')
    end
    
    delete(br);
end


%% double check some trials
trial = load(sprintf(trialStem,43));
showProbeLocation(trial)

% trial = probeLineROI(trial);


%% Find an area to smooth out the pixels
for st = 5%1:Nsets
    trialnumlist = trials{st};
    
    for tr_idx = trialnumlist(1:3)
        trial = load(sprintf(trialStem,tr_idx));
        
        if (~isfield(trial,'excluded') || ~trial.excluded) 
            tic
            fprintf('%s\n',trial.name);
            trial = smoothOutBrightPixels(trial);
            
            toc
        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
    end
    
    % just set the line for the rest of the trials
    temp.ROI = getpref('quickshowPrefs','brightSpots2Smooth');

    for tr_idx = trialnumlist(4:end)
        trial = load(sprintf(trialStem,tr_idx));
        trial.brightSpots2Smooth = temp.ROI;
        fprintf('Saving bright spots to smooth in trial %s\n',num2str(tr_idx))
        save(trial.name,'-struct','trial')
    end
end


%% Track the bar

for st = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',st,Nsets);
    trialnumlist = trials{st};
    
    close all
    
    br = waitbar(0,'Batch');
    br.Position =  [1050    251    270    56];
    
    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded) && ~isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            eval(routine{st}); %probeTrackROI_IR;
        elseif isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            fprintf('\t*Has profile: passing over trial for now\n')
            
            %OR...
            %fprintf('\t*Has profile: redoing\n')
            %eval(routine{set}); %probeTrackROI_IR;

            %OR...
            if isfield(trial.forceProbeStuff,'keimograph')
                fprintf('\t*Moving keimograph to alt file: redoing\n')
                keimograph = trial.forceProbeStuff.keimograph;
                save(regexprep(trial.name,'_Raw_','_keimograph_'),'keimograph');
                trial.forceProbeStuff = rmfield(trial.forceProbeStuff,'keimograph');
                save(trial.name,'-struct','trial')
            end
            if exist(regexprep(trial.name,'.mat','_barkeimograph.mat'),'file')
                fprintf('\t*Moving keimograph to alt file: movefile\n')
                movefile(regexprep(trial.name,'.mat','_barkeimograph.mat'),regexprep(trial.name,'_Raw_','_keimograph_'));
            end
        else
            fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
            continue
        end
    end
    
    delete(br);
    
end


%% Epi flash trials

%% Extract spikes

% for now, use trials in the sets
close all
% Go through all the sets of trials
for st = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',st,Nsets);
    trialnumlist = trials{st};
    trialnumlist = 152:204;
    examplespiketriallist = examplespiketrials{st};
    % Do a little investigation of filter properties on a couple of trials
    % first
    spikevars_cell = cell(3,1); cnt = 0;
    for tr_idx = examplespiketriallist
        trial = load(sprintf(trialStem,tr_idx)); 
        trial.spikeDetectionParams = spikevars;    
        
        fprintf('%s\n',trial.name);
        if isfield(trial,'excluded') && trial.excluded
            fprintf(' * Bad movie: %s\n',trial.name)
            continue
        end
        cnt = cnt+1;
        fstag = ['fs' num2str(trial.params.sampratein)];
        if ~isfield(trial,'spikeDetectionParams')
            spikevars = getacqpref('FlyAnalysis',['Spike_params_' fstag]);
        else
            spikevars = trial.spikeDetectionParams;
            setacqpref('FlyAnalysis',['Spike_params_' fstag],spikevars);
        end
        switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end
        [h.trial,spikevars_cell{cnt}] = spikeDetection(trial,invec1,spikevars);
        setacqpref('FlyAnalysis',['Spike_params_' fstag],spikevars);
        
        if cnt>=3
            break
        end
    end
    
    thresh = 0;
    peak = Inf;
    spikeTemplate = zeros(size(spikevars.spikeTemplate));
    for cnt = 1:length(spikevars_cell)
        thresh = max([thresh,spikevars_cell{cnt}.Distance_threshold]);
        peak = min([peak,spikevars_cell{cnt}.peak_threshold]);
        spikeTemplate = spikeTemplate + spikevars_cell{cnt}.spikeTemplate;
        hp(cnt) = spikevars_cell{cnt}.hp_cutoff;
        lp(cnt) = spikevars_cell{cnt}.lp_cutoff;
    end
    spikevars.spikeTemplate = spikeTemplate/cnt;
    spikevars.Distance_threshold = thresh;
    spikevars.peak_threshold = peak;
    spikevars.hp_cutoff = min(hp);
    spikevars.lp_cutoff = max(lp);

    [distancestructure] = spikeDetectionBatch(trialStem,trialnumlist,invec1,spikevars);
    close all; spikeSpotCheckBatch(trialStem,trialnumlist,invec1,'spikes',distancestructure);
    
end

%% force production vs start position
t_i_f = [-0.02 .13];
trial = load('B:\Raw_Data\180308\180308_F3_C1\EpiFlash2T_Raw_180308_F3_C1_5.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);

setordridx = [1 2 3 4 5 6 7];

script_singleSpikeTwitchAtEachDistance

%% Look at how force increases with spike (from 0 set point)

close all
N_trjct_fi = figure;
N_trjct_fi.Color = [0 0 0];
N_trjct_fi.Units = 'inches';
N_trjct_fi.Position = [4 2 8 6];

panl = panel(N_trjct_fi);
panl.pack('v',{1/2 1/2})  % phase plot on top

panl.margin = [18 16 10 10];
panl.descendants.margin = [10 10 10 10];

t_i_f = [-0.006 .13];


N_sp = 1:13;

clrs = parula(round(length(N_sp)*1.2));
clrs = clrs(end-length(N_sp)+1:end,:);

tr_ph_ax = panl(1).select();

tr_ph_ax.Color = [0 0 0];
tr_ph_ax.XColor = [1 1 1];
tr_ph_ax.YColor = [1 1 1];
tr_ph_ax.TickDir = 'out';
tr_ph_ax.XLim = [-10 140];
tr_ph_ax.YLim = 1E3*[-5 7]; 
hold(tr_ph_ax,'on')

tr_ax = panl(2).select();
tr_ax.Color = [0 0 0];
tr_ax.XColor = [1 1 1];
tr_ax.YColor = [1 1 1];
tr_ax.TickDir = 'out';
tr_ax.XLim = t_i_f;
tr_ax.YLim = [-10 140]; 
hold(tr_ax,'on')

trialnumlist = [trials{1} trials{2} trials{end}];
n_sp = zeros(size(trialnumlist));
fr_12 = zeros(size(trialnumlist));

cnt = 0;
t = makeInTime(trial.params);
for tr = trialnumlist
    trial = load(sprintf(trialStem,tr));
    cnt = cnt+1;
    if trial.excluded
        continue;
    end
    n_sp(cnt) = length(trial.spikes);
    if n_sp(cnt)>1
        fr_12(cnt) = 1/diff(t(trial.spikes(1:2)));
    end
end

for n = 1:length(N_sp)
    N = N_sp(n);
    trialnumlist_ = trialnumlist(n_sp==N);
    
    tr_ph_ax = panl(1).select();
    
    plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
    plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);
    
    tr_ax = panl(2).select();

    for tr = trialnumlist_
        trial = load(sprintf(trialStem,tr));
        if trial.excluded
            continue;
        end

        if length(trial.spikes) ~= N
            continue
        end
        
        t = makeInTime(trial.params);        
        trial2 = postHocExposure(trial,size(trial.forceProbeStuff.forceProbePosition,2));
        
        frame_times = t(trial2.exposure);
        ft = frame_times;
        
        t_sp = t(trial.spikes(1));
        sp_win = t>=t_sp+t_i_f(1) & t<t_sp+t_i_f(2);
        frame_win = frame_times>=t_sp+t_i_f(1) & frame_times <=t_sp+t_i_f(2);
        
        origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
        x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
        CoM = trial.forceProbeStuff.forceProbePosition';
        CoM = CoM*x_hat;
        origin = min(CoM(ft>ft(3)&ft<0));%handles.trial.forceProbeStuff.Origin'*x_hat;
        CoM = CoM - origin;
        
        dCoMdt = diff(CoM)./diff(frame_times);
        CoM_s = CoM(2:end);
        ft_ph = ft(2:end);
        
        trjct_t = t_i_f+t_sp;
        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
                
        brtrjct = plot(tr_ax, ft(trjct_win)-t_sp,CoM(trjct_win),'color',clrs(n,:),'tag',num2str(tr));
        
        trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
        phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clrs(n,:),'tag',num2str(tr));
        
        %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
        
        
    end
end
% savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
% savePDF(N_trjct_fi,savedir,[],sprintf('trajec_perN_%s_%d-%d',ID,trialnumlist(1),trialnumlist(end)))


%% Look at rebound after perturbation

% close all
% N_trjct_fi = figure;
% N_trjct_fi.Color = [0 0 0];
% N_trjct_fi.Units = 'inches';
% N_trjct_fi.Position = [4 2 8 6];
% 
% panl = panel(N_trjct_fi);
% panl.pack('v',{1/3 2/3})  % phase plot on top
% 
% panl.margin = [18 16 10 10];
% panl.descendants.margin = [10 10 10 10];
% 
% t_i_f = [-0.1 .27];
% 
% 
% 
% clrs = parula(round(length(N_sp)*1.2));
% clrs = clrs(end-length(N_sp)+1:end,:);
% 
% tr_ph_ax = panl(1).select();
% 
% tr_ph_ax.Color = [0 0 0];
% tr_ph_ax.XColor = [1 1 1];
% tr_ph_ax.YColor = [1 1 1];
% tr_ph_ax.TickDir = 'out';
% tr_ph_ax.XLim = t_i_f;
% tr_ph_ax.YLim =[-500 40]; 
% hold(tr_ph_ax,'on')
% 
% tr_ax = panl(2).select();
% tr_ax.Color = [0 0 0];
% tr_ax.XColor = [1 1 1];
% tr_ax.YColor = [1 1 1];
% tr_ax.TickDir = 'out';
% tr_ax.XLim = t_i_f;
% tr_ax.YLim = [-10 40]; 
% hold(tr_ax,'on')
% 
% trialnumlist = [trials{1} trials{end}];
% 
% N = 1;
% tr_ax = panl(2).select();
% 
% for tr = trialnumlist
%     trial = load(sprintf(trialStem,tr));
%     if trial.excluded
%         continue;
%     end
%     
%     if length(trial.spikes) ~= N
%         continue
%     end
%     
%     t = makeInTime(trial.params);
%     trial2 = postHocExposure(trial);
%     
%     frame_times = t(trial2.exposure);
%     ft = frame_times;
%     
%     t_sp = t(trial.spikes(1));
%     sp_win = t>=t_sp+t_i_f(1) & t<t_sp+t_i_f(2);
%     frame_win = frame_times>=t_sp+t_i_f(1) & frame_times <=t_sp+t_i_f(2);
%     
%     origin = find(trial.forceProbeStuff.EvalPnts(1,:)==0&trial.forceProbeStuff.EvalPnts(2,:)==0);
%     x_hat = trial.forceProbeStuff.EvalPnts(:,origin+1);
%     CoM = trial.forceProbeStuff.forceProbePosition';
%     CoM = CoM*x_hat;
%     origin = min(CoM(ft>ft(3)&ft<0));%handles.trial.forceProbeStuff.Origin'*x_hat;
%     CoM = CoM - origin;
%     
%     dCoMdt = diff(CoM)./diff(frame_times);
%     CoM_s = CoM(2:end);
%     ft_ph = ft(2:end);
%     
%     trjct_t = t_i_f+t_sp;
%     trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
%     trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
%     
%     brtrjct = plot(tr_ax, ft(trjct_win)-t_sp,CoM(trjct_win),'color',[0 .4 .74],'tag',num2str(tr));
%     
% %     trjct_ph_win = ft_ph>trjct_t(1)&ft_ph<trjct_t(2);
%     %phtrjct = plot(tr_ph_ax,CoM_s(trjct_ph_win),dCoMdt(trjct_ph_win),'color',clrs(n,:),'tag',num2str(tr));
%     
%     %     set(tr_emg_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
%     %     set(tr_ca_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
%     %     set(tr_bar_ax,'xlim',mean(trjct_t)+0.75/2*[-1 1],'xtick',[]);
%     
%     
% end
% % savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
% % savePDF(N_trjct_fi,savedir,[],sprintf('trajec_perN_%s_%d-%d',ID,trialnumlist(1),trialnumlist(end)))
% lines = findobj(tr_ax,'type','line');
% xdata = []; ydata = [];
% for l = lines
%     xdata = cat(2,xdata,lines.XData);
%     ydata = cat(2,ydata,lines.YData);
% end
% [xdata_o,order] = sort(xdata);
% 
% ydata_o = smooth(ydata(order),30);
% brtrjct = plot(tr_ax, xdata_o,ydata_o,'color',[0.9763    0.9831    0.0538],'tag','smoothed','linewidth',2);
% 
% trial = load('B:\Raw_Data\171103\171103_F1_C1\EpiFlash2T_Raw_171103_F1_C1_75.mat');
% tr_ph_ax = panl(1).select();
% brtrjct = plot(tr_ph_ax, t-t(trial.spikes(1)),trial.current_2,'color',[1 0 0],'tag','smoothed','linewidth',1);
% 


