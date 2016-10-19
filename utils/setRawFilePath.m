function t = setRawFilePath(t)

n0 = t.name;

if ~isempty(strfind(t.name,'tony')) && isempty(strfind(t.name,'Anthony'))
    return;
else
    fprintf('Old naming cnvtn - ');
    keyboard
end
t.name = regexprep(t.name,'Acquisition','Raw_Data');

pcpath = getpref('USERDIRECTORY','PC');
macpath = getpref('USERDIRECTORY','MAC');

n = t.name;

if ~isfield(t,'name_mac')
    raw_start = regexp(n,'\\R','once');
    if isempty(raw_start)
        raw_start = regexp(n,'/R','once');
    end
    n = [macpath n(raw_start:end)];

    n = regexprep(n,'\','/');
    
    t.name_mac = n;
end

n = t.name;

if ~isfield(t,'name_pc')
    raw_start = regexp(n,'\\R','once');
    if isempty(raw_start)
        raw_start = regexp(n,'/R','once');
    end
    
    n = [pcpath n(raw_start:end)];
    
    n = regexprep(n,'/','\');
    
    t.name_pc = n;
end

n = t.name_pc;
%Correction to change paths
if isempty(strfind(n,pcpath))
    n1 = n;
    raw_start = regexp(n,'\\R','once');
    n = [pcpath n(raw_start:end)];
    t.name_pc = n;
    if regexp(t.name_pc,filesep)
        t.name = t.name_pc;
    end
end
n = t.name_mac;
%Correction to change to 'tony'
if isempty(strfind(n,macpath))
    n1 = n;
    raw_start = regexp(n,'/R','once');
    n = [macpath n(raw_start(1):end)];
    t.name_mac = n;
    if regexp(t.name_mac,filesep)
        t.name = t.name_mac;
    end
end



if regexp(t.name_mac,filesep)
    t.name = t.name_mac;
elseif regexp(t.name_pc,filesep)
    t.name = t.name_pc;
else
    error('No filename has the file separator character')
end

if ~strcmp(n0,t.name);
    trial = t;
    save(trial.name, '-struct', 'trial');
    fprintf('Saving Raw file - \nname: %s...%s...%s; \npc: %s...%s; \nmac: %s...%s\n',...
        t.name(1:11),t.params.protocol,t.name(end-7:end),...
        t.name_pc(1:11),t.name_pc(end-7:end),...
        t.name_mac(1:11),t.name_mac(end-7:end))
elseif exist('n1','var') && ~(strcmp(n1,t.name_mac) || strcmp(n1,t.name_pc))
    trial = t;
    save(trial.name, '-struct', 'trial');
    fprintf('Changing Paths - \nfrom: %s...%s...%s; \nto: %s...%s; \nmac: %s...%s\n',...
        n1(1:20),t.params.protocol,t.name(end-7:end),...
        t.name_pc(1:20),t.name_pc(end-7:end),...
        t.name_mac(1:20),t.name_mac(end-7:end))
else
    fprintf('Raw file - name: %s...%s...%s; pc: %s...%s; mac: %s...%s\n',...
        t.name(1:8),t.params.protocol,t.name(end-7:end),...
        t.name_pc(1:8),t.name_pc(end-7:end),...
        t.name_mac(1:8),t.name_mac(end-7:end))
end