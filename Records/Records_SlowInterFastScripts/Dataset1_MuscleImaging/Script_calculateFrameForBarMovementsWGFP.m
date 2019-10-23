% close all
%%
% Go through all the probe frames

trial = load('E:\Data\171109\171109_F1_C1\EpiFlash2T_Raw_171109_F1_C1_1.mat');
[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

clear trials nobartrials bartrials

% if the position of the prep changes, make a new set
% bartrials{2} = 1:5; 
bartrials{1} = 6:65;
%%

minforce = 10;
maxforce = 200;

pops = cell(1,12);
cavals = [];
clustnum = [];
extflx = {};
cellnum = [];

Dir = D; cd(Dir);
cellid = '171109_F1_C1';
    
bartrials = bartrials{1};
bartrial = load(sprintf(trialStem,bartrials(1)));
bartrials = bartrials(bartrials~=55 & bartrials~=63);

%%
angle_ext_ = nan(max(size(bartrial.clustertraces)),length(bartrials));
angle_flx_ = nan(max(size(bartrial.clustertraces)),length(bartrials));
ft_ext_ = nan(max(size(bartrial.clustertraces)),length(bartrials));
ft_flx_ = nan(max(size(bartrial.clustertraces)),length(bartrials));
cluster_ext_ = nan(max(size(bartrial.clustertraces)),min(size(bartrial.clustertraces)),length(bartrials));
cluster_flx_ = nan(max(size(bartrial.clustertraces)),min(size(bartrial.clustertraces)),length(bartrials));
cnt = 0;
    
    %     minangle(cidx) = Inf;
    %     for tr = nobartrials'
    %         lp = load(sprintf(trialStem,tr),'legPositions');
    %         minangle(cidx) = min([minangle(cidx),min(lp.legPositions.Tibia_Angle)]);
    %     end
    
    for tr = bartrials(:)'
        
        bartrial = load(sprintf(trialStem,tr));
        ftleg = makeFrameTime(bartrial);
        ftcam = ftleg;
        ftmap = ftcam;

        cnt = cnt+1;

        ta = bartrial.forceProbeStuff.CoM - bartrial.forceProbeStuff.ZeroForce;

        stimsamps = ftcam>0.1&ftcam<bartrial.params.stimDurInSec-0.1;
        extend_log = (ta(:)<minforce & ftcam>0&ftcam<bartrial.params.stimDurInSec);
        extHeld = extend_log;
        angle_ext_(extHeld,cnt) = ta(extHeld);
        ft_ext_(extHeld,cnt) = ftcam(extHeld);
        for cl = 1:size(bartrial.clustertraces,2)
            cluster_ext_(extHeld,cl,cnt) = (bartrial.clustertraces(extHeld,cl)-min(bartrial.clustertraces(stimsamps,cl)))/min(bartrial.clustertraces(stimsamps,cl)) ;%bartrial.F0_clustertraces(cl))/bartrial.F0_clustertraces(cl);
            %cluster_ext_(extHeld,cl,cnt) = (bartrial.clustertraces(extHeld,cl));%-min(bartrial.clustertraces(stimsamps,cl)))/min(bartrial.clustertraces(stimsamps,cl)) ;%bartrial.F0_clustertraces(cl))/bartrial.F0_clustertraces(cl);
        end
        
        flex_log = (ta(:)>maxforce & ftcam>0&ftcam<bartrial.params.stimDurInSec);
        flxHeld = flex_log;
        angle_flx_(flxHeld,cnt) = ta(flxHeld);
        ft_flx_(flxHeld,cnt) = ftcam(flxHeld);
        cluster_flx_(flxHeld,:,cnt) = bartrial.clustertraces(flxHeld,:);
        for cl = 1:size(bartrial.clustertraces,2)
            cluster_flx_(flxHeld,cl,cnt) = (bartrial.clustertraces(flxHeld,cl)-min(bartrial.clustertraces(stimsamps,cl)))/min(bartrial.clustertraces(stimsamps,cl)); %bartrial.F0_clustertraces(cl))/bartrial.F0_clustertraces(cl);
            %cluster_flx_(flxHeld,cl,cnt) = (bartrial.clustertraces(flxHeld,cl));
        end
     end

    FfigExtVsFlx = figure; FfigExtVsFlx.Position = [356 391 501 421];
    ax = subplot(1,1,1,'parent',FfigExtVsFlx); ax.NextPlot = 'add';
    
    clmap = [
        1 1
        2 2
        3 3
        4 4
        5 5
        ];
    
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


[~,~,stats] = anovan(cavals,{clustnum extflx},'model','interaction',...
    'varnames',{'clustnum','extflx'});

results = multcompare(stats,'Dimension',[2 1]);
% ps(1) = results(results(:,1)==1 & results(:,2)==7,6);
% ps(2) = results(results(:,1)==2 & results(:,2)==8,6);
% ps(3) = results(results(:,1)==3 & results(:,2)==9,6);
% ps(4) = results(results(:,1)==4 & results(:,2)==10,6);
% ps(5) = results(results(:,1)==5 & results(:,2)==11,6);
% ps(6) = results(results(:,1)==6 & results(:,2)==12,6);


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
