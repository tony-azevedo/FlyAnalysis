%% Record for NRSA figures

%% Figure 1A,B
% Use the anatomy and fly head schematic from the previous submission

%% Figure 1C
% Low Frequency cell, down the row of middle amplitude
analysis_cell.name = {
    '140128_F1_C1';
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
    'PiezoSineOsciRespVsFreq'
    };

% Mid Range
transfer = PiezoSineOsciTransFunc(fig,handles,savetag);

analysis_cell.name = {
    '131122_F2_C1';
    };
analysis_cell.comment = {
    'High Frequency selective, hints of inhibition. Assymetric response to forward and back CourtS'
    };
analysis_cell.exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\131122\131122_F2_C1\PiezoSine_Raw_131122_F2_C1_10.mat';
    };
analysis_cell.evidencecalls = {
    'PiezoSineMatrix'
    'PiezoSongAverage'
    'PiezoSineOsciRespVsFreq'
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



