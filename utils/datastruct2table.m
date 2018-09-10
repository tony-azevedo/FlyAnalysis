function T = datastruct2table(data,varargin)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('DataStructFileName','',@ischar);

parse(p,varargin{:});

if ~isempty(p.Results.DataStructFileName)
    tablename = regexprep(p.Results.DataStructFileName,'.mat','_Table.mat');
%     if exist(tablename,'file')
%         T = load(tablename);
%         return
%     end
end

% sz = [length(data) length(fieldnames(data(1)))];

fldnames = fieldnames(data(1));
tblCreateString = 'T = table(';
d = '(';
b = ')';
for c_idx = 1:length(fldnames)
    if isa(data(1).(fldnames{c_idx}),'double')
        eval([fldnames{c_idx} ' = nan(size(data));']);
        d = '(';
        b = ')';
    end
    if isa(data(1).(fldnames{c_idx}),'double') && length(data(1).(fldnames{c_idx}))>1
        eval([fldnames{c_idx} ' = cell(size(data));']);
        d = '{';
        b = '}';
    elseif isa(data(1).(fldnames{c_idx}),'char')
        eval([fldnames{c_idx} ' = cell(size(data));']);
        d = '{';
        b = '}';
    elseif isa(data(1).(fldnames{c_idx}),'cell')
        eval([fldnames{c_idx} ' = cell(size(data));']);
        d = '{';
        b = '}';
    elseif isempty(data(1).(fldnames{c_idx}))
        eval([fldnames{c_idx} ' = nan(size(data));']);
        d = '(';
        b = ')';
    end
    
    tblCreateString = [tblCreateString fldnames{c_idx} ','];
    for r_idx = 1:length(data)
        if isempty(data(r_idx).(fldnames{c_idx}))
            continue
        end
        evalstr = [fldnames{c_idx} d 'r_idx' b ' = data(r_idx).(fldnames{c_idx});'];
        try eval(evalstr);
        catch e
            disp(e)
        end
    end
end
tblCreateString = [tblCreateString(1:end-1) ');'];

eval(tblCreateString)

T.Properties.Description = tablename;

if ~isempty(p.Results.DataStructFileName)
    save(tablename,'T')
end
