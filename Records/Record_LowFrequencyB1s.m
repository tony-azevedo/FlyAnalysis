%% Record of Low Frequency Responsive Cells

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_LowFrequencyB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1

%% Possible cells

%%
% VT30609
analysis_cell(1).name = {
    '140128_F1_C1';
    };
analysis_cell(1).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\CurrentStep_Raw_140128_F1_C1_15.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\CurrentStep_Raw_140128_F1_C1_10.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoSine_Raw_140128_F1_C1_100.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoStep_Raw_140128_F1_C1_1.mat';
};
analysis_cell(1).evidencecalls = {...
    'CurrentStepFamMatrix'
    'PiezoSineMatrix'
    'PiezoStepMatrix'
    'PiezoSineOsciRespVsFreq'
    };
analysis_cell(1).genotype = getFlyGenotype(analysis_cell(1).exampletrials{1});
analysis_cell(1).comment = {
    'Complete over harmonics, slight band pass';
    };

analysis_cell(2).name = {
    '140122_F2_C1';
    };
analysis_cell(2).comment = {
    'coarse freq sample, single amplitude, VCLAMP data!';
    };
analysis_cell(2).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_5.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\CurrentStep_Raw_140122_F2_C1_5.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_37.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoStep_Raw_140122_F2_C1_6.mat';
    };
analysis_cell(2).genotype = getFlyGenotype(analysis_cell(2).exampletrials{2});
analysis_cell(2).comment = {
    'coarse freq sample, single amplitude, VCLAMP data!';
    };


% % GH86
cnt = 3;
analysis_cell(cnt).name = {
    '131015_F3_C1';
    };
analysis_cell(cnt).comment = {
    'coarse frequency, no current injections';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\PiezoSine_Raw_131015_F3_C1_43.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\PiezoStep_Raw_131015_F3_C1_1.mat';
    };
analysis_cell(cnt).genotype = getFlyGenotype(analysis_cell(cnt).exampletrials{1});
analysis_cell(cnt).comment = {
    'coarse frequency, no current injections';
    };


%% Exporting PiezoSineMatrix info on cells 
close all
for c_ind = 1:length(analysis_cell)
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

            fn = fullfile(genotypedir,['LF_', ... 
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
for c_ind = 1:length(analysis_cell)
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
            fn = fullfile(genotypedir,['LF_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoSineOsciRespVsFreq.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-l','-a1.4');
            end
        end
    end
end

%% Exporting CurrentStepFamMatrix info on cells 
close all
for c_ind = 1:length(analysis_cell)
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
            fn = fullfile(genotypedir,['LF_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'CurrentStepFamMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            end
        end
    end
end

%% Exporting PiezoStepMatrix info on cells 
close all
for c_ind = 1:length(analysis_cell)
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
            fn = fullfile(genotypedir,['LF_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoStepMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            end
        end
    end
end

%% Plot f2/f2 ratio for PiezoSine

