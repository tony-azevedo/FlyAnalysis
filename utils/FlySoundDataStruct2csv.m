function FlySoundDataStruct2csv(dfn)
% Script to save a csv for each protocol
dfn = regexprep(dfn,'Acquisition','Raw_Data');

[filename,remain] = strtok(dfn,'\');
while ~isempty(remain);
[filename,remain] = strtok(remain,'\'); %#ok<STTOK>
end

D = regexprep(dfn,filename,'');
dfn = regexprep(dfn,'_Raw','');
dfn = regexprep(dfn,'_\d*.mat','.mat');

fprintf('Creating csv files for %s\n',D);
files = dir([D '*_Raw_*.mat']);

[~,dateID,flynum,cellnum] = extractRawIdentifiers(files(1).name);
IDstr = [dateID '_' flynum '_' cellnum];
% IDstr = date_contents(dc_ind).name;

files = dir(['*',IDstr,'*']);
protocols = {};
protocolDataFns = {};

for f_ind =1:length(files)
    if isempty(regexp(files(f_ind).name,'Raw', 'once')) &&...
            isempty(regexp(files(f_ind).name,'notes', 'once')) &&...
            isempty(regexp(files(f_ind).name,'Rig', 'once')) &&...
            isempty(regexp(files(f_ind).name,'Acquisition', 'once')) &&...
            isempty(regexp(files(f_ind).name,'Params', 'once')) &&...
            isempty(regexp(files(f_ind).name,'.csv', 'once')) &&...
            ~isempty(regexp(files(f_ind).name,'.mat', 'once'))
        
        protocols{end+1} = files(f_ind).name(1:regexp(files(f_ind).name,IDstr)-2); %#ok<AGROW>
        protocolDataFns{end+1} = files(f_ind).name; %#ok<AGROW>
    end
end

contents = what;

% For each protocol in a data folder
for p_ind = 1:length(protocols)
    
    data = load(protocolDataFns{p_ind});
    data = data.data;
    
    [data.idstr] = deal(IDstr);
    [data.datestr] = deal(dateID);
    [data.path] = deal(D);
    
    % make the trial stem and creation date for the file,
    trialstem = [protocols{p_ind} '_Raw_' IDstr '_%d.mat'];
    
    % add to structure; date, fly, cell, genotype, trial name, time stapmp
    for d_ind = 1:length(data)
        
        data(d_ind).rawname = sprintf(trialstem,data(d_ind).trial);
        
        if strcmp(contents.mat,data(d_ind).rawname)
            a = dir(data(d_ind).rawname);
            data(d_ind).timestamp = a.date;
        else
            a = dir(contents.mat{end});
            data(d_ind).timestamp = a.date;
        end
    end
    
    % run the structarr2csv
    fprintf('\t\tSaving %s\n',[protocolDataFns{p_ind}(1:end-4) '.csv'])
    structarray2csv(data,[protocolDataFns{p_ind}(1:end-4) '.csv'])    
end

% 
% function data = updateDataForCurrentStruct(data)
% rpn = rigparamnames;
% 
% % Find out what the date, fly, cell genotype are.
% acqfn = dir('Acquisition_*');
% if length(acqfn)>0
%     load(fullfile('.',acqfn.name));
% end
% 
% if exist('acqStruct','var')
%     [data.flynumber] = deal(acqStruct.flynumber);
%     [data.cellnumber] = deal(acqStruct.cellnumber);
%     [data.genotype] = deal(acqStruct.flygenotype);
% else % annoying cases where I stored rig parameters in the trial structure
%     [data.genotype] = deal(data(1).flygenotype);
%     rpn = rigparamnames();
%     for rp_ind = 1:length(rpn)
%         if isfield(data,rpn{rp_ind});
%             rigStruct.(rpn{rp_ind}) = data(:).(rpn{rp_ind});
%             data = rmfield(data(:),rpn{rp_ind});
%         end
%     end
%     if exist('rigStruct','var')
%         name = ['RigStruct_', ...
%             data(1).date,'_F',data(1).flynumber,'_C',data(1).cellnumber];
%         save(name,'rigStruct');
%     end
%     
%     for ii = 1:length(data)
%         if isfield(data(ii),'recgain')
%             data(ii).gain = data(ii).recgain;
%         end
%         if isfield(data(ii),'recmode')
%             data(ii).mode = data(ii).recmode;
%         end
%     end
%     data = rmfield(data(:),'flygenotype');
%     if isfield(data(ii),'recgain')
%         data = rmfield(data(:),'recgain');
%     end
%     if isfield(data(ii),'recmode')
%         data = rmfield(data(:),'recmode');
%     end
% end