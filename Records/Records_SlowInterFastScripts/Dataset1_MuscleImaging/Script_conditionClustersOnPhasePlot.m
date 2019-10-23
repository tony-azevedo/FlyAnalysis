% close all
%%
% Go through all the probe frames
% Plot the histogram of distances, velocities, and accelerations
% Plot relationships of {x,x_dot,x_ddot} with cluster values
PLOT = 1;
PRINT = 0;
cidx = 1;
% for cidx = 1:length(T_legImagingList.CellID)
T_row = T_legImagingList(cidx,:);
trialStem = [T_row.Protocol{1} '_Raw_' T_row.CellID{1} '_%d.mat'];
Dir = fileparts(T_row.TableFile{1}); cd(Dir);
cellid = T_row.CellID{1};

bartrials = T_row.Bartrials{1};
bartrial = load(sprintf(trialStem,bartrials(1)));

% Going with Non-bar clusters to start
map = T_row.ClusterMapping_NBCls{1};
% map assigns value map(:,1) to the cluster values map(:,2)

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

% replace the missing value, if there
clvals = unique(clmask);
missing = setxor(clvals,0:max(clvals));
if ~isempty(missing)
    clmask(clmask==max(clvals)) = missing;
end

clmask_mapped = clmask;
for cl = 1:size(map,1)
    clmask_mapped(clmask==map(cl,2)) = cl;
end
% figure
% ax = subplot(1,1,1);
% scaleclusters(ax,[1 1 1 1 1],clmask_mapped)

probe_ = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
dprobe_dt_ = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
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

%% Extract Data from each trial
dt = diff(ft(1:2));
for tr = bartrials'
    
    bartrial = load(sprintf(trialStem,tr));
    
    cnt = cnt+1;
    probe_(:,cnt) = bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce;
    dprobe_dt_(:,cnt) = cat(1,nan,diff(probe_(:,cnt)))/dt;
    ddprobe_dt2(:,cnt) = cat(1,diff(dprobe_dt_(:,cnt)),nan)/dt;
    
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
        uF_cl(:,cl,tr) = fillmissing(uF_cl(:,cl,tr),'linear');
    end
end

if (PLOT)
    exmpfig = figure; exmpfig.Position = [275   201   965   777];
    randtr = randperm(size(dF_cl,3),4);
    for rt = 1:length(randtr)
        ax = subplot(4,1,rt,'parent',exmpfig); cla(ax), ax.NextPlot = 'add';
        cl = 1:2;
        %plot(ft_ca,squeeze(F_cl(:,2,randtr(rt))),'Marker','.')
        plot(ft,squeeze(uF_cl(:,1,randtr(rt))),'Marker','.')
        plot(ft,probe_(:,randtr(rt))/max(probe_(:,randtr(rt)))*20,'Marker','.')
        title(ax,['trial ' num2str(bartrials(randtr(rt)))]);
        ax.XLim = [ft(1) ft(end)];
    end
    xlabel(ax,'time (s)');
    
    if (PRINT)
        filename = [cellid '_ActiveExamples'];
        export_fig(exmpfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
        export_fig(exmpfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
    end
end


%% Alternative 2)
% Now measure the change in the cluster intensity when the probe is
% in particular hot spots in the phase plot

% eliminate pre light and post light points
lghtOn = ft>0&ft<bartrial.params.stimDurInSec;

% reshape cubes into columns, 
% DF = reshape(ufdF_cl,[],size(ufdF_cl,2));
F = reshape(uF_cl,[],size(uF_cl,2));
for cl = 1:size(F,2)
    % Now each column is all of the trials for a given cluster.
    % DF(:,cl) = reshape(ufdF_cl(:,cl,:),[],1);
    temp = uF_cl(:,cl,:);
    temp(~lghtOn,1,:) = nan;
    F(:,cl) = reshape(temp,[],1);
end
probe = probe_(:);
dprobe_dt = dprobe_dt_(:);
ddprobe_dt2 = ddprobe_dt2(:);

[deltax] = subOptimalBinWidth(probe(:));

[dN,xbins,vbins] = histcounts2(probe(:),dprobe_dt(:),length(deltax)*[1 2],'Normalization','count');
clims = log10([1 max(dN(:))]);

% Use these bins and centers from here on out;
xctrs = xbins(1:end-1)+diff(xbins(1:2)/2);
vctrs = vbins(1:end-1)+diff(vbins(1:2)/2);

%% A few key numbers
soft = xbins(3);
hard = xbins(floor(length(xbins)-5));
[~,v0] = min(abs(vbins));
slow_p = vbins(v0+2);
slow_n = vbins(v0-2);

% u = nan(4,2);
% v = nan(4,2);

%% ROIs
% ROI 1: extending
u(1,:) = [xbins(1) xbins(5)];
v(1,:) = [vbins(v0-3) vbins(v0-1)];

% ROI 1: hard and slow - not moving at the furthest extent
u(2,:) = [hard xbins(end)];
v(2,:) = [slow_n slow_p];

% ROI3: fast, but deccelerating when flexed
u(3,:) = [200 366]; % Near top
v(3,:) = [850 3280]; % fast positive

% ROI3: fast, but deccelerating when flexed
u(4,:) = [69 200]; % Near top
v(4,:) = [-230 310]; % fast positive

% find the maximum value of all clusters
climmax = max(F,[],1);
dclimmax = max(F(2:end,:) - F(1:end-1,:),[],1);
dclimmin = min(F(2:end,:) - F(1:end-1,:),[],1);


%% Show ROIs, a few examples, and the cluster representation
roifig = figure; roifig.Position = [57 32 1270 964];
sgtitle(roifig,[regexprep(cellid,'\_','\\_')])
% Loop through ROIs
for roi = 1:size(u,1)
    % find the instances inside the roi
    % Then find neighboring points that are inside the roi
    roi_idx_0 = probe > u(roi,1) & probe <= u(roi,2) & dprobe_dt >= v(roi,1) & dprobe_dt <= v(roi,2);
    roi_idx_1 = cat(1,probe(2:end) > u(roi,1) & probe(2:end) <= u(roi,2) & dprobe_dt(2:end) >= v(roi,1) & dprobe_dt(2:end) <= v(roi,2),false);
    roi_idx = roi_idx_0 & roi_idx_1;
    F_roi = F(roi_idx,:);
    probe_roi = probe(roi_idx);
    dprobe_dt_roi = dprobe_dt(roi_idx);  % ddprobe_dt2_hf = ddprobe_dt2(roi_idx);

    % histogram the roi
    ax = subplot(4,size(u,1),0*size(u,1)+roi); ax.NextPlot = 'add';
    histpcolor(ax,probe_roi,dprobe_dt_roi,xbins,vbins,xctrs,vctrs,clims)
    
    % show a few random example snippets where the bar is in this roi
    T = length(ft);
    middlewind = 1:T > T/8 & 1:T < T*7/8;
    exmplidxs = roi_idx & repmat(middlewind(:),length(bartrials),1);
    allidx = find(exmplidxs);
    exmplidx = allidx(randperm(size(allidx,1),20));
    trlidx = ceil(exmplidx/T);
    ftidx = rem(exmplidx,T);
    
    axp = subplot(8,size(u,1),2*size(u,1)+roi); axp.NextPlot = 'add'; axp.YLim = [xbins(1) xbins(end)];
    axcl = subplot(8,size(u,1),3*size(u,1)+roi); axcl.NextPlot = 'add'; axcl.YLim = [0 climmax(1)];
    for ex = 1:length(exmplidx)
        ftwin = ftidx(ex)-10:ftidx(ex)+20;
        
        p_snip = probe_(ftwin,trlidx(ex));
        plot(axp,ft(ftwin)-ft(ftidx(ex)),p_snip ,'color',[0    0.4470    0.7410]);
        %l = plot(axp,ft(ftwin)-ft(ftidx(ex)),p_snip);
        
        cl_snip = uF_cl(ftwin,1,trlidx(ex));
        plot(axcl,ft(ftwin)-ft(ftidx(ex)),cl_snip,'color',[0.8500    0.3250    0.0980]);
        % plot(axcl,ft(ftwin)-ft(ftidx(ex)),cl_snip,'color',l.Color);
    end
        

    % average cluster values for that roi
    Froi = nanmean(F_roi,1);
    
    ax = subplot(4,size(u,1),2*size(u,1)+roi);
    clustermean(ax,Froi./climmax,clmask)

    roi_idx_1 = cat(1,false,roi_idx);
    
    % now look at the derivative of fluorescence in the roi:     
    DF_roi = F(roi_idx_1,:)-F(roi_idx,:);
    DFroi = nanmean(DF_roi);
    
    ax = subplot(4,size(u,1),3*size(u,1)+roi);
    clusterchange(ax,DFroi./dclimmax,clmask)
    
end
if (PRINT)
    filename = [cellid '_ClusterIGivenPhasePlot'];
    export_fig(roifig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop', '-r600','-transparent' , '-rgb');
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

function clusterchange(ax,F,clmask)
persistent hotcmap
if isempty(hotcmap)
    hotcmap = hot(256);
end

imshow(clmask*0,[0 1],'parent',ax);
alphamask(clmask*0+1,hotcmap(56,:),1,ax);

Fclr = round(F*255)+56;
    
for cl = 1:length(Fclr)
    if Fclr(cl) == 0
        %skip it
    else
        alphamask(clmask==cl,hotcmap(Fclr(cl),:),1,ax);
    end
end
end


function histpcolor(ax,u,v,ubins,vbins,uctrs,vctrs,clims)
dN = histcounts2(u(:),v(:),ubins,vbins,'Normalization','count');
s1 = pcolor(ax,vctrs,uctrs,log10(dN));
s1.EdgeColor = 'flat';
colormap(ax,'hot')
% colorbar(ax)
xlabel(ax,'Velocity (um/s)');
ylabel(ax,'Position (um)');
%title(ax,[regexprep(cellid,'\_','\\_') ' Proximal cluster active']);
ax.CLim = clims;
ax.XLim = [vbins(1) vbins(end)];
ax.YLim = [ubins(1) ubins(end)];
end
