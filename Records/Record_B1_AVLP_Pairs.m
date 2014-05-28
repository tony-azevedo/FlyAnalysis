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
    '140428_F1_C1'
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

reject_cells(6).name = {
    '140506_F1_C1'};
reject_cells(6).reason = {
    'single B1 cell, lost AVLP neuron upon starting the trials';
    };
reject_cells(6).exampletrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140506\140506_F1_C1\CurrentSine_Raw_140506_F1_C1_7.mat';
    };

reject_cells(7).name = {
    '140506_F1_C1'};
reject_cells(7).reason = {
    'single B1 cell, random neuron (not green) in the AVLP cluster.  B1 cell did not spike!';
    };
reject_cells(7).exampletrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140506\140506_F1_C1\CurrentSine_Raw_140506_F1_C1_7.mat';
    };

reject_cells(8).name = {
    '140512_F1_C1'};
reject_cells(8).reason = {
    'single B1 cell, spiking, could not get AVLP neurons!';
    };
reject_cells(8).exampletrial = {
'C:\Users\Anthony Azevedo\Raw_Data\140512\140512_F1_C1\CurrentStep_Raw_140512_F1_C1_4.mat';
    };

%% Cells to Analyze:
savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_Pairs';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1

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
    'C:\Users\Anthony Azevedo\Raw_Data\140417\140417_F1_C1\CurrentSine_Raw_140417_F1_C1_6.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140417\140417_F1_C1\CurrentStep_Raw_140417_F1_C1_24.mat';
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
'C:\Users\Anthony Azevedo\Raw_Data\140424\140424_F1_C2\CurrentSine_Raw_140424_F1_C2_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140424\140424_F1_C2\CurrentStep_Raw_140424_F1_C2_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140424\140424_F1_C2\CurrentStep_Raw_140424_F1_C2_27.mat';
};
analysis_cell(3).evidencecalls = {...
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

analysis_cell(4).name = {
   '140428_F1_C1'};
analysis_cell(4).comment = {
    'Unconnected, lost the B1 neuron after sine injections'
    };
analysis_cell(4).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140428\140428_F1_C1\CurrentSine_Raw_140428_F1_C1_67.mat';
};
analysis_cell(4).evidencecalls = {...
    'CurrentSineMatrix'
    };

analysis_cell(4).name = {
   '140428_F1_C1'};
analysis_cell(4).comment = {
    'Unconnected, lost the B1 neuron after sine injections'
    };
analysis_cell(4).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140428\140428_F1_C1\CurrentSine_Raw_140428_F1_C1_67.mat';
};
analysis_cell(4).evidencecalls = {...
    'CurrentSineMatrix'
    };

analysis_cell(5).name = {
   '140506_F2_C1'};
analysis_cell(5).comment = {
    'Unconnected, spiking B1 neuron, lost the AVLP neuron after sine injection'
    };
analysis_cell(5).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140506\140506_F2_C1\CurrentSine_Raw_140506_F2_C1_18.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140506\140506_F2_C1\CurrentStep_Raw_140506_F2_C1_1.mat';
};
analysis_cell(5).evidencecalls = {...
    'CurrentSineMatrix'
    'CurrentStepFamMatrix'
    };

% Use this one as a comparison with the spiking kind
analysis_cell(6).name = {
   '140508_F1_C1'};
analysis_cell(6).comment = {
    'Unconnected, non-spiking B1 neuron, lost AVLP at the Step injections'
    };
analysis_cell(6).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140508\140508_F1_C1\CurrentSine_Raw_140508_F1_C1_15.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140508\140508_F1_C1\CurrentStep_Raw_140508_F1_C1_3.mat';
};
analysis_cell(6).evidencecalls = {...
    'CurrentSineMatrix'
    'CurrentStepFamMatrix'
    };

analysis_cell(7).name = {
   '140508_F1_C2'};
analysis_cell(7).comment = {
    'Unconnected, spiking B1 neuron, crazy B1'
    };
analysis_cell(7).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140508\140508_F1_C2\CurrentSine_Raw_140508_F1_C2_14.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140508\140508_F1_C2\CurrentSine_Raw_140508_F1_C2_57.mat';  % Hyperpolarized
'C:\Users\Anthony Azevedo\Raw_Data\140508\140508_F1_C2\CurrentStep_Raw_140508_F1_C2_60.mat';  % a little confusing, looks like the non-spiking kind, but spikes in earlier records.  The spiking is unstable
};
analysis_cell(7).evidencecalls = {...
    'CurrentSineMatrix'
    'CurrentStepFamMatrix'
    };

analysis_cell(8).name = {
   '140508_F2_C1'};
analysis_cell(8).comment = {
    'Not very good recording, unconnected'
    };
analysis_cell(7).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140508\140508_F2_C1\CurrentSine_Raw_140508_F2_C1_18.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140508\140508_F2_C1\CurrentStep_Raw_140508_F2_C1_1.mat';
};
analysis_cell(8).evidencecalls = {...
    'CurrentSineMatrix'
    'CurrentStepFamMatrix'
    };

analysis_cell(9).name = {
   '140509_F1_C1'};
analysis_cell(9).comment = {
    'unconnected, non-spiking.  Not a typical B1 neuron'
    };
analysis_cell(9).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140509\140509_F1_C1\CurrentStep_Raw_140509_F1_C1_40.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140509\140509_F1_C1\CurrentSine_Raw_140509_F1_C1_1.mat';
};
analysis_cell(9).evidencecalls = {...
    'CurrentSineMatrix'
    'CurrentStepFamMatrix'
    };

% Use this one (all of fly 3) as a comparison with the non spiking kind
analysis_cell(10).name = {
   '140509_F3_C1'};
analysis_cell(10).comment = {
    'unconnected.  typical B1 neuron'
    };
analysis_cell(10).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140509\140509_F3_C1\CurrentSine_Raw_140509_F3_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140509\140509_F3_C1\CurrentStep_Raw_140509_F3_C1_1.mat';
};
analysis_cell(10).evidencecalls = {...
    'CurrentSineMatrix'
    'CurrentStepFamMatrix'
    };

analysis_cell(11).name = {
   '140509_F3_C2'};
analysis_cell(11).comment = {
    'typical B1 neuron, same as C1'
    };
analysis_cell(11).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140509\140509_F3_C2\CurrentSine_Raw_140509_F3_C2_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140509\140509_F3_C2\CurrentStep_Raw_140509_F3_C2_20.mat';
};
analysis_cell(11).evidencecalls = {...
    'CurrentSineMatrix'
    'CurrentStepFamMatrix'
    };

analysis_cell(12).name = {
   '140509_F3_C3'};
analysis_cell(12).comment = {
    'unconnected.  typical B1 neuron, same as C1'
    };
analysis_cell(12).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140509\140509_F3_C3\CurrentSine_Raw_140509_F3_C3_11.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140509\140509_F3_C3\CurrentStep_Raw_140509_F3_C3_1.mat';
};
analysis_cell(12).evidencecalls = {...
    'CurrentSineMatrix'
    'CurrentStepFamMatrix'
    };

analysis_cell(13).name = {
   '140512_F2_C1'};
analysis_cell(13).comment = {
    'unconnected.  not a real solid AVLP recording, weird B1 neuron.  I think I fucked it up with large hyperpolarizing current'
    };
analysis_cell(13).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140512\140512_F2_C1\CurrentSine_Raw_140512_F2_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140512\140512_F2_C1\CurrentStep_Raw_140512_F2_C1_1.mat';
};
analysis_cell(13).evidencecalls = {...
    'CurrentSineMatrix'
    'CurrentStepFamMatrix'
    };

analysis_cell(14).name = {
   '140512_F3_C1'};
analysis_cell(14).comment = {
    'unconnected.  typical B1 neuron, hyperpolarized the wrong cell because Multiclamp control changed while queriying the sate of the amplifier'
    };
analysis_cell(14).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140512\140512_F3_C1\CurrentSine_Raw_140512_F3_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140512\140512_F3_C1\CurrentStep_Raw_140512_F3_C1_16.mat';
};
analysis_cell(14).evidencecalls = {...
    'CurrentSineMatrix'
    'CurrentStepFamMatrix'
    };


%% Exporting dashboard info on cells 1:14 (Sine Matrices, step matrices)
close all
for c_ind = 1:length(analysis_cell)
    for t_ind = 1:length(analysis_cell(c_ind).exampletrials)
        trial = load(analysis_cell(c_ind).exampletrials{t_ind});
        obj.trial = trial;
        
        [obj.currentPrtcl,~,~,~,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = extractRawIdentifiers(trial.name);
        
        prtclData = load(dfile);
        obj.prtclData = prtclData.data;
        obj.prtclTrialNums = obj.currentTrialNum;

        for e_ind = 1:length(analysis_cell(c_ind).evidencecalls)
            % run analyses to go along with the trial
            if ~isempty(strfind(analysis_cell(c_ind).evidencecalls{e_ind},obj.currentPrtcl))
                fprintf('p = %s([],obj,'''');\n',analysis_cell(c_ind).evidencecalls{e_ind});
                eval(sprintf('f = %s([],obj,'''');',analysis_cell(c_ind).evidencecalls{e_ind}));
                for f_ind = 1:length(f)
                    p = panel.recover(f(f_ind));
                    fn = fullfile(savedir,['Pairs_' regexprep(obj.trialStem,'_%d.mat',['_',num2str(f_ind)]) '.pdf']);
                    p.export(fn, '-rp');
                end
            end
        end
    end
end

%%