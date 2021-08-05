function varargout = createTablesFromRaw(dfn,varargin)
% override = 0;
% if nargin
%     override = varargin{1};
% end
% 
% if  ~isempty(dir(dfn)) && ~override
%     return
% end

%% performance test
% 160706 - 160630_F1_C1: 16.36 seconds - 160630_F2_C1: 3.27 seconds 
%
tic 

tfnparts = split(dfn,filesep);

D = fullfile(tfnparts{1:end-1});
curprotocol = strtok(tfnparts{end},'_');
cellID = tfnparts{end-1}; 
tablename = fullfile(D,[curprotocol '_' cellID, '_Table.mat']);

fprintf('Creating parameter tables for %s\n',D);
rawfiles = dir(fullfile(D, '*_Raw_*.mat'));

select_protocols = 'all';
if nargin>1
    select_protocols = varargin{1};
end
switch select_protocols
    case 'all'
        protocols = cell(length(rawfiles),1);
        for f = 1:length(rawfiles)
            protocols{f} = strtok(rawfiles(f).name,'_');
        end
        protocols = unique(protocols);

    case 'one'
        protocols = {curprotocol};
end

tfns = protocols;
for p = 1:length(protocols)
    fprintf('Creating table %s:\n',protocols{p});
    rawfiles = dir(fullfile(D, [protocols{p} '_Raw_*.mat']));
    
    %% Create empty arrays and cells and table creation string
    trial = load(fullfile(D, rawfiles(1).name));
    
    data = trial.params;
    fldnames = fieldnames(data);
    tblCreateString = 'T = table(timestamp,';
    d = cell(size(fldnames));
    b = d;
    
    timestamp = zeros(size(rawfiles));
    tags = cell(size(rawfiles));
    excluded = zeros(size(rawfiles));
   
    for c_idx = 1:length(fldnames)
        if isa(data.(fldnames{c_idx}),'double')
            eval([fldnames{c_idx} ' = nan(size(rawfiles));']);
            d{c_idx} = '(';
            b{c_idx} = ')';
        end
        if isa(data.(fldnames{c_idx}),'double') && (length(data.(fldnames{c_idx}))>1 || strcmp(fldnames{c_idx}(end),'s')) % might be plural
            eval([fldnames{c_idx} ' = cell(size(rawfiles));']);
            d{c_idx} = '{';
            b{c_idx} = '}';
        elseif isa(data.(fldnames{c_idx}),'char')
            eval([fldnames{c_idx} ' = cell(size(rawfiles));']);
            d{c_idx} = '{';
            b{c_idx} = '}';
        elseif isa(data.(fldnames{c_idx}),'cell')
            eval([fldnames{c_idx} ' = cell(size(rawfiles));']);
            d{c_idx} = '{';
            b{c_idx} = '}';
        elseif isempty(data.(fldnames{c_idx}))
            eval([fldnames{c_idx} ' = nan(size(rawfiles));']);
            d{c_idx} = '(';
            b{c_idx} = ')';
        end
        
        tblCreateString = cat(2,tblCreateString,fldnames{c_idx},',');
        
    end
    tblCreateString = [tblCreateString(1:end-1) ',tags,excluded);'];
    
    %% now go through every trial and put the params into the appropriate vectors
    for f = 1:length(rawfiles)
        rawtrial = load(fullfile(D,rawfiles(f).name));
        if ~isfield(rawtrial,'excluded')
            rawtrial.excluded = 0;
            save(rawtrial.name, '-struct', 'rawtrial');
        end
        timestamp(f) = rawtrial.timestamp;
        excluded(f) = rawtrial.excluded;
        if isfield(rawtrial,'tags')
            tags{f} = rawtrial.tags;
        end

        for p_idx = 1:length(fldnames)
            evalstr = [fldnames{p_idx} d{p_idx} 'f' b{p_idx} ' = rawtrial.params.(fldnames{p_idx});'];
            try eval(evalstr);
            catch e
                if contains(fldnames{p_idx},'gain') && isempty(rawtrial.params.(fldnames{p_idx}))
                    gain(f) = nan;
                elseif contains(fldnames{p_idx},'mode') && isempty(rawtrial.params.(fldnames{p_idx}))
                    mode{f} = '';
                else
                    e.rethrow
                end
            end
        end
    end
    
    eval(tblCreateString)

    [~,order] = sort(T.trial);

    T = T(order,:);
    tfns{p} = regexprep(tablename,curprotocol,protocols{p});
    T.Properties.Description = tfns{p};
    
    fprintf('Writing table %s:\n',tfns{p});
    save(tfns{p},'T')
    
end

fprintf('Done creating Tables: %s',D)
toc
varargout = {dfn,tfns};