%% Create a table of cellids for Calcium Imagining experiments
%
% close all

T = T_MHC;

% allocation of double and cell arrays
n = zeros(height(T),1); n_cell = cell(height(T),1);

% Addtional columns in table
Bartrials = n_cell; 
Nobartrials = n_cell; 
% ClusterMapping = n_cell; 

T = addvars(T,Bartrials,Nobartrials);

% Preallocate Table
varTypes = varfun(@class,T,'OutputFormat','cell');
T_legImagingList = table('Size',[2000,size(T,2)],'VariableTypes',varTypes,'VariableNames',T.Properties.VariableNames);
Row_cnt = 0;

DEBUG = 0;

%%
CellIDs = T.CellID;

% if (DEBUG)
%     figure
%     ax = subplot(1,1,1);
% end

if (DEBUG)
    dbfig1 = figure;
    dbfig1.Position = [680 333 689 645];
    hght = ceil(length(CellIDs)/2);
    for n = 1:length(CellIDs)
        axn = subplot(3,2,n,'parent',dbfig1); axn.NextPlot = 'add';
    end
    
    % Non-bar clusters used on bar clusters
    dbfig2 = figure;
    dbfig2.Position = [680 333 689 645];
    hght = ceil(length(CellIDs)/2);
    for n = 1:length(CellIDs)
        axn = subplot(3,2,n,'parent',dbfig2); axn.NextPlot = 'add';
    end
end

for cidx = 1:length(CellIDs)
    T_row = T(cidx,:);
    trialStem = [T_row.Protocol{1} '_Raw_' T_row.CellID{1} '_%d.mat'];

    cellid = T_row.CellID{1};
    
    fprintf('Starting %s\n',cellid);
    
    Dir = fullfile('E:\Data',cellid(1:6),cellid);
    if ~exist(Dir,'dir')
        Dir = fullfile('F:\Acquisition',cellid(1:6),cellid);
    end
    cd(Dir);
    
    datafilename = fullfile(Dir);
    datafilename = fullfile(datafilename,[T.Protocol{cidx} '_' cellid '.mat']);
    data = load(datafilename); data = data.data;
    
    TP = datastruct2table(data,'DataStructFileName',datafilename,'rewrite',rewrite_yn);    
    TP = addExcludeFlagToDataTable(TP,trialStem);
    TP = addTrackingFlagsToDataTable(TP,trialStem);
    TP = TP(~TP.Excluded,:);
    T_row.TableFile = {TP.Properties.Description};
        
    T_row.Bartrials = {TP.trial(TP.HasProbe)};
    T_row.Nobartrials = {TP.trial(TP.HasTrackedLeg)};
    
    bartrial = load(sprintf(trialStem,T_row.Bartrials{1}(1)));
    
%     %% Using the bar clusters
%     % Find the number of clusters I made (N=6 typically)
%     if length(size(bartrial.clmask))>2
%         N_Cl_idx = nan(size(bartrial.clmask,3),1);
%         for idx = 1:length(N_Cl_idx)
%             N_Cl_idx(idx) = length(unique(bartrial.clmask(:,:,idx)))-1;
%         end
%         clmask = squeeze(bartrial.clmask(:,:,N_Cl_idx==min(size(bartrial.clustertraces))));
%     else
%         clmask = bartrial.clmask;
%     end
%     blobs = regionprops(clmask, clmask>0, 'all');
%     % find a fairly common mapping:
%     % 1 - distal cluster
%     % 2 - proximal cluster
%     % 3 - the cluster in the middle
%     % 4 - more dorsal
%     % 5 - more dorsal
%     % 6 - the remainder
%     
%     map = T_row.ClusterMapping{1};
% 
%     if (DEBUG)
%         axn = subplot(2,2,cidx,'parent',dbfig1); 
%         title(axn,regexprep(cellid,'\_','\\_'));
%         clrs = parula(size(bartrial.clustertraces,2)+1);
%         imshow(clmask*0,[0 255],'parent',axn);
%         for cl = 1:length(blobs)
%             clridx = map(map(:,2)==cl,1);
%             alphamask(clmask==cl,clrs(clridx,:),1,axn);
%             text(blobs(cl).Centroid(1),blobs(cl).Centroid(2),num2str(cl),'parent',axn,'color',[1 1 1],'verticalAlignment','middle','HorizontalAlignment','center');
%         end
%     end

    %% Using the non-bar clusters
    % Find the number of clusters I made (N=6 typically)
    % find a fairly common mapping:
    % 1 - distal cluster
    % 2 - proximal cluster
    % 3 - the cluster in the middle
    % 4 - more dorsal
    % 5 - more dorsal
    % 6 - the remainder

    clmask = bartrial.clmaskFromNonBarTrials;
    
    % replace the missing value, if there
    % move all the numbers back if nessesary
    clvals = unique(clmask);
    missing = setxor(clvals,0:max(clvals));
    map = T_row.ClusterMapping_NBCls{1};

    if ~isempty(missing)
        for j = length(missing):-1:1
            curmissing = missing(j);
            for i = curmissing+1:max(clvals)
                clmask(clmask==i) = i-1;
                map(map(:,2)==i,2) = i-1;
            end
        end
    end
    blobs = regionprops(clmask, clmask>0, 'all');
    

    if (DEBUG)
        axn = subplot(3,2,cidx,'parent',dbfig2); 
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

    %%
    Row_cnt = Row_cnt+1;
    T_legImagingList(Row_cnt,:) = T_row;
end

T_legImagingList = T_legImagingList(1:Row_cnt,:);

if (DEBUG)
    filename = '1-Clusters';
    export_fig(dbfig2,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
    filename = '2-NoBarClustersOnBartrials';
    export_fig(dbfig2,[figureoutputfolder '\' filename '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
    export_fig(dbfig2,[figureoutputfolder '\' filename '.png'], '-png','-nocrop','-transparent' , '-rgb');
end

