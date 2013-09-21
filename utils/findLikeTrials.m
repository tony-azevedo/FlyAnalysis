function likenums = findLikeTrials(name,varargin)

[prot,d,fly,cell,trial,D] = extractRawIdentifiers(name);
trial = str2num(trial);
rawfiles = dir([D prot '_Raw*']);
p = inputParser;
p.addParamValue('window',[1,length(rawfiles)],@isnumeric);
p.addParamValue('datastruct',struct,@isstruct);
parse(p,varargin{:});

window = p.Results.window;
datastruct = p.Results.datastruct;

if length(fieldnames(datastruct))==0 || length(datastruct) ~= length(rawfiles) %#ok<ISMT>
    dfile = [prot '_' d '_' fly '_' cell '.mat'];
    dataFileName = fullfile(D,dfile);
    
    dataFileExist = dir(dataFileName);
    if length(dataFileExist)
        datastruct = load(dataFileName);
        datastruct = datastruct.data;
    end
    if ~length(dataFileExist) || length(datastruct) ~= length(rawfiles)
        createDataFileFromRaw(dataFileName);
        datastruct = load(dataFileName);
    end
end

% find like trials

for d = 1:length(datastruct)
    if datastruct(d).trial == trial
        compare = datastruct(d);
    end
end

likenums = [];
for d = 1:length(datastruct)
    if datastruct(d).trial < window(1) || datastruct(d).trial > window(2)
        continue
    end
    fn = fieldnames(compare);
    e = true;
    for f = 1:length(fn)
        if strcmp('trial',fn{f})
            continue
        end
        switch isnumeric(datastruct(d).(fn{f}))
            case true
                if datastruct(d).(fn{f}) ~= compare.(fn{f})
                    e = false;
                    break
                end
            case false
                if datastruct(d).(fn{f}) ~= compare.(fn{f})
                    e = false;
                    break
                end
        end
    end
    if e
        likenums(end+1) = datastruct(d).trial;
    end
end
