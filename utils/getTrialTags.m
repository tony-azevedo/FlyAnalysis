function tags = getTrialTags(nums,id)

if isstruct(id)
    tags = {};
    for n = 1:length(nums)
        tags = union(id(nums(n)).tags,tags);
    end
elseif ischar(id)
    tags = {};
    for n = 1:length(nums)
        trial = load(sprintf(id,nums(n)));
        tags = union(trial.tags,tags);
    end 
end