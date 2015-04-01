% Record of Contralateral stimulation with GCaMP imaging  Record_GCaMP6s_Imaging
%% Checklist

analysis_cells = {...
    '150205_F2_C1'
    '150210_F1_C1'
    '150210_F3_C1'
    '150211_F2_C1'
    '150211_F3_C1'
    '150211_F4_C1'
    '150212_F1_C1'
    '150212_F2_C1'
};
analysis_cells_comment = {...
    'Awesome!  but I expected this based on the antennal movement.  Also, a little less distal';
    'Great movement, very large signals in the AMMC'
    'good movement of the antenna, see video, signals are more normal'
    'movement was ok, a little off axis. see video';
    'nice movement, axis parallel to image plane, good signal'
    'nice movement, axis parallel to image plane, great signal'
    'great movement, axis parallel to image plane, good signal, see video'
    'incredible terminal signals'
    };

clear analysis_cell
for c = 1:length(analysis_cells)
    analysis_cell(c).name = analysis_cells(c);
    analysis_cell(c).genotype = '20XUAS-IVS-GCaMP6s(attP40)R45D07-Gal4';
    analysis_cell(c).comment = analysis_cells_comment(c);
end

%%
cnt = find(strcmp(analysis_cells,'150205_F2_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150205\150205_F2_C1\PiezoChirp_Raw_150205_F2_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150205\150205_F2_C1\PiezoChirp_Raw_150205_F2_C1_11.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150205\150205_F2_C1\PiezoLongCourtshipSong_Raw_150205_F2_C1_1.mat';
analysis_cell(cnt).SineTrial = '';


%% 
cnt = find(strcmp(analysis_cells,'150210_F1_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150210\150210_F1_C1\PiezoChirp_Raw_150210_F1_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150210\150210_F1_C1\PiezoChirp_Raw_150210_F1_C1_11.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150210\150210_F1_C1\PiezoLongCourtshipSong_Raw_150210_F1_C1_1.mat';
analysis_cell(cnt).SineTrial = '';

%% 
cnt = find(strcmp(analysis_cells,'150210_F3_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150210\150210_F3_C1\PiezoChirp_Raw_150210_F3_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150210\150210_F3_C1\PiezoChirp_Raw_150210_F3_C1_11.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150210\150210_F3_C1\PiezoLongCourtshipSong_Raw_150210_F3_C1_1.mat';
analysis_cell(cnt).SineTrial = '';

%% 
cnt = find(strcmp(analysis_cells,'150211_F2_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150211\150211_F2_C1\PiezoChirp_Raw_150211_F2_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150211\150211_F2_C1\PiezoChirp_Raw_150211_F2_C1_11.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150211\150211_F2_C1\PiezoLongCourtshipSong_Raw_150211_F2_C1_1.mat';
analysis_cell(cnt).SineTrial = '';


%% 
cnt = find(strcmp(analysis_cells,'150211_F3_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150211\150211_F3_C1\PiezoChirp_Raw_150211_F3_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150211\150211_F3_C1\PiezoChirp_Raw_150211_F3_C1_11.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150211\150211_F3_C1\PiezoLongCourtshipSong_Raw_150211_F3_C1_1.mat';
analysis_cell(cnt).SineTrial = '';

%% 
cnt = find(strcmp(analysis_cells,'150211_F4_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150211\150211_F4_C1\PiezoChirp_Raw_150211_F4_C1_12.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150211\150211_F4_C1\PiezoChirp_Raw_150211_F4_C1_22.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150211\150211_F4_C1\PiezoLongCourtshipSong_Raw_150211_F4_C1_1.mat';
analysis_cell(cnt).SineTrial = '';

%% 
cnt = find(strcmp(analysis_cells,'150212_F1_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150212\150212_F1_C1\PiezoChirp_Raw_150212_F1_C1_21.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150212\150212_F1_C1\PiezoChirp_Raw_150212_F1_C1_31.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150212\150212_F1_C1\PiezoLongCourtshipSong_Raw_150212_F1_C1_1.mat';
analysis_cell(cnt).SineTrial = '';

%% 
cnt = find(strcmp(analysis_cells,'150212_F2_C1'));

analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150212\150212_F2_C1\PiezoChirp_Raw_150212_F2_C1_1.mat';
analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150212\150212_F2_C1\PiezoChirp_Raw_150212_F2_C1_11.mat';
analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150212\150212_F2_C1\PiezoLongCourtshipSong_Raw_150212_F2_C1_1.mat';
analysis_cell(cnt).SineTrial = '';

%% 
reject_cells = {...
    '141125_F1_C1'
    '141201_F1_C1'
    '150204_F1_C1'
    '150205_F1_C1'
    '150205_F2_C1_distal'
    '150210_F2_C1'
    '150211_F1_C1'
    };
reject_cells_comment = {...
    'Vaughan solutions, but great signals.  Gotta figure this out';
    'Great chirp signal,';
    'Not very good signal.  I think the movement of the antenna was off';
    'Not very good signal.  Movement of the antenna was really strange, see video';
    'Same cell, more distal terminals';
    'Movement was not good, rejected it before startting';
    'movement was good, but there was no signal.  Must have cut the AN or something.  check that next time';
    };
% %%
% cnt = find(strcmp(analysis_cells,'141125_F1_C1'));
% 
% analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141125\141125_F1_C1\PiezoChirp_Raw_141125_F1_C1_4.mat';
% analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141125\141125_F1_C1\PiezoChirp_Raw_141125_F1_C1_12.mat';
% analysis_cell(cnt).LongSongTrial = '';
% analysis_cell(cnt).SineTrial = '';


% cnt = find(strcmp(analysis_cells,'141201_F1_C1'));
% 
% analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141201\141201_F1_C1\PiezoChirp_Raw_141201_F1_C1_4.mat';
% analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\141201\141201_F1_C1\PiezoChirp_Raw_141201_F1_C1_10.mat';
% analysis_cell(cnt).LongSongTrial = '';
% analysis_cell(cnt).SineTrial = '';


% %%
% cnt = find(strcmp(analysis_cells,'150204_F1_C1'));
% 
% analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150204\150204_F1_C1\PiezoChirp_Raw_150204_F1_C1_1.mat';
% analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150204\150204_F1_C1\PiezoChirp_Raw_150204_F1_C1_11.mat';
% analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150204\150204_F1_C1\PiezoLongCourtshipSong_Raw_150204_F1_C1_1.mat';
% analysis_cell(cnt).SineTrial = '';
% 
% %%
% cnt = find(strcmp(analysis_cells,'150205_F1_C1'));
% 
% analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150205\150205_F1_C1\PiezoChirp_Raw_150205_F1_C1_1.mat';
% analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150205\150205_F1_C1\PiezoChirp_Raw_150205_F1_C1_11.mat';
% analysis_cell(cnt).LongSongTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150205\150205_F1_C1\PiezoLongCourtshipSong_Raw_150205_F1_C1_1.mat';
% analysis_cell(cnt).SineTrial = '';
% %% Very distal terminals
% cnt = find(strcmp(analysis_cells,'150205_F2_C1_distal'));
% 
% analysis_cell(cnt).ChirpUpTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150205\150205_F2_C1\PiezoChirp_Raw_150205_F2_C1_21.mat';
% analysis_cell(cnt).ChirpDownTrial = 'C:\Users\Anthony Azevedo\Raw_Data\150205\150205_F2_C1\PiezoChirp_Raw_150205_F2_C1_11.mat';
% analysis_cell(cnt).LongSongTrial = '';
% analysis_cell(cnt).SineTrial = '';
