%% Record of Low Frequency Responsive Cells

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_MidFrequencySpikingB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1

%% Possible cells

%% Cells that possibly should be excluded
exclude_cells = {
    '140311_F1_C1',  'From paired recording, no Piezosine data'
    '140121_F2_C1',  'Arclight, great cell for that, no Piezosine data, no obvious spikes'
    '140117_F2_C1',  'Not great PiezoSine data.  This should probably be put in the BP set'
    '131122_F3_C1',  ' No Data...'
    '131119_F2_C2',  ' No Data. Interesting current sign, though'
    '131015_F1_C1',  ' No Piezo connection (no responses). Interesting current sign, though, beautiful spiking!'
    };

%%
clear analysis_cell

% VT30604
cnt = 1;
analysis_cell(cnt).name = {
    '131211_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\CurrentStep_Raw_131211_F2_C1_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\PiezoSine_Raw_131211_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\CurrentPlateau_Raw_131211_F2_C1_5.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'Questionable.  No clear spiking, sharper tuning';
    };

% GH86
cnt = 2;
analysis_cell(cnt).name = {
    '131014_F4_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F4_C1\PiezoSine_Raw_131014_F4_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F4_C1\PiezoStep_Raw_131014_F4_C1_1.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'clear spiking (sweep), but not great stimulus control';
    };

cnt = 3;
analysis_cell(cnt).name = {
    '131014_F3_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\PiezoSine_Raw_131014_F3_C1_4.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\Sweep_Raw_131014_F3_C1_13.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\PiezoStep_Raw_131014_F3_C1_1.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'clear spiking, mid range frequency, holding potential is offset, but otherwise ok';
    };

cnt = 4;
analysis_cell(cnt).name = {
    '131016_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_12.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\PiezoStep_Raw_131016_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\PiezoSine_Raw_131016_F1_C1_10.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'Clear spiking, not good stimulus control! exclude from PiezoStepAnalysis';
    };

% VT30609
cnt = 5;
analysis_cell(cnt).name = {
    '140311_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140311\140311_F1_C1\Sweep_Raw_140311_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140311\140311_F1_C1\CurrentSine_Raw_140311_F1_C1_4.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'From paired recording, no AVLP, only current sine data';
    };

cnt = 6;
analysis_cell(cnt).name = {
    '140121_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\CurrentStep_Raw_140121_F2_C1_13.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\Sweep_Raw_140121_F2_C1_7.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'No obvious spikes in the sweep, current steps show activity, Piezo activity is unclear';
    };


cnt = 7;
analysis_cell(cnt).name = {
    '140117_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\CurrentStep_Raw_140117_F2_C1_10.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\Sweep_Raw_140117_F2_C1_7.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'No obvious spikes in the sweep, current steps show activity, Piezo activity is unclear';
    };


cnt = 8;
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
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'Banner cell, Current Sine @ hyp. Vm, was used in NRSA-resubmit, sharp tuning though coarse';
    };

cnt = 9;
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
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'Banner cell, Current Sine @ hyp. Vm, was used in NRSA-resubmit, sharp tuning though coarse';
    };

cnt = 10;
analysis_cell(cnt).name = {
    '140602_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\CurrentStep_Raw_140602_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\PiezoStep_Raw_140602_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\PiezoChirp_Raw_140602_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\PiezoChirp_Raw_140602_F1_C1_13.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\CurrentChirp_Raw_140602_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140602\140602_F1_C1\CurrentChirp_Raw_140602_F1_C1_6.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
''
};


%%
% cnt = n;
% analysis_cell(cnt).name = {
%     'aa';
%     };
% analysis_cell(cnt).exampletrials = {...
% };
% analysis_cell(cnt).genotype = getFlyGenotype(analysis_cell(cnt).exampletrials{1});
% analysis_cell(cnt).comment = {
%     'aa';
%     };

%% Exporting PiezoSineMatrix info on cells 
close all
for c_ind = 9:length(analysis_cell)
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

%% Exporting PiezoSineOsciRespVsFreq info on cells 
close all
for c_ind = 9:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
            extractRawIdentifiers(trial.name);
        
        if ~isempty(strfind('PiezoSineOsciRespVsFreq',obj.currentPrtcl))
            prtclData = load(dfile);
            obj.prtclData = prtclData.data;
            obj.prtclTrialNums = obj.currentTrialNum;

            genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
            if ~isdir(genotypedir), mkdir(genotypedir); end

            if exist('f','var') && ishandle(f), close(f),end
            PiezoSineOsciRespVsFreq([],obj,'');
            f = findobj(0,'tag','PiezoSineOsciRespVsFreq');
            if save
            p = panel.recover(f);
            fn = fullfile(genotypedir,['BPS_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoSineOsciRespVsFreq.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-l','-a1.4');
            end
        end
    end
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

%% Plot all transfer functions in one plot 


%% Plot f2/f2 ratio for PiezoSine

