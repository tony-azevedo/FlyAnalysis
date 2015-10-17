%% Set up the drug manipulations and the manipulations of size of the stimulus (foldX)
close all
trial = load(ac.trials.VoltageCommand);

h = getShowFuncInputsFromTrial(trial);
if isempty(strfind(h.dir,ac.name{1}))
    error('Get the right VoltageCommand trial, numbnuts!')
end

stimnames = {};
tag_collections = {};
for pd_ind = 1:length(h.prtclData);
    if ~ismember(h.prtclData(pd_ind).stimulusName,stimnames)
        stimnames{end+1} = h.prtclData(pd_ind).stimulusName;
        fprintf(1,'%s\n',stimnames{end});
    end
    
    tg_collection_str = sprintf('%s; ',h.prtclData(pd_ind).tags{:});
    if ~ismember(tg_collection_str,tag_collections);
        tag_collections{end+1} = tg_collection_str;
        fprintf(1,'%s\n',tg_collection_str);
    end
end
strprfunc = @(c)regexprep(c,{';','\s','^_','_$','\.'},{'','_','','','_'});

for tc_ind = 1:length(tag_collections)
    tag_collections{tc_ind} = strprfunc(tag_collections{tc_ind});
    tag_collections{tc_ind} = strprfunc(tag_collections{tc_ind});
end
if sum(ismember(tag_collections,''))
tag_collections = setxor(tag_collections,{''});
end

for d_ind = length(ac.drugs):-1:1
ac.drugs{d_ind} = strprfunc(ac.drugs{d_ind});
ac.drugs{d_ind} = strprfunc(ac.drugs{d_ind});
end

drugmap = struct();
for tc_ind = 1:length(tag_collections)
    for d_ind = length(ac.drugs):-1:1
        if ~isempty(regexpi(tag_collections{tc_ind},ac.drugs{d_ind}))
            break
        end
    end
    drugmap.(tag_collections{tc_ind}) = ac.drugs{d_ind};
    drugmap.(regexprep(tag_collections{tc_ind},'4','Four')) = ac.drugs{d_ind};
end

ENa = 1000*nernstPotential(130, 1,1);
EK = 1000*nernstPotential(3,141,1);
ECl = 1000*nernstPotential(117,1,1);
ECa = 1000*nernstPotential(1.5,1E-6,2);

Emap.TTX = ENa;
Emap.FourAP = EK;
Emap.TEA = EK;
Emap.FourAP_TEA = EK;
Emap.Cs = EK;
Emap.ZD = EK;
Emap.Cd = EK;
Emap.curare = 0;

comparestims = {'VoltageRamp_m100_p20',...
    'VoltageRamp_m70_p20','VoltageRamp_m70_p20_1s',...
    'VoltageRamp_m60_p40', 'VoltageRamp_m60_p40_1s',...
    'VoltageRamp_m60_p40_h_1s','VoltageRamp_m60_p40_h_0_5s'...
    'VoltageRamp_m50_p12_h_0_5s'};

rampstims = intersect(comparestims,stimnames);
stimnames = setdiff(stimnames,comparestims);

foldXs = {};
for st_ind = 1:length(stimnames)
    sn = stimnames{st_ind};
    foldX = sn(strfind(sn,'X')-1);
    if ~ismember(foldX,foldXs)
        foldXs{end+1} = foldX;
    end
end

foldX_stimnames = cell(size(foldXs));
for f_ind = 1:length(foldXs)
    foldX = foldXs{f_ind};
    X_stimnames = {};
    for st_ind = 1:length(stimnames)
        sn = stimnames{st_ind};
        if ~isempty(strfind(sn,[foldX 'X']))
            X_stimnames{end+1} = sn;
        end
        
    end
    foldX_stimnames{f_ind} = X_stimnames;
end

