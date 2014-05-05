% Script to save a csv for each protocol
%%  Make sure to navigate to the Raw Data folder

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
        
        % Find out what the date, fly, cell genotype are.
        contents = what;
        acqfn = dir('Acquisition_*');
        load(fullfile('.',acqfn.name));
        IDstr = acqfn.name(12:end-4);
        
        files = dir(['*',IDstr,'*']);
        protocols = {};
        protocolDataFns = {};
        
        for f_ind =1:length(files)
            if isempty(regexp(files(f_ind).name,'Raw')) &&...
                    isempty(regexp(files(f_ind).name,'notes')) &&...
                    isempty(regexp(files(f_ind).name,'Rig')) &&...
                    isempty(regexp(files(f_ind).name,'Acquisition')) &&...
                    isempty(regexp(files(f_ind).name,'.csv')) &&...
                    ~isempty(regexp(files(f_ind).name,'.mat'))
                
                protocols{end+1} = files(f_ind).name(1:regexp(files(f_ind).name,IDstr)-1);
                protocolDataFns{end+1} = files(f_ind).name;
            end
        end
        
        
        % For each protocol in a data folder
        for p_ind = 1:length(protocols)
            
            data = load(protocolDataFns{p_ind});
            data = data.data;
            
            % make the trial stem and creation date for the file,
            trialstem = [protocols{p_ind} '_Raw' IDstr '_%d.mat'];
            
            % add to structure; date, fly, cell, genotype, trial name, time stapmp
            for d_ind = 1:length(data)
                
                data(d_ind).rawname = sprintf(trialstem,data(d_ind).trial);
                data(d_ind).datestr = IDstr(2:7);
                data(d_ind).idstr = IDstr(2:end);
                data(d_ind).fly = acqStruct.flynumber;
                data(d_ind).cell = acqStruct.cellnumber;
                data(d_ind).genotype = acqStruct.flygenotype;
                if strcmp(contents.mat,data(d_ind).rawname)
                    a = dir(data(d_ind).rawname);
                    data(d_ind).timestamp = a.date;
                else
                    data(d_ind).timestamp = acqfn.date;
                end
                data(d_ind).path = contents.path;
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