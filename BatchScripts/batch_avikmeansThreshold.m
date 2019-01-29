%% Batch script for thresholding regions of interest for k_means
% for faster kmeans clustering of individual movies

% Assuming I'm in a directory where the movies are to be processed

for tr_idx = trialnumlist(1:4) 
    trial = load(sprintf(trialStem,tr_idx));

    %waitbar(tr_idx/length(trialnumlist),br);

    Script_AskAboutThresholdForCaImagingROI;
    thresholds(tr_idx) = trial.kmeans_threshold;
    REDO.kmeans_ROI = trial.kmeans_ROI;
end
clear REDO;

temp.ROI = getacqpref('quickshowPrefs','avi_kmeans_roi');
temp.threshold = median(thresholds);
for tr_idx = trialnumlist(1:end) 
    trial = load(sprintf(trialStem,tr_idx));
    fprintf('Saving file: %d\n',tr_idx);
    trial.kmeans_ROI = temp.ROI;
    trial.kmeans_threshold = temp.threshold;
    save(trial.name,'-struct','trial')    
end

