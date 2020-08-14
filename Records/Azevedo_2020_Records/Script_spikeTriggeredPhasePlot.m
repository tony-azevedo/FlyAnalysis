% Go through each cell, get the bar trials, find spikes, and collect the
% bar movements that result from the spikes
PLOT = 1;
DEBUG = 0;
PRINT = 0;

clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];

% close all

labels = unique(T_SM.Cell_label);
N_spikes = zeros(size(labels));
t_total = N_spikes;

%% standardize the histogram bins
ubins = linspace(-10,370,24);
vbins = linspace(-6000,6000,40);

uctrs = ubins(1:end-1)+diff(ubins(1:2)/2);
vctrs = vbins(1:end-1)+diff(vbins(1:2)/2);

%% Create a figure and axes to plot all of the labels
ppfig = figure; ppfig.Position = [546 32 1305 964];
ppax11 = subplot(3,2,1,'parent',ppfig); ppax11.NextPlot = 'add';
ppax12 = subplot(3,2,2,'parent',ppfig); ppax12.NextPlot = 'add';
ppax21 = subplot(3,2,3,'parent',ppfig); ppax21.NextPlot = 'add';
ppax22 = subplot(3,2,4,'parent',ppfig); ppax22.NextPlot = 'add';
ppax31 = subplot(3,2,5,'parent',ppfig); ppax31.NextPlot = 'add';
ppax32 = subplot(3,2,6,'parent',ppfig); ppax32.NextPlot = 'add';

pltcnt = 0;

%%
for lblidx = 1:length(labels)
    label = labels(lblidx);
    T_label = T_SM(contains(T_SM.Cell_label,label) & T_SM.bar_good,:);
    
    u_label = [];
    v_label = [];
    U = [];
    V = [];
    
    centroids = zeros(height(T_label),2); % u,v centers of the spike contingent phase
    
    for cidx = 1:length(T_label.CellID)
        
        cellid = T_label.CellID{cidx};
        T_Cell = T_label(contains(T_label.CellID,cellid) & T_label.bar_good,:);
        bargroup = T_Cell.bar_trialnums{1};
        %     for r = 2:height(T_Cell)
        %         % so far this is irrelevant because no cell uses two
        %         % protocols
        %         bargroup = [bargroup T_Cell.bar_trialnums{r}];
        %     end
        
        Dir = fullfile('E:\Data',cellid(1:6),cellid);
        cd(Dir);
        
        trialStem = [T_Cell.Protocol{1} '_Raw_' cellid '_%d.mat'];
        bartrial = load(fullfile(Dir,sprintf(trialStem,bargroup(1))));
        t = makeInTime(bartrial.params); t = t(:);
        
        ft = makeFrameTime(bartrial);
        dt = diff(ft(1:2));
        
        v_ = nan(length(t),length(bargroup));
        spikes_ = v_;
        
        probe = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
        dprobe_dt = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
        ddprobe_dt2 = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
        cnt = 0;
        
        for tr = bargroup
            
            bartrial = load(sprintf(trialStem,tr));
            if isfield(bartrial,'excluded') && bartrial.excluded
                continue
            end
            if ~isfield(bartrial,'spikes')
                error('This cell doesn''t have spikes for all trials')
                continue
            end
            cnt = cnt+1;
            v_(1:length(bartrial.voltage_1),cnt) = bartrial.voltage_1;
            
            spikes_(:,cnt) = 0;
            spikes_(bartrial.spikes,cnt) = 1;
            if strcmp(cellid,'190605_F1_C1')
                spikes_(t>0&t<0.06,cnt) = 0;
            end
            
            probe(1:length(bartrial.forceProbeStuff.CoM),cnt) = bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce;
            
            % skootch the derivative over 1, delay relative to spike
            dprobe_dt(:,cnt) = cat(1,nan,diff(probe(:,cnt)))/dt;
            ddprobe_dt2(:,cnt) = cat(1,diff(dprobe_dt(:,cnt)),nan)/dt;
        end
        nanidx = ~isnan(v_(1,:));
        v_ = v_(:,nanidx);
        spikes_ = spikes_(:,nanidx);
        probe = probe(:,nanidx);
        ddprobe_dt2 = ddprobe_dt2(:,nanidx);
        
        %% Concatonate probe locations and velocities
        U = cat(1,U,probe(:));
        V = cat(1,V,dprobe_dt(:));
        
        %%
        if PLOT && any(contains(ofinterest,T_Cell.CellID{1}))
            cfig = figure; cfig.Position = [200+10*pltcnt 300-10*pltcnt 560 700];
            pltcnt = pltcnt+1;
            ax1 = subplot(4,1,1);
            for c = 1:size(spikes_,2)
                raster(ax1,t(logical(spikes_(:,c))),c+[-.4 .4]);
            end
            
            ax2 = subplot(4,1,2);
            plot(ax2,t,v_);
            
            ax3 = subplot(4,1,3);
            plot(ax3,ft,probe);
            
            ax4 = subplot(4,1,4);
            switch T_Cell.Protocol{1}
                case 'EpiFlash2T'
                    plot(ax4,t,EpiFlashStim(bartrial.params));
                case 'EpiFlash2TTrain'
                    plot(ax4,makeInTime(bartrial.params),EpiFlashTrainStim(bartrial.params));
            end
            linkaxes([ax1,ax2,ax3],'x')
            sgtitle(cfig,regexprep(T_Cell.CellID,'\_','\\_'));
        end
        
        %% When looking at subsequent forces, look for DT ms
        DT = 0.040; % ms
        NT = sum(t>=0&t<=DT);
        DF = sum(ft>=0&ft<=DT); % N frames
        
        % get rid of spikes in the far preperiod and very end
        spikes = spikes_;
        spikes(isnan(spikes(:))) = 0;
        
        wind = t<-bartrial.params.preDurInSec+.08 | t>t(length(t))-(DT+2*diff(ft(1:2)));
        spikes(wind,:) = 0;
        
        %% Create matrices of probe movements following spike
        
        u = nan(DF,sum(spikes(:)));
        v = nan(DF,sum(spikes(:)));
        
        cnt = 0;
        for c = 1:size(spikes,2)
            t_spikes = t(logical(spikes(:,c)));
            
            if DEBUG
                figure
                ax1 = subplot(2,1,1); ax1.NextPlot = 'add';
                plot(ax1,t,v_(:,c));
                ax2 = subplot(2,1,2); ax2.NextPlot = 'add';
                plot(ax2,ft,probe(:,c));
            end
            
            for i = 1:length(t_spikes)
                
                cnt = cnt+1;
                t_i = t_spikes(i);
                t_idx = find(t==t_i);
                ft_i = find(ft>=t_i,1);
                if t_i>ft(end)
                    continue
                end
                if ft_i+DF-1 > length(ft)
                    % for early cells, the video was short
                    u(1:length(ft)-ft_i+1,cnt) = probe(ft_i:length(ft),c);
                    v(1:length(ft)-ft_i+1,cnt) = dprobe_dt(ft_i:length(ft),c);
                else
                    u(:,cnt) = probe(ft_i:ft_i+DF-1,c);
                    v(:,cnt) = dprobe_dt(ft_i:ft_i+DF-1,c);
                end
                
                % draw each point only once
                probe(ft_i:ft_i+DF-1,c) = NaN;
                dprobe_dt(ft_i:ft_i+DF-1,c) = NaN;
                
                if DEBUG
                    plot(ax1,t(t_idx:t_idx+NT),v_(t_idx:t_idx+NT,c));
                    plot(ax2,ft(ft_i:ft_i+DF-1),u(:,cnt));
                end
            end
        end
        
        %% Add the number of spikes for the cell type
        N_spikes(lblidx) = N_spikes(lblidx)+size(u,2);
        t_total(lblidx) = t_total(lblidx)+ sum(~wind)/bartrial.params.sampratein*size(v_,2);
        
        
        %% Get the centroid for the spike contingent trajectories for each cell
        N_spike = histcounts2(u(:),v(:),ubins,vbins,'Normalization','count');
        centroids(cidx,:) = histCentroid(uctrs,vctrs,N_spike);
        
        %% Concatonate probe locations and velocities
        try 
            u_label = cat(2,u_label,u);
            v_label = cat(2,v_label,v);
        catch e
            if strcmp(e.identifier,'MATLAB:catenate:dimensionMismatch')
                if size(u_label,1) < size(u,1)
                    u_label = cat(1,u_label,nan(diff([size(u_label,1) size(u,1)]),size(u_label,2)));
                    v_label = cat(1,v_label,nan(diff([size(v_label,1) size(v,1)]),size(v_label,2)));
                    u_label = cat(2,u_label,u);
                    v_label = cat(2,v_label,v);
                elseif size(u,1) < size(u_label,1)
                    u = cat(1,u,nan(diff([size(u,1) size(u_label,1)]),size(u,2)));
                    v = cat(1,v,nan(diff([size(v,1) size(v_label,1)]),size(v,2)));
                    u_label = cat(2,u_label,u);
                    v_label = cat(2,v_label,v);
                end
            else
                e.rethrow
            end
        end
                
    end
    
    N_spike = histcounts2(u_label(:),v_label(:),ubins,vbins,'Normalization','count');
    N_all = histcounts2(U(:),V(:),ubins,vbins,'Normalization','count');

    fprintf('%d frames\n',sum(~isnan(u_label(:))))
    
    centroid_all = histCentroid(uctrs,vctrs,N_all);

    %N_frac = N_num./N_den; N_frac(isnan(N_frac)) = 0;
    
    eval(['ax1 = ppax' num2str(lblidx) '1;']);
    eval(['ax2 = ppax' num2str(lblidx) '2;']);

    s1 = pcolor(ax1,vctrs,uctrs,log10(N_all));
    s1.EdgeColor = 'flat';
    colormap(ax1,'hot')
    colorbar(ax1)
    xlabel(ax1,'Velocity (um/s)');
    ylabel(ax1,'Position (um)');
    
    s1 = pcolor(ax2,vctrs,uctrs,log10(N_spike));
    s1.EdgeColor = 'flat';
    colormap(ax2,'hot')
    colorbar(ax2)
    xlabel(ax2,'Velocity (um/s)');
    ylabel(ax2,'Position (um)');
    
    ax2.CLim = ax1.CLim;
    set([ax1,ax2],'XLim',[vbins(1) vbins(end)],'YLim',[ubins(1) ubins(end)])
    
    % Note, so far the axes are flipped, u on y-axis, v on x-axis
    % plot(ax1,centroid_all(2),centroid_all(1),'marker','.','markersize',10,'color',lightclrs(lblidx,:));
    plot(ax2,centroid_all(2),centroid_all(1),'marker','+','markersize',10,'color',lightclrs(lblidx,:));
    for c = 1:size(centroids,1)
        % Note, so far the axes are flipped, u on y-axis, v on x-axis
        plot(ax2,centroids(c,2),centroids(c,1),'marker','.','markersize',10,'tag',T_label.CellID{c},'color',lightclrs(lblidx,:));
    end
    
    %% Now go back and plot the ratio of N frames|spike vs N frames
    ax1 = ax2;
    cla(ax1)
    L_spike = N_spike./N_all;
    L_spike(isnan(L_spike)) = 0;
    L_spike(N_all<2) = 0;
    s1 = pcolor(ax1,vctrs,uctrs,L_spike);
    s1.EdgeColor = 'flat';
    colormap(ax1,'hot')
    colorbar(ax1)
    xlabel(ax1,'Velocity (um/s)');
    ylabel(ax1,'Position (um)');
    ax1.CLim = [0 1];
    
    drawnow
end

%% Save figure if you want to 
if (PRINT)
    filename = ['SpikeConditionedPhasePlots'];
    filename = ['SpikeLiklihoodPhasePlots'];
    export_fig(ppfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
    delete(findobj(ppfig,'type','line','marker','.'));
    export_fig(ppfig,[figureoutputfolder '\' 'GFPClusters6' '.png'], '-png','-nocrop', '-r600','-transparent' , '-rgb');
end


%% Plot total number of spikes for each type
figure
ax = subplot(1,1,1); ax.NextPlot = 'add';
spikesPerTime = N_spikes./t_total;
for l = 1:length(spikesPerTime)
    plot(ax,l,spikesPerTime(l),'Marker','.','markersize',18,'color',clrs(l,:));
end
ylabel(ax,'N spikes / Total Time');
ax.FontSize = 12;
ax.XLim = [.5 3.5];

%%
function c = histCentroid(uc,vc,dN)
x = dN.*repmat(uc(:),1,size(dN,2));
x = sum(x(:))/sum(dN(:));
y = dN.*repmat(vc(:)',size(dN,1),1);
y = sum(y(:))/sum(dN(:));
c = [x,y];
end
