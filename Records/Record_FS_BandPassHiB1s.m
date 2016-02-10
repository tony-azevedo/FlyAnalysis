%% Record of Band Pass Hi Cells
clear analysis_cell analysis_cells c cnt id save_log example_cell analysis_grid
savedir = 'C:\Users\tony\Dropbox\RAnalysis_Data\Record_FS_BandPassHighB1s';
if ~isdir(savedir)
    mkdir(savedir)
end
save_log = 0;
id = 'BPH_';


%%

analysis_grid = {...
%     '131014_F4_C1'  'GH86-Gal4/GH86-Gal4;pJFRC7/pJFRC7;'	'clear spiking (sweep), but not great stimulus control'
%     '131014_F3_C1'  'GH86-Gal4/GH86-Gal4;pJFRC7/pJFRC7;'	'clear spiking, mid range frequency, holding potential is offset, but otherwise ok'
%     '131016_F1_C1'  'GH86-Gal4/GH86-Gal4;pJFRC7/pJFRC7;'	'Clear spiking, not good stimulus control! exclude from PiezoStepAnalysis'
    '131126_F2_C2'  'GH86-Gal4/GH86-Gal4;pJFRC7/pJFRC7;'	'Banner cell, Current Sine @ hyp. Vm, was used in NRSA-resubmit, sharp tuning though coarse'
    
    '150421_F1_C1'  '10XUAS-mCD8:GFP/+;FruGal4/+'      'Larger amplitudes produce lower amplitude responses'
    '150513_F2_C1'  '10XUAS-mCD8:GFP/+;FruGal4/+'      'PiezoChirp is an interesting stimulus, strong spontaneous noise'
%     '150527_F1_C3'  'pJFRC7/+;63A03-Gal4/+'    'Without perfusion, beautiful clear line, nice spiker, the somewhat dim one next to the big guy'
     '150528_F1_C1'  'pJFRC7/+;63A03-Gal4/+'       'Without perfusion, NO CLEAR SPIKING, but certainly band pass high'
    
    '150531_F1_C1'  '10XUAS-mCD8:GFP/+;FruGal4/+'     'Without perfusion, Very nice cell, tall spikes, also has hyperpolarized responses'
    '151125_F1_C1'  '10XUAS-mCD8:GFP/+;FruGal4/+'     'hyperpolarized responses'
    
    '151130_F1_C1'  'pJFRC7/+;VT30609/+'     'Lots of noise, appears to be due to antennal input, tall spikes, hyperpolarized responses didnt work'
    
    '151201_F1_C1'  '10XUAS-mCD8:GFP/+;FruGal4/+'     'Hyperpolarization responses didnt work'
    '151201_F1_C2'  '10XUAS-mCD8:GFP/+;FruGal4/+'     'Lots of noise, appears to be due to antennal input, tall spikes, hyperpolar responses didnt work'
    '151201_F1_C2_2'  '10XUAS-mCD8:GFP/+;FruGal4/+'     'This is the second set of responses in the other block'
    '151201_F1_C3'  '10XUAS-mCD8:GFP/+;FruGal4/+'     'Lots of noise, appears to be due to antennal input, tall spikes, hyperpolar responses didnt work'
    
    };

no_nerve_grid = {
        % No nerve
    '150722_F1_C2'  '10XUAS-mCD8:GFP;FruGal4'    'BPH. ZD does take out Ih. Only 2.5V'
    '150922_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH. Beautiful Cell in Fru Gal4, now need to switch the order of the drugs'
    '151001_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL.'
    '151001_F2_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPL.' % For this cell, the voltage changed during the curare, I've untagged the curare traces and excluded the cntrl trials
    '151021_F3_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH! Nice.'
    '151022_F1_C1'  '10XUAS-mCD8:GFP;FruGal4'    'BPH! Access drifts up.'
    };

male_grid = { ...
    '150602_F3_C1'  'ShakB2-y/X;pJFRC7;45D07'  'Without perfusion, Weird cell, a ton of spontaneous noise.  Where is this from?'  %Male
    };

clear analysis_cell analysis_cells control_cells control_cells
genotypes = {   '10XUAS-mCD8:GFP/+;FruGal4/+'                           '20XUAS-mCD8:GFP;VT27938-Gal4';
    'UAS-Dcr;10XUAS-mCD8:GFP/+;FruGal4/UAS-paraRNAi'        'UAS-Dcr;20XUAS-mCD8:GFP/+;VT27938-Gal4/UAS-paraRNAi'
    };

for c = 1:size(analysis_grid,1)
    analysis_cell(c).name = analysis_grid{c,1};
    analysis_cell(c).genotype = analysis_grid{c,2}; %#ok<*SAGROW>
    analysis_cell(c).comment = analysis_grid{c,3};
    analysis_cells{c} = analysis_grid{c,1};
end
fprintf('BandPass-Hi: \n')
fprintf('\t%s\n',analysis_cells{:})


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

%% Example cell 
example_cell.name = '151201_F1_C1';
example_cell.PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151201\151201_F1_C1\PiezoSine_Raw_151201_F1_C1_3.mat';
example_cell.CurrentStepTrial = ...
'';
example_cell.CurrentChirpTrial = ...
'';
example_cell.SweepTrial = ...
        'C:\Users\tony\Raw_Data\151201\151201_F1_C1\Sweep_Raw_151201_F1_C1_2.mat';

% other possibility
% example_cell.name = '151201_F1_C2';
% example_cell.PiezoSineTrial = ...
% 'C:\Users\tony\Raw_Data\151201\151201_F1_C2\PiezoSine_Raw_151201_F1_C2_112.mat';
% example_cell.CurrentStepTrial = ...
% '';
% example_cell.CurrentChirpTrial = ...
% '';
% example_cell.SweepTrial = ...
% '';

%% Figure 3 example

fig3example_cell0.name = '151201_F1_C1';
fig3example_cell0.PiezoStepTrialAnt = ...
'C:\Users\tony\Raw_Data\151201\151201_F1_C1\PiezoStep_Raw_151201_F1_C1_2.mat';
fig3example_cell0.PiezoStepTrialPost = ...
'C:\Users\tony\Raw_Data\151201\151201_F1_C1\PiezoStep_Raw_151201_F1_C1_7.mat';

fig3example_cell0.PiezoSine25 = ...
'C:\Users\tony\Raw_Data\151201\151201_F1_C1\PiezoSine_Raw_151201_F1_C1_7.mat';
fig3example_cell0.PiezoSine50 = ...
'C:\Users\tony\Raw_Data\151201\151201_F1_C1\PiezoSine_Raw_151201_F1_C1_15.mat';
fig3example_cell0.PiezoSine100 = ...
'C:\Users\tony\Raw_Data\151201\151201_F1_C1\PiezoSine_Raw_151201_F1_C1_23.mat';
fig3example_cell0.PiezoSine200 = ...
'C:\Users\tony\Raw_Data\151201\151201_F1_C1\PiezoSine_Raw_151201_F1_C1_31.mat';

fig3example_cell0.genotype = '10XUAS-mCD8:GFP/+;FruGal4/+'; %#ok<*SAGROW>


fig3example_cell180.name = '131126_F2_C2';
fig3example_cell180.PiezoStepTrialAnt = ...
'C:\Users\tony\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_7.mat';
fig3example_cell180.PiezoStepTrialPost = ...
'C:\Users\tony\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_6.mat';

fig3example_cell180.PiezoSine25 = ...
'C:\Users\tony\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_2.mat';
fig3example_cell180.PiezoSine50 = ...
'C:\Users\tony\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_5.mat';
fig3example_cell180.PiezoSine100 = ...
'C:\Users\tony\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_8.mat';
fig3example_cell180.PiezoSine200 = ...
'C:\Users\tony\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_11.mat';

fig3example_cell180.genotype = 'GH86-Gal4/GH86-Gal4;pJFRC7/pJFRC7;'; %#ok<*SAGROW>


%% GH86
cnt = find(strcmp(analysis_cells,'131014_F4_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\131014\131014_F4_C1\PiezoSine_Raw_131014_F4_C1_8.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        '';
    
    analysis_cell(cnt).extratrials = {...
        'C:\Users\tony\Raw_Data\131014\131014_F4_C1\PiezoStep_Raw_131014_F4_C1_1.mat';
        'C:\Users\tony\Raw_Data\131014\131014_F4_C1\Sweep_Raw_131014_F4_C1_21.mat'; % Before I actually got good at these
        };
end


%% C:\Users\tony\Dropbox\AzevedoWilson_B1_MS\Figure1\BPHPiezoSineResponseVsFrequencyCurves
cnt = find(strcmp(analysis_cells,'131014_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\131014\131014_F3_C1\PiezoSine_Raw_131014_F3_C1_8.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        '';
    analysis_cell(cnt).extratrials = {...
        'C:\Users\tony\Raw_Data\131014\131014_F3_C1\PiezoStep_Raw_131014_F3_C1_1.mat';
        'C:\Users\tony\Raw_Data\131014\131014_F3_C1\PiezoBWCourtshipSong_Raw_131014_F3_C1_1.mat';
        'C:\Users\tony\Raw_Data\131014\131014_F3_C1\PiezoCourtshipSong_Raw_131014_F3_C1_1.mat';
        'C:\Users\tony\Raw_Data\131014\131014_F3_C1\Sweep_Raw_131014_F3_C1_5.mat'; % Strangely high
        };
end

%%
cnt = find(strcmp(analysis_cells,'131016_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\131016\131016_F1_C1\PiezoSine_Raw_131016_F1_C1_17.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        '';
    analysis_cell(cnt).SpikeTrial = ...
        'C:\Users\tony\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_12.mat';
    
    analysis_cell(cnt).extratrials = {...
        'C:\Users\tony\Raw_Data\131016\131016_F1_C1\PiezoStep_Raw_131016_F1_C1_1.mat';
        'C:\Users\tony\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_1.mat'; % Strangely low
        };
end


%%
cnt = find(strcmp(analysis_cells,'131126_F2_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_7.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_4.mat';
    
    analysis_cell(cnt).extratrials = {...
        'C:\Users\tony\Raw_Data\131126\131126_F2_C2\CurrentStep_Raw_131126_F2_C2_20.mat'; % this is what a spiking cell looks like
        'C:\Users\tony\Raw_Data\131126\131126_F2_C2\PiezoStep_Raw_131126_F2_C2_1.mat';
        'C:\Users\tony\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_1.mat';  % hyperpolarized
        'C:\Users\tony\Raw_Data\131126\131126_F2_C2\CurrentSine_Raw_131126_F2_C2_29.mat'; % resting
        'C:\Users\tony\Raw_Data\131126\131126_F2_C2\CurrentStep_Raw_131126_F2_C2_22.mat'; % hyperpolarized
        'C:\Users\tony\Raw_Data\131126\131126_F2_C2\Sweep_Raw_131126_F2_C2_11.mat';
        };
end

%%
cnt = find(strcmp(analysis_cells,'150421_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150421\150421_F1_C1\PiezoSine_Raw_150421_F1_C1_16.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
        'C:\Users\tony\Raw_Data\150421\150421_F1_C1\PiezoChirp_Raw_150421_F1_C1_2.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150421\150421_F1_C1\CurrentStep_Raw_150421_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150421\150421_F1_C1\CurrentChirp_Raw_150421_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150421\150421_F1_C1\Sweep_Raw_150421_F1_C1_3.mat';
    analysis_cell(cnt).SweepVClampEx = ...
        'C:\Users\tony\Raw_Data\150513\150513_F2_C1\Sweep_Raw_150513_F2_C1_2.mat';
    analysis_cell(cnt).VoltageStepEx = ...
        'C:\Users\tony\Raw_Data\150513\150513_F2_C1\VoltageStep_Raw_150513_F2_C1_3.mat';
end

%%
cnt = find(strcmp(analysis_cells,'150513_F2_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\150513\150513_F2_C1\PiezoSine_Raw_150513_F2_C1_17.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
        'C:\Users\tony\Raw_Data\150513\150513_F2_C1\PiezoChirp_Raw_150513_F2_C1_2.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150513\150513_F2_C1\CurrentStep_Raw_150513_F2_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150513\150513_F2_C1\CurrentChirp_Raw_150513_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150513\150513_F2_C1\Sweep_Raw_150513_F2_C1_5.mat';
    analysis_cell(cnt).SweepVClampEx = ...
        'C:\Users\tony\Raw_Data\150513\150513_F2_C1\Sweep_Raw_150513_F2_C1_2.mat';
    analysis_cell(cnt).VoltageStepEx = ...
        'C:\Users\tony\Raw_Data\150513\150513_F2_C1\VoltageStep_Raw_150513_F2_C1_3.mat';
    
    
    analysis_cell(cnt).extratrials = {...
        };
end

%% Not very strong responses to the PiezoSines
cnt = find(strcmp(analysis_cells,'150527_F1_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\150527\150527_F1_C3\PiezoSine_Raw_150527_F1_C3_17.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
        'C:\Users\tony\Raw_Data\150527\150527_F1_C3\PiezoChirp_Raw_150527_F1_C3_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150527\150527_F1_C3\CurrentChirp_Raw_150527_F1_C3_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150527\150527_F1_C3\Sweep_Raw_150527_F1_C3_7.mat';
    analysis_cell(cnt).SweepVClampEx = ...
        'C:\Users\tony\Raw_Data\150527\150527_F1_C3\Sweep_Raw_150527_F1_C3_9.mat';
    analysis_cell(cnt).VoltageStepEx = ...
        'C:\Users\tony\Raw_Data\150527\150527_F1_C3\VoltageStep_Raw_150527_F1_C3_1.mat';
    
    analysis_cell(cnt).extratrials = {...
        };
end

%%
cnt = find(strcmp(analysis_cells,'150528_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\150528\150528_F1_C1\PiezoSine_Raw_150528_F1_C1_17.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
        'C:\Users\tony\Raw_Data\150528\150528_F1_C1\PiezoChirp_Raw_150528_F1_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150528\150528_F1_C1\CurrentStep_Raw_150528_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150528\150528_F1_C1\CurrentChirp_Raw_150528_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150528\150528_F1_C1\Sweep_Raw_150528_F1_C1_56.mat';
    analysis_cell(cnt).SweepVClampEx = ...
        'C:\Users\tony\Raw_Data\150528\150528_F1_C1\Sweep_Raw_150528_F1_C1_55.mat';
    analysis_cell(cnt).VoltageStepEx = ...
        'C:\Users\tony\Raw_Data\150528\150528_F1_C1\VoltageStep_Raw_150528_F1_C1_1.mat';
    
    analysis_cell(cnt).extratrials = {...
        };
end

%%
cnt = find(strcmp(analysis_cells,'150531_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\150531\150531_F1_C1\PiezoSine_Raw_150531_F1_C1_17.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
        '';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150531\150531_F1_C1\CurrentStep_Raw_150531_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150531\150531_F1_C1\CurrentChirp_Raw_150531_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150531\150531_F1_C1\Sweep_Raw_150531_F1_C1_39.mat';
    analysis_cell(cnt).SweepVClampEx = ...
        '';
    analysis_cell(cnt).VoltageStepEx = ...
        'C:\Users\tony\Raw_Data\150531\150531_F1_C1\VoltageStep_Raw_150531_F1_C1_8.mat';
    
    analysis_cell(cnt).extratrials = {...
        };
end

%% Tons of spontaneous noise MALE!!

cnt = find(strcmp(analysis_cells,'150602_F3_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\150602\150602_F3_C1\PiezoSine_Raw_150602_F3_C1_17.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
        'C:\Users\tony\Raw_Data\150602\150602_F3_C1\PiezoChirp_Raw_150602_F3_C1_1.mat';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\150602\150602_F3_C1\CurrentStep_Raw_150602_F3_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        'C:\Users\tony\Raw_Data\150602\150602_F3_C1\CurrentChirp_Raw_150602_F3_C1_2.mat';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\150602\150602_F3_C1\Sweep_Raw_150602_F3_C1_4.mat';
    analysis_cell(cnt).SweepVClampEx = ...
        'C:\Users\tony\Raw_Data\150602\150602_F3_C1\Sweep_Raw_150602_F3_C1_3.mat';
    analysis_cell(cnt).VoltageStepEx = ...
        'C:\Users\tony\Raw_Data\150602\150602_F3_C1\VoltageStep_Raw_150602_F3_C1_1.mat';
    
    analysis_cell(cnt).extratrials = {...
        };
end


%%
cnt = find(strcmp(analysis_cells,'151125_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\151125\151125_F1_C1\PiezoSine_Raw_151125_F1_C1_23.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
        '';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\151125\151125_F1_C1\Sweep_Raw_151125_F1_C1_6.mat';
    analysis_cell(cnt).SweepVClampEx = ...
        '';
    analysis_cell(cnt).VoltageStepEx = ...
        '';
    
    analysis_cell(cnt).extratrials = {...
        };
end

%%
cnt = find(strcmp(analysis_cells,'151130_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151130\151130_F1_C1\PiezoSine_Raw_151130_F1_C1_155.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
        '';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151130\151130_F1_C1\PiezoStep_Raw_151130_F1_C1_2.mat';
    analysis_cell(cnt).SweepVClampEx = ...
        '';
    analysis_cell(cnt).VoltageStepEx = ...
        '';
    
    analysis_cell(cnt).extratrials = {...
        };
end

%% '10XUAS-mCD8:GFP/+;FruGal4/+'
cnt = find(strcmp(analysis_cells,'151201_F1_C1'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\151201\151201_F1_C1\PiezoSine_Raw_151201_F1_C1_23.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
        '';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\151201\151201_F1_C1\CurrentStep_Raw_151201_F1_C1_1.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\151201\151201_F1_C1\Sweep_Raw_151201_F1_C1_2.mat';
    analysis_cell(cnt).SweepVClampEx = ...
        '';
    analysis_cell(cnt).VoltageStepEx = ...
        'C:\Users\tony\Raw_Data\151201\151201_F1_C1\VoltageStep_Raw_151201_F1_C1_1.mat';
    
    analysis_cell(cnt).extratrials = {...
        };
end

%% '10XUAS-mCD8:GFP/+;FruGal4/+'
cnt = find(strcmp(analysis_cells,'151201_F1_C2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151201\151201_F1_C2\PiezoSine_Raw_151201_F1_C2_122.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
        '';
    analysis_cell(cnt).CurrentStepTrial = ...
        'C:\Users\tony\Raw_Data\151201\151201_F1_C2\CurrentStep_Raw_151201_F1_C2_5.mat';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\151201\151201_F1_C2\Sweep_Raw_151201_F1_C2_3.mat';
    analysis_cell(cnt).SweepVClampEx = ...
        '';
    analysis_cell(cnt).VoltageStepEx = ...
        'C:\Users\tony\Raw_Data\151201\151201_F1_C2\VoltageStep_Raw_151201_F1_C2_1.mat';
    
    analysis_cell(cnt).extratrials = {...
        };
end

%% '10XUAS-mCD8:GFP/+;FruGal4/+'
cnt = find(strcmp(analysis_cells,'151201_F1_C2_2'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
        'C:\Users\tony\Raw_Data\151201\151201_F1_C2\PiezoSine_Raw_151201_F1_C2_12.mat';
end

%% '10XUAS-mCD8:GFP/+;FruGal4/+'
cnt = find(strcmp(analysis_cells,'151201_F1_C3'));
if ~isempty(cnt)
    analysis_cell(cnt).PiezoSineTrial = ...
'C:\Users\tony\Raw_Data\151201\151201_F1_C3\PiezoSine_Raw_151201_F1_C3_23.mat';
    analysis_cell(cnt).PiezoChirpTrial = ...
        '';
    analysis_cell(cnt).CurrentStepTrial = ...
        '';
    analysis_cell(cnt).CurrentChirpTrial = ...
        '';
    analysis_cell(cnt).SweepTrial = ...
        'C:\Users\tony\Raw_Data\151201\151201_F1_C3\Sweep_Raw_151201_F1_C3_3.mat';
    analysis_cell(cnt).SweepVClampEx = ...
        '';
    analysis_cell(cnt).VoltageStepEx = ...
        'C:\Users\tony\Raw_Data\151201\151201_F1_C3\VoltageStep_Raw_151201_F1_C3_1.mat';
    
    analysis_cell(cnt).extratrials = {...
        };
end

%% No Nerve

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150722_F1_C2'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\150722\150722_F1_C2\VoltageCommand_Raw_150722_F1_C2_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\150722\150722_F1_C2\Sweep_Raw_150722_F1_C2_3.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPL_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP' 'TEA' 'Cd'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'150922_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\150922\150922_F2_C1\VoltageCommand_Raw_150922_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\150922\150922_F2_C1\Sweep_Raw_150922_F2_C1_5.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'MLA' '4AP' 'TEA' 'TTX' 'ZD' };
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151001_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151001\151001_F1_C1\VoltageCommand_Raw_151001_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151001\151001_F1_C1\Sweep_Raw_151001_F1_C1_5.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151001_F2_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151001\151001_F2_C1\VoltageCommand_Raw_151001_F2_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151001\151001_F2_C1\Sweep_Raw_151001_F2_C1_3.mat';
    analysis_cell(cnt).stem = 'SineResponse_BPH_100Hz_0_5V_3X';
    analysis_cell(cnt).drugs = {'' 'curare' '4AP' 'TEA' 'TTX' 'ZD'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151021_F3_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151021\151021_F3_C1\VoltageCommand_Raw_151021_F3_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151021\151021_F3_C1\Sweep_Raw_151021_F3_C1_5.mat';
    analysis_cell(cnt).drugs = {'' 'TTX' '4AP TEA'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151022_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
        'C:\Users\tony\Raw_Data\151022\151022_F1_C1\VoltageCommand_Raw_151022_F1_C1_1.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151022\151022_F1_C1\Sweep_Raw_151022_F1_C1_3.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP TEA' 'Cd'};
end

%% 10XUAS-mCD8:GFP/+;FruGal4/+
cnt = find(strcmp(analysis_cells,'151117_F1_C1'));

if ~isempty(cnt)
    analysis_cell(cnt).trials.VoltageCommand = ...
'C:\Users\tony\Raw_Data\151117\151117_F1_C1\VoltageCommand_Raw_151117_F1_C1_2.mat';
    analysis_cell(cnt).SweepTrial = ...
'C:\Users\tony\Raw_Data\151117\151117_F1_C1\Sweep_Raw_151117_F1_C1_4.mat';
    analysis_cell(cnt).drugs = {'' 'curare' 'TTX' '4AP' 'TEA'};
end

%%
%Script_FrequencySelectivity

