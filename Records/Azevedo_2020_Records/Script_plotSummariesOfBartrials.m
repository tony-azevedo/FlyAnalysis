% close all
%%
% Go through all the probe frames
% Plot the histogram of distances, velocities, and accelerations
% Plot relationships of {x,x_dot,x_ddot} with cluster values

cidx = 1;
for cidx = 1:length(T_legImagingList.CellID)
    T_row = T_legImagingList(cidx,:);
    trialStem = [T_row.Protocol{1} '_Raw_' T_row.CellID{1} '_%d.mat'];
    Dir = fileparts(T_row.TableFile{1}); cd(Dir);
    cellid = T_row.CellID{1};
    
    bartrials = T_row.Bartrials{1};
    bartrial = load(sprintf(trialStem,bartrials(1)));
    probe_ = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
    dprobe_dt_ = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
    ddprobe_dt2_ = nan(length(bartrial.forceProbeStuff.CoM),length(bartrial));
    cnt = 0;
    for tr = bartrials'
    
        bartrial = load(sprintf(trialStem,tr));
        ft = makeFrameTime(bartrial);
        cnt = cnt+1;
        probe_(:,cnt) = bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce;
        dprobe_dt_(:,cnt) = cat(1,diff(probe_(:,cnt)),nan)/diff(ft(1:2));
        ddprobe_dt2_(:,cnt) = cat(1,nan,diff(dprobe_dt_(:,cnt)))/diff(ft(1:2));
        
        %         playfig = figure; playfig.Position = [348    32   892   964]; %playfig.MenuBar = 'none';
        %
        %         ax1 = axes('parent',playfig,...
        %             'Position',[.13 .7 .82,.28],...
        %             'Color',[1 1 1]);
        %         ax1.NextPlot = 'add';
        %         plot(ax1,ft,probe_(:,cnt),'Color',[0    0.4470    0.7410]);
        %
        %         ax2 = axes('parent',playfig,...
        %             'Position',[.13 .4 .82,.28],...
        %             'Color',[1 1 1]);
        %         ax2.NextPlot = 'add';
        %         plot(ax2,ft,dprobe_dt_(:,cnt),'Color',[0.8500    0.3250    0.0980]);
        %
        %         ax3 = axes('parent',playfig,...
        %             'Position',[.13 .1 .82,.28],...
        %             'Color',[1 1 1]);
        %         ax2.NextPlot = 'add';
        %         plot(ax3,ft,ddprobe_dt2_(:,cnt),'Color',[0.9290    0.6940    0.1250]);
        %         linkaxes([ax1,ax2,ax3],'x')
        %         ax1.XLim = [ft(1) ft(end)];
    end

    comfig = figure; comfig.Position = [348    32   640   964];
    ax = subplot(3,1,1,'parent',comfig); %ax.NextPlot = 'add';
    
    [deltax] = subOptimalBinWidth(probe_(:));
    [dN,xbins,ybins] = histcounts2(probe_(:),dprobe_dt_(:),length(deltax)*[1 2],'Normalization','count');
    xbins = xbins(1:end-1)+diff(xbins(1:2)/2);
    ybins = ybins(1:end-1)+diff(ybins(1:2)/2);
    s1 = pcolor(ax,ybins,xbins,log10(dN)); 
    s1.EdgeColor = 'flat';
    colormap(ax,'hot')
    colorbar(ax)
    xlabel('Velocity (um/s)');
    ylabel('Position (um)');
    ax.TickDir = 'out';
    
    k = 0.2234; %N/m;
    uforceticks = [0  20  40  60  80 ]/k;
    ax.YTick = uforceticks;
    ax.YTickLabel = {'0' '20' '40' '60' '80'};
    %ax.YLim = [uforceticks(2) uforceticks(5)];
    
    k = 0.2234; %N/m;
    forceticks = [-8:2:6]*1e3/k;
    uticks = [-1.5:.5:1]*1e4;
    ax.XTick = forceticks;
    ax.XTickLabel = { '-1.5' '-1' '-0.5' '0' '0.5' '1'};
    %ax.XLim = [-forceticks(2)/2 forceticks(4)];

    
    title(ax,regexprep(cellid,'\_','\\_'));

    %     ax = subplot(3,1,2,'parent',comfig);
    %     [dN,xbins,ybins] = histcounts2(probe_(:),ddprobe_dt2_(:),length(deltax)*[1 2],'Normalization','countdensity');
    %     xbins = xbins(1:end-1)+diff(xbins(1:2)/2);
    %     ybins = ybins(1:end-1)+diff(ybins(1:2)/2);
    %     s2 = pcolor(ax,ybins,xbins,log(dN));
    %     s2.EdgeColor = 'flat';
    %     xlabel('Acceleration (um/s/s)');
    %     ylabel('Position (um)');
    %
    %     ax = subplot(3,1,3,'parent',comfig);
    %     [dN,xbins,ybins] = histcounts2(dprobe_dt_(:),ddprobe_dt2_(:),length(deltax)*[1 2],'Normalization','countdensity');
    %     xbins = xbins(1:end-1)+diff(xbins(1:2)/2);
    %     ybins = ybins(1:end-1)+diff(ybins(1:2)/2);
    %     s3 = pcolor(ax,ybins,xbins,log(dN));
    %     s3.EdgeColor = 'flat';
    %     xlabel('Acceleration (um/s/s)');
    %     ylabel('Velocity (um/s)');
    
    
    if (DEBUG)
        filename = [cellid '_phasePlotHist'];
        export_fig(comfig,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
        export_fig(comfig,[figureoutputfolder '\' filename '.png'], '-png','-nocrop', '-r600','-transparent' , '-rgb');
    end
end


