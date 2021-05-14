function varargout = findLikeTrials_includingExcluded(varargin)
% [nums,inds] = findLikeTrials('name',name,'trial',trial,'window',window,'datastruct',datastruct)

p = inputParser;
p.addParameter('trial',[],@isnumeric);
p.addParameter('name','',@ischar);
p.addParameter('window',[],@isnumeric);
p.addParameter('datatable',table,@istable);
p.addParameter('exclude',{''},@iscell);
p.addParameter('withtags',{},@iscell);

parse(p,varargin{:});

trial = p.Results.trial;
name = p.Results.name;
window = p.Results.window;
datatable = p.Results.datatable;
excludedFields = p.Results.exclude;
includedTags = p.Results.withtags;

excludedFields = union(excludedFields,{'trial','gain','timestamp','arduino_duration','blueToggle','controlToggle','excluded'});

if ~isempty(name) 
    [~,~,~,~,trial,~,~,tfile] = extractRawIdentifiers(name);
    trial = str2double(trial);
    if isempty(datatable)
        datatable = load(tfile);
        datatable = datatable.T;
    end
end
if isempty(window) && ~isempty(name)
    window = [1,height(datatable)];
end
if isempty(window)
    window = [1,height(datatable)];
end
    
compare_row = datatable(datatable.trial==trial,:);
comptable = getDoubleColumns(datatable);
compare_row = getDoubleColumns(compare_row);
xtable = excludeColumns(comptable,excludedFields);
rowextable = excludeColumns(compare_row,excludedFields);

idx = true(height(xtable),1);
for cidx = 1:width(xtable)
    if ~isnan(rowextable{1,cidx})
        idx = idx & xtable{:,cidx} == rowextable{1,cidx};
    end
end
comptable = comptable(idx,:);

likenums = comptable.trial;
[~,a,b] = intersect(datatable.trial,comptable.trial);
varargout = {comptable.trial,a(:),comptable};
