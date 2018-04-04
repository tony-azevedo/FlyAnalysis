%% ForceProbe patcing workflow 180222_F1_C1
trial = load('B:\Raw_Data\180222\180222_F1_C1\CurrentStep2T_Raw_180222_F1_C1_98.mat');
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);

cd (D)
clear trials

%% Current step movements

trial = load('B:\Raw_Data\180222\180222_F1_C1\CurrentStep2T_Raw_180222_F1_C1_98.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 98:126; 
Nsets = length(trials);
    
trial = load(sprintf(trialStem,100));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    };

%% Piezo Ramp stimuli

trial = load('B:\Raw_Data\180222\180222_F1_C1\PiezoRamp2T_Raw_180222_F1_C1_32.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trials{1} = 2:31; % beautiful vidoes of the leg with no bar, but not analyable yet
trials{2} = 32:61; 
trials{3} = 62:91; 
Nsets = length(trials);
    
trial = load(sprintf(trialStem,30));
showProbeImage(trial)

routine = {
    'probeTrackROI_IR' 
    'probeTrackROI_IR' 
    'probeTrackROI_IR'
    };

%% Set probe line 

close all
% Go through all the sets of trials
for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    br = waitbar(0,sprintf('Batch %d of %d',set,Nsets));
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
trial = load(sprintf(trialStem,17));
showProbeLocation(trial)

% trial = probeLineROI(trial);


%% Find an area to smooth out the pixels
for set = 1:Nsets
    trialnumlist = trials{set};
    
    for tr_idx = trialnumlist(1:end)
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
    temp.ROI = getacqpref('quickshowPrefs','brightSpots2Smooth');

%     for tr_idx = trialnumlist(4:end)
%         trial = load(sprintf(trialStem,tr_idx));
%         trial.brightSpots2Smooth = temp.ROI;
%         fprintf('Saving bright spots to smooth in trial %s\n',num2str(tr_idx))
%         save(trial.name,'-struct','trial')
%     end
    
    % undo
%     for tr_idx = trialnumlist
%         trial = load(sprintf(trialStem,tr_idx));
%         trial = rmfield(trial,'brightSpots2Smooth');
%         save(trial.name,'-struct','trial')
%     end

end


%% Track the bar

for set = 1:Nsets
    fprintf('\n\t***** Batch %d of %d\n',set,Nsets);
    trialnumlist = trials{set};
    
    close all
    
    br = waitbar(0,'Batch');
    br.Position =  [1050    251    270    56];
    
    for tr_idx = trialnumlist
        trial = load(sprintf(trialStem,tr_idx));
        
        waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
        
        if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded) && ~isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            eval(routine{set}); %probeTrackROI_IR;
        elseif isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            fprintf('\t*Has profile: passing over trial for now\n')
            
            %OR...
%             fprintf('\t*Has profile: redoing\n')
%             eval(routine{set}); %probeTrackROI_IR;

            %OR...
            if isfield(trial.forceProbeStuff,'keimograph')
                fprintf('\t*Moving keimograph to alt file: redoing\n')
                keimograph = trial.forceProbeStuff.keimograph;
                save(regexprep(trial.name,'.mat','_barkeimograph.mat'),'keimograph');
                trial.forceProbeStuff = rmfield(trial.forceProbeStuff,'keimograph');
                save(trial.name,'-struct','trial')
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

% This was agonizing for this cell, very annoying

%% Align spikes and bar trajectories for current injection

trial = load('B:\Raw_Data\180222\180222_F1_C1\CurrentStep2T_Raw_180222_F1_C1_98.mat');
[protocol,~,~,~,~,~,trialStem,~] = extractRawIdentifiers(trial.name);

clear trials
trialnumlist = 98:126; 

cnt = 0;
for tr_idx = trialnumlist
    trial = load(sprintf(trialStem,tr_idx));
    if ~isfield(trial,'forceProbeStuff') || ~isfield(trial,'spikes') || length(trial.spikes)~=1
        continue
    end
    cnt = cnt+1;
    spikes = trial.spikes;

    t = makeInTime(trial.params);
    spikes = t(spikes);
    
    fs = trial.params.sampratein; %% sample rate
    switch trial.params.mode_1; case 'VClamp', invec1 = 'current_1'; case 'IClamp', invec1 = 'voltage_1'; otherwise; invec1 = 'voltage_1'; end
    switch trial.params.mode_2; case 'VClamp', invec2 = 'current_2'; case 'IClamp', invec2 = 'voltage_2'; otherwise; invec2 = 'voltage_2'; end
    
    patch = trial.(invec1);
    altin = trial.(invec2);
    bar = trial.forceProbeStuff.CoM;

    ft = postHocExposure(trial);
    sri = trial.params.sampratein;
    ft = ft.exposure;
    frametimes = t(ft);
    frames = find(ft);
    fr = sri/median(diff(frames));
    
    DT = .1;
    DT_pre = 0.02;
    DT_pre = ceil(DT_pre*fr)/fr;
    DT = ceil(DT*fr)/fr; % 20 ms window
    DT_post = DT-DT_pre;
    DF_pre = DT_pre*fr;
    DF_post = DT_post*fr;

    % if there is a single spikes
    for sp_idx = 1
        % find it,
        spidx = find(t==spikes(sp_idx));
        [~,fridx] = min(abs(frametimes-t(spidx)));
        if spidx+DT_post*sri>length(altin)
            break
        end
        if fridx+DF_post>length(bar)
            break
        end
        spike_trajects(:,cnt) = patch(spidx-DT_pre*sri+1:spidx+DT_post*sri);
        alt_trajects(:,cnt) = altin(spidx-DT_pre*sri+1:spidx+DT_post*sri);
        
        randidx = randi([round(trial.params.sampratein*DT) length(altin)-round(trial.params.sampratein*DT)],1);
        ctr_trajects(:,cnt) = altin(randidx-DT_pre*sri+1: randidx+DT_post*sri);
        
        fridx_rnd = randi([round(fr*DT) length(bar)-round(fr*DT)],1);
        
        sp_idx
        bar_trajects(:,cnt) = bar(fridx-DF_pre+1:fridx+DF_post)-bar(fridx);
        bar_t_trajects(:,cnt) = frametimes(fridx-DF_pre+1:fridx+DF_post)-t(spidx);
        bar_ctr_trajects(:,cnt) = bar(fridx_rnd-DF_pre+1:fridx_rnd+DF_post)-bar(fridx_rnd);
    end
    % select out the bar trajectory
    % select out the EMG
    % Align
    % Average
    % plot
end

figure
ax1 = subplot(3,1,1);
t_win = (0-DT_pre*sri+1:0+DT_post*sri)/sri;
plot(ax1,t_win,spike_trajects,'color',[1 .7 .7]); hold on
ylim(ax1,[-50 10])

ax2 = subplot(3,1,2);
plot(ax2,t_win,alt_trajects,'color',[1 .7 .7]); hold on
ylim(ax2,[-50 10])

ax3 = subplot(3,1,3);
plot(ax3,bar_t_trajects,bar_trajects,'color',[1 .7 .7])
ylim(ax3,[-3 8])

xlim([ax1,ax2,ax3],[-DT_pre DT_post])
