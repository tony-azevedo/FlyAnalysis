% Record of Contralateral stimulation with GCaMP imaging  Record_GCaMP6s_Imaging
analysis_cells = {...
    '141209_F1_C1';
    '150107_F1_C1'
    '150128_F1_C1'
    '150128_F2_C1'
    '150128_F3_C1'
    '150129_F1_C1'
    '150129_F2_C1'
    '150203_F1_C1'
    '150203_F2_C1'
};
analysis_cells_comment = {...
    'Attachment ok.';
    'Great chirp probe connection, probe not connected for other stimuli';
    'Probe was a little off, piston-like action on the antenna';
    'Probe was well aligned, looked like ok movement'
    'Probe was well connected, good movement'
    'attachment was off, should probably not be included.'
    'Probe was well connected, Great signal.'
    'Probe was well connected, Shows the double excitation during the sogn'
    'Decent signal, similar to other distal terminal arrangments.  I think this had to do with positioning'
    };

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c);
    analysis_cell(c).genotype = '20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4';
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%%
cnt = find(strcmp(analysis_cells,'141209_F1_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoChirp_Raw_141209_F1_C1_5.mat'; % distal 'up'
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoChirp_Raw_141209_F1_C1_17.mat'; % distal 'down'
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoLongCourtshipSong_Raw_141209_F1_C1_5.mat';
analysis_cell(cnt).SineTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141209\141209_F1_C1\PiezoSine_Raw_141209_F1_C1_1.mat'; % distal 

%%
cnt = find(strcmp(analysis_cells,'150107_F1_C1'));

% note, these trials are from 40 - 400 Hz
analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150107\150107_F1_C1\PiezoChirp_Raw_150107_F1_C1_10.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150107\150107_F1_C1\PiezoChirp_Raw_150107_F1_C1_14.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150107\150107_F1_C1\PiezoLongCourtshipSong_Raw_150107_F1_C1_1.mat';  % Not great
analysis_cell(cnt).SineTrial = '';

%%
cnt = find(strcmp(analysis_cells,'150128_F1_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F1_C1\PiezoChirp_Raw_150128_F1_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F1_C1\PiezoChirp_Raw_150128_F1_C1_11.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F1_C1\PiezoLongCourtshipSong_Raw_150128_F1_C1_1.mat';
analysis_cell(cnt).SineTrial = '';

%%
cnt = find(strcmp(analysis_cells,'150128_F2_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F2_C1\PiezoChirp_Raw_150128_F2_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F2_C1\PiezoChirp_Raw_150128_F2_C1_11.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F2_C1\PiezoLongCourtshipSong_Raw_150128_F2_C1_1.mat';
analysis_cell(cnt).SineTrial = '';

%%
cnt = find(strcmp(analysis_cells,'150128_F3_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F3_C1\PiezoChirp_Raw_150128_F3_C1_22.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F3_C1\PiezoChirp_Raw_150128_F3_C1_15.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150128\150128_F3_C1\PiezoLongCourtshipSong_Raw_150128_F3_C1_1.mat';
analysis_cell(cnt).SineTrial = '';

%%
cnt = find(strcmp(analysis_cells,'150129_F1_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150129\150129_F1_C1\PiezoChirp_Raw_150129_F1_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150129\150129_F1_C1\PiezoChirp_Raw_150129_F1_C1_11.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150129\150129_F1_C1\PiezoLongCourtshipSong_Raw_150129_F1_C1_1.mat';
analysis_cell(cnt).SineTrial = '';

%%
cnt = find(strcmp(analysis_cells,'150129_F2_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150129\150129_F2_C1\PiezoChirp_Raw_150129_F2_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150129\150129_F2_C1\PiezoChirp_Raw_150129_F2_C1_11.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150129\150129_F2_C1\PiezoLongCourtshipSong_Raw_150129_F2_C1_10.mat';
analysis_cell(cnt).SineTrial = '';

%%
cnt = find(strcmp(analysis_cells,'150203_F1_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F1_C1\PiezoChirp_Raw_150203_F1_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F1_C1\PiezoChirp_Raw_150203_F1_C1_11.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F1_C1\PiezoLongCourtshipSong_Raw_150203_F1_C1_1.mat';
analysis_cell(cnt).SineTrial = '';

%%
cnt = find(strcmp(analysis_cells,'150203_F2_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F2_C1\PiezoChirp_Raw_150203_F2_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F2_C1\PiezoChirp_Raw_150203_F2_C1_20.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150203\150203_F2_C1\PiezoLongCourtshipSong_Raw_150203_F2_C1_11.mat';
analysis_cell(cnt).SineTrial = '';


%% 
% reject_cells = {...
%     '150106_F1_C1'; 'Very bright terminals, probably due to damage, no responses';
%     '141210_F2_C1'; 'Pulled on the contralateral AN trying to stop the motion. no good';
%     '141210_F3_C1';  'Baseline headed down, not great';
%     '141211_F1_C1'; 'The attachement to the antenna was not good, too much glue, it torqued the antenna into a weird position';
%     '141211_F2_C1'; 'decent movement, but no response to courtship song';
%     '141211_F3_C1'; 'No signal.  Antenna was oriented in the wrong way wasn''t able to move correctly. Led to decision to reject quickly';
%     '141210_F1_C1'; 'Really dim, ';
%     '150106_F1_C1'; 'Very bright terminals, probably due to damage, no responses';
%     };
% 
% cnt = find(strcmp(reject_cells,'141210_F2_C1'));
% 
% reject_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F2_C1\PiezoChirp_Raw_141210_F2_C1_1.mat';
% reject_cell(cnt).ChirpDownTrial = '';
% reject_cell(cnt).LongSongTrial = '';
% reject_cell(cnt).SineTrial = '';
% 
% cnt = find(strcmp(reject_cells,'141211_F1_C1'));
% 
% reject_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoChirp_Raw_141211_F1_C1_1.mat';
% reject_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoChirp_Raw_141211_F1_C1_18.mat';
% reject_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoLongCourtshipSong_Raw_141211_F1_C1_1.mat';
% reject_cell(cnt).SineTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F1_C1\PiezoSine_Raw_141211_F1_C1_1.mat';
% 
% cnt = find(strcmp(reject_cells,'141211_F2_C1'));
% 
% reject_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F2_C1\PiezoChirp_Raw_141211_F2_C1_2.mat';
% reject_cell(cnt).ChirpDownTrial = '';
% reject_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F2_C1\PiezoLongCourtshipSong_Raw_141211_F2_C1_1.mat';
% reject_cell(cnt).SineTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141211\141211_F2_C1\PiezoSine_Raw_141211_F2_C1_1.mat';
% 
% cnt = find(strcmp(reject_cells,'141210_F1_C1'));
% 
% reject_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F1_C1\PiezoChirp_Raw_141210_F1_C1_1.mat';
% reject_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F1_C1\PiezoChirp_Raw_141210_F1_C1_9.mat';
% reject_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F1_C1\PiezoLongCourtshipSong_Raw_141210_F1_C1_1.mat';
% reject_cell(cnt).SineTrial = '';
% 
%%
% cnt = find(strcmp(analysis_cells,'141210_F3_C1'));
% 
% analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F3_C1\PiezoChirp_Raw_141210_F3_C1_1.mat'; % up
% analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F3_C1\PiezoChirp_Raw_141210_F3_C1_9.mat'; % down
% analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F3_C1\PiezoLongCourtshipSong_Raw_141210_F3_C1_1.mat';
% analysis_cell(cnt).SineTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141210\141210_F3_C1\PiezoSine_Raw_141210_F3_C1_48.mat'; 

