function varargout = addH5DataToTrials(dfn)

[filename,remain] = strtok(dfn,'\');
while ~isempty(remain);
    [filename,remain] = strtok(remain,'\');
end

D = regexprep(dfn,filename,'');
curprotocol = strtok(filename,'_');

fprintf('Adding params to raw files: %s \n',D);
rawfiles = dir([D '*.mat']);
protocols = cell(length(rawfiles),1);
for f = 1:length(rawfiles)
    protocols{f} = strtok(rawfiles(f).name,'_');
end
protocols = unique(protocols);

for prot = 1:length(protocols);
    clear params
    info = h5info(regexprep(dfn,curprotocol,protocols{prot}));
    trials = info.Groups;
    for n = 1:length(trials)
        h5params = trials(n).Datasets;
        for p = 1:length(h5params)
            params.(h5params(p).Name) = ...
                h5read(regexprep(dfn,curprotocol,protocols{prot}),...
                [trials(n).Name '/' h5params(p).Name]);
            
            if iscell(params.(h5params(p).Name))
                temp = params.(h5params(p).Name);
                params.(h5params(p).Name) = temp{1};
                if length(temp)>1
                    error('encountered weird situation');
                end
            end
            
        end
        name = [regexprep(trials(n).Name,'/',''),'.mat'];
        name = regexprep(name,'Acquisition','Raw_Data');
        raw = load(name);
        
        us = regexp(name,'_');
        dot = regexp(name,'\.');        
        trial = str2double(name(us(end)+1:dot(1)-1));

        params.trial = trial;

        
        raw.params = params;
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