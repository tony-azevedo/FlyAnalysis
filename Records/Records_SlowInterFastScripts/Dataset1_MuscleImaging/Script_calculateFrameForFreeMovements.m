% close all
%%
% Go through all the probe frames
% Plot the histogram of distances, velocities, and accelerations
% Plot relationships of {x,x_dot,x_ddot} with cluster values

cidx = 1;
minangle = nan(length(T_legImagingList.CellID));
minangle = [ %specify for each fly;
    20
    34
    20
    26
    33
];

pops = cell(1,12);
cavals = [];
clustnum = [];
extflx = {};
cellnum = [];

for cidx = 1:length(T_legImagingList.CellID)
    T_row = T_legImagingList(cidx,:);
    trialStem = [T_row.Protocol{1} '_Raw_' T_row.CellID{1} '_%d.mat'];
    Dir = fileparts(T_row.TableFile{1}); cd(Dir);
    cellid = T_row.CellID{1};
    
    nobartrials = T_row.Nobartrials{1};
    nobartrial = load(sprintf(trialStem,nobartrials(1)));
    
    angle_ext_ = nan(max(size(nobartrial.clustertraces)),length(nobartrials));
    angle_flx_ = nan(max(size(nobartrial.clustertraces)),length(nobartrials));
    ft_ext_ = nan(max(size(nobartrial.clustertraces)),length(nobartrials));
    ft_flx_ = nan(max(size(nobartrial.clustertraces)),length(nobartrials));
    cluster_ext_ = nan(max(size(nobartrial.clustertraces)),min(size(nobartrial.clustertraces)),length(nobartrials));
    cluster_flx_ = nan(max(size(nobartrial.clustertraces)),min(size(nobartrial.clustertraces)),length(nobartrials));
    cnt = 0;
    
    %     minangle(cidx) = Inf;
    %     for tr = nobartrials'
    %         lp = load(sprintf(trialStem,tr),'legPositions');
    %         minangle(cidx) = min([minangle(cidx),min(lp.legPositions.Tibia_Angle)]);
    %     end
    
    for tr = nobartrials'
        
        nobartrial = load(sprintf(trialStem,tr));
        ftleg = makeFrameTime(nobartrial);
        ftcam = makeFrameTime2CB2T(nobartrial);
        ftmap = ftcam;
        for i = 1:length(ftmap)
            [~,ftmap(i)] = min(abs(ftleg-ftcam(i)));
        end
        cnt = cnt+1;

        ta = nobartrial.legPositions.Tibia_Angle(ftmap);

        anglegt120 = (ta>120 & ftcam>0&ftcam<nobartrial.params.stimDurInSec) | (isnan(ta) & ftcam>0&ftcam<nobartrial.params.stimDurInSec);
        L = 10;
        extHeld = anglegt120;
        for i = 1:length(anglegt120)
            try extHeld(i) = all(anglegt120(i-L:i));
            catch
                extHeld(i) = all(anglegt120(1:i));
            end
        end
        angle_ext_(extHeld,cnt) = ta(extHeld);
        ft_ext_(extHeld,cnt) = ftcam(extHeld);
        for cl = 1:size(nobartrial.clustertraces,2)
            cluster_ext_(extHeld,cl,cnt) = (nobartrial.clustertraces(extHeld,cl)-nobartrial.F0_clustertraces(cl))/nobartrial.F0_clustertraces(cl);
        end
        
        anglelt2 = (ta<minangle(cidx)+2.5 & ftcam>0&ftcam<nobartrial.params.stimDurInSec) | (isnan(ta) & ftcam>0&ftcam<nobartrial.params.stimDurInSec);
        L = 5;
        flxHeld = anglelt2;
        for i = 1:length(anglelt2)
            try flxHeld(i) = all(anglelt2(i-L:i));
            catch
                flxHeld(i) = all(anglelt2(1:i));
            end
        end
        angle_flx_(flxHeld,cnt) = ta(flxHeld);
        ft_flx_(flxHeld,cnt) = ftcam(flxHeld);
        cluster_flx_(flxHeld,:,cnt) = nobartrial.clustertraces(flxHeld,:);
        for cl = 1:size(nobartrial.clustertraces,2)
            cluster_flx_(flxHeld,cl,cnt) = (nobartrial.clustertraces(flxHeld,cl)-nobartrial.F0_clustertraces(cl))/nobartrial.F0_clustertraces(cl);
        end
     end

    FfigExtVsFlx = figure; FfigExtVsFlx.Position = [356 391 501 421];
    ax = subplot(1,1,1,'parent',FfigExtVsFlx); ax.NextPlot = 'add';
    
    clmap = T_legImagingList.ClusterMapping_NoBar{cidx};
    
    for cl = 1:size(cluster_ext_,2)
        clidx = clmap(clmap(:,1)==cl,2);
        ext = cluster_ext_(:,clidx,:); ext = ext(~isnan(ext));
        
%         pops{cl*2-1} = cat(1,pops{cl*2-1},{ext});
        cavals = cat(1,cavals,ext);
        clustnum = cat(1,clustnum,repmat(cl,size(ext)));
        cellnum = cat(1,cellnum,repmat(cidx,size(ext)));
        extstr = cell(size(ext));
        extstr(:) = {'ext'};
        extflx = cat(1,extflx,extstr);
        
        plot(ax,cl-.2*ones(size(ext)),ext,'.');

        flx = cluster_flx_(:,clidx,:); flx = flx(~isnan(flx));
%         pops{cl*2} = cat(1,pops{cl*2},{flx});

        cavals = cat(1,cavals,flx);
        clustnum = cat(1,clustnum,repmat(cl,size(flx)));
        cellnum = cat(1,cellnum,repmat(cidx,size(flx)));
        flxstr = cell(size(flx));
        flxstr(:) = {'flx'};
        extflx = cat(1,extflx,flxstr);
        
        plot(ax,cl+.2*ones(size(flx)),flx,'.');
    end
    
    
    %% Now go through and average all the calcium imaging frames that "been
    % flexed" vs "been extendend";
    
%     if cidx==3
%         cnt = 0;
%         extimage = zeros([512,640]);
%         extimagecnt = 0;
%         flximage = zeros([512,640]);
%         flximagecnt = 0;
%         
%         
%         for tr = nobartrials'
%             cnt = cnt+1;
%             nobartrial = load(sprintf(trialStem,tr));
%             fprintf('Finding frames in %s\n',nobartrial.imageFile2);
%             vid = VideoReader(nobartrial.imageFile2);
%             extfrms = ft_ext_(:,cnt);
%             flxfrms = ft_flx_(:,cnt);
%             
%             frms = sort([extfrms(~isnan(extfrms));flxfrms(~isnan(flxfrms))]);
%             for f = 1:length(frms)
%                 ft = frms(f);
%                 vid.CurrentTime = ft;
%                 fprintf('\tCurrent Time %.2f - ',ft);
%                 
%                 if any(ft==extfrms)
%                     mov3 = double(readFrame(vid));
%                     extimagecnt = extimagecnt+1;
%                     extimage = extimage + mov3(:,:,1);
%                     fprintf('extended\n');
%                 elseif any(ft==flxfrms)
%                     mov3 = double(readFrame(vid));
%                     flximagecnt = flximagecnt+1;
%                     flximage = flximage + mov3(:,:,1);
%                     fprintf('flexed\n');
%                 end
%             end
%             delete(vid);
%         end
%         extimage = extimage/extimagecnt; % extimage = extimage*extimagecnt;
%         flximage = flximage/flximagecnt;
%         
%         extdisplayf = figure;
%         extdisplayf.Position = [40 40 640 530];
%         extdisplayf.Tag = 'ext_fig';
%         extdispax = axes('parent',extdisplayf,'units','pixels','position',[0 0 640 512],'tag','dispax');
%         extdispax.Box = 'off'; extdispax.XTick = []; extdispax.YTick = []; extdispax.Tag = 'dispax';
%         colormap(extdispax,'gray')
%         
%         hold(extdispax,'off')
%         im = imshow(extimage,[2 quantile(flximage(:),0.999)],'parent',extdispax);
%         hold(extdispax,'on');
%         
%         flxdisplayf = figure;
%         flxdisplayf.Position = [740 40 640 530];
%         flxdisplayf.Tag = 'ext_fig';
%         flxdispax = axes('parent',flxdisplayf,'units','pixels','position',[0 0 640 512],'tag','dispax');
%         flxdispax.Box = 'off'; flxdispax.XTick = []; flxdispax.YTick = []; flxdispax.Tag = 'dispax';
%         colormap(flxdispax,'gray')
%         
%         hold(flxdispax,'off')
%         im = imshow(flximage,[2 quantile(flximage(:),0.999)],'parent',flxdispax);
%         hold(flxdispax,'on');
%         
%         % imwrite(extimage/quantile(flximage(:),0.999)-quantile(flximage(:),0.0001)/quantile(flximage(:),0.999),[figureoutputfolder '\AverageExtFigureRaw.png'],'png','BitDepth',16)
%         imwrite(extimage/quantile(flximage(:),0.999)-2/quantile(flximage(:),0.999),[figureoutputfolder '\AverageExtFigureRaw.png'],'png','BitDepth',16)
%         imwrite(flximage/quantile(flximage(:),0.999)-2/quantile(flximage(:),0.999),[figureoutputfolder '\AverageFlxFigureRaw.png'],'png','BitDepth',16)
%         
%         if (PRINT)
%             filename = ['AverageExtFigure'];
%             %export_fig(extdisplayf,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
%             export_fig(extdisplayf,[figureoutputfolder '\' filename '.png'], '-png','-nocrop', '-r600','-transparent' , '-rgb');
%             
%             filename = ['AverageFlxFigure'];
%             %export_fig(extdisplayf,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
%             export_fig(flxdisplayf,[figureoutputfolder '\' filename '.png'], '-png','-nocrop', '-r600','-transparent' , '-rgb');
%             
%         end
%     end
end

[~,~,stats] = anovan(cavals,{clustnum extflx},'model','interaction',...
    'varnames',{'clustnum','extflx'});

results = multcompare(stats,'Dimension',[2 1]);
ps(1) = results(results(:,1)==1 & results(:,2)==7,6);
ps(2) = results(results(:,1)==2 & results(:,2)==8,6);
ps(3) = results(results(:,1)==3 & results(:,2)==9,6);
ps(4) = results(results(:,1)==4 & results(:,2)==10,6);
ps(5) = results(results(:,1)==5 & results(:,2)==11,6);
ps(6) = results(results(:,1)==6 & results(:,2)==12,6);


FViolinExtVsFlx = figure; FViolinExtVsFlx.Position = [356 391 501 421];
ax = subplot(1,1,1,'parent',FViolinExtVsFlx); ax.NextPlot = 'add';
for cl = 1:length(unique(clustnum))
    pops{2*cl-1} = cavals(clustnum==cl & strcmp(extflx,'ext'));
    pops{2*cl} = cavals(clustnum==cl & strcmp(extflx,'flx'));
end
% violin(pops);
g = double(strcmp(extflx,'flx'))+1;
g = cat(2,clustnum,g);
boxplot(cavals,g,'plotstyle','compact','OutlierSize',1,'BoxStyle' ,'outline','MedianStyle','line')

xlabel(ax,'Cluster');
ax.XTick = [2 4 6 8 10 12] -.5;
ax.XTickLabel = {'1' '2' '3' '4' '5' '6'};

ylabel(ax,'F');
