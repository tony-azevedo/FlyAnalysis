%% Record - Muscle imaging
% Preliminary results
% Workflow_MHCGal4_GCaMP6f_170703_F1_C1_CaImControl
% Workflow_MHCGal4_GCaMP6f_170705_F1_C1_CaImControl
% Workflow_MHCGal4_GCaMP6f_170707_F2_C1_CaImControl
% Workflow_MHCGal4_GCaMP6f_170707_F3_C1_CaImControl

% Preliminary controls
Workflow_MHCGal4_pJFRC7_171107_F2_C1_CaImControl
Workflow_MHCGal4_pJFRC7_171109_F1_C1_CaImControl

avi_scaled
caImavi_nobar
caImavi_scaled_noEMG
caImavi

%% Run the deepLabCut on the data
% see http://www.mousemotorlab.org/deeplabcut/
% 

%% calculate cluster intensity with the entire set from 170705
trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
trialnumlist = (26:41); % 1700705 example set for probe extraction
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D);
for tr_idx = trialnumlist %   1:length(data)
    trial = load(sprintf(trialStem,tr_idx));

    if isfield(trial ,'forceProbe_line') && isfield(trial,'forceProbe_tangent') && (~isfield(trial,'excluded') || ~trial.excluded)
        fprintf('%s\n',trial.name);
        probeTrackROI_getBarModel(trial) % need to get the barmodel in there
    else
        fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
        continue
    end        
end


%% make cluster images from several flies
trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
trialnumlist = (27:41); % 1700705 example set for probe extraction
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
cd(D);
batch_avikmeansClusterIntensity_v2


%% Show ca traces from all 5 clusters from trial 170705_F1_C1_25
savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';

trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
CSHL_select_kmeansROI
savePDF(fluof,savedir,[],'All_clusters_and_Bar')

%% show the clusters

trial = load('B:\Raw_Data\170703\170703_F1_C1\EpiFlash2T_Raw_170703_F1_C1_12.mat');
[~,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
clustid = [1 2 3 4 5];

% trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
% [~,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
% clustid = [1 2 3 4 5];
% 
% trial = load('B:\Raw_Data\170707\170707_F3_C1\EpiFlash2T_Raw_170707_F3_C1_11.mat');
% [~,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
% clustid = [2 3 4 5 1];
% 
% trial = load('B:\Raw_Data\170707\170707_F2_C1\EpiFlash2T_Raw_170707_F2_C1_35.mat');
% [~,dateID,flynum,cellnum,trialnum] = extractRawIdentifiers(trial.name);
% clustid = [5 1 3 2 4];
% 
clrs = [
    0 1 1           %c
    1 0.3 0.945       %m
    .43 0.5  1           %b
    0.2 1.00 0.2         %g
    1 1 0.2           %y
    ];

smooshedImagePath = regexprep(trial.name,{'_Raw_','.mat'},{'_smooshed_', '.mat'});
iostr = load(smooshedImagePath);

displayf = figure;
set(displayf,'position',[40 10 640 512],'color',[0 0 0]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 640 512]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax','color',[0 0 0]);
colormap(dispax,'gray')

clustf = figure;
set(clustf,'position',[40 10 640 512],'color',[0 0 0]);
clustax = axes('parent',clustf,'units','pixels','position',[0 0 640 512]);
set(clustax,'box','off','xtick',[],'ytick',[],'tag','dispax','color',[0 0 0]);
colormap(clustax,'gray')

scale = [quantile(iostr.smooshedframe(:),0.05) 1*quantile(iostr.smooshedframe(:),0.999)];
im = imshow(iostr.smooshedframe,scale,'parent',dispax);

for cl_d_idx = 1:5
    cl_idx = clustid(cl_d_idx);
    clmask = trial.clmask==cl_idx;
    ii = find(sum(clmask,1),1,'first');
    jj = find(clmask(:,ii),1,'first');
    clmask_b = bwtraceboundary(clmask,[jj,ii],'E',8);
    
    line(clmask_b(:,2),clmask_b(:,1),'parent',dispax,'color',clrs(cl_d_idx,:),'tag',num2str(cl_idx));
    line(clmask_b(:,2),clmask_b(:,1),'parent',clustax,'color',clrs(cl_d_idx,:),'tag',num2str(cl_idx));
    
    while size(clmask_b,1)<75
        clmask(min(clmask_b(:,1))-2:max(clmask_b(:,1))+2,min(clmask_b(:,2))-2:max(clmask_b(:,2))+2) = 0;
        ii = find(sum(clmask,1),1,'first');
        jj = find(clmask(:,ii),1,'first');
        try clmask_b = bwtraceboundary(clmask,[jj,ii],'E',8);
        catch
            clmask_b = bwtraceboundary(clmask,[jj,ii],'W',8);
        end
        line(clmask_b(:,2),clmask_b(:,1),'parent',dispax,'color',clrs(cl_d_idx,:),'tag',num2str(cl_idx));
        line(clmask_b(:,2),clmask_b(:,1),'parent',clustax,'color',clrs(cl_d_idx,:),'tag',num2str(cl_idx));
    end
end

xlim(clustax,[400 1200])
axis(clustax,'equal');

% savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro\clusters';
% savePDF(displayf,savedir,[],sprintf('ClusterMasks_%s',[dateID '_' flynum '_' cellnum '_' trialnum]))
% saveas(displayf,[savedir,filesep,sprintf('ClusterMasks_%s',[dateID '_' flynum '_' cellnum '_' trialnum])],'png')
% savePDF(clustf,savedir,[],sprintf('ClusterMasks_only_%s',[dateID '_' flynum '_' cellnum '_' trialnum]))



%% now mess around with the bar dynamics
trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
CSHL_select_trajectories;

%% Plot the EMG and the clusters
trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
CSHL_EMGTraces;
CSHL_select_EMGTraces;

%% For 170705_F1_C1, look at various trajectories and look at the fluorescnece for different types
trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D);

% First find all the spikes
trialnumlist = (27:41);% trialnumlist = 120;
tresh = -150
for tr = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(tr)));
    if  isfield(trial,'excluded') && trial.excluded
        continue;
    end

    simplerExtractSpikes_EMG

end

% Then go through and average wherever there is a spike
for tr = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(tr)));
    if  isfield(trial,'excluded') && trial.excluded
        continue;
    end

    simplerExtractSpikes_EMG

end


