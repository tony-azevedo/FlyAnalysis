%% Record of Band Pass Hi Cells
clear all
savedir = 'C:\Users\Anthony Azevedo\Dropbox\RAnalysis_Data\Record_FS_BandPassHighB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 1
id = 'BPH_';


%%

analysis_cells = {...
'131014_F4_C1'
'131014_F3_C1'
'131016_F1_C1'
'131126_F2_C2'

'150421_F1_C1'
'150513_F2_C1'
'150527_F1_C3'
'150528_F1_C1'

'150531_F1_C1'
'150602_F3_C1'
};

analysis_cells_comment = {...
    'clear spiking (sweep), but not great stimulus control';
    'clear spiking, mid range frequency, holding potential is offset, but otherwise ok';
    'Clear spiking, not good stimulus control! exclude from PiezoStepAnalysis';
    'Banner cell, Current Sine @ hyp. Vm, was used in NRSA-resubmit, sharp tuning though coarse';

    'Larger amplitudes produce lower amplitude responses'
    'PiezoChirp is an interesting stimulus, strong spontaneous noise'
    'Without perfusion, beautiful clear line, nice spiker, the somewhat dim one next to the big guy'
    'Without perfusion, NO CLEAR SPIKING, but certainly band pass high'
    
    'Without perfusion, Very nice cell, tall spikes, also has hyperpolarized responses'
    'Without perfusion, Weird cell, a ton of spontaneous noise.  Where is this from?'
};

analysis_cells_genotype = {...
'GH86-Gal4!GH86-Gal4;pJFRC7!pJFRC7;'
'GH86-Gal4!GH86-Gal4;pJFRC7!pJFRC7;'
'GH86-Gal4!GH86-Gal4;pJFRC7!pJFRC7;'
'GH86-Gal4!GH86-Gal4;pJFRC7!pJFRC7;'

'10XUAS-GFP;Fru-Gal4';
'10XUAS-GFP;Fru-Gal4';
'pJFRC7/+;63A03-Gal4/+';
'pJFRC7/+;63A03-Gal4/+';

'10XUAS-GFP;Fru-Gal4';
'pJFRC7/Cy0;45D07-Gal4/TM6b';  %Male
};


clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c); 
    analysis_cell(c).genotype = analysis_cells_genotype(c); %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%% Rejects

% '140602_F1_C1'
% Cells that possibly should be excluded

exclude_cells = {
    '140311_F1_C1',  'From paired recording, no Piezosine data'
    '140121_F2_C1',  'Arclight, great cell for that, no Piezosine data, no obvious spikes'
    '140117_F2_C1',  'Not great PiezoSine data.  This should probably be put in the BP set'
    '131122_F3_C1',  ' No Data...'
    '131119_F2_C2',  ' No Data. Interesting current sign, though'
    '131015_F1_C1',  ' No Piezo connection (no responses). Interesting current sign, though, beautiful spiking!'
    };


%% 'Genotype'
% 
% cnt = find(strcmp(analysis_cells,''));

%%


%% GH86
cnt = find(strcmp(analysis_cells,'131014_F4_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F4_C1\PiezoSine_Raw_131014_F4_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F4_C1\Sweep_Raw_131014_F4_C1_21.mat';

analysis_cell(cnt).extratrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F4_C1\PiezoStep_Raw_131014_F4_C1_1.mat';
};


%%
cnt = find(strcmp(analysis_cells,'131014_F3_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\PiezoSine_Raw_131014_F3_C1_4.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\Sweep_Raw_131014_F3_C1_5.mat';

analysis_cell(cnt).extratrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\PiezoStep_Raw_131014_F3_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\PiezoBWCourtshipSong_Raw_131014_F3_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\PiezoCourtshipSong_Raw_131014_F3_C1_1.mat';
};

%%
cnt = find(strcmp(analysis_cells,'131016_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\PiezoSine_Raw_131016_F1_C1_10.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_12.mat';

analysis_cell(cnt).extratrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\PiezoStep_Raw_131016_F1_C1_1.mat';
};


%%
cnt = find(strcmp(analysis_cells,'131126_F2_C2'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_4.mat';

analysis_cell(cnt).extratrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentStep_Raw_131126_F2_C2_20.mat'; % this is what a spiking cell looks like
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_1.mat';  % hyperpolarized
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_29.mat'; % resting
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\CurrentStep_Raw_131126_F2_C2_22.mat'; % hyperpolarized
'C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_11.mat';
};

%%
cnt = find(strcmp(analysis_cells,'150421_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150421\150421_F1_C1\PiezoSine_Raw_150421_F1_C1_1.mat';
analysis_cell(cnt).PiezoChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150421\150421_F1_C1\PiezoChirp_Raw_150421_F1_C1_2.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150421\150421_F1_C1\CurrentStep_Raw_150421_F1_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150421\150421_F1_C1\CurrentChirp_Raw_150421_F1_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150421\150421_F1_C1\Sweep_Raw_150421_F1_C1_3.mat';
analysis_cell(cnt).SweepVClampEx = ...
'C:\Users\Anthony Azevedo\Raw_Data\150513\150513_F2_C1\Sweep_Raw_150513_F2_C1_2.mat';
analysis_cell(cnt).VoltageStepEx = ...
'C:\Users\Anthony Azevedo\Raw_Data\150513\150513_F2_C1\VoltageStep_Raw_150513_F2_C1_3.mat';

%%
cnt = find(strcmp(analysis_cells,'150513_F2_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150513\150513_F2_C1\PiezoSine_Raw_150513_F2_C1_1.mat';
analysis_cell(cnt).PiezoChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150513\150513_F2_C1\PiezoChirp_Raw_150513_F2_C1_2.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150513\150513_F2_C1\CurrentStep_Raw_150513_F2_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150513\150513_F2_C1\CurrentChirp_Raw_150513_F2_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150513\150513_F2_C1\Sweep_Raw_150513_F2_C1_5.mat';
analysis_cell(cnt).SweepVClampEx = ...
'C:\Users\Anthony Azevedo\Raw_Data\150513\150513_F2_C1\Sweep_Raw_150513_F2_C1_2.mat';
analysis_cell(cnt).VoltageStepEx = ...
'C:\Users\Anthony Azevedo\Raw_Data\150513\150513_F2_C1\VoltageStep_Raw_150513_F2_C1_3.mat';


analysis_cell(cnt).extratrials = {...
};

%% Not very strong responses to the PiezoSines
cnt = find(strcmp(analysis_cells,'150527_F1_C3'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150527\150527_F1_C3\PiezoSine_Raw_150527_F1_C3_1.mat';
analysis_cell(cnt).PiezoChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150527\150527_F1_C3\PiezoChirp_Raw_150527_F1_C3_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150527\150527_F1_C3\CurrentChirp_Raw_150527_F1_C3_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150527\150527_F1_C3\Sweep_Raw_150527_F1_C3_7.mat';
analysis_cell(cnt).SweepVClampEx = ...
'C:\Users\Anthony Azevedo\Raw_Data\150527\150527_F1_C3\Sweep_Raw_150527_F1_C3_9.mat';
analysis_cell(cnt).VoltageStepEx = ...
'C:\Users\Anthony Azevedo\Raw_Data\150527\150527_F1_C3\VoltageStep_Raw_150527_F1_C3_1.mat';

analysis_cell(cnt).extratrials = {...
};

%%
cnt = find(strcmp(analysis_cells,'150528_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150528\150528_F1_C1\PiezoSine_Raw_150528_F1_C1_1.mat';
analysis_cell(cnt).PiezoChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150528\150528_F1_C1\PiezoChirp_Raw_150528_F1_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150528\150528_F1_C1\CurrentStep_Raw_150528_F1_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150528\150528_F1_C1\CurrentChirp_Raw_150528_F1_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150528\150528_F1_C1\Sweep_Raw_150528_F1_C1_56.mat';
analysis_cell(cnt).SweepVClampEx = ...
'C:\Users\Anthony Azevedo\Raw_Data\150528\150528_F1_C1\Sweep_Raw_150528_F1_C1_55.mat';
analysis_cell(cnt).VoltageStepEx = ...
'C:\Users\Anthony Azevedo\Raw_Data\150528\150528_F1_C1\VoltageStep_Raw_150528_F1_C1_1.mat';

analysis_cell(cnt).extratrials = {...
};

%%
cnt = find(strcmp(analysis_cells,'150531_F1_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150531\150531_F1_C1\PiezoSine_Raw_150531_F1_C1_1.mat';
analysis_cell(cnt).PiezoChirpTrial = ...
'';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150531\150531_F1_C1\CurrentStep_Raw_150531_F1_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150531\150531_F1_C1\CurrentChirp_Raw_150531_F1_C1_1.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150531\150531_F1_C1\Sweep_Raw_150531_F1_C1_39.mat';
analysis_cell(cnt).SweepVClampEx = ...
'';
analysis_cell(cnt).VoltageStepEx = ...
'C:\Users\Anthony Azevedo\Raw_Data\150531\150531_F1_C1\VoltageStep_Raw_150531_F1_C1_8.mat';

analysis_cell(cnt).extratrials = {...
};

%% Tons of spontaneous noise MALE!!
cnt = find(strcmp(analysis_cells,'150602_F3_C1'));
analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C1\PiezoSine_Raw_150602_F3_C1_1.mat';
analysis_cell(cnt).PiezoChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C1\PiezoChirp_Raw_150602_F3_C1_1.mat';
analysis_cell(cnt).CurrentStepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C1\CurrentStep_Raw_150602_F3_C1_1.mat';
analysis_cell(cnt).CurrentChirpTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C1\CurrentChirp_Raw_150602_F3_C1_2.mat';
analysis_cell(cnt).SweepTrial = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C1\Sweep_Raw_150602_F3_C1_4.mat';
analysis_cell(cnt).SweepVClampEx = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C1\Sweep_Raw_150602_F3_C1_3.mat';
analysis_cell(cnt).VoltageStepEx = ...
'C:\Users\Anthony Azevedo\Raw_Data\150602\150602_F3_C1\VoltageStep_Raw_150602_F3_C1_1.mat';

analysis_cell(cnt).extratrials = {...
};


%%
%Script_FrequencySelectivity

