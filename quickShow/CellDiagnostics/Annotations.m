function varargout = Annotations(intrial,varargin)
% varargout = CellInputResistance(trial,varargin)
%   plot all the input resistance measurements from the cell.  Save them to
%   the data structure

[~,dateID,flynum,cellnum,~,Dir,~,dfile] = ...
    extractRawIdentifiers(intrial.name);

% Find all the rawfiles
rawfiles = dir([Dir '*_Raw_*.mat']);
l = false(1,length(rawfiles));
for r_ind = 1:length(rawfiles)
    l(r_ind) = isempty(strfind(rawfiles(r_ind).name,'SealAndLeak'));
end
rawfiles = rawfiles(l);

fid = fopen(fullfile(Dir,'Annotations.txt'),'w');
curprtcl = [];
for r_ind = 1:length(rawfiles)
    
    try annotation = load(rawfiles(r_ind).name,'annotation');
    catch e
        continue
    end
    if isempty(annotation) || ~length(fieldnames(annotation))
        continue
    end
    annotation = annotation.annotation;
    params = load(rawfiles(r_ind).name,'params'); params = params.params;
    name = load(rawfiles(r_ind).name,'name'); name = name.name;
    excluded = load(rawfiles(r_ind).name,'excluded'); excluded = excluded.excluded;
    
    if isempty(curprtcl) || ~strcmp(params.protocol,curprtcl)
        curprtcl = params.protocol;
        fprintf(fid,'\n');
        fprintf(1,'\n');
    end
    for i = 1:size(annotation,1)
        switch excluded
            case 0
                fprintf(fid,[name(regexp(name,params.protocol):end) '(included): ' annotation{i,3} '\n']);
                fprintf(1,[name(regexp(name,params.protocol):end) '(included): ' annotation{i,3} '\n']);
            case 1
                fprintf(fid,[name(regexp(name,params.protocol):end) ' (excluded): ' annotation{i,3} '\n']);
                fprintf(1,[name(regexp(name,params.protocol):end) ' (excluded): ' annotation{i,3} '\n']);
        end
    end
end

fclose(fid);
fclose('all');
clear fid
winopen(Dir)

varargout = {};
