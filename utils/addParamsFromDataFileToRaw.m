function varargout = addParamsFromDataFileToRaw(dfn)

[filename,remain] = strtok(dfn,'\');
while ~isempty(remain);
[filename,remain] = strtok(remain,'\');
end

D = regexprep(dfn,filename,'');
curprotocol = strtok(filename,'_');

fprintf('Adding params for %s\n',D);
rawfiles = dir([D '*.mat']);

protocols = cell(length(rawfiles),1);
for f = 1:length(rawfiles)
    protocols{f} = strtok(rawfiles(f).name,'_');
end
protocols = unique(protocols);

for p = 1:length(protocols)
    data = load(regexprep(dfn,curprotocol,protocols{p}));
    data = data.data;
    rawfiles = dir([D protocols{p} '*_Raw_*']);
    fprintf('\t%s\n',protocols{p});
    for r = 1:length(rawfiles)
        raw = load([D rawfiles(r).name]);
        if isfield(raw,'params')
            continue
        end
        
        us = regexp(raw.name,'_');
        trialnum = str2double(raw.name(us(end)+1:end));
        if trialnum == data(trialnum).trial
            raw.params = data(trialnum);
        end
        fprintf('\t%d\t',trialnum);
        fn = fieldnames(raw);
        savestr = ['save(name'];
        for f = 1:length(fn)
            eval([fn{f} '=raw.(fn{f});'])
            savestr = [savestr ',''' fn{f} ''''];
        end
        savestr = [savestr ');'];

        name = regexprep(name,'Acquisition','Raw_Data');
        eval(savestr)
        fprintf('\t%s\n',name);
    end
end

varargout = {};