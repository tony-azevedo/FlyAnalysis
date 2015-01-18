% Analysis Record for In Vivo Calcium imaging with antennal stimulation
savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_GCaMP6s_Imaging';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1

%% GCaMP6s cells all
'150107_F1_C1'
'150106_F1_C1'
'141211_F3_C1'
'141211_F1_C1'
'141211_F2_C1'
'141210_F3_C1'
'141210_F2_C1'
'141210_F1_C1'
'141201_F1_C1'
'141125_F1_C1'
'141124_F1_C1'
'141123_F1_C1'
'141123_F2_C1'
'141120_F1_C1'
'141119_F1_C1'
'141118_F1_C1'
'141029_F2_C1'
'141029_F1_C1'
'141028_F2_C1'
'141028_F1_C1'
'141027_F1_C1'
'141027_F2_C1'
'141025_F1_C1'

%% Checklist
'141211_F2_C1'
'141211_F1_C1'
'141210_F3_C1'
'141210_F2_C1'
'141210_F1_C1'
'141201_F1_C1'
'141125_F1_C1'
'141124_F1_C1'
'141123_F1_C1'
'141123_F2_C1'
'141120_F1_C1'
'141119_F1_C1'
'141118_F1_C1'
'141029_F2_C1'
'141029_F1_C1'
'141028_F2_C1'
'141028_F1_C1'
'141027_F1_C1'
'141027_F2_C1'
'141025_F1_C1'


%% Rejected
reject_cells = {...
    '150106_F1_C1'; 'Very bright terminals, probably due to damage, no responses';
    '141211_F3_C1'; 'No signal.  Antenna was oriented in the wrong way wasn''t able to move correctly. Led to decision to reject quickly';
    };
};

%% Analysis cells
analysis_cells = {...
    '150107_F1_C1'
};

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(cnt).name = {
        analysis_cells{c}
    };
end

%% For the figure

cnt = 1;
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\150107\150107_F1_C1\PiezoChirp_Raw_150107_F1_C1_1.mat';
    %'C:\Users\Anthony Azevedo\Raw_Data\150107\150107_F1_C1\PiezoChirp_Raw_150107_F1_C1_11.mat'; % 17 Hz to 800 Hz
    'C:\Users\Anthony Azevedo\Raw_Data\150107\150107_F1_C1\PiezoChirp_Raw_150107_F1_C1_14.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\150107\150107_F1_C1\PiezoLongCourtshipSong_Raw_150107_F1_C1_1.mat';  % Not great
};
analysis_cell(cnt).genotype = '20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4';
analysis_cell(cnt).comment = {
    'Great chirp signal, but the other stimuli were not delivered well. probe not connected';
    };

cnt = 2;
analysis_cell(cnt).name = {
    '141209_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoChirp_Raw_141209_F1_C1_5.mat'; % distal 'up'
'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoChirp_Raw_141209_F1_C1_17.mat'; % distal 'down'
% 'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoChirp_Raw_141209_F1_C1_19.mat'; % proximal 'up'
% 'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoChirp_Raw_141209_F1_C1_27.mat'; % proximal 'down'
'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoLongCourtshipSong_Raw_141209_F1_C1_5.mat';
%'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoLongCourtshipSong_Raw_141209_F1_C1_8.mat'; % proximal
'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoSine_Raw_141209_F1_C1_1.mat'; % distal 
%'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoSine_Raw_141209_F1_C1_55.mat'; % proximal
};

analysis_cell(cnt).genotype = '20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4';
analysis_cell(cnt).comment = {
    'Complete over harmonics, slight band pass';
    };


cnt = 2;
analysis_cell(cnt).name = {
    '141210_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F1_C1\PiezoChirp_Raw_141210_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F1_C1\PiezoChirp_Raw_141210_F1_C1_9.mat';
'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F1_C1\PiezoLongCourtshipSong_Raw_141210_F1_C1_1.mat';
};
analysis_cell(cnt).genotype = '20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4';
analysis_cell(cnt).comment = {
    'Complete over harmonics, slight band pass';
    };

cnt = 3;
analysis_cell(cnt).name = {
    '141210_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F2_C1\PiezoChirp_Raw_141210_F2_C1_1.mat';
};
analysis_cell(cnt).genotype = '20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4';
analysis_cell(cnt).comment = {
    'Complete over harmonics, slight band pass';
    };

cnt = 4;
analysis_cell(cnt).name = {
    '141210_F3_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F3_C1\PiezoChirp_Raw_141210_F3_C1_1.mat'; % up
'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F3_C1\PiezoChirp_Raw_141210_F3_C1_9.mat'; % down
    
'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F3_C1\PiezoSine_Raw_141210_F3_C1_48.mat'; 

'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F3_C1\PiezoLongCourtshipSong_Raw_141210_F3_C1_1.mat';

'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F3_C1\PiezoStimulus_Raw_141210_F3_C1_1.mat';
};
analysis_cell(cnt).genotype = '20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4';
analysis_cell(cnt).comment = {
    'Good cell, clear signals';
    };

cnt = 5;
analysis_cell(cnt).name = {
    '141211_F1_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoChirp_Raw_141211_F1_C1_1.mat';
'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoChirp_Raw_141211_F1_C1_18.mat';

'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoSine_Raw_141211_F1_C1_1.mat';

'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoLongCourtshipSong_Raw_141211_F1_C1_1.mat';
};
analysis_cell(cnt).genotype = '20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4';
analysis_cell(cnt).comment = {
    'Complete over harmonics, slight band pass';
    };

cnt = 6;
analysis_cell(cnt).name = {
    '141211_F2_C1';
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F2_C1\PiezoChirp_Raw_141211_F2_C1_2.mat';
'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F2_C1\PiezoChirp_Raw_141211_F2_C1_17.mat';

'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F2_C1\PiezoSine_Raw_141211_F2_C1_1.mat';

'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F2_C1\PiezoLongCourtshipSong_Raw_141211_F2_C1_1.mat';
};
analysis_cell(cnt).genotype = '20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4';
analysis_cell(cnt).comment = {
    'decent movement, but no response to courtship song';
    };


%% PiezoChirp Up

for c_ind = 1:length(analysis_cell)
t_ind = 1;

trial = load(analysis_cell(c_ind).exampletrials{t_ind});
obj.trial = trial;

[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;

f(c_ind) = PiezoChirpScimStackFamily([],obj,'');

genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
if ~isdir(genotypedir), mkdir(genotypedir); end

fn = fullfile(genotypedir,['CaIm_', ...
    dateID '_', ...
    flynum '_', ...
    cellnum '_', ...
    num2str(obj.trial.params.trialBlock) '_',...
    'ChirpScim', ...
    '.pdf']);

export_fig C:\Users\Anthony' Azevedo'\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\CaIm_141209_F1_C1_3_ChirpScim.pdf -pdf -transparent
end


%% PiezoChirp Down

c_ind = 1;
t_ind = 2;

trial = load(analysis_cell(c_ind).exampletrials{t_ind});
obj.trial = trial;

[obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
    extractRawIdentifiers(trial.name);

prtclData = load(dfile);
obj.prtclData = prtclData.data;
obj.prtclTrialNums = obj.currentTrialNum;

f = PiezoChirpScimStackFamily([],obj,'');

genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
if ~isdir(genotypedir), mkdir(genotypedir); end

fn = fullfile(genotypedir,['CaIm_', ...
    dateID '_', ...
    flynum '_', ...
    cellnum '_', ...
    num2str(obj.trial.params.trialBlock) '_',...
    'ChirpScim', ...
    '.pdf']);

export_fig C:\Users\Anthony' Azevedo'\RAnalysis_Data\Record_GCaMP6s_Imaging\20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4\CaIm_141209_F1_C1_3_ChirpScim.pdf -pdf -transparent

%% PiezoLongSong
for c_ind = 1:length(analysis_cell)
    t_ind = 3;
    
    trial = load(analysis_cell(c_ind).exampletrials{t_ind});
    obj.trial = trial;
    
    [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
        extractRawIdentifiers(trial.name);
    
    prtclData = load(dfile);
    obj.prtclData = prtclData.data;
    obj.prtclTrialNums = obj.currentTrialNum;
    
    f = PiezoSongScimFamily([],obj,'');
    
    genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
    if ~isdir(genotypedir), mkdir(genotypedir); end
    
    fn = fullfile(genotypedir,['CaIm_', ...
        dateID '_', ...
        flynum '_', ...
        cellnum '_', ...
        num2str(obj.trial.params.trialBlock) '_',...
        'SongScim']);
    
    eval(['export_fig ',...
        regexprep(fn,'Anthony Azevedo','Anthony'' Azevedo'''),...
        ' -pdf -transparent'])
end

%%
% %% 45D07-Gal4
% % 141028_F1_C1 % Reject: no data
% % 141029_F2_C1 % Reject: Antennal movement, probe potentially touching the objective.
% 
% clear analysis_cell
% cnt = 1;
% analysis_cell(cnt).name = {
%     '141118_F1_C1';
%     };
% analysis_cell(cnt).exampletrials = {...
% 'C:\Users\Anthony Azevedo\Raw_Data\141118\141118_F1_C1\PiezoChirp_Raw_141118_F1_C1_9.mat'; % terminals clear movement up and down in z
% 'C:\Users\Anthony Azevedo\Raw_Data\141118\141118_F1_C1\PiezoChirp_Raw_141118_F1_C1_19.mat'; % ammc
% };
% 
% % 141119_F1_C1
% % 141123_F1_C1
% % 141123_F2_C1
% % 141124_F1_C1


% c_ind = 1;
% t_ind = 2;
% 
% trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% obj.trial = trial;
% 
% [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
%     extractRawIdentifiers(trial.name);
% 
% prtclData = load(dfile);
% obj.prtclData = prtclData.data;
% obj.prtclTrialNums = obj.currentTrialNum;
% 
% f = PiezoChirpScimStackFamily([],obj,'');
% 
% genotypedir = fullfile(savedir,analysis_cell(c_ind).genotype);
% if ~isdir(genotypedir), mkdir(genotypedir); end
% 
% fn = fullfile(genotypedir,['LF_', ...
%     dateID '_', ...
%     flynum '_', ...
%     cellnum '_', ...
%     num2str(obj.trial.params.trialBlock) '_',...
%     'PiezoSineMatrix', ...
%     '.pdf']);
% 
% 
% %% GH86-Gal4
% 
% % 2014-10-27	F2C1 % Reject: Antennal movement, probe potentially touching the objective.
% 
% clear analysis_cell
% cnt = 1;
% analysis_cell(cnt).name = {
%     '141120_F1_C1';
%     };
% analysis_cell(cnt).exampletrials = {...
% 'C:\Users\Anthony Azevedo\Raw_Data\141120\141120_F1_C1\PiezoChirp_Raw_141120_F1_C1_30.mat'; % terminals
% };
% analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(1).exampletrials{1})));
% analysis_cell(cnt).comment = {
%     'Complete over harmonics, slight band pass';
%     };
% 
% % terminals
% c_ind = 1;
% t_ind = 1;
% 
% %%
% trial = load(analysis_cell(c_ind).exampletrials{t_ind});
% obj.trial = trial;
% 
% [obj.currentPrtcl,dateID,flynum,cellnum,obj.currentTrialNum,obj.dir,obj.trialStem,dfile] = ...
%     extractRawIdentifiers(trial.name);
% 
% if ~isempty(strfind('PiezoSineMatrix',obj.currentPrtcl))
%     prtclData = load(dfile);
%     obj.prtclData = prtclData.data;
%     obj.prtclTrialNums = obj.currentTrialNum;
%     
%     
%     f = PiezoSineMatrix([],obj,'');
% end
% 
% 
