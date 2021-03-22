function T = datastruct2table(data,varargin)
% Turns a structure array into a data table. It assumes all the structures
% have the same fields and just creates a row for each structure array
% entry. 
% Amazingly, the table is quite a bit more efficient, eg 5kb vs 21 kb

p = inputParser;
p.PartialMatching = 0;
p.addParameter('DataStructFileName','',@ischar);
p.addParameter('rewrite','no',@ischar);

parse(p,varargin{:});

if ~isempty(p.Results.DataStructFileName) && ~strcmp(p.Results.rewrite,'yes')
    tablename = regexprep(p.Results.DataStructFileName,'.mat','_Table.mat');
    if exist(tablename,'file')
        T = load(tablename); 
        if isfield(T,'T')
            T = T.T;
            %             head(T)
            return
        end
    end
end
tablename = regexprep(p.Results.DataStructFileName,'.mat','_Table.mat');

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
    if isa(data(1).(fldnames{c_idx}),'double') && (length(data(1).(fldnames{c_idx}))>1 || strcmp(fldnames{c_idx}(end),'s')) % might be plural
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
    
    tblCreateString = cat(2,tblCreateString,fldnames{c_idx},',');
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
    fprintf('Writing table %s:\n',tablename);
    save(tablename,'T')
end

