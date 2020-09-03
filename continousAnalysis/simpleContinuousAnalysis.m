%% Reading a continuous file, 5000 entries at a time

% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200812_F1_C2_2_A.bin');

%cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200823_F2_C1_1_A.bin');
% cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200823_F2_C1_2_A.bin');

cdr = ContinuousDataReader('AcquireWithEpiFeedback_ContRaw_200823_F3_C1_7_A.bin');

% cdr.channels
cdr.chooseChannels({'probe_position','arduino_output'});%,'b_0','b_128'});
cdr.nextCookie(20)

%% 
cdr.nextCookie(50)

%% 
% cdr.rewind
cdr.ffwRead

%%
cdr.overview

%% 
cdr.ffwRecording(20,.00001)


