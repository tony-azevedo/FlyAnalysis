%% Record of Low Frequency Responsive Cells

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_MidFrequencySpikingB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1


%%

analysis_cells = {...
'131211_F2_C1'
'131014_F4_C1'
'131014_F3_C1'
'131016_F1_C1'
'140311_F1_C1'
'140121_F2_C1'
'131126_F2_C2'
'140602_F1_C1'
'150421_F1_C1'
};

analysis_cells_comment = {...
    'Questionable.  No clear spiking, sharper tuning';
    'clear spiking (sweep), but not great stimulus control';
    'clear spiking, mid range frequency, holding potential is offset, but otherwise ok';
    'Clear spiking, not good stimulus control! exclude from PiezoStepAnalysis';
    'From paired recording, no AVLP, only current sine data';
    'No obvious spikes in the sweep, current steps show activity, Piezo activity is unclear';
    'Banner cell, Current Sine @ hyp. Vm, was used in NRSA-resubmit, sharp tuning though coarse';
    'Not great access, has a lot of the hallmarks of a spiking cell.  Spiking cell accordign to notebook';
    '??'
};

analysis_cells_genotype = {...
'pJFRC7;VT30609'
'GH86-Gal4!GH86-Gal4;pJFRC7!pJFRC7;'
'GH86-Gal4!GH86-Gal4;pJFRC7!pJFRC7;'
'GH86-Gal4!GH86-Gal4;pJFRC7!pJFRC7;'
'GH86-Gal4!+;pJFRC7!+;VT34811-Gal4!+'
';pJFRC7!pJFRC7;VT30609-Gal4!VT30609-Gal4'
';pJFRC7!pJFRC7;VT30609-Gal4!VT30609-Gal4'
';;VT30609-Gal4!ArcLight'
'Fru-Gal4,UAS-GFP'
};


clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c); 
    analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%%
% VT30604
cnt = find(strcmp(analysis_cells,'131211_F2_C1'));
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\CurrentStep_Raw_131211_F2_C1_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\PiezoSine_Raw_131211_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\CurrentPlateau_Raw_131211_F2_C1_5.mat';
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\PiezoSine_Raw_131211_F2_C1_6.mat';
};

%% GH86
cnt = find(strcmp(analysis_cells,'131014_F4_C1'));
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F4_C1\PiezoSine_Raw_131014_F4_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F4_C1\PiezoStep_Raw_131014_F4_C1_1.mat';
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F4_C1\Sweep_Raw_131014_F4_C1_21.mat';
};

%%
cnt = find(strcmp(analysis_cells,'131014_F3_C1'));
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\PiezoSine_Raw_131014_F3_C1_4.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\Sweep_Raw_131014_F3_C1_13.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\PiezoStep_Raw_131014_F3_C1_1.mat';
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\Sweep_Raw_131014_F3_C1_5.mat';
};
analysis_cell(cnt).comment = {
    'clear spiking, mid range frequency, holding potential is offset, but otherwise ok';
    };

%%
cnt = find(strcmp(analysis_cells,'131016_F1_C1'));
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_12.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\PiezoStep_Raw_131016_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\PiezoSine_Raw_131016_F1_C1_10.mat';
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_2.mat';
};

%% VT30609
cnt = find(strcmp(analysis_cells,'140311_F1_C1'));
analysis_cell(cnt).name = {
    '140311_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140311\140311_F1_C1\Sweep_Raw_140311_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140311\140311_F1_C1\CurrentSine_Raw_140311_F1_C1_4.mat';
};
analysis_cell(cnt).baselinetrial = {
''
};

%%
cnt = find(strcmp(analysis_cells,'140121_F2_C1'));
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\CurrentStep_Raw_140121_F2_C1_13.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\Sweep_Raw_140121_F2_C1_7.mat';
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\PiezoSine_Raw_140121_F2_C1_25.mat';
};

%%
cnt = find(strcmp(analysis_cells,'131126_F2_C2'));
analysis_cell(cnt).name = {
    '131126_F2_C2';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_11.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_1.mat';  % hyperpolarized
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_29.mat'; % resting
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentStep_Raw_131126_F2_C2_20.mat'; % this is what a spiking cell looks like
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentStep_Raw_131126_F2_C2_22.mat'; % hyperpolarized
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_1.mat';
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_4.mat';
};

%%
cnt = find(strcmp(analysis_cells,'140602_F1_C1'));
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\CurrentStep_Raw_140602_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\PiezoStep_Raw_140602_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\PiezoChirp_Raw_140602_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\PiezoChirp_Raw_140602_F1_C1_13.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\CurrentChirp_Raw_140602_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\CurrentChirp_Raw_140602_F1_C1_6.mat';
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\PiezoChirp_Raw_140602_F1_C1_5.mat';
};

%%
cnt = find(strcmp(analysis_cells,'150421_F1_C1'));
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\150421\150421_F1_C1\CurrentChirp_Raw_150421_F1_C1_2.mat';
};
analysis_cell(cnt).baselinetrial = {
'C:\Users\Anthony Azevedo\Raw_Data\150421\150421_F1_C1\Sweep_Raw_150421_F1_C1_1.mat';
};


%% Exporting PiezoSineMatrix info on cells 
close all
for c_ind = 4%:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoSineMatrix',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;
            
            
            f = PiezoSineMatrix([],obj,'');
            if save
            p = panel.recover(f);

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            fn = fullfile(genotypedir,['BPS_', ... 
                dateID '_', ...
                flynum '_', ... 
                cellnum '_', ... 
                num2str(obj.trial.params.trialBlock) '_',...
                'PiezoSineMatrix', ...
                '.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-l');

            f2 = findobj(0,'tag','PiezoSineMatrixStimuli');
            f2 = f2(1);
            p = panel.recover(f2);
            p.fontname = 'Arial';
            fn = regexprep(fn,'PiezoSineMatrix','PiezoSineMat_Stim');
            p.export(fn, '-rp','-l');
            end
        end
    end
end

%% Exporting PiezoSineOsciRespVsFreq info on cells with X-functions
close all
clear transfer freqs dsplcmnts        
cnt = 0;
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoSineOsciRespVsFreq',obj.currentPrtcl))
            cnt = cnt+1;
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            if exist('f','var') && ishandle(f), close(f),end
            
            hasPiezoSineName{cnt} = analysis_cell(c_ind).name;
            [transfer{cnt},freqs{cnt},dsplcmnts{cnt}] = PiezoSineOsciRespVsFreq([],obj,'');
            f = findobj(0,'tag','PiezoSineOsciRespVsFreq');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['BP_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoSineOsciRespVsFreq.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-l','-a1.4');
            end
        end
    end
end

% Count the number of displacements, etc
all_dsplcmnts = [];
for d_ind = 1:length(dsplcmnts) 
    all_dsplcmnts = [all_dsplcmnts,dsplcmnts{d_ind}];
end
all_dsplcmnts = sort(unique(all_dsplcmnts));

all_freqs = [];
for d_ind = 1:length(freqs) 
    all_freqs = [all_freqs,round(freqs{d_ind}*100)/100];
end
all_freqs = sort(unique(all_freqs));

% Plotting transfer from all cells
f = figure;
pnl = panel(f);
pnl.pack('v',{2/3  1/3})  % response panel, stimulus panel
pnl.margin = [13 10 2 10];
pnl(1).marginbottom = 2;
pnl(2).marginleft = 12;

pnl(1).pack('h',length(all_dsplcmnts));

ylims = [0 -Inf];
for d_ind = 1:length(all_dsplcmnts)
    dspltranf = nan(length(transfer),length(all_freqs));
    ax = pnl(1,d_ind).select(); hold(ax,'on')
    for c_ind = 1:length(transfer)
        dspl = dsplcmnts{c_ind};
        d_i = find(round(dspl*10)/10 == all_dsplcmnts(d_ind));
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*100)/100);
        dspltranf(c_ind,af_i) = real(abs(transfer{c_ind}(:,d_i)))';
        
        plot(freqs{c_ind},real(abs(transfer{c_ind}(:,d_i))),...
            'parent',ax,'linestyle','-','color',[.85 .85 .85],...
            'marker','.','markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85],...
            'tag',sprintf('%.2f',dsplcmnts{c_ind}(d_ind)))
    end
    plot(all_freqs(~isnan(dspltranf(2,:))),nanmean(dspltranf(:,~isnan(dspltranf(2,:))),1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    % plot(all_freqs,nanmean(dspltranf,1),'color',[0 1/length(all_dsplcmnts) 0]*d_ind);
    
    set(ax,'xscale','log');
    
    ylims = [min(ylims(1),min(dspltranf(:))) max(ylims(2),max(dspltranf(:)))];
end
for d_ind = 1:length(all_dsplcmnts)
    set(pnl(1,d_ind).axis,'ylim',ylims);
end

%phases (all the same?)
pnl(2).pack('h',length(all_dsplcmnts));
for d_ind = 1:length(all_dsplcmnts)
    dsplphase = nan(length(transfer),length(all_freqs));
    ax = pnl(2,d_ind).select(); hold(ax,'on')
    for c_ind = 1:length(transfer)
        
        dspl = dsplcmnts{c_ind};
        d_i = find(round(dspl*10)/10 == all_dsplcmnts(d_ind));
        [~,af_i] = intersect(all_freqs,round(freqs{c_ind}*100)/100);
        dsplphase(c_ind,af_i) = angle(transfer{c_ind}(:,d_i))';
        
        % for col_ind = 1:size(dsplphase,2);
            %         dsplphase(:,col_ind) = clusterPhases(dsplphase(:,col_ind));
        % end
        plot(freqs{c_ind},dsplphase(c_ind,af_i),...
        'parent',ax,'linestyle','-','color',[.85 .85 .85],...
        'marker','.','markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85],...
        'tag',sprintf('%.2f',dsplcmnts{c_ind}(d_ind)))
    end
    %dsplphase = dsplphase/(2*pi)*360;
    plot(all_freqs,nanmean(dsplphase,1),...
        'parent',ax,'linestyle','none','color',[.85 .85 .85],...
        'marker','.','markerfacecolor',[0 1/length(all_dsplcmnts) 0]*d_ind,...
        'markeredgecolor',[0 1/length(all_dsplcmnts) 0]*d_ind)

    set(ax,'xscale','log');
    set(ax,'yticklabel',{'-\pi','0','\pi'});
    set(ax,'YTick',[-pi,0, pi])
end
fn = fullfile(savedir,'BPS_PiezoSineOsciRespVsFreq.pdf');
pnl.fontname = 'Arial';
pnl.export(fn, '-rp','-l','-a1.4');
saveas(f, regexprep(fn,'.pdf',''), 'fig')

for d_ind = 1:length(all_dsplcmnts)
     set(pnl(2,d_ind).select(),'YTick',[-pi,0, pi])
end

%% Exporting PiezoStepMatrix info on cells 
close all
for c_ind = 9:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoStepMatrix',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            f = PiezoStepMatrix([],obj,'');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoStepMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            
            f2 = findobj(0,'tag','PiezoStepMatrixStimuli');
            f2 = f2(1);
            p = panel.recover(f2);
            p.fontname = 'Arial';
            fn = regexprep(fn,'PiezoStepMatrix','PiezoStepMat_Stim');
            p.export(fn, '-rp','-l');

            end
        end
    end
end

%% Exporting PiezChirpMatrix info on cells
close all
for c_ind = 9:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoChirpMatrix',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            f = PiezoChirpMatrix([],obj,'');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoChirpMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            
            f2 = findobj(0,'tag','PiezoChirpMatrixStimuli');
            f2 = f2(1);
            p = panel.recover(f2);
            p.fontname = 'Arial';
            fn = regexprep(fn,'PiezoChirpMatrix','PiezoChirpMat_Stim');
            p.export(fn, '-rp','-l');

            end
        end
    end
end

%% Exporting PiezoChirpZAP info on cells 
close all
for c_ind = 9:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoChirpZAP',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            if exist('f','var') && ishandle(f), close(f),end
            PiezoChirpZAP([],obj,'');
            f = findobj(0,'tag','PiezoChirpZAP');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoChirpZAP.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-l','-a1.4');
            end
        end
    end
end

%% Exporting CurrentStepFamMatrix info on cells
close all
for c_ind = 9:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('CurrentStepFamMatrix',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            f = CurrentStepFamMatrix([],obj,'');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'CurrentStepFamMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            end
        end
    end
end

%% Exporting CurrentChirpMatrix info on cells 
close all
for c_ind = 9:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('CurrentChirpMatrix',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            f = CurrentChirpMatrix([],obj,'');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'CurrentChirpMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            
            f2 = findobj(0,'tag','CurrentChirpMatrixStimuli');
            f2 = f2(1);
            p = panel.recover(f2);
            p.fontname = 'Arial';
            fn = regexprep(fn,'CurrentChirpMatrix','CurrentChirpMat_stim');
            p.export(fn, '-rp','-l');

            end
        end
    end
end

%% Exporting CurrentChirpZAP info on cells
close all
for c_ind = 9:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('CurrentChirpZAP',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            if exist('f','var') && ishandle(f), close(f),end
            CurrentChirpZAP([],obj,'');
            f = findobj(0,'tag','CurrentChirpZAP');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'CurrentChirpZAP.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-l','-a1.4');
            end
        end
    end
end

%% Exporting CurrentSineMatrix info on cells
close all
for c_ind = 9:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('CurrentSineMatrix',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            f = CurrentSineMatrix([],obj,'');
            if save
            p = panel.recover(f(1));
            fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'CurrentSineMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            end
        end
    end
end

%% Exporting CurrentSineVvsFreq info on cells 
close all
for c_ind = 9:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('CurrentSineVvsFreq',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            if exist('f','var') && ishandle(f), close(f),end
            
            CurrentSineVvsFreq([],obj,'');
            f = findobj(0,'tag','CurrentSineVvsFreq');

            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'CurrentSineVvsFreq.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            end
        end
    end
end

%% Plot f2/f2 ratio for PiezoSine

%% Resting membrane potential
close all
vm_rest = nan(size(analysis_cell));
for c_ind = 1:length(analysis_cell)
    if isempty(analysis_cell(c_ind).baselinetrial{1}), continue,end
    trial = load(analysis_cell(c_ind).baselinetrial{1});
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    t = makeInTime(obj.trial.params);
    if t(1)<0;
        vm_rest(c_ind) = mean(obj.trial.voltage(t<0));
    else
        vm_rest(c_ind) = mean(obj.trial.voltage(t<1));
    end
end
f = figure;
pnl = panel(f);
pnl.pack(1)  % response panel, stimulus panel
pnl.margin = [16 12 2 12];
ax = pnl(1).select(); hold(ax,'on')
colors = get(ax,'colorOrder');
colors = [colors; (2/3)*colors];

for c_ind = 1:length(analysis_cell)
    plot(c_ind,vm_rest(c_ind),...
        'parent',ax,'linestyle','none','color',colors(c_ind,:),...
        'marker','.','markerfacecolor',colors(c_ind,:),...
        'markeredgecolor',colors(c_ind,:))
end
set(ax,'ylim',[ -60 -22])
pnl(1).ylabel('Resting V_m (mV)')

fn = fullfile(savedir,'BPS_Vm_rest.pdf');
pnl.fontname = 'Arial';
pnl.export(fn, '-rp','-l','-a1');
saveas(f, regexprep(fn,'.pdf',''), 'fig')

%% Spontaneous oscillations

close all

fig = figure;
pnl = panel(fig);
pnl.pack('v',{1/3 2/3})  % response panel, stimulus panel
pnl.margin = [16 12 2 10];
ax = pnl(1).select(); hold(ax,'on');

colors = get(ax,'colorOrder');
colors = [colors; (2/3)*colors];

% plot the FFT of spontaneous oscilations
% get the peak
peak = nan(size(analysis_cell));
spontFreq = peak;

for c_ind = 1:length(analysis_cell)
    if isempty(analysis_cell(c_ind).baselinetrial{1}), continue,end
    trial = load(analysis_cell(c_ind).baselinetrial{1});
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    t = makeInTime(obj.trial.params);
    if ~isempty(strfind(obj.currentPrtcl,'Sweep'))
        t_ind = ~isnan(t);
    elseif ~isempty(strfind(obj.currentPrtcl,'PiezoChirp'))
        t_ind = t>(t(end)-3);
    else
        t_ind = t>(t(end)-trial.params.postDurInSec);
    end
    x = t(t_ind);
    y = obj.trial.voltage(t_ind);
    
    % section for averaging
    dT = .5;
    dX = sum(x<x(1)+dT);
    x_mat = reshape(x,dX,[]);
    y_mat = reshape(y,dX,[]);
    
    f_ = trial.params.sampratein/dX*[0:dX/2]; f_ = [f_, fliplr(f_(2:end-1))];

    Y_mat = fft(y_mat,[],1);    
    Y_mat = real(conj(Y_mat).*Y_mat);
    %figure; loglog(f,Y_mat), pause, close(gcf);

    mean_Y_mat = mean(Y_mat,2);
    ax = pnl(1).select(); hold(ax,'on');
    plot(f_,mean_Y_mat,...
        'parent',ax,'linestyle','-','color',colors(c_ind,:),...
        'marker','none','markerfacecolor',colors(c_ind,:),...
        'markeredgecolor',colors(c_ind,:))
    
    [peak(c_ind),f_ind] = max(mean_Y_mat(f_>10&f_<1000));
    spontFreq(c_ind) = f_(f_ind+(sum(f_<=10)+1)/2);
    
    plot(spontFreq(c_ind),peak(c_ind),...
        'parent',ax,'linestyle','none','color',colors(c_ind,:),...
        'marker','o','markerfacecolor','none',...
        'markeredgecolor',colors(c_ind,:))
end

set(ax,'xscale','log','yscale','log')
set(ax,'xlim',[10 1000])
pnl(1).ylabel('Power (mV^2/Hz^2)')
pnl(1).xlabel('Frequency (Hz)')

%% Plot the spontaneous oscillations versus the peak freqency sensitivity

clear transfer freqs dsplcmnts 
selectFreq = nan(size(spontFreq));
log_switch = nan(size(spontFreq));
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoChirpZAP',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;
            [~,~,transfer,f_sampled] = PiezoChirpZAP([],obj,'','plot',0);
            [trpk,f_ind] = max(transfer(f_sampled > 25 ... %min(trial.params.freqStart,trial.params.freqEnd) ...
                                    & f_sampled < max(trial.params.freqStart,trial.params.freqEnd)));
            selectFreq(c_ind) = f_sampled(f_ind+sum(f_sampled <= 25));
            log_switch(c_ind) = 1;
            break

        elseif ~isempty(strfind('PiezoSineOsciRespVsFreq',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;
            
            [transfer,freqs,dsplcmnts] = PiezoSineOsciRespVsFreq([],obj,'','plot',0);
            tr = real(abs(transfer));
            [trpk,inds] = max(tr,[],1);
            
            selectFreq(c_ind) = mean(freqs(inds));
            log_switch(c_ind) = 0;
        end
    end
end
log_switch(isnan(log_switch)) = 0;
ax = pnl(2).select(); hold(ax,'on');

colors = get(ax,'colorOrder');
colors = [colors; (2/3)*colors];
for c_ind = 1:length(analysis_cell)
    l = plot(spontFreq(c_ind), selectFreq(c_ind),'parent',ax, ...
        'linestyle','none','color',[0 0 0],...
        'marker','o','markerfacecolor',[0 0 0],'markeredgecolor',[0 0 0]);
    if log_switch(c_ind)
    set(l,...
        'markerfacecolor',[.85 .85 .85],'markeredgecolor',[.85 .85 .85])
    
    end
end
set(ax,'xscale','log','yscale','log')
set(ax,'xlim',[10 1000],'ylim',[10 300])
l_chirp = findobj(ax,'markerfacecolor',[.85 .85 .85]);
l_sine = findobj(ax,'markerfacecolor',[0 0 0]);

legend([l_chirp(1),l_sine(1)],{'chirp','sine'});
pnl(2).ylabel('Preferred Freq (Hz)')
pnl(2).xlabel('Spontaneous Freq (Hz)')

figure(fig)
fn = fullfile(savedir,'BPS_SelectivityVsSpontaneous.pdf');
pnl.fontname = 'Arial';
pnl.export(fn, '-rp','-l','-a1');

%% Cells that possibly should be excluded
exclude_cells = {
    '140311_F1_C1',  'From paired recording, no Piezosine data'
    '140121_F2_C1',  'Arclight, great cell for that, no Piezosine data, no obvious spikes'
    '140117_F2_C1',  'Not great PiezoSine data.  This should probably be put in the BP set'
    '131122_F3_C1',  ' No Data...'
    '131119_F2_C2',  ' No Data. Interesting current sign, though'
    '131015_F1_C1',  ' No Piezo connection (no responses). Interesting current sign, though, beautiful spiking!'
    };
