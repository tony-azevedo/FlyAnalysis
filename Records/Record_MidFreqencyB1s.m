%% Record of Low Frequency Responsive Cells

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_MidFrequencyB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1

%% Possible cells
% 131217_F2_C1 ?????????

%%
% VT30609
cnt = 1;
analysis_cell(cnt).name = {
    '131126_F2_C3';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\PiezoSine_Raw_131126_F2_C3_4.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\PiezoStep_Raw_131126_F2_C3_18.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\CurrentStep_Raw_131126_F2_C3_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\CurrentStep_Raw_131126_F2_C3_27.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C3\CurrentSine_Raw_131126_F2_C3_11.mat';
};
analysis_cell(cnt).evidencecalls = {...
    'CurrentStepFamMatrix'
    'PiezoSineMatrix'
    'PiezoSineOsciRespVsFreq'
    'PiezoStepMatrix'
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'band pass, high left side (50 Hz), peak at 100, slow steps';
    };

cnt = 2;
analysis_cell(cnt).name = {
    '131126_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C1\CurrentStep_Raw_131126_F2_C1_4.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C1\PiezoSine_Raw_131126_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C1\PiezoStep_Raw_131126_F2_C1_34.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'band pass, low left side, slight peak following hyperpolarizing current injection';
    };

cnt = 3;
analysis_cell(cnt).name = {
    '131122_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoSine_Raw_131122_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoStep_Raw_131122_F2_C1_1.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
    'No clear evidence of non-spiking';
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

            fn = fullfile(genotypedir,['BP_', ... 
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
            fn = fullfile(genotypedir,['BP_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
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
            fn = fullfile(genotypedir,['BP_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
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
            fn = fullfile(genotypedir,['BP_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
                'PiezoStepMatrix.pdf']);
            p.fontname = 'Arial';
            p.export(fn, '-rp','-a1');
            
            f2 = findobj(0,'tag','PiezoStepMatrixStimuli');
            f2 = f2(1);
            p = panel.recover(f2);
            p.fontname = 'Arial';
            fn = regexprep(fn,'PiezoSineMatrix','PiezoSineMat_Stim');
            p.export(fn, '-rp','-l');

            end
        end
    end
end

%% Plot f2/f2 ratio for PiezoSine

