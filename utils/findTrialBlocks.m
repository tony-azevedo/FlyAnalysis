function varargout = findTrialBlocks(data)

b = 1:length(data);
n = b;
i = b;
for d = 1:length(data)
    b(d) = data(d).trialBlock;
    n(d) = data(d).trial;
    i(d) = d;
end

varargout = {b,n,i};