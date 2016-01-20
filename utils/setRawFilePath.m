function t = setRawFilePath(t)

n0 = t.name;

t.name = regexprep(t.name,'Acquisition','Raw_Data');

pcpath = getpref('USERDIRECTORY','PC');
macpath = getpref('USERDIRECTORY','MAC');

n = t.name;

if ~isfield(t,'name_mac')
    if strfind(n,pcpath)
        n = [macpath n(length(pcpath)+1:end)];
    end
    n = regexprep(n,'\','/');
    
    t.name_mac = n;
end

n = t.name;

if ~isfield(t,'name_pc')
    if strfind(n,macpath)
        n = [pcpath n(length(macpath)+1:end)];
    end
    n = regexprep(n,'/','\');
    
    t.name_pc = n;
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
        t.name(1:8),t.params.protocol,t.name(end-7:end),...
        t.name_pc(1:8),t.name_pc(end-7:end),...
        t.name_mac(1:8),t.name_mac(end-7:end))
else
    fprintf('Raw file - name: %s...%s...%s; pc: %s...%s; mac: %s...%s\n',...
        t.name(1:8),t.params.protocol,t.name(end-7:end),...
        t.name_pc(1:8),t.name_pc(end-7:end),...
        t.name_mac(1:8),t.name_mac(end-7:end))
end