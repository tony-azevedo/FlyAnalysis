%% Reading a continuous file, 5000 entries at a time

cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200810_F0_C1_5_A.bin')

%% 

cdr.ffwRecording(2,.00001)

%% 
cdr.nextChunk


%% 
cdr.nextCookie

%%

cdr.aChunk

%% 
cdr.aCookie(.5)

%%
cdr.rewind