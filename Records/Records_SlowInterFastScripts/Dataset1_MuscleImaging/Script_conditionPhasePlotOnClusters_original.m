% close all
%%
% Go through all the probe frames
% Plot the histogram of distances, velocities, and accelerations
% Plot relationships of {x,x_dot,x_ddot} with cluster values
PLOT = 0;
PRINT = 0;
cidx = 3;
% for cidx = 1:length(T_legImagingList.CellID)
T_row = T_legImagingList(cidx,:);
trialStem = [T_row.Protocol{1} '_Raw_' T_row.CellID{1} '_%d.mat'];
Dir = fileparts(T_row.TableFile{1}); cd(Dir);
cellid = T_row.CellID{1};

% Going with Non-bar clusters to start
map = T_row.ClusterMapping_NBCls{1};
% map assigns value map(:,1) to the cluster values map(:,2)

bartrials = T_row.Bartrials{1};
bartrial = load(sprintf(trialStem,bartrials(1)));
probe = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
dprobe_dt = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
ddprobe_dt2 = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
cnt = 0;

ft_ca = makeFrameTime2CB2T(bartrial);
dt = diff(ft_ca(1:2));
stimwind = (ft_ca>0-dt*1/2 & ft_ca<dt*1/2) |  (ft_ca>bartrial.params.stimDurInSec-dt*1/2 & ft_ca<bartrial.params.stimDurInSec+dt*1/2);

%% Preallocate for filtering steps
% Fluo(cluster)
F_cl = nan(max(size(bartrial.clustertraces_NBCls)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
% derivative of Fluo(cluster)
dF_cl = nan(max(size(bartrial.clustertraces_NBCls)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
% thresholded derivative of Fluo(cluster)
fdF_cl = dF_cl;
% upsampled thresholded derivative of Fluo(cluster)
ufdF_cl = zeros(max(size(bartrial.forceProbeStuff.CoM)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
% upsampled Fluo(cluster)
uF_cl = nan(max(size(bartrial.forceProbeStuff.CoM)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));

for tr = bartrials'
    
    bartrial = load(sprintf(trialStem,tr));
    
    cnt = cnt+1;
    probe(:,cnt) = bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce;
    dprobe_dt(:,cnt) = cat(1,diff(probe(:,cnt)),nan)/dt;
    ddprobe_dt2(:,cnt) = cat(1,nan,diff(dprobe_dt(:,cnt)))/dt;
    
    % order the clusters appropriately
    for cl = 1:size(map,1)
        F_cl(:,cl,cnt) = bartrial.clustertraces_NBCls(:,map(cl,2));
        dF_cl(:,cl,cnt) = cat(1,diff(F_cl(:,cl,cnt)),nan);
        dF_cl(stimwind,cl,cnt) = 0;
    end
end

%%
% Threshold the F derivatives
% Apply this function to the derivatives F_cl
clear exp
sigm = @(x,k,th) x .* 1./(1+exp(-k.*( x - th)));
k = 40;
th = .5;
for tr = 1:size(dF_cl,3)
    for cl = 1:size(dF_cl,2)
        % threshold
        fdF_cl(:,cl,tr) = sigm(dF_cl(:,cl,tr),k,th);
    end
end

%%
% Then map Ca traces to CoM frame time vector and convolve with fast kernel
ft = makeFrameTime(bartrial);
ftca2ft = ft_ca;
for tci = 1:length(ft_ca)
    [~,ti] = min(abs(ft-ft_ca(tci)));
    ftca2ft(tci) = ti;
end
%
ker = 1:50;
ker = ker.^3.*(exp(-ker*.75/1));
[~,dpeak] = max(ker);
for tr = 1:size(dF_cl,3)
    for cl = 1:size(dF_cl,2)
        % insert
        ufdF_cl(ftca2ft,cl,tr) = fdF_cl(:,cl,tr);
        % insert
        uF_cl(ftca2ft,cl,tr) = F_cl(:,cl,tr);
        % convolve
        temp = conv(ufdF_cl(:,cl,tr),ker);
        ufdF_cl(:,cl,tr) = temp(dpeak:end-(length(ker)-dpeak));
        %
        uF_cl(:,cl,tr) = fillmissing(uF_cl(:,cl,tr),'pchip');
    end
end

%% plot histograms of activation values and thresholding
if (PLOT)
    dclfig = figure; dclfig.Position = [348    32   640   964];
    [deltax] = subOptimalBinWidth(probe(:));
    for cl = 1:size(map,1)
        ax = subplot(3,2,cl,'parent',dclfig); ax.NextPlot = 'add';
        H = histogram(dF_cl(:,cl,:),'BinMethod','fd','DisplayStyle','stairs','Normalization','pdf');
        H = histogram(fdF_cl(:,cl,:),'BinMethod','fd','DisplayStyle','stairs','Normalization','pdf');
        plot(-1:.01:2,sigm(-1:.01:2,k,th))
        title(ax,['cluster ' num2str(cl)]);
        xlabel('Rectify derivative')
        ylabel('count')
    end
    ax = subplot(3,2,6,'parent',dclfig); cla(ax), ax.NextPlot = 'add';
    plot(squeeze(dF_cl(:,2,16)))
    plot(squeeze(fdF_cl(:,2,16)))
    plot(squeeze(F_cl(:,2,16))/max(squeeze(F_cl(:,2,16)))*4,'color',[0 0 0])
    xlabel('Frames')
    
    if (PRINT)
        filename = [cellid '_ReLuActivation']; %#ok<*UNRCH>
        export_fig(dclfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
        export_fig(dclfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
    end
end

%% Plot a few exmample traces and their activations
if (PLOT)
    exmpfig = figure; exmpfig.Position = [275   201   965   777];
    randtr = randperm(size(dF_cl,3),4);
    for rt = 1:length(randtr)
        ax = subplot(4,1,rt,'parent',exmpfig); cla(ax), ax.NextPlot = 'add';
        cl = 1:2;
        plot(ft_ca,squeeze(F_cl(:,2,randtr(rt))))
        plot(ft_ca,squeeze(fdF_cl(:,2,randtr(rt))))
        plot(ft,squeeze(ufdF_cl(:,2,randtr(rt))))
        title(ax,['trial ' num2str(randtr(rt))]);
        ax.XLim = [ft(1) ft(end)];
    end
    xlabel(ax,'time (s)');
    
    if (PRINT)
        filename = [cellid '_ActiveExamples'];
        export_fig(exmpfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
        export_fig(exmpfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
    end
end

%% reshape cubes into columns
DF = reshape(ufdF_cl,[],size(ufdF_cl,2));
F = reshape(uF_cl,[],size(uF_cl,2));
for cl = 1:size(DF,2)
    % Now each column is all of the trials for a given cluster.
    DF(:,cl) = reshape(ufdF_cl(:,cl,:),[],1);
    F(:,cl) = reshape(uF_cl(:,cl,:),[],1);
end
probe = probe(:);
dprobe_dt = dprobe_dt(:);
ddprobe_dt2 = ddprobe_dt2(:);

%% First get rid of soft and slow and hard and slow values

[~,xbins,vbins] = histcounts2(probe(:),dprobe_dt(:),length(deltax)*[1 2],'Normalization','count');
soft = xbins(floor(length(xbins)/7));
[~,v0] = min(abs(vbins));
slow_p = vbins(v0+2);
slow_n = vbins(v0-2);
hard = xbins(floor(length(xbins)-5));

% Use these bins and centers from here on out;
xctrs = xbins(1:end-1)+diff(xbins(1:2)/2);
vctrs = vbins(1:end-1)+diff(vbins(1:2)/2);


softandslow = probe < soft & dprobe_dt >= slow_n & dprobe_dt <= slow_p;
hardandslow = probe > hard & dprobe_dt >= slow_n & dprobe_dt <= slow_p;
DF_hf = DF(~softandslow & ~hardandslow,:);
probe_hf = probe(~softandslow & ~hardandslow);
dprobe_dt_hf = dprobe_dt(~softandslow & ~hardandslow);
ddprobe_dt2_hf = ddprobe_dt2(~softandslow & ~hardandslow);

DF_ss = DF(softandslow,:);
probe_ss = probe(softandslow,:);
dprobe_dt_ss = dprobe_dt(softandslow,:);
ddprobe_dt2_ss = ddprobe_dt2(softandslow,:);

%% Alternative 1) which parts of phase plot are found when clusters are active
% Now measure the change in the cluster intensity when for hot spots 
% in the phase plot


%% Compare the activations of Clusters 1, 2, and 4 vs each other
if (PLOT)
    clvsclfig = figure; clvsclfig.Position = [275   201   965   777];
    ax = subplot(2,2,1,'parent',clvsclfig); ax.NextPlot = 'add';
    plot(DF(:,2),DF(:,1),'.')
    plot(DF_hf(:,2),DF_hf(:,1),'.','markersize',2)
    xlabel(ax,'cluster 2 activity');
    ylabel(ax,'cluster 1 activity');
    
    ax = subplot(2,2,2,'parent',clvsclfig); ax.NextPlot = 'add';
    plot(DF(:,2),DF(:,3),'.')
    plot(DF_hf(:,2),DF_hf(:,3),'.','markersize',2)
    xlabel(ax,'cluster 2 activity');
    ylabel(ax,'cluster 3 activity');
    
    ax = subplot(2,2,3,'parent',clvsclfig); ax.NextPlot = 'add';
    plot(DF(:,2),DF(:,4),'.')
    plot(DF_hf(:,2),DF_hf(:,4),'.','markersize',2)
    % plot(DF_ss(:,2),DF_ss(:,4),'.','markersize',2)
    xlabel(ax,'cluster 2 activity');
    ylabel(ax,'cluster 4 activity');
    
    ax = subplot(2,2,4,'parent',clvsclfig); ax.NextPlot = 'add';
    plot(DF(:,1),DF(:,4),'.','displayname','all')
    plot(DF_hf(:,1),DF_hf(:,4),'.','markersize',2,'displayname','hard and fast')
    plot(DF_ss(:,1),DF_ss(:,4),'.','markersize',1,'displayname','soft and slow')
    xlabel(ax,'cluster 1 activity');
    ylabel(ax,'cluster 4 activity');
    
    legend(ax,'toggle')
    
    if (PRINT)
        filename = [cellid '_ClVsCl_NoSoftAndSlow'];
        export_fig(clvsclfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
        export_fig(clvsclfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
    end
end

%% Great!
% There is a difference in the relationships between the clusters when
% only looking at the hard and fast probe points, vs looking at just
% the soft and slow points. This is likely because soft and slow points
% are when the fly has let go of the bar


%% Plot the kinematic variables in the hard and fast vs soft and slow conditions
if (PLOT)
    
    dN_hf = histcounts2(probe_hf(:),dprobe_dt_hf(:),xbins,vbins,'Normalization','count');
    dN_ss = histcounts2(probe_ss(:),dprobe_dt_ss(:),xbins,vbins,'Normalization','count');

    kinfig = figure; kinfig.Position = [447 32 608 964];
    ax = subplot(3,1,1,'parent',kinfig);
    
    s1 = pcolor(ax,vctrs,xctrs,log10(dN));
    s1.EdgeColor = 'flat';
    colormap(ax,'hot')
    colorbar(ax)
    xlabel(ax,'Velocity (um/s)');
    ylabel(ax,'Position (um)');
    
    title(ax,[regexprep(cellid,'\_','\\_') ' hard and fast']);
    
    ax = subplot(3,1,2,'parent',kinfig);
    s1 = pcolor(ax,vctrs,xctrs,log10(dN_ss));
    colormap(ax,'hot')
    colorbar(ax)
    
    s1.EdgeColor = 'flat';
    xlabel(ax,'Velocity (um/s)');
    ylabel(ax,'Position (um)');
    
    title(ax,'soft and slow');
    
    if (PRINT)
        filename = [cellid '_kinematicRegimes'];
        export_fig(kinfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
        export_fig(kinfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
    end
end

%% Now compare the kinematic variables conditioned on the activations
% 1) When cluster 2 is active, where are velocity and probe?
cluster2active = DF_hf(:,2)>th;
DF_given2 = DF_hf(cluster2active,2);
probe_given2 = probe_hf(cluster2active);
dprobe_dt_given2 = dprobe_dt_hf(cluster2active);
ddprobe_dt2_given2 = ddprobe_dt2_hf(cluster2active);

if (PLOT)
    proxfig = figure; proxfig.Position = [447 32 608 964];
    ax = subplot(6,2,1,'parent',proxfig);
    dN = histcounts2(probe_given2(:),dprobe_dt_given2(:),xbins,vbins,'Normalization','count');
    s1 = pcolor(ax,vctrs,xctrs,log10(dN));
    s1.EdgeColor = 'flat';
    colormap(ax,'hot')
    colorbar(ax)
    xlabel(ax,'Velocity (um/s)');
    ylabel(ax,'Position (um)');
    title(ax,[regexprep(cellid,'\_','\\_') ' Proximal cluster active']);
    
    clims = ax.CLim;
    %
    % They tend to be on the right hand side of the phase plot
    
    %
    % 2) When cluster 1 is active, where are the velocity and probe?
    cluster1active = DF_hf(:,1)>th;
    probe_given1 = probe_hf(cluster1active);
    dprobe_dt_given1 = dprobe_dt_hf(cluster1active);
    
    ax = subplot(6,2,2,'parent',proxfig);
    dN = histcounts2(probe_given1(:),dprobe_dt_given1(:),xbins,vbins,'Normalization','count');
    s1 = pcolor(ax,vctrs,xctrs,log10(dN));
    s1.EdgeColor = 'flat';
    colormap(ax,'hot')
    colorbar(ax)
    xlabel(ax,'Velocity (um/s)');
    ylabel(ax,'Position (um)');
    title(ax,[regexprep(cellid,'\_','\\_') ' Distal cluster active']);
    
    ax.CLim = clims;
    
    %
    % Again, the bar is moving fast and hard when cluster 1 is active
    
    
    % 3) When only cluster 2 is active
    cluster2not1active = DF_hf(:,2)>th & DF_hf(:,1)<=th;
    probe_given2not1 = probe_hf(cluster2not1active);
    dprobe_given2not1 = dprobe_dt_hf(cluster2not1active);
    
    ax = subplot(3,1,2,'parent',proxfig);
    dN = histcounts2(probe_given2not1(:),dprobe_given2not1(:),xbins,vbins,'Normalization','count');
    s1 = pcolor(ax,vctrs,xctrs,log10(dN));
    s1.EdgeColor = 'flat';
    colormap(ax,'hot')
    colorbar(ax)
    xlabel(ax,'Velocity (um/s)');
    ylabel(ax,'Position (um)');
    title(ax,[regexprep(cellid,'\_','\\_') ' Proximal only']);
    ax.CLim = clims;
    
    %
    % 4) When only cluster 1 is active
    cluster1not2active = DF_hf(:,2)<=th & DF_hf(:,1)>th ;
    probe_given1not2 = probe_hf(cluster1not2active);
    dprobe_given1not2 = dprobe_dt_hf(cluster1not2active);
    
    ax = subplot(3,1,3,'parent',proxfig);
    dN = histcounts2(probe_given1not2(:),dprobe_given1not2(:),xbins,vbins,'Normalization','count');
    s1 = pcolor(ax,vctrs,xctrs,log10(dN));
    s1.EdgeColor = 'flat';
    colormap(ax,'hot')
    colorbar(ax)
    xlabel(ax,'Velocity (um/s)');
    ylabel(ax,'Position (um)');
    title(ax,[regexprep(cellid,'\_','\\_') ' Distal only']);
    ax.CLim = clims;
    
    if (PRINT)
        filename = [cellid '_ConditionalProbability'];
        export_fig(proxfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
        export_fig(proxfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
    end
end

%% Alternative 2)
% Now measure the change in the cluster intensity when the probe is
% in particular hot spots in the phase plot

% eliminate pre light and post light points
lghtOn = ft>0&ft<bartrial.params.stimDurInSec;

% reshape cubes into columns, 
F = reshape(uF_cl,[],size(uF_cl,2));
for cl = 1:size(DF,2)
    % Now each column is all of the trials for a given cluster.
    temp = uF_cl(:,cl,:);
    temp(~lghtOn,1,:) = nan;
    F(:,cl) = reshape(temp,[],1);
end
probe = probe(:);
dprobe_dt = dprobe_dt(:);
ddprobe_dt2 = ddprobe_dt2(:);

soft = xbins(floor(length(xbins)/7));
hard = xbins(floor(length(xbins)-5));
[~,v0] = min(abs(vbins));
slow_p = vbins(v0+2);
slow_n = vbins(v0-2);

% u = nan(4,2);
% v = nan(4,2);

% ROI 1: soft and slow - not moving, probe at 0 extent
u(1,:) = [xbins(1) soft];
v(1,:) = [vbins(v0-2) vbins(v0+2)];

% ROI 1: hard and slow - not moving at the furthest extent
u(2,:) = [hard xbins(end)];
v(2,:) = [slow_n slow_p];

% ROI3: fast, but deccelerating when flexed
u(3,:) = [287 366]; % Near top
v(3,:) = [782 1863]; % fast positive

% find the maximum value of all clusters
climmax = max(F(:));

% Loop through ROIs
for roi = 1:size(u,1)
    roi_idx = probe > u1(1) & probe <= u1(2) & dprobe_dt >= v1(1) & dprobe_dt <= v1(2);
    F_roi = F(roi_idx,:);
    probe_roi = probe(roi_idx);
    dprobe_dt_roi = dprobe_dt(roi_idx);  % ddprobe_dt2_hf = ddprobe_dt2(roi_idx);

    % average cluster values for that roi
    Froi = nanmean(F,1);
    





end


% Soft and slow
softandslow = probe < soft & dprobe_dt >= slow_n & dprobe_dt <= slow_p;
DF_ss = DF(softandslow,:);
probe_ss = probe(softandslow,:);
dprobe_dt_ss = dprobe_dt(softandslow,:);
ddprobe_dt2_ss = ddprobe_dt2(softandslow,:);

% fast, but deccelerating when flexed
y = [287 366]; % Near top
x = [782 1863]; % fast positive
roi3_idx = probe >=y(1) & probe <= y(2) & dprobe_dt >= slow_n & dprobe_dt <= slow_p;
F_roi3 = uF_cl(roi3_idx,:,:);

% end

function scalclusters(ax,F,clmask);
axn = subplot(2,2,cidx,'parent',dbfig2);
title(axn,regexprep(cellid,'\_','\\_'));
clrs = parula(size(bartrial.clustertraces_NBCls,2)+1);
imshow(clmask*0,[0 255],'parent',axn);
for cl = 1:length(blobs)
    clridx = map(map(:,2)==cl,1);
    %alphamask(clmask==cl,clrs(cl,:),1,axn);
    alphamask(clmask==cl,clrs(clridx,:),1,axn);
    %text(blobs(cl).Centroid(1),blobs(cl).Centroid(2),num2str(cl),'parent',axn,'color',[1 1 1],'verticalAlignment','middle','HorizontalAlignment','center');
end
end


