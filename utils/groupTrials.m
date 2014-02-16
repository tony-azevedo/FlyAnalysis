function varargout = groupTrials(data,params_to_discriminate)

%% group trials index loop  TODO: turn this into a tree class
params_seen = containers.Map;

trials = zeros(length(data));
for t = 1:length(trials)
    trials(t) = data(t).trial;
end

for p = params_to_discriminate
    p_seen = containers.Map('KeyType', class(data(1).(p{1})),'ValueType','any');
    
    for e = 1:length(data)
        if ~p_seen.isKey(data(e).(p{1}))
            group_trials_vec = [];
        else
            group_trials_vec = p_seen(data(e).(p{1}));
        end
        group_trials_vec(end+1) = data(e).trial;
        p_seen(data(e).(p{1})) = group_trials_vec;
    end
    params_seen(p{1}) = p_seen;
end

dims = nan(length(params_to_discriminate),1);
for p = 1:length(params_to_discriminate)
    dims(p) = params_seen(params_to_discriminate{p}).Count;
end
gt = cell(dims(:)');


for e = 1:length(data)
    index = nan(size(dims));
    for d = 1:length(dims)
        param = params_to_discriminate{d};
        p_seen = params_seen(param).keys;
        switch class(p_seen{1})
            case 'char'
                l = find(strcmp(p_seen,data(e).(param)));
            case 'double'
                l = find(cell2mat(p_seen)==data(e).(param));
        end
        if ~isempty(l)
            index(d) = l;
        end
    end
    if sum(isnan(index))
        error('problem')
    end
    indxstr = sprintf('%g,',index(:));
    eval(sprintf('tmp = gt{%s};',indxstr(1:end-1)));
    tmp(end+1) = data(e).trial;
    eval(sprintf('gt{%s} = tmp;',indxstr(1:end-1)));
end

gt_vec = gt(:);
nee = false(size(gt_vec));
for e = 1:length(gt_vec)
    nee(e) = ~isempty(gt_vec{e});
end

gt_vec = gt_vec(nee);
gls = cell(size(gt_vec));
for g = 1:length(gt_vec)
    group = gt_vec{g};
    groupstr = '';
    for p = 1:length(params_to_discriminate)
        if isnumeric(data(group(1)).(params_to_discriminate{p}))
            p_val = num2str(data(group(1)).(params_to_discriminate{p}));
        else
            p_val = data(group(1)).(params_to_discriminate{p});
        end
        groupstr = sprintf('%s%s_%s_',groupstr,params_to_discriminate{p},p_val);
    end
    groupstr = regexprep(groupstr(1:end-1),'\.','o');
    gls{g} = groupstr;
    fprintf('\t%s\n',groupstr);
end

varargout = {gt_vec,gls,gt};


