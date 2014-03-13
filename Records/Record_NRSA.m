%% Record for NRSA figures

%% Figure 1A,B
% Use the anatomy and fly head schematic from the previous submission

%% Figure 1C
% Low Frequency cell, down the row of middle amplitude
analysis_cell.name = {
    '140128';
    };
analysis_cell.comment = {
    'Low Frequency selective, very nice!'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\PiezoSine_Raw_140128_F1_C1_81.mat';
    };
analysis_cell.evidencecalls = {
    'PiezoSineMatrix'
    'PiezoSongAverage'
    };

transfer = PiezoSineOsciTransFunc(fig,handles,savetag);

analysis_cell.name = {
    '131015';
    };
analysis_cell.comment = {
    'High Frequency selective, hints of inhibition. Assymetric response to forward and back CourtS'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoSine_Raw_140110_F1_C1_17.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoCourtshipSong_Raw_140110_F1_C1_2.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoBWCourtshipSong_Raw_140110_F1_C1_4.mat';
    };
analysis_cell.evidencecalls = {
    'PiezoSineMatrix'
    'PiezoSongAverage'
    };


%% Fig 1D
% Tuning curve, amplitude, rather than normalized

%% Fig 1E
% BS cell

%% Fig 1F
% Tuning curve, amplitude, rather than normalized


%% Fig 1G
% High Freq rectifying.

%% Fig 1H
% Tuning curve, amplitude, rather than normalized

%% 
% Export the fig


%% Figure 2A
% Oscillations, Spiking

%% Figure 2B 
% Image of a cell

%% Figure 2C 
% Break-In, Fluorescence, voltage

%% Figure 2D
% Fluorescence change in B1 and non-B1 vs dV

%% Figure 2E
% Current injection - hypothesis

%% 
% Export the fig


%% Figure 3A 
% AVLP 100 Hz selective

%% Figure 3B
% AVLP High Frequency selective.



