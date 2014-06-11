cd('C:\Users\Anthony Azevedo\Code\FlyAnalysis\Records\') % Go to the home folder

%% Cells to Analyze


analysis_cell(1).name = '140117_F2_C1';
analysis_cell(1).comment = {'Bright, isolated','Prepoints on Voltage Plateau too few to get good dFoverF relationship'};
analysis_cell(1).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\Sweep_Raw_140117_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
analysis_cell(1).breakin_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\Sweep_Raw_140117_F2_C1_2.mat';...
    };
analysis_cell(1).plateau_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };

analysis_cell(2).name = '140121_F2_C1';
analysis_cell(2).comment = {'Example Cell, sound responsive, not spiking, just great! This is the Example cell for figure'};
analysis_cell(2).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\Sweep_Raw_140121_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
analysis_cell(2).breakin_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\Sweep_Raw_140121_F2_C1_2.mat';...
    };
analysis_cell(2).plateau_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\VoltagePlateau_Raw_140121_F2_C1_4.mat';...
    };


analysis_cell(4).name = '140131_F3_C1';
analysis_cell(4).comment = {'Moving.  Nice bright cell, not sound responsive, otherwise classic B1'};
analysis_cell(4).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\Sweep_Raw_140131_F3_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\VoltagePlateau_Raw_140131_F3_C1_1.mat';...
    };
analysis_cell(4).breakin_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\Sweep_Raw_140131_F3_C1_2.mat';...
    };
analysis_cell(4).plateau_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\VoltagePlateau_Raw_140131_F3_C1_1.mat';...
    };


% New Internal

analysis_cell(5).name = '140205_F1_C1';
analysis_cell(5).comment = {'Not a B1 cell, some spikes, smaller DF/F / DV'};
analysis_cell(5).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140205\140205_F1_C1\Sweep_Raw_140205_F1_C1_3.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140205\140205_F1_C1\VoltagePlateau_Raw_140205_F1_C1_2.mat';...
    };
analysis_cell(5).breakin_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140205\140205_F1_C1\Sweep_Raw_140205_F1_C1_3.mat';...
    };
analysis_cell(5).plateau_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140205\140205_F1_C1\VoltagePlateau_Raw_140205_F1_C1_2.mat';...
    };

analysis_cell(6).name = '140206_F1_C1';
analysis_cell(6).comment = {'Movement, Not sound responsive.  Good looking cell'};
analysis_cell(6).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\VoltagePlateau_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\PiezoSine_Raw_140206_F1_C1_26.mat';...
    };
analysis_cell(6).breakin_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_2.mat';...
    };
analysis_cell(6).plateau_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\VoltagePlateau_Raw_140206_F1_C1_1.mat';...
    };

analysis_cell(7).name = '140207_F1_C2';
analysis_cell(7).comment = {'Moving a lot!  Should be able to fix, Not sound responsive. Cell is pressed against others'};
analysis_cell(7).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\Sweep_Raw_140207_F1_C2_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\VoltagePlateau_Raw_140207_F1_C2_5.mat';...
    };
analysis_cell(7).breakin_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\Sweep_Raw_140207_F1_C2_2.mat';...
    };
analysis_cell(7).plateau_trial = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\VoltagePlateau_Raw_140207_F1_C2_5.mat';...
    };

cnt = 8;
analysis_cell(cnt).name = '140528_F1_C1';
analysis_cell(cnt).comment = {
'Break in at -25, pretty good cell. Changed gain in Iclamp, though this doesnt matter'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140528\140528_F1_C1\Sweep_Raw_140528_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140528\140528_F1_C1\VoltagePlateau_Raw_140528_F1_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140528\140528_F1_C1\Sweep_Raw_140528_F1_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140528\140528_F1_C1\VoltagePlateau_Raw_140528_F1_C1_1.mat';
    };


cnt = 9;
analysis_cell(cnt).name = '140530_F1_C1';
analysis_cell(cnt).comment = {
'Break in at -25, High Frequency cell.'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F1_C1\Sweep_Raw_140530_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F1_C1\VoltagePlateau_Raw_140530_F1_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F1_C1\Sweep_Raw_140530_F1_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F1_C1\VoltagePlateau_Raw_140530_F1_C1_1.mat';
    };


cnt = 10;
analysis_cell(cnt).name = '140530_F2_C1';
analysis_cell(cnt).comment = {
'Break in at -25, High Frequency cell.'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\Sweep_Raw_140530_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\VoltagePlateau_Raw_140530_F2_C1_2.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\Sweep_Raw_140530_F2_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\VoltagePlateau_Raw_140530_F2_C1_2.mat';
    };

cnt = 11;
analysis_cell(cnt).name = '140602_F1_C1';
analysis_cell(cnt).comment = {
'Break in at -25, Mid Range Spiking.'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\Sweep_Raw_140602_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\VoltagePlateau_Raw_140602_F1_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\Sweep_Raw_140602_F1_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\VoltagePlateau_Raw_140602_F1_C1_1.mat';
    };

cnt = 12;
analysis_cell(cnt).name = '140602_F2_C1';
analysis_cell(cnt).comment = {
'Break in at -25, Mid range, non spiking. Motion artifact'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\Sweep_Raw_140602_F2_C1_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\VoltagePlateau_Raw_140602_F2_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\Sweep_Raw_140602_F2_C1_2.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F2_C1\VoltagePlateau_Raw_140602_F2_C1_1.mat';
    };

cnt = 13;
analysis_cell(cnt).name = '140603_F1_C1';
analysis_cell(cnt).comment = {
'Break in at -25, Mid range, non spiking. There is a delay in the acquisition. didnt have the exposure trace'
};
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140603\140603_F1_C1\Sweep_Raw_140603_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140603\140603_F1_C1\VoltagePlateau_Raw_140603_F1_C1_1.mat';
    };
analysis_cell(cnt).breakin_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140603\140603_F1_C1\Sweep_Raw_140603_F1_C1_1.mat';
    };
analysis_cell(cnt).plateau_trial = {...
'C:\Users\Anthony Azevedo\Raw_Data\140603\140603_F1_C1\VoltagePlateau_Raw_140603_F1_C1_1.mat';
    };


fprintf('Currently analyzing %d cells.\n\n',length(analysis_cell))
for c_ind = 1:length(analysis_cell)
    fprintf('Cell %d ID: %s\n', c_ind,analysis_cell(c_ind).name);
    fprintf('Comment: %s\n\n', analysis_cell(c_ind).comment{1});
end

backgroundCorrectionFlag = 1;
if backgroundCorrectionFlag
    savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_ArcLightImaging\BackgroundCorrection';
else
    savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_ArcLightImaging\NoCorrection';
end
if ~isdir(savedir)
    mkdir(savedir)
end    
if backgroundCorrectionFlag
    savedir = 'C:\Users\Anthony'' Azevedo''\RAnalysis_Data\Record_ArcLightImaging\BackgroundCorrection\';
else
    savedir = 'C:\Users\Anthony'' Azevedo''\RAnalysis_Data\Record_ArcLightImaging\NoCorrection\';
end

save = 1


%% Motion minimization
% These cells are used to test the image correlation methods
close all
moving_cell(1).name = '140131_F3_C1';
moving_cell(1).comment = {'Moving.  Nice bright cell, not sound responsive, otherwise classic B1'};
moving_cell(1).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\Sweep_Raw_140131_F3_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\VoltagePlateau_Raw_140131_F3_C1_1.mat';...
    };
moving_cell(1).evidencecalls = {...
    };


moving_cell(2).name = '140206_F1_C1';
moving_cell(2).comment = {'Movement, Not sound responsive.  Good looking cell'};
moving_cell(2).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\VoltagePlateau_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\PiezoSine_Raw_140206_F1_C1_26.mat';...
    };
moving_cell(2).evidencecalls = {...
    };


moving_cell(3).name = '140207_F1_C2';
moving_cell(3).comment = {'Cell is pressed against others. Moving a lot!  Should be able to fix, Not sound responsive.'};
moving_cell(3).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\Sweep_Raw_140207_F1_C2_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\Sweep_Raw_140207_F1_C2_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\VoltagePlateau_Raw_140207_F1_C2_5.mat';...
    };
moving_cell(3).evidencecalls = {...
    };


for c_ind = 1%:length(moving_cell)
    for t_ind = 1:length(moving_cell(c_ind).exampletrials)
        trial = load(moving_cell(c_ind).exampletrials{t_ind});
        [protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(trial.name);

        afterCorrectionFig = figure;
        set(afterCorrectionFig,'name',[moving_cell(c_ind).name ' - ' protocol '_' trialnum]);
        moviefile = roiFluoTrace(trial,trial.params,'NewROI','No','dFoFfig',afterCorrectionFig,'MotionCorrection',true,'MovieLocation',[pwd '\html']);
        implay(moviefile);
    end
end

%%
% The subpixel registration works well to align images that have shifted in
% x and y.  However, most of the movement produced by beating of the brain
% is stretching of the cell in x and y.  This is a fundamental limitation
% on how much motion artifact can be eliminated from the \Delta F/F trace.
% The hallmark of correction is the stationary electrode.
% Motion correction (such as it is) has been implemented in all following
% analysis, but a better solution is to use a tight ROI.

%% No Effect of Internal pH
% We thought briefly that low pH of the initial batch of internal was
% causing the rapid decline in the fluorescence following break-in.
% The pH of the final 4 aliquots was measured with pH paper, which
% indicated a pH of 6. The colors have faded.  The next batch of 
% Internal was pH'd to 7.18.  However, the decline in fluorescence
% remained.

figure
trial = load(analysis_cell(2).exampletrials{1});
roiFluoTrace(trial,trial.params,'NewROI','No','dFoFfig',gcf,'MotionCorrection',true);

figure
trial = load(analysis_cell(6).exampletrials{1});
roiFluoTrace(trial,trial.params,'NewROI','No','dFoFfig',gcf,'MotionCorrection',true);


%% Save all the roiFluoTraces
close all
roiFluoTraceSavedir = 'C:\Users\Anthony'' Azevedo''\RAnalysis_Data\Record_ArcLightImaging\RoiFluoTraces\';
% if ~isdir(roiFluoTraceSavedir)
%     mkdir(roiFluoTraceSavedir)
% end
proplist =  getpref('AnalysisFigures','roiFluoTrace');
fig = figure(proplist{:});

for c_ind = 1:length(analysis_cell)
    fig = figure(proplist{:});
    
    trial = load(analysis_cell(c_ind).breakin_trial{1});
    roiFluoTrace(trial,trial.params,'NewROI','No','dFoFfig',fig,'MotionCorrection',true);

    [currentPrtcl,dateID,flynum,cellnum] = ...
            extractRawIdentifiers(trial.name);

    eval(['export_fig ', ...
        [roiFluoTraceSavedir [dateID,'_',flynum,'_',cellnum,'_',currentPrtcl,'_',num2str(trial.params.trial)]],...
        ' -pdf -transparent'])
    close(fig)
    
    trial = load(analysis_cell(c_ind).plateau_trial{1});

    [currentPrtcl,dateID,flynum,cellnum,currentTrialNum,celldir,trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    prtclData = prtclData.data;
    trials = findLikeTrials('name',trial.name,'datastruct',prtclData);

    for t_ind = 1:length(trials)
        fig = figure(proplist{:});
        trial = load(fullfile(celldir,sprintf(trialStem,trials(t_ind))));
        try roiFluoTrace(trial,trial.params,'NewROI','No','dFoFfig',fig,'MotionCorrection',true);
        catch
            close(fig)
            continue
        end
        eval(['export_fig ', ...
            [roiFluoTraceSavedir [dateID,'_',flynum,'_',cellnum,'_',currentPrtcl,'_',num2str(trial.params.trial)]],...
            ' -pdf -transparent'])
        
        close(fig)
    end
end

%% Fluorescence Changes at Break-in
% Look for a strong change in the statistics of the current trace (-7X
% std).  That is the point of break in.  Then plot the change in
% fluorescence of DFrames frames before and after.
close all

dT_exposure_window = .2;
% dFrame = 15;
% commandvoltage = zeros(length(analysis_cell),1);
% breakin_dF_traces = zeros(length(analysis_cell),dFrame*2+1);
% breakin_dF_dF = breakin_dF_traces;
% breakin_dF_model_traces = breakin_dF_dF;
% breakin_framewindows = zeros(length(analysis_cell),dFrame*2+1);

for c_ind = 1:length(analysis_cell)
    clear obj
    disp(analysis_cell(c_ind).name)   
    trial = load(analysis_cell(c_ind).exampletrials{1});
    obj.trial = trial;
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    % Bring up the quickShow_sweep Fig
    figure
    if backgroundCorrectionFlag
        quickShow_Sweep(gcf,obj,'No Save','BGCorrectImages',true);
    else
        quickShow_Sweep(gcf,obj,'No Save','BGCorrectImages',false);
    end
    
    dfofax = findobj(gcf,'tag','quickshow_dFoverF_ax');
    dFtrace = get(findobj(dfofax,'type','line'),'ydata');

    % Find the Break-in point
    t = makeInTime(trial.params);
    current = trial.current(1:length(t));
    baseline = t<.5;
    current_baseline_std = std(trial.current(baseline));
    threshold = 10;
    
    switch analysis_cell(c_ind).name
        case '140206_F1_C1'
            break_in = 595501;
        case '140602_F1_C1'
            break_in = 56500;
        case '140602_F2_C1'
            break_in = 89205;
        otherwise
            break_in = find(abs(current-current_baseline_std) > threshold*current_baseline_std,1);
    end
    
    commandvoltage(c_ind) = mean(trial.voltage(t<break_in)); %#ok<SAGROW>
    deltaT = t(break_in);
    
    % Change the time base (exposure time and t);
    et = trial.exposure_time-deltaT;
    t = t-deltaT;
    
    % The exposures are within 20 ms of break-in
    % This is regardless of sampling rate
    frame_window = et >= -dT_exposure_window & et <= dT_exposure_window;
    et_window = et(frame_window);
    et_window = et_window(:);
    frame_window = find(frame_window);
    
    figure(gcf)
    subplot(3,1,1), hold on
    plot(t+deltaT,ones(size(t)) * threshold*current_baseline_std,'k:');
    plot(t+deltaT,ones(size(t)) * -threshold*current_baseline_std,'k:');
    
    if backgroundCorrectionFlag
        breakin_dF = dFoverF_bgcorr_trace(obj.trial);
    else
        breakin_dF = dFoverF_withbg_trace(obj.trial);
    end
    
    % Fit a line to baseline and an exponential to the decay.  Subtract off the decay from the initial points
    coef = [-40, 40,3];            
    exp_base = et(et>0 & et<4);

    [exp_coeffout,resid,jacob,covab,mse] = nlinfit(...
        exp_base(:)',...
        breakin_dF(et>0 & et<4),...
        @exponential,coef);
    parci = nlparci(exp_coeffout,resid,'jacobian',jacob);
    
    base_base = et(et>-.5 & et<0);
    [base_coeffout] = polyfit(...
        base_base(:)',...
        breakin_dF(et>-.5 & et<0),...
        1);
    breakin_dF_model = [...
        base_coeffout(1)*et_window(et_window <= 0) + base_coeffout(2); ...
        exponential(exp_coeffout,et_window(et_window > 0))];
    
    subplot(3,1,2), hold on
    plot(...
        et(et>-.5 & et<0)+deltaT,...
        base_coeffout(1)*et(et>-.5 & et<0) + base_coeffout(2));
    plot(...
        et(et>-.5 & et<0)+deltaT,...
        breakin_dF(et>-.5 & et<0),'m');
    
    switch analysis_cell(c_ind).name
        case '140207_F1_C2'
            exp_base = et(et>0 & et<.4);
            [exp_coeffout] = polyfit(...
                exp_base(:)',...
                breakin_dF(et>0 & et<.4),...
                1);
            breakin_dF_model = [...
                base_coeffout(1)*et_window(et_window <= 0) + base_coeffout(2); ...
                exp_coeffout(1)*et_window(et_window > 0) + exp_coeffout(2)];

            % Plot
            subplot(3,1,2), hold on
            plot(...
                et(et>0)+deltaT,...
                exp_coeffout(1)*et(et>0) + exp_coeffout(2));
            plot(...
                et(et>0)+deltaT,...
                breakin_dF(et>0),'g');
        otherwise
            % Plot
            subplot(3,1,2), hold on
            plot(...
                et(et>0)+deltaT,...
                exponential(exp_coeffout,et(et>0)));
            plot(...
                et(et>0)+deltaT,...
                breakin_dF(et>0),'g');
    end
    

    breakin_dF = breakin_dF(frame_window);
    
    breakin_dF_traces(c_ind,:) = breakin_dF; %#ok<SAGROW>
    breakin_dF_model_traces(c_ind,:) = breakin_dF_model' - breakin_dF_model(find(et_window<=0,1,'last')); %#ok<SAGROW>
    breakin_dF_dF(c_ind,:) = breakin_dF - mean(breakin_dF(et_window<=0)); %#ok<SAGROW>
    breakin_exposure_time_windows(c_ind,:) = et_window; %#ok<SAGROW>
    
%     eval(['export_fig ', ...
%         [savedir ['break-in_long_',dateID,'_',flynum,'_',cellnum]],...
%         ' -pdf -transparent'])

    axs = findobj(gcf,'type','axes');
    for ax = axs'
        %ax
        set(ax,'xlim',[et_window(1)+deltaT   et_window(end)+deltaT]);
    end
    set(dfofax,'ylim',[min(dFtrace(frame_window)), max(dFtrace(frame_window))]);

%     eval(['export_fig ', ...
%         [savedir ['break-in_',dateID,'_',flynum,'_',cellnum]],...
%         ' -pdf -transparent'])
    
end

close all

%%
% With the time of break-in found and the change in fluorescence localized,
% plot the fluorescence trace at break-in.
close all

figure;
ax = subplot(1,1,1); hold on
colors = get(gca,'ColorOrder');
colors = [colors; (2/3)*colors];
for t_ind = 1:size(breakin_dF_dF,1)
    plot(breakin_exposure_time_windows(t_ind,:),breakin_dF_dF(t_ind,:),...
        '-','color',colors(t_ind,:),...
        'displayname',analysis_cell(t_ind).name);
    x_p = breakin_exposure_time_windows(t_ind,:) > .02 & breakin_exposure_time_windows(t_ind,:) <.1;
    x_n = breakin_exposure_time_windows(t_ind,:) > -.1 & breakin_exposure_time_windows(t_ind,:) <.02;
    DeltaF_breakin(t_ind) = mean(breakin_dF_traces(t_ind,x_p),2)-...
        mean(breakin_dF_traces(t_ind,x_n),2); %#ok<SAGROW>
end

ylabel('% \DeltaF/F')
xlabel('Time from break-in (s)');
textbp('Frames, 20 ms exposure');

plot([-.1 -.1],get(gca,'ylim'),'--', 'color',[1 .9 .9]);
plot([-.02 -.02],get(gca,'ylim'),'--','color',[1 .9 .9]);
plot([.02 .02],get(gca,'ylim'),'--','color',[.9 .9 1]);
plot([.1 .1],get(gca,'ylim'),'--','color',[.9 .9 1]);

saveas(gcf,fullfile(regexprep(savedir,'''',''),'Break-in_Fluorescence'));

eval(['export_fig ', ...
    [savedir 'Break-in_Fluorescence'],...
    ' -pdf -transparent'])


%%
% With the time of break-in found and the change in fluorescence localized,
% plot the modelled fluorescence trace at break-in.

x = 1:size(breakin_exposure_time_windows,2);
dFrame = find(breakin_exposure_time_windows(1,:) < 0,1,'last');
x = x-dFrame;

figure
plot(x,breakin_dF_model_traces);
colors = get(gca,'ColorOrder');

colors = [colors; (2/3)*colors];
ylabel('% \DeltaF/F')
xlabel('Frames, 20 ms exposure');

eval(['export_fig ', ...
    [savedir 'Break-in_Fluorescence_Models'],...
    ' -pdf -transparent'])

DeltaF_model_breakin = breakin_dF_model_traces(:,dFrame+1);
            
%% Compare the actual and modelled breakins
figure
hold on
for c_ind = 1:length(DeltaF_breakin)
    plot(DeltaF_breakin(c_ind),DeltaF_model_breakin(c_ind),'o','color',colors(c_ind,:),'markerfacecolor',colors(c_ind,:),'DisplayName',analysis_cell(c_ind).name);
end
%legend(gca,'show','location','best')
scale = [min([DeltaF_breakin(:);DeltaF_model_breakin(:)]) , max([DeltaF_breakin(:);DeltaF_model_breakin(:)])];
plot(scale,scale,':','color',[1 1 1]*.8);
xlabel('Measured %\DeltaF/F')
ylabel('%\DeltaF/F from fit')
title('\DeltaF/F: fit vs measured')
[RHO,PVAL] = corr(DeltaF_breakin(:),DeltaF_model_breakin(:));
textbp(sprintf('rho = %.2f',RHO));

eval(['export_fig ', ...
    [savedir 'FitVsMeasured_DeltaF'],...
    ' -pdf -transparent'])


%% 
% Plot DF_over_F vs holding potential

figure
hold on
for c_ind = 1:length(DeltaF_breakin)
    plot(commandvoltage(c_ind),DeltaF_breakin(c_ind),'o','color',colors(c_ind,:),'markerfacecolor',colors(c_ind,:),'DisplayName',analysis_cell(c_ind).name);
end
legend(gca,'show','location','best')
plot([0 0],get(gca,'ylim'),'k:')
plot(get(gca,'xlim'),[0 0],'k:')
xlim([-50,-20])

ylabel('% \DeltaF/F')
xlabel('V_m (mV)');
title('Measured \DeltaF/F');

set(gcf,'tag','DFoverF_vs_DV_fig');

saveas(gcf,fullfile(regexprep(savedir,'''',''),'DFoverF_vs_DV_fig'));

eval(['export_fig ', ...
    [savedir 'DFoverF_vs_DV_fig'],...
    ' -pdf -transparent'])


%% 
% Plot DF_over_F vs holding potential

figure
hold on
for c_ind = 1:length(DeltaF_breakin)
    plot(commandvoltage(c_ind),DeltaF_model_breakin(c_ind),'o','color',colors(c_ind,:),'markerfacecolor',colors(c_ind,:),'DisplayName',analysis_cell(c_ind).name);
end
legend(gca,'show','location','best')
plot([0 0],get(gca,'ylim'),'k:')
plot(get(gca,'xlim'),[0 0],'k:')
xlim([-50,-20])
title('Model \DeltaF/F');

ylabel('% \DeltaF/F')
xlabel('V_m (mV)');

set(gcf,'tag','DFoverF_vs_DV_fig');

eval(['export_fig ', ...
    [savedir 'DFoverF_vs_DV_model'],...
    ' -pdf -transparent'])


%%
% We can see that those cells that do not appear to be B1 cells also do not
% increase in fluorescence upon break-in (from the 
% orginal notes, see the Google Drive notebook notes).  Currently, the four
% definite B1 cells cluster around 2% change in fluorescence, once they are
% held at 50mV.  When comparing these \Delta Fs to calibration curves,
% consider the decrease in fluorescence for a step from -50mV to -36mV.
%
% As a future plan, if I break in at -40, I should deliver steps from -40.


%% Comparison of break-in step with \Delta F/F vs \Delta V
% I typically recorded two blocks of VoltagePlateau protocols in a row.  I
% have combined such blocks in order to incorporate them all into this
% analysis.

close all
coeffout = zeros(length(analysis_cell),4);
parci = coeffout;

pf = figure;
for c_ind = 1:length(analysis_cell)
    disp(analysis_cell(c_ind).name)
    trial = load(analysis_cell(c_ind).plateau_trial{1});
    obj.trial = trial;
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);

    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    
    figure
    if backgroundCorrectionFlag
        VoltagePlateauxAverageDFoverF(gcf,obj,'No Save','BGCorrectImages',true);
    else
        VoltagePlateauxAverageDFoverF(gcf,obj,'No Save','BGCorrectImages',false);
    end
    
    eval(['export_fig ', ...
        [savedir ['AverageDFoverF_',dateID,'_',flynum,'_',cellnum]],...
        ' -pdf -transparent'])
    
    figure

    if backgroundCorrectionFlag
        [h,dV,dF] = DFoverFoverDV_off(gcf,obj,'No Save','BGCorrectImages',true);
    else
        [h,dV,dF] = DFoverFoverDV_off(gcf,obj,'No Save','BGCorrectImages',false);
    end

    set(findobj(h,'color',[.3 1 .3]),'color',[.8 .8 .8])
    set(findobj(h,'color',[0 .7 0]),'color',[.8 .8 .8],'markerfacecolor',[.8 .8 .8])
    
    coef = [16.0664  943.8559   63.7402  256.1001]; 
    
    [coeffout(c_ind,:)] = nlinfit(dV(:)',dF(:)',@CaoBoltzmann,coef);

    lastwarn('');
    [coeffout(c_ind,:),resid,jacob,covab,mse] = nlinfit(dV(:)',dF(:)',@CaoBoltzmann,coeffout(c_ind,:));
    [lastmsg, lastid] = lastwarn();
    if ~isempty(lastmsg)
        textbp('Illconditioned NLinFit')
    end
    
    parci = nlparci(coeffout(c_ind,:),resid,'jacobian',jacob);

    deltaV_hyp = 1.5*min(dV(1,:)):.01: 1.5*max(dV(1,:));

    [dFprediction, delta] = nlpredci(@CaoBoltzmann,deltaV_hyp,coeffout(c_ind,:),resid,'covar',covab);
    hold on,
    plot(deltaV_hyp,dFprediction,'color',colors(c_ind,:),'linewidth',2)
    plot(deltaV_hyp,[dFprediction+delta;dFprediction-delta],'color',colors(c_ind,:),'linewidth',.5)
    
    deltaV_hyp_in_ci = false(size(deltaV_hyp));
    for v_ind = 1:length(deltaV_hyp)
        if DeltaF_breakin(c_ind) < dFprediction(v_ind) + delta(v_ind) && DeltaF_breakin(c_ind) > dFprediction(v_ind) - delta(v_ind)
            deltaV_hyp_in_ci(v_ind) = true;
        end
    end
    if sum(deltaV_hyp_in_ci)
        left = find(deltaV_hyp_in_ci,1,'first');
        right = find(diff(deltaV_hyp_in_ci)==-1,1,'first');
        mid = find(dFprediction <= DeltaF_breakin(c_ind),1,'first')
        if isempty(right)
            
        end
        plot([deltaV_hyp(left) deltaV_hyp(left)], get(gca,'ylim'),'k','color',[.8 .8 .8]);
        plot([deltaV_hyp(right) deltaV_hyp(right)], get(gca,'ylim'),'k','color',[.8 .8 .8]);
        plot(deltaV_hyp(mid),DeltaF_breakin(c_ind),'o','color',colors(c_ind,:),'markerfacecolor',colors(c_ind,:));
        plot(get(gca,'xlim'),[DeltaF_breakin(c_ind) ,DeltaF_breakin(c_ind)],':','color',colors(c_ind,:));

        predci_delta(c_ind) = deltaV_hyp(right) - deltaV_hyp(left);

        DeltaV_breakin(c_ind) = deltaV_hyp(mid);
        out_of_range_cell(c_ind) = 0; 
    else
        error
        plot(get(gca,'xlim'),[DeltaF_breakin(c_ind) ,DeltaF_breakin(c_ind)],':','color',colors(c_ind,:));
        DeltaV_breakin(c_ind) = min(dV(1,:));
        out_of_range_cell(c_ind) = 1; 
    end
    
    eval(['export_fig ', ...
        [savedir ['DeltaV_breakin_',dateID,'_',flynum,'_',cellnum]],...
        ' -pdf -transparent'])

end

%%
close all
figure; hold on
for c_ind = 1:length(analysis_cell)
    if ~out_of_range_cell(c_ind)
        plot(DeltaF_breakin(c_ind) , DeltaV_breakin(c_ind),'o','color',colors(c_ind,:),'markerfacecolor',colors(c_ind,:));
        errorbar(DeltaF_breakin(c_ind),DeltaV_breakin(c_ind),predci_delta(c_ind));
    else
        %plot(DeltaF_breakin(c_ind) , DeltaV_breakin(c_ind),'o','color',colors(c_ind,:));
    end
end

xlabel('%\DeltaF/F')
ylabel('Predicted \DeltaV (+/- ci)')

%% Main Figure
close all
clear obj
c_ind = 2;

disp(analysis_cell(c_ind).name)
trial = load(analysis_cell(c_ind).exampletrials{1});
obj.trial = trial;
[obj.currentPrtcl,dateID,flynum,cellnum,trialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);
obj.currentTrialNum = str2num(trialNum);
prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = nan(size(obj.prtclData));
for i = 1:length(obj.prtclData)
    obj.prtclTrialNums(i) = obj.prtclData(i).trial;
end 

% Bring up the quickShow_sweep Fig
sweepfig = figure;
UnabridgedSweep(sweepfig,obj,'Save','BGCorrectImages',false);

roiFig = figure;
roiFluoTrace(obj.trial,obj.trial.params,'NewROI','No','dFoFfig',roiFig,'MotionCorrection',true);

tracesFig = open(fullfile(regexprep(savedir,'''',''),'Break-in_Fluorescence.fig'));

dotsFig = open(fullfile(regexprep(savedir,'''',''),'DFoverF_vs_DV_fig.fig'));

%%
%close mainFig
mainFig = figure;

set(mainFig,'color',[1 1 1],'position',[527   298   713   680])
panl = panel(mainFig);
panl.fontname = 'Arial';
panl.pack('h',{1/2 1/2})  % response panel, stimulus panel

panl(1).pack('v',{1/4 3/4})
panl(1,2).pack('v',{1/3 1/3 1/3})
panl(1,2).de.margin = 4;

panl(2).pack('v',{1/2 1/2});

% Cell image panel4
ax = panl(1,1).select();
roipanl = panel.recover(roiFig);
roiax = roipanl(1,1).select();
cellimage = findobj(roiax,'type','image');
xy = get(cellimage,'cdata');

imshow(xy,[0 max(xy(:))],'initialmagnification','fit','parent',ax);
%copyobj(findobj(roiax,'type','line'),ax);

xlim(ax,[1 64]);
ylim(ax,[1 64]);
xlims = [3.16 3.56];

% \DeltaF break in panel
ax1 = panl(1,2,1).select();
inax = findobj(sweepfig,'tag','quickshow_dFoverF_ax');
l = copyobj(findobj(inax,'type','line'),ax1);
time = get(l,'xdata');
current = get(l,'ydata');
set(l,'ydata',current - mean(current(time>=3 & time<=3.26)));
panl(1,2,1).ylabel('%\DeltaF/F')
set(ax1,'YLim',[-2 5],'xtick',[],'xColor',[1 1 1]);

% current break in panel
ax2 = panl(1,2,2).select();
inax = findobj(sweepfig,'tag','quickshow_inax');
copyobj(findobj(inax,'type','line'),ax2);
panl(1,2,2).ylabel('pA')
set(ax2,'ylim',[-300 300],'xtick',[],'xColor',[1 1 1]);

% V break in panel
ax3 = panl(1,2,3).select();
outax = findobj(sweepfig,'tag','quickshow_outax');
copyobj(findobj(outax,'type','line'),ax3);
panl(1,2,3).ylabel('mV')
set(ax3,'ylim',[-51 -44]);
panl(1,2,3).xlabel('Time (s)')

set([ax1,ax2,ax3],'xlim',xlims,'Tickdir','out');
set(findobj([ax1,ax2,ax3],'type','line'),'color',[0 0 0]);

%Traces panel
ax4 = panl(2,1).select();
traces_ax = get(tracesFig,'children');
copyobj(get(traces_ax,'children'),ax4);
panl(2,1).xlabel('Time from patch (s)')
panl(2,1).ylabel('%\DeltaF/F')
set(ax4,'xlim',[-.18 .18],'Tickdir','out');

traces = findobj(ax4,'type','line','linestyle','-');

% Dots panel
ax5 = panl(2,2).select();
dots_ax = findobj(dotsFig,'type','axes','-not','tag','legend');
copyobj(get(dots_ax,'children'),ax5);
panl(2,2).xlabel('V_{hold} (mV)')
panl(2,2).ylabel('%\DeltaF/F')
legend(ax5,'hide');
set(ax5,'xlim',[-52 -20],'Tickdir','out')

dots = findobj(ax5,'type','line','Marker','o');
x = dots;
for i = 1:length(x)
    x(i) = get(dots(i),'xdata');
end
mV = repmat(x(:),1,3);

delta = max(mV(:)) - min(mV(:));
greys = -.8*(mV-max(mV(:)))/(-delta)+.8;

for i = 1:length(x)
    set(dots(i),'markerFaceColor',greys(i,:),'markerEdgeColor',greys(i,:));
    set(findobj(traces,'displayname',get(dots(i),'displayname')),'color',greys(i,:));
end
fn = fullfile(regexprep(savedir,'''',''),'ArcLightMainFig.pdf');
panl.export(fn, '-rp', '-a1.0');


%%
panl.margin = [18 10 2 10];
panl(2).marginleft = 18;
%panl(2).margintop = 8;


%% Rejected cells
% Cells were rejected if: 
%%
% # the cell was clearly not a B1 cell (al PN or confirmed not green)
% # images were lost because of bugs in the code
% # patching failed
% # fluorescence changes in response to voltage steps were not imaged
% # the cell was not isolated from the surrounding cells

cnt = 0;

cnt = cnt+1;
reject_cells(cnt).name = '131203_F1_C1';
reject_cells(cnt).reason = 'No images, lost cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F1_C1\Sweep_131217_F1_C1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '131203_F1_C2';
reject_cells(cnt).reason = 'No Images! Not imaging break in';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131203_F2_C1';
reject_cells(cnt).reason = 'Not imaging break-in, no responses';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131211_F1_C1';
reject_cells(cnt).reason = 'Rogue Cell (al PN)';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131211_F1_C2';
reject_cells(cnt).reason = 'No voltage clamp steps (no calibration). Cell Moved during CurrentPlateau';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentPlateau_Raw_131211_F1_C2_2.mat';
reject_cells(cnt).evidencecalls = 'fluorescence(trial,trial.params)';

cnt = cnt+1;
reject_cells(cnt).name = '131212_F1_C1';
reject_cells(cnt).reason = 'Not a green cell';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131217_F1_C2';
reject_cells(cnt).reason = 'Single bad sweep';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F2_C1\Sweep_Raw_131217_F2_C1_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '131217_F2_C2';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F2_C2\Sweep_Raw_131217_F2_C2_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140114_F1_C1';
reject_cells(cnt).reason = 'Break in in I=0 Mode, and blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140114\140114_F1_C1\Sweep_Raw_140114_F1_C1_4.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140114_F2_C1';
reject_cells(cnt).reason = 'Wrong Cell, image not zoomed in';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140114\140114_F2_C1\Sweep_Raw_140114_F2_C1_1.mat';


cnt = cnt+1;
reject_cells(cnt).name = '140115_F1_C1';
reject_cells(cnt).reason = 'Current Clamp Breakin, but only went to 5mV from 10, not inside cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140115\140115_F1_C1\Sweep_Raw_140115_F1_C1_2.mat';


cnt = cnt+1;
reject_cells(cnt).name = '140115_F1_C2';
reject_cells(cnt).reason = 'Couldn''t break in, weird voltage values';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140115\140115_F1_C2\Sweep_Raw_140115_F1_C2_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140115_F2_C1';
reject_cells(cnt).reason = 'Good Motion example! Not good access, ran out of saline, no cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140115\140115_F2_C1\CurrentPlateau_Raw_140115_F2_C1_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140121_F1_C1';
reject_cells(cnt).reason = 'Blew up the cell while patching';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F1_C1\Sweep_Raw_140121_F1_C1_2.mat';


cnt = cnt+1;
reject_cells(cnt).name = '140122_F2_C1';
reject_cells(cnt).reason = 'Moving a lot! Not a clear deliniation of the cell';
reject_cells(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\Sweep_Raw_140122_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_12.mat';...
    };
reject_cells(cnt).evidencecalls = {...
    };


cnt = cnt+1;
reject_cells(cnt).name = '140122_F2_C2';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C2\Sweep_Raw_140122_F2_C2_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140128_F1_C1';
reject_cells(cnt).reason = 'Cell was up against some others, not clearly isolated';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\Sweep_Raw_140128_F1_C1_5.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140131_F1_C1';
reject_cells(cnt).reason = 'Blew up the cell, couldn''t patch it';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '140206_F2_C1';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F2_C1\Sweep_Raw_140206_F2_C1_2.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140206_F3_C1';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F3_C1\Sweep_Raw_140206_F3_C1_2.mat';

for c_ind = 1:length(reject_cells)
    fprintf('Cell ID: %s\n', reject_cells(c_ind).name);
    fprintf('Comment: %s\n\n', reject_cells(c_ind).reason);
end




%%
'131203_F1_C1'; % All Cells recorded in VT30609/ArcLight line
'131203_F1_C2';
'131203_F2_C1';

'131211_F1_C1'; % Rogue Cell (al PN)
'131211_F1_C2'; % 
'131211_F2_C1'; % First cell that looked good, not great calibration

'131212_F1_C1';  % Not Green

'131217_F1_C1';  
'131217_F2_C1';
'131217_F2_C2';

'140114_F1_C1';
'140114_F2_C1';

'140115_F1_C1';
'140115_F1_C2';
'140115_F2_C1';

'140117_F2_C1';

'140121_F1_C1';
'140121_F2_C1';

'140122_F1_C1';
'140122_F2_C1';
'140122_F2_C2';

% MakeOutTime change

'140128_F1_C1';

'140131_F1_C1';
'140131_F3_C1';

% New Internal

'140205_F1_C1';

'140206_F1_C1';
'140206_F3_C1';

'140207_F1_C2';

