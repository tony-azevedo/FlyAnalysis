%% Record - Muscle imaging Following MN Stimulation

%% 181023: Current acquisition protocol
% 15 trials without the bar at ~50Hz calcium imaging. Use these to define the clusters
% 60 trials without the bar at 100 Hz calcium imaging. Use these trials to compare leg movement, calcium signals
% 60 trials with bar, use these to look at force and clusters

% Step 1: move data to raw_raw_data on cloud
% Step 2: compress movies to h264
% Step 3: delete greyscale movies
% Step 4: Detect bar in videos
% Step 5: Move videos to media beast for tracking
% Step 6: Track legs on media beast
% Step 7: Transfer tracking data back to raw data folder
% Step 8: run the clustering on trials 1-15
% Step 9: get the intensity for all of the clusters for 16-75
% Step 10: Merge leg position and kinematics with calcium data

%%
Workflow_MNStim_LegCaImaging_81A07_181008_F1_C1 % 81A07
Workflow_MNStim_LegCaImaging_81A07_181011_F4_C1 % 81A07
Workflow_MNStim_LegCaImaging_81A07_181111_F3_C1 % 35C09


