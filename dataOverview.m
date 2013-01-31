function [] = dataOverview(data)

dispstr = '';
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
        [unq,~,IC] = unique(cell2mat(tmp));
        unq = cellstr(num2str(unq'));
    else
        [unq,~,IC] = unique(tmp);
    end
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
