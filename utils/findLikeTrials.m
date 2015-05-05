function varargout = findLikeTrials(varargin)
% [nums,inds] = findLikeTrials('name',name,'trial',trial,'window',window,'datastruct',datastruct)

p = inputParser;
p.addParameter('trial',[],@isnumeric);
p.addParameter('name','',@ischar);
p.addParameter('window',[],@isnumeric);
p.addParameter('datastruct',struct,@isstruct);
p.addParameter('exclude',{''},@iscell);
parse(p,varargin{:});

trial = p.Results.trial;
name = p.Results.name;
window = p.Results.window;
datastruct = p.Results.datastruct;
excludedFields = p.Results.exclude;

excludedFields = union(excludedFields,{'trial','gain','mode'});

if ~isempty(name);
    [~,~,~,~,trial,D,~,dfile] = extractRawIdentifiers(name);
    trial = str2double(trial);
    datastruct = load(dfile);
    datastruct = datastruct.data;
end
if isempty(window) && ~isempty(name)
    window = [1,length(datastruct)];
end
if isempty(window)
    window = [1,length(datastruct)];
end
    
% find like trials

for d = 1:length(datastruct)
    if datastruct(d).trial == trial
        compare_struct = datastruct(d);
        break
    end
end

if isfield(datastruct,'combinedTrialBlock') && compare_struct.combinedTrialBlock ~= 0
    fprintf(1,'Trial Blocks have been combined: %d\n',compare_struct.combinedTrialBlock);
    excludedFields = union(excludedFields,'trialBlock');
end

likenums = [];
likeinds = [];
for d = 1:length(datastruct)
    if datastruct(d).trial < min(window) || datastruct(d).trial > max(window)
        continue
    end
    fn = fieldnames(compare_struct);
    e = true;
    for f = 1:length(fn)
        if sum(strcmp(excludedFields,fn{f}))
            continue
        end
        switch class(datastruct(d).(fn{f}))
            case 'double'
                if length(datastruct(d).(fn{f})) == length(compare_struct.(fn{f}))
                    if datastruct(d).(fn{f}) ~= compare_struct.(fn{f})
                        e = false;
                        break
                    end
                else
                    e = false;
                    break
                end
            case 'char'
                if datastruct(d).(fn{f}) ~= compare_struct.(fn{f})
                    e = false;
                    break
                end
            case 'cell'
                if ~isempty(setxor(compare_struct.(fn{f}),datastruct(d).(fn{f})))
                    e = false;
                    break
                end
        end
    end
    if e
        likenums(end+1) = datastruct(d).trial;
        likeinds(end+1) = d;
    end
end
if ~isempty(name);
    trials = excludeTrials('trials',likenums,'name',name);
    [likenums,il] = intersect(likenums,trials);
    likeinds = likeinds(il);
end
varargout = {likenums,likeinds};
