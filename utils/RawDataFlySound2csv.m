function RawDataFlySound2csv()
% Script to save a csv for each protocol
%%  Make sure to navigate to the Raw Data folder
cd C:\Users\Anthony' Azevedo'\Raw_Data\
%%

dotname = @(s) isempty(strfind(s,'.')); % utility function for navigating folders

root_contents = dir;
% clean out the contents
root_contents = root_contents(find(cell2mat({root_contents(:).isdir})));
root_contents = root_contents(find(cellfun(dotname,{root_contents(:).name})));

for rc_ind = 1:length(root_contents)
    
    fprintf('In %s directory\n',root_contents(rc_ind).name);
    eval(sprintf('cd %s',root_contents(rc_ind).name));
    
    date_contents = dir;
    % clean out the contents
    date_contents = date_contents(find(cell2mat({date_contents(:).isdir})));
    date_contents = date_contents(find(cellfun(dotname,{date_contents(:).name})));
    
    for dc_ind = 1:length(date_contents)
        
        fprintf('\tIn %s directory\n',date_contents(dc_ind).name);
        eval(sprintf('cd %s',date_contents(dc_ind).name));
        IDstr = date_contents(dc_ind).name;
                
        files = dir(['*',IDstr,'*']);
        protocols = {};
        protocolDataFns = {};
        
        for f_ind =1:length(files)
            if isempty(regexp(files(f_ind).name,'Raw')) &&...
                    isempty(regexp(files(f_ind).name,'notes')) &&...
                    isempty(regexp(files(f_ind).name,'Rig')) &&...
                    isempty(regexp(files(f_ind).name,'Acquisition')) &&...
                    isempty(regexp(files(f_ind).name,'Params')) &&...
                    isempty(regexp(files(f_ind).name,'.csv')) &&...
                    ~isempty(regexp(files(f_ind).name,'.mat'))
                
                protocols{end+1} = files(f_ind).name(1:regexp(files(f_ind).name,IDstr)-2);
                protocolDataFns{end+1} = files(f_ind).name;
            end
        end
        
        contents = what;
        
        % For each protocol in a data folder
        for p_ind = 1:length(protocols)
            
            data = load(protocolDataFns{p_ind});
            data = data.data;
            
            data = updateDataForCurrentStruct(data);
            [data.idstr] = deal(IDstr);
            [data.datestr] = deal(IDstr(1:regexp(IDstr,'_F')-1));
            [data.path] = deal(contents.path);
            
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
        cd ..
        clearvars -except date_contents root_contents dc_ind rc_ind dotname
    end
    cd ..
end


function data = updateDataForCurrentStruct(data)
rpn = rigparamnames;

% Find out what the date, fly, cell genotype are.
acqfn = dir('Acquisition_*');
if length(acqfn)>0
    load(fullfile('.',acqfn.name));
end

if exist('acqStruct','var')
        [data.flynumber] = deal(acqStruct.flynumber);
        [data.cellnumber] = deal(acqStruct.cellnumber);
        [data.genotype] = deal(acqStruct.flygenotype);
else % annoying cases where I stored rig parameters in the trial structure
    [data.genotype] = deal(data(1).flygenotype);
    rpn = rigparamnames();
    for rp_ind = 1:length(rpn)
        if isfield(data,rpn{rp_ind});
            rigStruct.(rpn{rp_ind}) = data(:).(rpn{rp_ind});
            data = rmfield(data(:),rpn{rp_ind});
        end
    end
    if exist('rigStruct','var')
        name = ['RigStruct_', ...
            data(1).date,'_F',data(1).flynumber,'_C',data(1).cellnumber];
        save(name,'rigStruct');
    end

    for ii = 1:length(data)
        if isfield(data(ii),'recgain')
            data(ii).gain = data(ii).recgain;
        end
        if isfield(data(ii),'recmode')
            data(ii).mode = data(ii).recmode;
        end
    end
    data = rmfield(data(:),'flygenotype');
    if isfield(data(ii),'recgain')
        data = rmfield(data(:),'recgain');
    end
    if isfield(data(ii),'recmode')
        data = rmfield(data(:),'recmode');
    end
end

function  rpn = rigparamnames()
rpn = { 
    'headstagegain' 
    'daqCurrentOffset' 
    'daqout_to_current' 
    'daqout_to_current_offset' 
    'daqout_to_voltage' 
    'daqout_to_voltage_offset' 
    'rearcurrentswitchval' 
    'hardcurrentscale' 
    'hardcurrentoffset' 
    'hardvoltagescale' 
    'hardvoltageoffset' 
    'scaledcurrentscale' 
    'scaledcurrentoffset' 
    'scaledvoltagescale' 
    'scaledvoltageoffset'
    'Cm'
    'Rinput'
    'Rseries'
    'currentoffset'
    'currentscale'
    'iclampoutputfactor'
    'vclampoutputfactor'
    'voltageoffset'
    'voltagescale'
    };
