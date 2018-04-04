% Record - CHSL Talk

% Great example - Clear segmentation, interesting dynamics
'B:\Raw_Data\170707\170707_F3_C1\EpiFlash2T_Raw_170707_F3_C1_17.mat';

% This entire two blocks are the best to investigate. Use these data.


% Nice recordings, but the bar runs into resistance
'B:\Raw_Data\170703\170703_F1_C1\EpiFlash2T_Raw_170703_F1_C1_15.mat';

% Good recording, check this one out too
% Blocks 6, 7, 8 are all pretty good, #25, block 6, really good!
'B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_27.mat';


% First, make a movie that is good sized and small
trial = load('B:\Raw_Data\170705\170705_F1_C1\EpiFlash2T_Raw_170705_F1_C1_25.mat');
avi_scaled
caImavi_nobar
caImavi_scaled_noEMG
caImavi

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

savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro\clusters';
savePDF(displayf,savedir,[],sprintf('ClusterMasks_%s',[dateID '_' flynum '_' cellnum '_' trialnum]))
saveas(displayf,[savedir,filesep,sprintf('ClusterMasks_%s',[dateID '_' flynum '_' cellnum '_' trialnum])],'png')
savePDF(clustf,savedir,[],sprintf('ClusterMasks_only_%s',[dateID '_' flynum '_' cellnum '_' trialnum]))



%% measure the pixel distance

displayf = figure;           
set(displayf,'position',[200 150 980 786],'color',[0 0 0]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 980 786]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');

% top origin
top = imread('B:\Raw_Data\RigSpecifications\ImageOfChamber_top_2017-09-28-133949-0000.bmp');
imshow(top)
ptop = impoint(dispax);
y1 = ptop.getPosition; %595.4388   45.5612

% bottom 898.2 um
bottom = imread('B:\Raw_Data\RigSpecifications\ImageOfChamber_bottom_2017-09-28-134157-0000.pgm');
imshow(bottom)
pbottom = impoint(dispax);
y2 = pbottom.getPosition; % 620.2551  936.3367

% left origin
left = imread('B:\Raw_Data\RigSpecifications\ImageOfChamber_left_2017-09-28-134307-0000.pgm');
imshow(left)
pleft = impoint(dispax);
x1 = pleft.getPosition; % 215.3571  289.8061

% right 603 um
right = imread('B:\Raw_Data\RigSpecifications\ImageOfChamber_right_2017-09-28-134338-0000.pgm');
imshow(right)
pright = impoint(dispax);
x2 = pright.getPosition; % 800.5000  278.0510

L_v = 898.2;
L_h = 603;

perpixel_y = L_v/sqrt((y2(2)-y1(2))^2+(y2(1)-y1(1))^2) % HAHA! resolution is 1 um per pixel! 1.0083
perpixel_x = L_h/sqrt((x2(2)-x1(2))^2+(x2(1)-x1(1))^2) % HAHA! resolution is 1 um per pixel! 1.04 
% AND!! the electrode is essentially perpendicular! since the non movement
% direction is close to 0;

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


%% Now show what is going on with 81A07
trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
% responseWithVideo_2T_script
trials(1) = trial;

trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_37.mat');
% responseWithVideo_2T_script
trials(2) = trial;

% Look at both trials, 1 and 2
CSHL_MNTraces


%% kinematics vs firing rate
% first a trial run
% trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
% simpleExtractSpikes

trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
cd(D);

trialnumlist = 14:151; 
for tr = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(tr)));
    if trial.excluded
        continue;
    end

    simpleExtractSpikes
    pause(.5)
end

%% kinematics vs firing rate, correct a few trials
% first a trial run
% trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
% simpleExtractSpikes

trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D);

trialnumlist = 14:151;
for tr = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(tr)));
    if trial.excluded
        continue;
    end

    simplerExtractSpikes
    
end


%% Load a trial from quickShow and then run the spike detection
  simplerExtractSpikes

%% plot single spikes, the emgs, and the trajectories
trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D)
ID = [dateID '_' flynum '_' cellnum];
trialnumlist = 22:151; 
CSHL_select_spikes

%%
CSHL_select_spikes_FR

%%
CSHL_trajects_by_SpN

%% Include the second to last trajectory from the ca imaging expt


%% Load a trial from quickShow and then run the spike detection
trial = load('B:\Raw_Data\170920\170920_F2_C1\EpiFlash2T_Raw_170920_F2_C1_18.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D);

trialnumlist =  25:138;
% trialnumlist =  139:210;
% trialnumlist = 206;
for tr = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(tr)));
    if isfield(trial,'excluded') && trial.excluded
        continue;
    end

    simplerExtractSpikes_EMG
end

%%
trial = load('B:\Raw_Data\170920\170920_F1_C1\EpiFlash2T_Raw_170920_F1_C1_30.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D);

trialnumlist =  28:54;
% trialnumlist = 120;
for tr = 1:length(trialnumlist)
    trial = load(sprintf(trialStem,trialnumlist(tr)));
    if  isfield(trial,'excluded') && trial.excluded
        continue;
    end

    simplerExtractSpikes_EMG

end

%% Look at the three cells and see what's up with the single spikes in single cells

trjct1C1Sp_fi = figure;
set(trjct1C1Sp_fi,'color',[0 0 0],'units','inches','position',[4 2 8 6]);
panl = panel(trjct1C1Sp_fi);
panl.pack('v',{1/2 1/2})  % phase plot on top

panl.margin = [18 16 10 10];
panl.descendants.margin = [10 10 10 10];

tr_ph_ax = panl(1).select();

tr_ph_ax.Color = [0 0 0];
tr_ph_ax.XColor = [1 1 1];
tr_ph_ax.YColor = [1 1 1];
tr_ph_ax.TickDir = 'out';
tr_ph_ax.XLim = [-10 140];
tr_ph_ax.YLim = 1E3*[-5 7]; 
hold(tr_ph_ax,'on')

plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);

t_i_f = [-0.006 0.02];

tr_ax = panl(2).select();
set(tr_ax,'color',[0 0 0],'xcolor',[1 1 1],'ycolor',[1 1 1],'tickdir','out','xlim',t_i_f,'ylim',[-10 140]); hold(tr_ax,'on')

trial = load('B:\Raw_Data\170921\170921_F1_C1\EpiFlash2T_Raw_170921_F1_C1_22.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D);
trialnumlist = 14:151;

clr = [.0 .1 1]
N = 1;
CSHL_1cell_1spike

clr = [.3 .4 1]
N = 2;
CSHL_1cell_1spike


trial = load('B:\Raw_Data\170920\170920_F2_C1\EpiFlash2T_Raw_170920_F2_C1_25.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D);
trialnumlist =  25:138;

clr = [1 0 0]
N = 1;
CSHL_1cell_1spike_EMG

clr = [1 .3 .5]
N = 2;
CSHL_1cell_1spike_EMG

trial = load('B:\Raw_Data\170920\170920_F1_C1\EpiFlash2T_Raw_170920_F1_C1_30.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);
cd(D);
trialnumlist =  28:54;

clr = [.7 .7 .7]
N = 1;
CSHL_1cell_1spike_EMG

clr = [1 1 1]
N = 2;
CSHL_1cell_1spike_EMG

clrs = [
    .0 .1 1
    .3 .4 1
    1 0 0
    1 .3 .5
    .7 .7 .7
    1 1 1];

for c = 1:size(clrs,1)
    l = findobj(tr_ax,'type','line','color',clrs(c,:));
    zeroidx = zeros(size(l));
    negidx = zeros(size(l));
    posidx = zeros(size(l));
    for l_i = 1:length(l)
        XData = l(l_i).XData
        x_ = abs(XData);
        zeroidx(l_i) = find(abs(XData)==min(abs(XData)));
        posidx(l_i) = length(XData(zeroidx(l_i):end));
        negidx(l_i) = length(XData(1:zeroidx(l_i)-1));
    end
    
    X = zeros(length(l),min(negidx)+min(posidx));
    Y = zeros(length(l),min(negidx)+min(posidx));
    for l_i = 1:length(l)
        XData = l(l_i).XData;
        X(l_i,:) = XData(zeroidx(l_i)-min(negidx):zeroidx(l_i)-1+min(posidx));
        YData = l(l_i).YData;
        Y(l_i,:) = YData(zeroidx(l_i)-min(negidx):zeroidx(l_i)-1+min(posidx));
    end
    delete(l);
%     plot(tr_ax,,mean(Y),'color',clrs(c,:),'linewidt',2);
%     plot(tr_ax,mean(X),mean(Y),'color',clrs(c,:),'linewidt',2);
    errbrsx_x = repmat(mean(X,1),2,1)+repmat(sem(X,1),2,1).*repmat([-1; 1],1,length(sem(X,1)));
    errbrsy_y = repmat(mean(Y,1),2,1)+repmat(sem(Y,1),2,1).*repmat([-1; 1],1,length(sem(Y,1)));
    
    plot(repmat(mean(X,1),2,1),errbrsy_y,'color',clrs(c,:),'linewidth',1);
    plot(errbrsx_x,repmat(mean(Y,1),2,1),'color',clrs(c,:),'linewidth',1);
    plot(tr_ax,mean(X),mean(Y),'color',clrs(c,:),'linewidth',1);
end


savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
savePDF(trjct1C1Sp_fi,savedir,[],sprintf('trajec_perN_3cells'))

%% 81A07 recordings

% look at force vs distance
t_i_f = [-0.02 .13];

trjct1C1Sp_fi = figure;
trjct1C1Sp_fi.Color = [0 0 0];
trjct1C1Sp_fi.Units = 'inches';
trjct1C1Sp_fi.Position = [4 2 8 6];

panl = panel(trjct1C1Sp_fi);
panl.pack('v',{1/2 1/2})  % phase plot on top

panl.margin = [18 16 10 10];
panl.descendants.margin = [10 10 10 10];

tr_ph_ax = panl(1).select();

tr_ph_ax.Color = [0 0 0];
tr_ph_ax.XColor = [1 1 1];
tr_ph_ax.YColor = [1 1 1];
tr_ph_ax.TickDir = 'out';
tr_ph_ax.XLim = [-10 140];
tr_ph_ax.YLim = 1E3*[-5 7]; 
hold(tr_ph_ax,'on')

plot(tr_ph_ax,[0 0],tr_ph_ax.YLim,'color',[.2 .2 .2]);
plot(tr_ph_ax,tr_ph_ax.YLim,[0 0],'color',[.2 .2 .2]);

tr_ax = panl(2).select();
tr_ax.Color = [0 0 0];
tr_ax.XColor = [1 1 1];
tr_ax.YColor = [1 1 1];
tr_ax.TickDir = 'out';
tr_ax.XLim = [-10 140];
tr_ax.YLim = 1E3*[-5 7]; 
hold(tr_ax,'on')


trial = load('B:\Raw_Data\170920\170920_F2_C1\EpiFlash2T_Raw_170920_F2_C1_18.mat');
[~,dateID,flynum,cellnum,~,D,trialStem,] = extractRawIdentifiers(trial.name);

trialnumlist =  25:138;
clr = [1 1 1]
N = 1;
CSHL_1cell_1spike_EMG

trialnumlist = [187:210];
clr = [1 0 0]
N = 1;
CSHL_1cell_1spike_EMG

trialnumlist = [139:162];
clr = [0 1 0]
N = 1;
CSHL_1cell_1spike_EMG

trialnumlist = [163:188];
clr = [0 0 1]
N = 1;
CSHL_1cell_1spike_EMG


clrs = [
    .0 .1 1
    .3 .4 1
    1 0 0
    1 .3 .5
    .7 .7 .7
    1 1 1];

CSHL_1cell_1spike_EMG

savedir = 'E:\tony\Projects\FlySensorimotor\Talks\CSHL_DmelNeuro';
savePDF(trjct1C1Sp_fi,savedir,[],sprintf('170920_F2_C1_trajectory_over_distance'))

%% 81A07 recordings

% this one is crappy!
'B:\Raw_Data\170616\170616_F1_C1\EpiFlash2T_Raw_170616_F1_C1_86.mat';

% No bar, nice, but EMG is contaminated and fluctuates
'B:\Raw_Data\170616\170616_F1_C1\EpiFlash2T_Raw_170616_F1_C1_30.mat';

%%
% this one is pretty crappy, but has sensory feedback
'B:\Raw_Data\170817\170817_F1_C1\EpiFlash2T_Raw_170817_F1_C1_1.mat';

savedir = 'E:\tony\Projects\FlySensorimotor\Talks\LabMeeting171017';
savePDF(gcf,savedir,[],sprintf('170817_F1_C1_PiezoStep_1'))

% savedir = 'E:\tony\Projects\FlySensorimotor\Talks\LabMeeting171017';
% savePDF(gcf,savedir,[],sprintf('170817_F1_C1_PiezoStep_2'))

%% PiezoSine2T
'B:\Raw_Data\170817\170817_F1_C1\EpiFlash2T_Raw_170817_F1_C1_1.mat';

savedir = 'E:\tony\Projects\FlySensorimotor\Talks\LabMeeting171017';
savePDF(gcf,savedir,[],sprintf('170817_F1_C1_PiezoSine'))


%% 81A07 ChR recordings

% Crappy single spike cases: 
'B:\Raw_Data\170830\170830_F1_C1\EpiFlash2T_Raw_170830_F1_C1_82.mat';

% Other
'B:\Raw_Data\170830\170830_F1_C1\EpiFlash2T_Raw_170830_F1_C1_77.mat';


%% Other flexor recordings

% Clear 1:1, but have to filter out the triangle transients
'B:\Raw_Data\170623\170623_F1_C1\EpiFlash2T_Raw_170623_F1_C1_9.mat';

savedir = 'E:\tony\Projects\FlySensorimotor\Talks\LabMeeting171017';
savePDF(gcf,savedir,[],sprintf('170504_F2_C1_EpiFlash2T'))


