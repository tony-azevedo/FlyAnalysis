%% All Pairs
all_pairs = {
    '140311_F1_C1'
    '140403_F1_C1'
    '140717_F1_C1'
    '140419_F1_C1'
    '140421_F1_C1'
    '140422_F1_C1'
    '140423_F1_C1'
    '140424_F1_C1'
    '140424_F1_C2'
};
%% Documenting Patching Difficulties.
% I struggled here.  I did not start new cells when pathcing failed. listed
% below are cells where patching failed alltogeher
patching_failure = {
    '140313_F1_C1'
    '140407'
    '140308'
    '140409_F1_C1'
    '140415_F1_C1'
};


disp([length(patching_failure) ' cells']);

%% Cells To Exclude:
reject_cells(1).name = {
    '140311_F1_C1'};
reject_cells(1).reason = {
    'Single B1 neuron'
    };
reject_cells(1).exampletrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140311\140311_F1_C1\Sweep_Raw_140311_F1_C1_1.mat';
    };

reject_cells(2).name = {
    '140403_F1_C1'};
reject_cells(2).reason = {
    'single B1 cell';
    };
reject_cells(2).exampletrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140403\140403_F1_C1\Sweep_Raw_140403_F1_C1_1.mat';
    };

analysis_cell(3).name = {
    '140419_F1_C1'
    };
analysis_cell(3).comment = {
    'Bad access on the B1 cell.'
    };
analysis_cell(3).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140419\140419_F1_C1\CurrentSine_Raw_140419_F1_C1_106.mat';
    };
analysis_cell(3).evidencecalls = {...
    };

reject_cells(4).name = {
    '140421_F1_C1'};
reject_cells(4).reason = {
    'single B1 cell';
    };
reject_cells(4).exampletrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140421\140421_F1_C1\CurrentStep_Raw_140421_F1_C1_2.mat';
    };

reject_cells(4).name = {
    '140422_F1_C1'};
reject_cells(4).reason = {
    'single AVLP-PN cell';
    };
reject_cells(4).exampletrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140422\140422_F1_C1\CurrentStep_Raw_140422_F1_C1_3.mat';
    };

reject_cells(5).name = {
    '140423_F1_C1'};
reject_cells(5).reason = {
    'single B1 cell, not a lot going on';
    };
reject_cells(5).exampletrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140423\140423_F1_C1\CurrentStep_Raw_140423_F1_C1_35.mat';
    };


%% Cells to Analyze:
recorded_cells = {
    '140717_F1_C1'; 
    '140424_F1_C1'; 
    '140424_F1_C2';
};

analysis_cell(1).name = {
    '140717_F1_C1';
    };
analysis_cell(1).comment = {
    'Unconnected'
    };
analysis_cell(1).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140417\140417_F1_C1\CurrentStep_Raw_140417_F1_C1_24.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140417\140417_F1_C1\CurrentSine_Raw_140417_F1_C1_6.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140417\140417_F1_C1\CurrentStep_Raw_140417_F1_C1_82.mat';
    };
analysis_cell(1).evidencecalls = {
    'CurrentStepFamMatrix'
    'CurrentSineMatrix'
    };


analysis_cell(2).name = {
   '140424_F1_C1'};
analysis_cell(2).comment = {
    'Nice, but unconnected'
    };
analysis_cell(2).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140424\140424_F1_C1\CurrentSine_Raw_140424_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140424\140424_F1_C1\CurrentStep_Raw_140424_F1_C1_4.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140424\140424_F1_C1\CurrentStep_Raw_140424_F1_C1_22.mat';
};
analysis_cell(2).evidencecalls = {...
    'CurrentStepFamMatrix'
    'CurrentSineMatrix'
    };

analysis_cell(3).name = {
   '140424_F1_C2'};
analysis_cell(3).comment = {
    'Unconnected'
    };
analysis_cell(3).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140424\140424_F1_C2\CurrentStep_Raw_140424_F1_C2_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140424\140424_F1_C2\CurrentStep_Raw_140424_F1_C2_27.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140424\140424_F1_C2\CurrentSine_Raw_140424_F1_C2_1.mat';
};
analysis_cell(3).evidencecalls = {...
    'CurrentStepFamMatrix'
    'CurrentSineMatrix'
    };

%% Exporting dashboard info on each cell 1 (Sine Matrices, step matrices)
close all

for c_ind = 1
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
        obj.currentPrtcl
        prtclData = load(dfile);
        obj.prtclData = prtclData.data;
        obj.prtclTrialNums = obj.currentTrialNum;

        for e_ind = 1:length(analysis_cell(c_ind).evidencecalls)
            if ~isempty(strfind(analysis_cell(c_ind).evidencecalls{e_ind},obj.currentPrtcl))
                fprintf('%s([],obj,'''');\n',analysis_cell(c_ind).evidencecalls{e_ind});
                eval(sprintf('%s([],obj,'''');',analysis_cell(c_ind).evidencecalls{e_ind}));
            end
        end
    end
end

%figname
%eval(sprintf('export_fig C:\\Users\\Anthony'' Azevedo''\\Desktop\\Rachel'' Meeting''\\Figure_%d -pdf -transparent',numext));
%fprintf('** Figure_%d saved\n',numext);


%% Exporting dashboard info on each cell 2(Sine Matrices, step matrices)
close all
for c_ind = 2
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
        obj.currentPrtcl
        prtclData = load(dfile);
        obj.prtclData = prtclData.data;
        obj.prtclTrialNums = obj.currentTrialNum;

        for e_ind = 1:length(analysis_cell(c_ind).evidencecalls)
            if ~isempty(strfind(analysis_cell(c_ind).evidencecalls{e_ind},obj.currentPrtcl))
                fprintf('%s([],obj,'''');\n',analysis_cell(c_ind).evidencecalls{e_ind});
                eval(sprintf('%s([],obj,'''');',analysis_cell(c_ind).evidencecalls{e_ind}));
            end
        end
    end
end



%% Exporting dashboard info on each cell 3 (Sine Matrices, step matrices)
close all
for c_ind = 3:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
        obj.currentPrtcl
        prtclData = load(dfile);
        obj.prtclData = prtclData.data;
        obj.prtclTrialNums = obj.currentTrialNum;

        for e_ind = 1:length(analysis_cell(c_ind).evidencecalls)
            if ~isempty(strfind(analysis_cell(c_ind).evidencecalls{e_ind},obj.currentPrtcl))
                fprintf('%s([],obj,'''');\n',analysis_cell(c_ind).evidencecalls{e_ind});
                eval(sprintf('%s([],obj,'''');',analysis_cell(c_ind).evidencecalls{e_ind}));
            end
        end
    end
end



