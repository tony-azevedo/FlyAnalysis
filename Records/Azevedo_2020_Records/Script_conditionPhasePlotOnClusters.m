close all
%%
% Go through all the probe frames
% Plot the histogram of distances, velocities, and accelerations
% Plot relationships of {x,x_dot,x_ddot} with cluster values

% Note, a hard coded trial for Figure 1 of the paper is in the section
% around 215

PLOT = 0;
PRINT = 0;

proxfig = figure; proxfig.Position = [162 476 1608 460];
Fvals = [];
Gs = [];

hexclrs = [
    '3C489E'
    'D64C90'
    'F9A61A'
    '00FF00'
    '47DDFF'
    '03AC72'
];
clrs = hex2rgb(hexclrs);

Dxbin = [
    5
    5
    5
    8
    7
    ];
evntths = [
    0.005   0.005
    0.005   0.005
    0.005   0.005
    0.005   0.005
    0.005   0.005
    ];

for cidx = 1:length(T_legImagingList.CellID)
    T_row = T_legImagingList(cidx,:);
    trialStem = [T_row.Protocol{1} '_Raw_' T_row.CellID{1} '_%d.mat'];
    Dir = fileparts(T_row.TableFile{1}); cd(Dir);
    cellid = T_row.CellID{1}
    
    % Going with Non-bar clusters to start
    map = T_row.ClusterMapping_NBCls{1};
    % map assigns value map(:,1) to the cluster values map(:,2)
    
    bartrials = T_row.Bartrials{1};
    bartrial = load(sprintf(trialStem,bartrials(1)));
    
    clmask = bartrial.clmaskFromNonBarTrials;
    if length(size(clmask))>2
        N_Cl_idx = nan(size(clmask,3),1);
        for idx = 1:length(N_Cl_idx)
            N_Cl_idx(idx) = length(unique(clmask(:,:,idx)))-1;
        end
        clmask = squeeze(clmask(:,:,N_Cl_idx==min(size(bartrial.clustertraces_NBCls))));
    else
        %clmask = clmask;
    end
    
    %{
    Now we have a clmask.
    The initial clmask often is missing a cluster that is associated with
    distal pixels. Thus there are only 5 labels, and "6" can be one of them.
    The map tells the assignment for the 1:5 clusters we're interested in,
    but it doesn't assign the columns in the clustertraces matrix, that
    only has as 5 columns. If "2" is missing, then cluster 3 intensity can
    be found in column 3.
    %}
    
    % move all the numbers back if nessesary
    clvals = unique(clmask);
    missing = setxor(clvals,0:max(clvals));
    if ~isempty(missing)
        for j = length(missing):-1:1
            curmissing = missing(j);
            for i = curmissing+1:max(clvals)
                clmask(clmask==i) = i-1;
                map(map(:,2)==i,2) = i-1;
            end
        end
    end
    if (DEBUG)
        figure
        axn = subplot(1,1,1);
        title(axn,regexprep(cellid,'\_','\\_'));
        % clrs = parula(size(bartrial.clustertraces,2)+1);
        imshow(clmask*0,[0 255],'parent',axn);
        for cl = 1:size(map,1)
            clridx = cl;
            clnum = map(map(:,1)==cl,2);
            alphamask(clmask==clnum,clrs(clridx,:),1,axn);
            % text(blobs(cl).Centroid(1),blobs(cl).Centroid(2),num2str(cl),'parent',axn,'color',[1 1 1],'verticalAlignment','middle','HorizontalAlignment','center');
        end
    end
    
    clmask_mapped = clmask;
    for cl = 1:size(map,1)
        clmask_mapped(clmask==map(cl,2)) = cl;
    end
    if (DEBUG)
        figure
        axn = subplot(1,1,1);
        title(axn,regexprep(cellid,'\_','\\_'));
        % clrs = parula(size(bartrial.clustertraces,2)+1);
        imshow(clmask_mapped*0,[0 255],'parent',axn);
        for cl = 1:size(map,1)
            alphamask(clmask_mapped==cl,clrs(cl,:),1,axn);
            % text(blobs(cl).Centroid(1),blobs(cl).Centroid(2),num2str(cl),'parent',axn,'color',[1 1 1],'verticalAlignment','middle','HorizontalAlignment','center');
        end
    end
    
    ft = makeFrameTime(bartrial);
    dt = diff(ft(1:2));
    
    probe = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
    dprobe_dt = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
    ddprobe_dt2 = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
    cnt = 0;
    
    ft_ca = makeFrameTime2CB2T(bartrial);
    
    %% Preallocate for filtering steps
    % Fluo(cluster)
    F_cl = nan(max(size(bartrial.clustertraces_NBCls)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
    barcoverage_cl = nan(max(size(bartrial.clustertraces_NBCls)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
    % derivative of Fluo(cluster)
    % dF_cl = nan(max(size(bartrial.clustertraces_NBCls)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
    % thresholded derivative of Fluo(cluster)
    % fdF_cl = dF_cl;
    % upsampled thresholded derivative of Fluo(cluster)
    % ufdF_cl = zeros(max(size(bartrial.forceProbeStuff.CoM)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
    % upsampled Fluo(cluster)
    uF_cl = nan(max(size(bartrial.forceProbeStuff.CoM)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
    uBC_cl = nan(max(size(bartrial.forceProbeStuff.CoM)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
    % derivative of upsampled Fluo(cluster)
    duF_cl = nan(max(size(bartrial.forceProbeStuff.CoM)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
    duBC_cl = nan(max(size(bartrial.forceProbeStuff.CoM)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
    fduF_cl = zeros(max(size(bartrial.forceProbeStuff.CoM)),min(size(bartrial.clustertraces_NBCls)),length(bartrials));
    
    for tr = bartrials'
        
        bartrial = load(sprintf(trialStem,tr));
        F0 = bartrial.F0_clustertraces_NBCls;
        
        cnt = cnt+1;
        probe(:,cnt) = bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce;
        dprobe_dt(:,cnt) = cat(1,diff(probe(:,cnt)),nan)/dt;
        ddprobe_dt2(:,cnt) = cat(1,nan,diff(dprobe_dt(:,cnt)))/dt;
        
        % order the clusters appropriately
        
        for cl = 1:size(map,1)
%             F_cl(:,cl,cnt) = (medfilt1(bartrial.clustertraces_NBCls(:,map(cl,2))) - F0(map(cl,2)))/F0(map(cl,2));
            F_cl(:,cl,cnt) = (bartrial.clustertraces_NBCls(:,map(cl,2)) - F0(map(cl,2)))/F0(map(cl,2));%             catch
%                 if length(bartrial.clustertraces_NBCls(:,map(cl,2))) < size(F_cl,1)
%                     F_cl(1:length(bartrial.clustertraces_NBCls(:,map(cl,2))),cl,cnt) = (medfilt1(bartrial.clustertraces_NBCls(:,map(cl,2))) - F0(map(cl,2)))/F0(map(cl,2));
%                 end
%             end
            try barcoverage_cl(:,cl,cnt) = bartrial.clustercovered_NBCls(:,map(cl,2));
            catch
                if length(bartrial.clustercovered_NBCls(:,map(cl,2))) < size(F_cl,2)
                    barcoverage_cl(1:length(bartrial.clustercovered_NBCls(:,map(cl,2))),cl,cnt) = bartrial.clustercovered_NBCls(:,map(cl,2));
                end
            end
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
    
    dt = diff(ft_ca(1:2));
    stimwind_ft = (ft > 2*dt & ft <= bartrial.params.stimDurInSec-2*dt);
    for tr = 1:size(F_cl,3)
        for cl = 1:size(F_cl,2)
            % insert
            uF_cl(:,cl,tr) = nan;
            uF_cl(ftca2ft,cl,tr) = F_cl(:,cl,tr);
            uF_cl(:,cl,tr) = fillmissing(uF_cl(:,cl,tr),'linear');
            [uF_cl(:,cl,tr),duF_cl(:,cl,tr)] = sgolay_t(uF_cl(:,cl,tr),7,9);
            
            duF_cl(~stimwind_ft,cl,tr) = 0;
            
            uBC_cl(:,cl,tr) = nan;
            uBC_cl(ftca2ft,cl,tr) = barcoverage_cl(:,cl,tr);
            uBC_cl(:,cl,tr) = fillmissing(uBC_cl(:,cl,tr),'linear');
            duBC_cl(:,cl,tr) = cat(1,diff(uBC_cl(:,cl,tr)),nan);

            duF_cl(uBC_cl(:,cl,tr)>.4,cl,tr) = 0;
            
        end
    end
    
    %% find thresholding params
    if 0%(PLOT)
        thfig = figure; thfig.Position = [348 32 1077 964];
    end
    
    kth = map;
    for cl = 1:size(map,1)
        [rho,edges] = histcounts(duF_cl(stimwind_ft,cl,:),'BinMethod','fd','Normalization','pdf');
        cntrs = round(1E6*edges(1:end-1)+1/2*diff(edges(1:2)))/1E6;
        mx = max(rho(cntrs<0));
        fwemx = abs(cntrs(find(rho<=mx/exp(1.2)&cntrs<0,1,'last')));
        
        th = fwemx;
        k = 50/(1+exp(th));
        kth(cl,:) = [k,th];
        if 0 %(PLOT)
            ax = subplot(3,2,cl,'parent',thfig); ax.NextPlot = 'add';
            plot(ax,cntrs,rho,'Color',[.7 .7 .7]);
            plot(ax,-cntrs(cntrs<=0),rho(cntrs<=0),'Color',[1 .4 .2]);
            plot(cntrs,softplus(kth(1,:),cntrs),'Color',[1 .4 .2]);
            ax.YLim = [0 3];
        end
        
    end
    
    %% Threshold the F derivatives
    % Apply this function to the derivatives F_cl
    clear exp
    sigm = @(x,k,th) x .* 1./(1+exp(-k.*( x - th)));
    for tr = 1:size(F_cl,3)
        for cl = 1:size(F_cl,2)
            % threshold
            fduF_cl(:,cl,tr) = sigm(duF_cl(:,cl,tr),kth(cl,1),kth(cl,2));
        end
    end
    
    if 0% (PLOT)
        ax = subplot(3,2,6,'parent',thfig); cla(ax), ax.NextPlot = 'add';
        %1
        plot(squeeze(uF_cl(:,1,16)/max(squeeze(F_cl(:,2,16)))*4),'color',[.5 .5 .5])
        plot(squeeze(duF_cl(:,1,16)),'color',[.8 .8 .8])
        plot(squeeze(fduF_cl(:,1,16)),'color',[0 0 0])
        %2
        plot(squeeze(uF_cl(:,2,16)/max(squeeze(F_cl(:,2,16)))*4),'color',[1 .5 .5])
        plot(squeeze(duF_cl(:,2,16)),'color',[1 .8 .8])
        plot(squeeze(fduF_cl(:,2,16)),'color',[.6 0 0])
        
        xlabel('Frames')
        
        if (PRINT)
            filename = [cellid '_Events_Trial_16']; %#ok<*UNRCH>
            export_fig(dclfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
            %export_fig(dclfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
        end
    end
    
    %% Plot a few exmample traces and their activations
    if 0 %(PLOT)
        exmpfig = figure; exmpfig.Position = [275   201   965   777];
        randtr = randperm(size(F_cl,3),4);
        if strcmp(cellid,'181210_F1_C1')
            randtr = [3,12,13,16];
        elseif strcmp(cellid,'190424_F2_C1')
            randtr = [31    21    11    38];
        end
        for rt = 1:length(randtr)
            ax = subplot(4,1,rt,'parent',exmpfig); cla(ax), ax.NextPlot = 'add';
            % probe
            plot(ft,probe(:,randtr(rt))/400*4,'color',[.5 .5 1])
            %1
            plot(ft,squeeze(uF_cl(:,1,randtr(rt))/max(squeeze(uF_cl(:,1,randtr(rt))))*4),'color',[.5 .5 .5])
            plot(ft,squeeze(duF_cl(:,1,randtr(rt))),'color',[.8 .8 .8])
            plot(ft,squeeze(fduF_cl(:,1,randtr(rt))),'color',[0 0 0])
            plot(ft,squeeze(uBC_cl(:,1,randtr(rt))),'color',[0 1 .5])
            %2
            plot(ft,squeeze(uF_cl(:,2,randtr(rt))/max(squeeze(F_cl(:,2,randtr(rt))))*4),'color',[1 .5 .5])
            plot(ft,squeeze(duF_cl(:,2,randtr(rt))),'color',[1 .8 .8])
            plot(ft,squeeze(fduF_cl(:,2,randtr(rt))),'color',[.6 0 0])
            
            
            title(ax,num2str(bartrials(randtr(rt))));
            ax.XLim = [ft(1) ft(end)];
        end
        xlabel(ax,'time (s)');
        sgtitle(exmpfig,regexprep(cellid, '\_','\\_'))
        
        if (PRINT)
            filename = [cellid '_ActiveExamples'];
            export_fig(exmpfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
            export_fig(exmpfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
        end
    end
    
    %% Plot Chosen example for Figure 1
    if (PLOT) && strcmp(cellid,'181210_F1_C1')
        exmpfig = figure; exmpfig.Position = [275   201   965   777];
        randtr = [16]; % trial 40
        bartrial = load(sprintf(trialStem,bartrials(randtr)));

        % emg
        ax = subplot(7,1,1,'parent',exmpfig); cla(ax), ax.NextPlot = 'add';
        t = makeInTime(bartrial.params);
        plot(ax,t,bartrial.current_2,'color',[1 0 0]);
        
        % clusters
        ax1 = subplot(7,1,[2 3],'parent',exmpfig); cla(ax1), ax1.NextPlot = 'add';
        ax2 = subplot(7,1,[4 5],'parent',exmpfig); cla(ax2), ax2.NextPlot = 'add';
        for cl = 1:size(uF_cl,2)
            plot(ax1,ft_ca,squeeze(F_cl(:,cl,randtr)),'color',clrs(cl,:))
            plot(ax2,ft,squeeze(fduF_cl(:,cl,randtr)),'color',clrs(cl,:))
        end
        ax2.YLim = [-.1 .4];
        ax2.XTick = [];
        
        % probe
        axp = subplot(7,1,[6 7],'parent',exmpfig); cla(axp), axp.NextPlot = 'add';
        plot(axp,ft,bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce,'color',[.5 .5 1])

        linkaxes([ax,ax1,ax2,axp],'x');
        ax.XLim = [2.1366    4.4738];
        set([ax,ax1,ax2,axp],'tickdir','out')
        
%         
%         title(ax,num2str(bartrials(randtr(rt))));
%         ax.XLim = [ft(1) ft(end)];
%         
%         xlabel(ax,'time (s)');
%         sgtitle(exmpfig,regexprep(cellid, '\_','\\_'))
%         
        if (PRINT)
            filename = [cellid '_ActiveExamples'];
            export_fig(exmpfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
            export_fig(exmpfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
        end
    end
    
    %% reshape cubes into columns
    % First need some matrices to hash back to trials
    tmshsh = repmat(ft,1,size(probe,2));
    idxhsh = repmat(1:length(ft),1,size(probe,2));
    trlhsh = repmat(bartrials(:)',size(probe,1),1);
    
    % "events"
    DF = reshape(fduF_cl,[],size(fduF_cl,2));
    % fluorescence
    F = reshape(uF_cl,[],size(uF_cl,2));
    BC = reshape(uBC_cl,[],size(uBC_cl,2));
    dBC = reshape(uBC_cl,[],size(duBC_cl,2));
    for cl = 1:size(DF,2)
        % Now each column is all of the trials for a given cluster.
        DF(:,cl) = reshape(fduF_cl(:,cl,:),[],1);
        F(:,cl) = reshape(uF_cl(:,cl,:),[],1);
        BC(:,cl) = reshape(uBC_cl(:,cl,:),[],1);
        dBC(:,cl) = reshape(duBC_cl(:,cl,:),[],1);
    end
    probe = probe(:);
    dprobe_dt = dprobe_dt(:);
    ddprobe_dt2 = ddprobe_dt2(:);
    tmshsh = tmshsh(:);
    trlhsh = trlhsh(:);
    idxhsh = idxhsh(:);
    
    %% First get rid of soft and slow and hard and slow values
    [deltax] = subOptimalBinWidth(probe(:));
    
    [dNall,xbins,vbins] = histcounts2(probe(:),dprobe_dt(:),length(deltax)*[1 2],'Normalization','count');
    soft = xbins(floor(length(xbins)/7));
    [~,v0] = min(abs(vbins));
    slow_p = vbins(v0+2);
    slow_n = vbins(v0-2);
    hard = xbins(floor(length(xbins)-Dxbin(cidx)));
    
    % Use these bins and centers from here on out;
    uctrs = xbins(1:end-1)+diff(xbins(1:2)/2);
    vctrs = vbins(1:end-1)+diff(vbins(1:2)/2);
    
    softandslow = probe < soft & dprobe_dt >= slow_n & dprobe_dt <= slow_p;
    hardandslow = probe > hard & dprobe_dt >= slow_n & dprobe_dt <= slow_p;
    DF_hf = DF(~softandslow & ~hardandslow,:);
    F_hf = F(~softandslow & ~hardandslow,:);
    probe_hf = probe(~softandslow & ~hardandslow);
    dprobe_dt_hf = dprobe_dt(~softandslow & ~hardandslow);
    ddprobe_dt2_hf = ddprobe_dt2(~softandslow & ~hardandslow);
    
    DF_ss = DF(softandslow,:);
    probe_ss = probe(softandslow,:);
    dprobe_dt_ss = dprobe_dt(softandslow,:);
    ddprobe_dt2_ss = ddprobe_dt2(softandslow,:);
    
    %% Find Times when BC is decreasing, rule those out for increases in cluster 1.
    
    %% Alternative 1) which parts of phase plot are found when clusters are active
    % Now measure the change in the cluster intensity when for hot spots
    % in the phase plot
    
    
    %% Compare the activations of Clusters 1, 2, and 4 vs each other
    if 0 %(PLOT)
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
        plot(DF_ss(:,2),DF_ss(:,4),'.','markersize',2)
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
    
    %% Compare activities of Clusters 1 and 2 when active
    if 0% (PLOT)
        evntth = 0.005;
        cluster2active = DF_hf(:,2)>=evntth;
        cluster1active = DF_hf(:,1)>=evntth;
        
        clvsclfig = figure; clvsclfig.Position = [275 764 259 214];
        ax = subplot(1,1,1,'parent',clvsclfig); ax.NextPlot = 'add';
        %         plot(DF(:,2),DF(:,1),'.','color',[1 1 1]*.8,'markersize',8)
        plot(DF_hf(cluster2active&cluster1active,2),DF_hf(cluster2active&cluster1active,1),'.','markersize',4,'color',[0 0 1],'Displayname','Both')
        plot(DF_hf(cluster2active&~cluster1active,2),DF_hf(cluster2active&~cluster1active,1),'.','markersize',4,'color',[1 0 0],'Displayname','Cluster2')
        plot(DF_hf(~cluster2active&cluster1active,2),DF_hf(~cluster2active&cluster1active,1),'.','markersize',4,'color',[0 1 0],'Displayname','Cluster1')
        xlabel(ax,'cluster 2 activity');
        ylabel(ax,'cluster 1 activity');
        
        if (PRINT)
            filename = [cellid '_ClVsCl_NoSoftAndSlow'];
            export_fig(clvsclfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
            export_fig(clvsclfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
        end
        ax.XLim = [0 2];
        ax.YLim = [0 2];
        title(ax,cellid);
        
    end
    
    %% Great!
    % There is a difference in the relationships between the clusters when
    % only looking at the hard and fast probe points, vs looking at just
    % the soft and slow points. This is likely because soft and slow points
    % are when the fly has let go of the bar
    
    
    %% Plot the kinematic variables in the hard and fast vs soft and slow conditions
    if 1%(PLOT)
        
        dN_hf = histcounts2(probe_hf(:),dprobe_dt_hf(:),xbins,vbins,'Normalization','count');
        dN_ss = histcounts2(probe_ss(:),dprobe_dt_ss(:),xbins,vbins,'Normalization','count');
        
        kinfig = figure; kinfig.Position = [447 32 608 964];
        ax = subplot(3,1,1,'parent',kinfig);
        
        s1 = pcolor(ax,vctrs,uctrs,log10(dN_hf));
        s1.EdgeColor = 'flat';
        colormap(ax,'hot')
        colorbar(ax)
        xlabel(ax,'Velocity (um/s)');
        ylabel(ax,'Position (um)');
        
        title(ax,[regexprep(cellid,'\_','\\_') ' hard and fast']);
        
        ax = subplot(3,1,2,'parent',kinfig);
        s1 = pcolor(ax,vctrs,uctrs,log10(dN_ss));
        colormap(ax,'hot')
        colorbar(ax)
        s1.EdgeColor = 'flat';
        xlabel(ax,'Velocity (um/s)');
        ylabel(ax,'Position (um)');
        
        title(ax,'soft and slow');

        ax = subplot(3,1,3,'parent',kinfig);
        s1 = pcolor(ax,vctrs,uctrs,log10(dNall));
        colormap(ax,'hot')
        colorbar(ax)
        s1.EdgeColor = 'flat';
        xlabel(ax,'Velocity (um/s)');
        ylabel(ax,'Position (um)');
        
        title(ax,'all');

        centroidall = histCentroid(uctrs,vctrs,dNall);
        ax.NextPlot
        plot(ax,centroidall(2),centroidall(1),'o','tag',[cellid '_1and2'],'color',[0 0 1])

        
        if (PRINT)
            filename = [cellid '_kinematicRegimes'];
            export_fig(kinfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
            export_fig(kinfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
        end
    end
    
    %% Now compare the kinematic variables conditioned on the activations
    evntth_1 = evntths(cidx,1);
    evntth_2 = evntths(cidx,2);
    % 1) When cluster 2 is active, where are velocity and probe?
    cluster2active = DF(:,2)>=evntth_2 & ~softandslow & ~hardandslow;
    DF_given2 = DF(cluster2active,2);
    probe_given2 = probe(cluster2active);
    dprobe_dt_given2 = dprobe_dt(cluster2active);
    ddprobe_dt2_given2 = ddprobe_dt2(cluster2active);
    cluster2ValsFor2active = F(cluster2active,2);

    % 2) When cluster 1 is active, where are the velocity and probe?
    cluster1active = DF(:,1)>=evntth_1 & ~softandslow & ~hardandslow;
    probe_given1 = probe(cluster1active);
    dprobe_dt_given1 = dprobe_dt(cluster1active);
    
    %% 1b) When both 1 and 2 are active, where are the velocity and probe?
    cluster1active = DF(:,1)>=evntth_1 & ~softandslow & ~hardandslow;
    cluster2active = DF(:,2)>=evntth_2 & ~softandslow & ~hardandslow;
    probe_given1and2 = probe(cluster1active&cluster2active);
    dprobe_dt_given1and2 = dprobe_dt(cluster1active&cluster2active);
    
    measurements = regionprops(cluster1active&cluster2active, 'Area','PixelList');
    if (PLOT) && strcmp(cellid,'181210_F1_C1')
        %% sections of note
        %{
        
        %}
        [descacti,o] = sort([measurements.Area],'descend');
        descm = measurements(o);
        activation = descm(4);
        idx = activation.PixelList(1,2);
        
        trialend = find(trlhsh(idx+1:end)~=trlhsh(idx),1) - 1;
        if trialend<50
            i_f = trialend;
        else
            i_f = 50;
        end
        DT = [tmshsh(idx-50) tmshsh(idx+i_f)];
        iwin = idx + (-50:i_f);
        %idx = 5700;
        
        bartrial = load(sprintf(trialStem,trlhsh(idx)));
        t = makeInTime(bartrial.params);
        twin = t>=DT(1)&t<=DT(2);

        f = figure
        f.Position = [680 652 184 326];
        ax1 = subplot(7,1,1);
        plot(t(twin),bartrial.current_2(twin),'color',[0 0 0]);
        title(sprintf('Trial %d: %f.2 s, idx = %d',trlhsh(idx),tmshsh(idx),idx));
        ax1.YLim = [-350 100];
        
        ax2 = subplot(7,1,[2 3]);
        plot(tmshsh(iwin),F(iwin,1),'color',clrs(1,:))
        hold on
        plot(tmshsh(iwin),F(iwin,2),'color',clrs(2,:))
        ax2.YLim = [0 4];
        
        ax3 = subplot(7,1,[4 5]);
        plot(tmshsh(iwin),DF(iwin,1),'color',clrs(1,:))
        hold on
        plot(tmshsh(iwin),DF(iwin,2),'color',clrs(2,:))
        ax3.YLim = [0 1.1];
        
        ax4 = subplot(7,1,[6 7]);
        plot(tmshsh(iwin),probe(iwin),'color',[.2 .2 .2])
        ax4.YLim = [0 400];
        %         title(sprintf('Trial %d: %f.2 s, idx = %d',trlhsh(idx),tmshsh(idx),idx));
        
        set([ax1 ax2 ax3 ax4],'XLim',DT,'TickDir','out','box','off')
        set([ax1 ax2 ax3],'XTick',[])
        
        fprintf('Trial %d: %f.2 s, idx = %d',trlhsh(idx),tmshsh(idx),idx);
        fprintf('\n');
        
    end
    
    %% 3) When only cluster 2 is active
    cluster2not1active = DF(:,2)>=evntth_2 & DF(:,1)<=evntth_1 & ~softandslow & ~hardandslow;
    measurements = regionprops(cluster2not1active, 'Area','PixelList');
    longact = measurements([measurements.Area]>1);
    % shortact = measurements([measurements.Area]<=1);
    twoOver1sxions = [];
    for la = 1:length(longact)
        twoOver1sxions = cat(1,twoOver1sxions,longact(la).PixelList(:,2));
    end
%     cluster2not1active(:) = false;
%     cluster2not1active(twoOver1sxions) = true;

    if (PLOT) && strcmp(cellid,'181210_F1_C1')
        %% sections of note!
        %{ 
        181210_F1_C1
        40 2.36
        39  3.24
        37  3.243
        37  2.78
        29  2.04
        29  1.8
        27  1.96
        25  .46
        
        181209_F2_C1
        
        %}
        [descacti,o] = sort([measurements.Area],'descend');
        descm = measurements(o);
        activation = descm(8);
        idx = activation.PixelList(1,2);
        
        trialend = find(trlhsh(idx+1:end)~=trlhsh(idx),1) - 1;
        if trialend<50
            i_f = trialend;
        else
            i_f = 50;
        end
        DT = [tmshsh(idx-50) tmshsh(idx+i_f)];
        iwin = idx + (-50:i_f);
        %idx = 5700;
        
        bartrial = load(sprintf(trialStem,trlhsh(idx)));
        t = makeInTime(bartrial.params);
        twin = t>=DT(1)&t<=DT(2);

        f = figure
        f.Position = [680 652 184 326];
        ax1 = subplot(7,1,1);
        plot(t(twin),bartrial.current_2(twin),'color',[0 0 0]);
        title(sprintf('Trial %d: %f.2 s, idx = %d',trlhsh(idx),tmshsh(idx),idx));
        ax1.YLim = [-350 100];
        
        ax2 = subplot(7,1,[2 3]);
        plot(tmshsh(iwin),F(iwin,1),'color',clrs(1,:))
        hold on
        plot(tmshsh(iwin),F(iwin,2),'color',clrs(2,:))
        ax2.YLim = [0 4];
        
        ax3 = subplot(7,1,[4 5]);
        plot(tmshsh(iwin),DF(iwin,1),'color',clrs(1,:))
        hold on
        plot(tmshsh(iwin),DF(iwin,2),'color',clrs(2,:))
        ax3.YLim = [0 .1];
        
        ax4 = subplot(7,1,[6 7]);
        plot(tmshsh(iwin),probe(iwin),'color',[.2 .2 .2])
        ax4.YLim = [0 400];
        %         title(sprintf('Trial %d: %f.2 s, idx = %d',trlhsh(idx),tmshsh(idx),idx));
        
        set([ax1 ax2 ax3 ax4],'XLim',DT,'TickDir','out','box','off')
        set([ax1 ax2 ax3],'XTick',[])
        
        fprintf('Trial %d: %f.2 s, idx = %d',trlhsh(idx),tmshsh(idx),idx);
        fprintf('\n');
        
    end
    probe_given2not1 = probe(cluster2not1active);
    dprobe_given2not1 = dprobe_dt(cluster2not1active);
    cluster1ValsFor2not1active = F(cluster2not1active,1);
    cluster2ValsFor2not1active = F(cluster2not1active,2);
    
    %% 4) When only cluster 1 is active    
    % but use the full set and exclude soft and slow to see if there are
    % long consecutive stretches
    cluster1not2active = DF(:,2)<=evntth_2 & DF(:,1)>evntth_1 & ~softandslow & ~hardandslow;
    cluster1not2active = DF(:,2)<=evntth_2 & DF(:,1)>evntth_1 & ~softandslow & ~hardandslow & dBC(:,1)>=0 & BC(:,1)<.3 & ~isnan(probe);
    measurements = regionprops(cluster1not2active, 'Area','PixelList');
    longact = measurements([measurements.Area]>1);
    % shortact = measurements([measurements.Area]<=1);
    oneOver2sxions = [];
    for la = 1:length(longact)
        oneOver2sxions = cat(1,oneOver2sxions,longact(la).PixelList(:,2));
    end
    cluster1not2active(:) = false;
    cluster1not2active(oneOver2sxions) = true;
    
    if (PLOT) && strcmp(cellid,'181210_F1_C1') % strcmp(cellid,'190424_F2_C1')
        %%
        [descacti,o] = sort([measurements.Area],'descend');
        descm = measurements(o);
        activation = descm(7);
        idx = activation.PixelList(1,2);
        
        trialend = find(trlhsh(idx+1:end)~=trlhsh(idx),1) - 1;
        if trialend<50
            i_f = trialend;
        else
            i_f = 50;
        end
        DT = [tmshsh(idx-50) tmshsh(idx+i_f)];
        t0 = tmshsh(idx);
        iwin = idx + (-50:i_f);
        %idx = 5700;
        
        bartrial = load(sprintf(trialStem,trlhsh(idx)));
        t = makeInTime(bartrial.params);
        twin = t>=DT(1)&t<=DT(2);

        f = figure;
        f.Position = [340 298 663 569];%[680 652 184 326];
        ax1 = subplot(7,1,1);
        plot(t(twin)-t0,bartrial.current_2(twin),'color',[0 0 0]);
        title(sprintf('Trial %d: %f.2 s, idx = %d',trlhsh(idx),tmshsh(idx),idx));
        ax1.YLim = [-350 100];
        
        ax2 = subplot(7,1,[2 3]);
        plot(tmshsh(iwin)-t0,F(iwin,1),'color',clrs(1,:))
        hold on
        plot(tmshsh(iwin)-t0,F(iwin,2),'color',clrs(2,:))
        ax2.YLim = [0 5];

        ax3 = subplot(7,1,[4 5]);
        plot(tmshsh(iwin)-t0,DF(iwin,1),'color',clrs(1,:))
        hold on
        plot(tmshsh(iwin)-t0,DF(iwin,2),'color',clrs(2,:))
        ax3.YLim = [0 .325];
        
        ax4 = subplot(7,1,[6 7]); ax4.NextPlot = 'add';
        plot(tmshsh(iwin)-t0,probe(iwin),'color',[.2 .2 .2])
        plot(tmshsh(iwin)-t0,BC(iwin,1)*100,'color',[1 .2 .4])
        ax = gca;
        ax.YLim = [0 500];
        %         title(sprintf('Trial %d: %f.2 s, idx = %d',trlhsh(idx),tmshsh(idx),idx));
        
        set([ax1 ax2 ax3 ax4],'XLim',DT-t0,'TickDir','out','box','off')
        set([ax1 ax2 ax3],'XTick',[])
        
        fprintf('Trial %d: %f.2 s, idx = %d',trlhsh(idx),tmshsh(idx),idx);
        fprintf('\n');
        
    end
    probe_given1not2 = probe(oneOver2sxions);
    dprobe_given1not2 = dprobe_dt(oneOver2sxions);
    cluster2ValsFor1not2active = F(oneOver2sxions,2);
    rand2sxions = randperm(length(F(:,2)),length(oneOver2sxions));
    randcluster2Vals = F(rand2sxions,2);
    
    %% Calculate histgrams for each condition
    dN1 = histcounts2(probe_given1(:),dprobe_dt_given1(:),xbins,vbins,'Normalization','count');
    centroid1and2 = histCentroid(uctrs,vctrs,dN1);
    
    dN2 = histcounts2(probe_given2(:),dprobe_dt_given2(:),xbins,vbins,'Normalization','count');
    centroid1and2 = histCentroid(uctrs,vctrs,dN2);
    
    dN1and2 = histcounts2(probe_given1and2(:),dprobe_dt_given1and2(:),xbins,vbins,'Normalization','count');
    centroid1and2 = histCentroid(uctrs,vctrs,dN1and2);
    
    dN2not1 = histcounts2(probe_given2not1(:),dprobe_given2not1(:),xbins,vbins,'Normalization','count');
    centroid2not1 = histCentroid(uctrs,vctrs,dN2not1);

    dN1not2 = histcounts2(probe_given1not2(:),dprobe_given1not2(:),xbins,vbins,'Normalization','count');
    centroid1not2 = histCentroid(uctrs,vctrs,dN1not2);

    %% Group Fvals for different conditions.
    Fvals = cat(1,Fvals,[cluster2ValsFor2active;cluster2ValsFor2not1active;cluster2ValsFor1not2active;randcluster2Vals]);
    g = [zeros(size(cluster2ValsFor2active));ones(size(cluster2ValsFor2not1active));ones(size(cluster2ValsFor1not2active))*2;ones(size(randcluster2Vals))*3];
    Gs = cat(1,Gs,g);
    
    %% Also do a bootstrap of the median values of random draws.
    N = 5000;
    rand2Vals = nan(length(oneOver2sxions),N);
    for n = 1:N
        rand2sxions = randperm(length(F(:,2)),length(oneOver2sxions));
        rand2Vals(:,n) = F(rand2sxions,2);
    end
    randFs{cidx} = rand2Vals;
    medFs = median(rand2Vals,1);
    p_med = sum(medFs>median(cluster2ValsFor1not2active))/N;
    if p_med==0
        fprintf('P(median is different) < %g\n',1/N);
    else
        fprintf('P(median is different) = %g\n',p_med);
    end
    figure
    hist(medFs), hold on
    plot(median(cluster2ValsFor1not2active)*[1 1],get(gca,'ylim'),'r');
    xlim(gca, [1,3]);
    
    %%
    
    ax = findobj(proxfig,'type','axes','tag','EventNumber');
    if isempty(ax)
        ax = axes('parent',proxfig,'position',[.85 .2 .14 .6],'tag','EventNumber'); ax.NextPlot = 'add';
    end
    % plot(ax,1+cidx*(.1),numel(probe_given2)/numel(probe),'.','color',[0 0 0]);
    plot(ax,1+cidx*(.1),numel(probe_hf)/numel(probe),'o','color',[0 0 0]);
    % plot(ax,2+cidx*(.1),numel(probe_given1)/numel(probe),'o','color',[0 0 0]);
    plot(ax,2+cidx*(.1),numel(probe_given1and2)/numel(probe),'o','color',[0 0 0]);
    plot(ax,3+cidx*(.1),numel(probe_given2not1)/numel(probe),'o','color',[0 0 0]);
    plot(ax,4+cidx*(.1),numel(probe_given1not2)/numel(probe),'o','color',[0 0 0]);
    fprintf('%d %s: N frames = %d\n',cidx,cellid,numel(probe));
    
    ax.YLim = [0 .17];
    
    ax = findobj(proxfig,'type','axes','tag','Centroid');
    if isempty(ax)
        ax = axes('parent',proxfig,'position',[.65 .2 .14 .32],'tag','Centroid'); ax.NextPlot = 'add';
    end
    centroid = [centroid1and2;centroid2not1];
    plot(ax,centroid1and2(2),centroid1and2(1),'o','tag',[cellid '_1and2'],'color',[0 0 1])
    plot(ax,centroid2not1(2),centroid2not1(1),'o','tag',[cellid '_2'],'color',[1 0 0])
    plot(ax,centroid1not2(2),centroid1not2(1),'o','tag',[cellid '_1'],'color',[0 1 0])
    plot(ax,centroid(:,2),centroid(:,1),'tag',cellid,'color',[0 0 0])
    
    k = 0.2234; %N/m;
    uforceticks = [30 40 50 60 70 80 90]/k;
    %     ax.YTick = uforceticks;
    %     ax.YTickLabel = {'30' '40' '50' '60' '70' '80' '90'};
    ax.YLim = [uforceticks(1) uforceticks(5)];

    k = 0.2234; %N/m;
    forceticks = [0:200:1000]/k;
    %     ax.XTick = forceticks;
    %     ax.XTickLabel = {'0' '200' '400' '600' '800' '1000'};
    %     ax.XLim = [-forceticks(2)/2 forceticks(4)];
    
    
    if strcmp(cellid,'181210_F1_C1')
        pfig = proxfig;
    else
        pfig = figure; pfig.Position = [162 476 1608 460];
    end
    ax = axes('parent',pfig,'position',[.05 .6 .14 .32]);
    clustermean(ax,[1/2 1/2 0 0 0],clmask_mapped)
    
    ax = axes('parent',pfig,'position',[.05 .2 .14 .32]);
    s1 = pcolor(ax,vctrs,uctrs,log10(dN1and2));
    s1.EdgeColor = 'flat';
    colormap(ax,'hot')
    %colorbar(ax)
    xlabel(ax,'Velocity (um/s)');
    ylabel(ax,'Position (um)');
%     title(ax,[regexprep(cellid,'\_','\\_') ' Proximal cluster active']);
    centroid = [centroid1and2;centroid2not1];
    ax.NextPlot = 'add';
    plot(ax,centroid1and2(2),centroid1and2(1),'o','tag',[cellid '_1and2'],'color',[0 0 1])

    clims = ax.CLim;
    %     k = 0.2234; %N/m;
    %     uforceticks = [0:20:100]/k;
    %     ax.YTick = uforceticks;
    %     ax.YTickLabel = {'0' '20' '40' '60' '80' '100'};
    %     ax.YLim = [uforceticks(1) uforceticks(end)];
    
    %     vticks = [-4000:1000:2000]/k;
    %     ax.XTick = vticks;
    %     ax.XTickLabel = {'-4' '-3' '-2' '-1' '0' '1' '2'};
    %     ax.XLim = [vticks(1) vticks(end)];
    ax.XLim = [-1.54E4 1.05E4];

    
    ax = axes('parent',pfig,'position',[.25 .6 .14 .32]);
    clustermean(ax,[0 1 0 0 0],clmask_mapped)
    
    ax = axes('parent',pfig,'position',[.25 .2 .14 .32]);
    s1 = pcolor(ax,vctrs,uctrs,log10(dN2not1));
    s1.EdgeColor = 'flat';
    colormap(ax,'hot')
    %colorbar(ax)
    xlabel(ax,'dF/dt (mN/s)');
    ylabel(ax,'Position (um)');
    ax.NextPlot = 'add';
    plot(ax,centroid2not1(2),centroid2not1(1),'o','tag',[cellid '_2'],'color',[1 0 0])

    
    title(ax,[regexprep(cellid,'\_','\\_') ' Proximal only']);
    ax.CLim = clims;
    ax.XLim = [-1.54E4 1.05E4];

    ax = axes('parent',pfig,'position',[.45 .6 .14 .32]);
    clustermean(ax,[1 0 0 0 0],clmask_mapped)
    
    ax = axes('parent',pfig,'position',[.45 .2 .14 .32]);
    s1 = pcolor(ax,vctrs,uctrs,log10(dN1not2));
    s1.EdgeColor = 'flat';
    colormap(ax,'hot')
    %colorbar(ax)
    xlabel(ax,'Velocity (um/s)');
    ylabel(ax,'Position (um)');
    title(ax,[regexprep(cellid,'\_','\\_') ' Distal only']);
    ax.CLim = clims;
    ax.XLim = [-1.54E4 1.05E4];

    %% Now compare that to either 1 or two active on their own
    % fig12 = figure; fig12.Position = [162 476 1608 460];
    % 
    % ax = axes('parent',fig12,'position',[.05 .6 .14 .32]);
    % clustermean(ax,[1 0 0 0 0],clmask_mapped)
    % 
    % ax = axes('parent',fig12,'position',[.05 .2 .14 .32]);
    % s1 = pcolor(ax,vctrs,uctrs,log10(dN1));
    % s1.EdgeColor = 'flat';
    % colormap(ax,'hot')
    % %colorbar(ax)
    % xlabel(ax,'Velocity (um/s)');
    % ylabel(ax,'Position (um)');
    % title(ax,[regexprep(cellid,'\_','\\_') ' Distal (all)']);
    % ax.CLim = clims;
    % ax.XLim = [-1.54E4 1.05E4];
    % 
    % ax = axes('parent',fig12,'position',[.25 .6 .14 .32]);
    % clustermean(ax,[0 1 0 0 0],clmask_mapped)
    % 
    % ax = axes('parent',fig12,'position',[.25 .2 .14 .32]);
    % s1 = pcolor(ax,vctrs,uctrs,log10(dN2));
    % s1.EdgeColor = 'flat';
    % colormap(ax,'hot')
    % %colorbar(ax)
    % xlabel(ax,'Velocity (um/s)');
    % ylabel(ax,'Position (um)');
    % title(ax,[regexprep(cellid,'\_','\\_') ' Proximal (all)']);
    % ax.CLim = clims;
    % ax.XLim = [-1.54E4 1.05E4];
    
end
bxfig = figure;   
ax = subplot(1,1,1);
boxplot(ax,Fvals,Gs,'plotstyle','compact','OutlierSize',1,'BoxStyle' ,'outline','MedianStyle','line')
p = ranksum(Fvals(Gs==1),Fvals(Gs==2));

[~,~,stats] = anovan(Fvals,{Gs},'model','interaction',...
    'varnames',{'group'});

% results = multcompare(stats);
% ps(1) = results(results(:,1)==1 & results(:,2)==7,6);
% ps(2) = results(results(:,1)==2 & results(:,2)==8,6);
% ps(3) = results(results(:,1)==3 & results(:,2)==9,6);
% ps(4) = results(results(:,1)==4 & results(:,2)==10,6);
% ps(5) = results(results(:,1)==5 & results(:,2)==11,6);
% ps(6) = results(results(:,1)==6 & results(:,2)==12,6);
% 

ax = findobj(proxfig,'type','axes','tag','Centroid');
ch = ax.Children;
Two = findobj(ch,'type','Line','-regexp','tag','_2');
OneAND2 = findobj(ch,'type','Line','-regexp','tag','1and2');
v_2 = cell2mat(get(Two,'XData'));
v_1and2 = cell2mat(get(OneAND2,'XData'));

p = ranksum(v_2,v_1and2);

figure(proxfig)
if (PRINT)
    filename = [cellid '_ConditionalProbability12'];
    filename = [cellid '_CentroidImport'];
    export_fig(proxfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
    export_fig(proxfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop', '-r600','-transparent' , '-rgb');
end


function clustermean(ax,F,clmask)
persistent hotcmap
if isempty(hotcmap)
    hotcmap = hot(255);
end

imshow(clmask*0,[0 1],'parent',ax);
alphamask(clmask*0+1,hotcmap(1,:),1,ax);
Fclr = round(F*255);

for cl = 1:length(Fclr)
    if Fclr(cl) == 0
        %skip it
    else
        alphamask(clmask==cl,hotcmap(Fclr(cl),:),1,ax);
    end
end
end

function c = histCentroid(uc,vc,dN)
x = dN.*repmat(uc(:),1,size(dN,2));
x = sum(x(:))/sum(dN(:));
y = dN.*repmat(vc(:)',size(dN,1),1);
y = sum(y(:))/sum(dN(:));
c = [x,y];
end