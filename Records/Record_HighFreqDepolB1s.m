%% Record of High Frequency Responsive B1 cells
clear all

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_HighFrequencyB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1

% GH86

% VT30609
cnt = 1;
analysis_cell(cnt).name = {
    '140530_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F1_C1\PiezoChirp_Raw_140530_F1_C1_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F1_C1\PiezoStep_Raw_140530_F1_C1_33.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
''
};


cnt = 2;
analysis_cell(cnt).name = {
    '140530_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoChirp_Raw_140530_F2_C1_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoChirp_Raw_140530_F2_C1_10.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoChirp_Raw_140530_F2_C1_24.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoChirp_Raw_140530_F2_C1_6.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoSine_Raw_140530_F2_C1_6.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoSine_Raw_140530_F2_C1_88.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoSine_Raw_140530_F2_C1_270.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoStep_Raw_140530_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F2_C1\PiezoSine_Raw_140530_F2_C1_315.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140530\140530_F1_C1\PiezoChirp_Raw_140530_F1_C1_12.mat';
};
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));
analysis_cell(cnt).comment = {
''
};

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
            fn = fullfile(genotypedir,['HP_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
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
for c_ind = 1:length(analysis_cell)
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
            fn = fullfile(genotypedir,['HP_' dateID '_' flynum '_' cellnum '_' num2str(obj.trial.params.trialBlock) '_',...
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

            fn = fullfile(genotypedir,['HP_', ... 
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

