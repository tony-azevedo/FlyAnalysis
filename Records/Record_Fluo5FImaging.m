%% Calcium imaging Record_Fluo5FImaging

%% Earlier Attempts
% 6/25/2014 14:00:48	F1C1	GH86;pJFRC7	Look for Calcium signals in the terminals
% 8/6/2014 15:53:06     F2C1	GH86	Ca imaging, try to see dendrites, terminals, and spikes
% 8/7/2014 13:25:47     F1C1	GH86;pJFRC7	fill cell with 50uM alexa, just to see the terminals.  after that, go down in Ca indicator concentration
% 8/7/2014 11:24:08     F2C1	GH86	Ca imaging, try to see dendrites, terminals, and spikes
% 8/7/2014 17:03:46 	F2C1	GH86-Gal4;pJFRC7	Still trying to get a good image of the cell.  Working out the problems 100uM alexa
% 8/10/2014 19:49:53	F1C1	GH86-Gal4;pJFCR7	Try to image spikes with Ca dye.  using 100uM Fluo this time and 50uM Alexa.  
% 8/12/2014 15:45:07	F1C1	GH86;pJFRC7	"Random PNs and LNs.  The laser is not mode lockign today.  THe call went out to sean and to Victor.  Power is high, things are working at longer wavelengths. 
% This is to test that I can patch LNs and PN for the FLou5f signal.  Should work tomorrow"
% 8/13/2014 16:26:42	F1C1	pJFRC7;VT27938	Measure Ca signals from Fluo5F in the antennal lobe. Do this in a line where there is little GFP staining there in the first place. i.e. not in GH86
% 8/13/2014 17:05:53	F2C1	VT27398	Look for Fluo5F responses in neurons
% 8/14/2014 20:35:42	F1C1	;pJFRC7;VT27938	Try to fill a B1 Neuron, naked brain

%% Some success with strange looking PN
% 8/15/2014 15:10:09	F1C1	pJFRC7;VT27938	Look for Ca signals in the antennal lobe.  Trying to test Fluo5F signals in Drosophila neurons
% 8/15/2014 15:24:08	F2C1	pJFRC7;VT27938	Trying to load LN with Ca indicators and find calcium signals.
% 8/15/2014 18:36:44	F2C2	"	"

%% Cells to Analyze:
cnt = 0;
clear analysis_cell

cnt = cnt+1;
analysis_cell(cnt).name = {
    '140828_F1_C1';
    };
analysis_cell(cnt).comment = {
    'Nice spiker!  Very good looking cell.  The bottom end seems to leak a little.'
    };
analysis_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoSine_Raw_140110_F1_C1_17.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoCourtshipSong_Raw_140110_F1_C1_2.mat';
    'C:\Users\Anthony Azevedo\Raw_Data\140110\140110_F1_C1\PiezoBWCourtshipSong_Raw_140110_F1_C1_4.mat';
    };
analysis_cell(cnt).evidencecalls = {
    'PiezoSineMatrix'
    'PiezoSongAverage'
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));


cnt = cnt+1;
analysis_cell(cnt).name = {
    '140212_F1_C1'
    };
analysis_cell(cnt).comment = {
    '140 Hz selective, maybe a little less. No Courtship'
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140212\140212_F1_C1\PiezoSine_Raw_140212_F1_C1_49.mat';
    };
analysis_cell(cnt).evidencecalls = {...
    'PiezosineDepolTransFunc'
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));


cnt = cnt+1;
analysis_cell(cnt).name = {
   '140214_F1_C1'};
analysis_cell(cnt).comment = {
    'Responsive to higher intensities across frequencies.  TTX'
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140214\140214_F1_C1\PiezoSine_Raw_140214_F1_C1_102.mat';
    };
analysis_cell(cnt).evidencecalls = {...
    'PiezosineDepolTransFunc'
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));



cnt = cnt+1;
analysis_cell(cnt).name = {
    '140218_F3_C1'
    };
analysis_cell(cnt).comment = {
    'Kind of responsive at high frequencies.'
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140218\140218_F3_C1\PiezoSine_Raw_140218_F3_C1_1.mat';
    };
analysis_cell(cnt).evidencecalls = {...
    'PiezoSineMatrix'
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));


cnt = cnt+1;
analysis_cell(cnt).name = {
    '140219_F3_C4'
    };
analysis_cell(cnt).comment = {
    '140 Hz, very selective, interesting PiezoChirp Response'
    };
analysis_cell(cnt).exampletrials = {...
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoCourtshipSong_Raw_140219_F3_C4_12.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoSine_Raw_140219_F3_C4_27.mat';
'C:\Users\Anthony Azevedo\Raw_Data\140219\140219_F3_C4\PiezoBWCourtshipSong_Raw_140219_F3_C4_3.mat';
    };
analysis_cell(cnt).evidencecalls = {...
    'PiezoSineMatrix'
    };
analysis_cell(cnt).genotype = genotypoToFilename(IdentifyGenotype(getFlyGenotype(analysis_cell(cnt).exampletrials{1})));

savedir = 'C:\Users\Anthony Azevedo\RAnalysis_Data\Record_WEDPNs';
if ~isdir(savedir)
    mkdir(savedir)
end
save = 1