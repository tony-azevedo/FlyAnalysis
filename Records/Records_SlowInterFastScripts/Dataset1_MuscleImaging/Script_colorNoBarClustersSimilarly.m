% close all

dbfig1 = figure;
dbfig1.Position = [259 32 1247 964];
hght = ceil(length(T_legImagingList.CellID)/2);
for n = 1:length(T_legImagingList.CellID)
     axn = subplot(3,2,n,'parent',dbfig1); axn.NextPlot = 'add';
%    axn = subplot(1,1,1,'parent',dbfig1); axn.NextPlot = 'add';
end

hexclrs = [
    '3C489E'
    'D64C90'
    'F9A61A'
    '00FF00'
    '47DDFF'
%    '03AC72'
    'ED4545'
];
clrs = hex2rgb(hexclrs);

for cidx = 1:length(T_legImagingList.CellID)
    T_row = T_legImagingList(cidx,:);
    trialStem = [T_row.Protocol{1} '_Raw_' T_row.CellID{1} '_%d.mat'];

    Dir = fileparts(T_row.TableFile{1}); cd(Dir);

    cellid = T_row.CellID{1};
        
    nobartrial = load(sprintf(trialStem,T_row.Nobartrials{1}(1)));
    
    %% Using the bar clusters
    % Find the number of clusters I made (N=6 typically)
    if length(size(nobartrial.clmask))>2
        N_Cl_idx = nan(size(bartrial.clmask,3),1);
        for idx = 1:length(N_Cl_idx)
            N_Cl_idx(idx) = length(unique(nobartrial.clmask(:,:,idx)))-1;
        end
        clmask = squeeze(nobartrial.clmask(:,:,N_Cl_idx==min(size(nobartrial.clustertraces))));
    else
        clmask = bartrial.clmask;
    end
    blobs = regionprops(clmask, clmask>0, 'all');
    % find a fairly common mapping:
    % 1 - distal cluster
    % 2 - proximal cluster
    % 3 - the cluster in the middle
    % 4 - more dorsal
    % 5 - more dorsal
    % 6 - the remainder
    
    map = T_row.ClusterMapping_NoBar{1};

    axn = subplot(3,2,cidx,'parent',dbfig1);
    %axn = subplot(1,1,1,'parent',dbfig1);
    title(axn,regexprep(cellid,'\_','\\_'));
    % clrs = parula(size(bartrial.clustertraces,2)+1);
    imshow(clmask*0,[0 255],'parent',axn);
    for cl = 1:length(blobs)
        clridx = map(map(:,2)==cl,1);
        alphamask(clmask==cl,clrs(clridx,:),1,axn);
        % text(blobs(cl).Centroid(1),blobs(cl).Centroid(2),num2str(cl),'parent',axn,'color',[1 1 1],'verticalAlignment','middle','HorizontalAlignment','center');
    end
    
end

%%
filename = '3-NoBarClusters';
export_fig(dbfig1,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
export_fig(dbfig1,[figureoutputfolder '\' filename '.png'], '-png','-nocrop', '-r600','-transparent' , '-rgb');

