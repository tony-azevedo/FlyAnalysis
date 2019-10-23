% close all

dbfig1 = figure;
dbfig1.Position = [259 32 1247 964];
hght = ceil(length(T_legImagingList.CellID)/2);
for n = 1:6
    axn = subplot(3,2,n,'parent',dbfig1); axn.NextPlot = 'add';
    %    axn = subplot(1,1,1,'parent',dbfig1); axn.NextPlot = 'add';
end

hexclrs = [
    '3C489E'
    'D64C90'
    'F9A61A'
    '00FF00'
    '47DDFF'
    'ED4545'
    '03AC72'
    '3304AC'    
    ];
clrs = hex2rgb(hexclrs);

cidx = 2 % used for the paper
T_row = T_legImagingList(cidx,:);
trialStem = [T_row.Protocol{1} '_Raw_' T_row.CellID{1} '_%d.mat'];

Dir = fileparts(T_row.TableFile{1}); cd(Dir);

cellid = T_row.CellID{1};

nobartrial = load(sprintf(trialStem,T_row.Nobartrials{1}(1)));

Nclustermap_181210_F1_C1{4} = T_row.ClusterMapping_NoBar{1};

Nclustermap_181210_F1_C1{1} = [
    1     1
    4     2
    3     3];
Nclustermap_181210_F1_C1{2} = [
    2     1
    1     2
    3     3
    4     4];
Nclustermap_181210_F1_C1{3} = [
    1     1
    6     2
    5     3
    4     4
    3     5];

Nclustermap_181210_F1_C1{5} = [
    2     1
    4     2
    5     3
    7     4
    1     5
    6     6
    3     7];


Nclustermap_181210_F1_C1{6} = [
    3     1
    8     2
    6     3
    1     4
    5     5
    2     6
    7     7
    4     8];


%% showing no bar clusters
% Find the number of clusters I made (N=6 typically)
N_Cl_idx = nan(size(bartrial.clmask,3),1);
for idx = 1:length(N_Cl_idx)
    N_Cl_idx(idx) = length(unique(nobartrial.clmask(:,:,idx)))-1;
end
for idx = 1:length(N_Cl_idx)
    clmask = squeeze(nobartrial.clmask(:,:,idx));
    blobs = regionprops(clmask, clmask>0, 'all');
    % find a fairly common mapping:
    % 1 - distal cluster
    % 2 - proximal cluster
    % 3 - the cluster in the middle
    % 4 - more dorsal
    % 5 - more dorsal
    % 6 - the remainder
    
    map = Nclustermap_181210_F1_C1{idx};
    
    axn = subplot(3,2,idx,'parent',dbfig1);
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
filename = 'AllN-NoBarClusters';
export_fig(dbfig1,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
export_fig(dbfig1,[figureoutputfolder '\' filename '.png'], '-png','-nocrop', '-r600','-transparent' , '-rgb');

