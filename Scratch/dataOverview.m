function [] = dataOverview(data)

dispstr = sprintf('%s\n',data(1).protocol);
field = fieldnames(data);
l = length(data);
tmp = cell(1,l);

for name = 1:length(field)
    % for now, skip the following:
    if sum(strcmp(field{name},{'trial','Ihold','Vrest','Rin','trigdiff'}));
        continue
    end
    for e = 1:l
        tmp{e} = data(e).(field{name});
    end
    if isnumeric(tmp{1})
        for i = 1:length(tmp)
            tmp{i} = num2str(tmp{i});
        end
    end
    if iscell(tmp{1})
        for i = 1:length(tmp)
            c = tmp{i};
            tmp{i} = sprintf('%s; ',c{:});
        end
    end

    [unq,~,IC] = unique(tmp);
    if length(unq)>1
        unqstr = '';
        for u = 1:length(unq)
            unqstr = sprintf('%s\t\t%s: %g\n',unqstr,unq{u},sum(IC==u));
        end
        str = sprintf('\t%s:\n',field{name});
        str = sprintf('%s%s\n',str,unqstr);
        dispstr = sprintf('%s%s',dispstr,str);
    end
end

fprintf('\n%s\n',dispstr')
