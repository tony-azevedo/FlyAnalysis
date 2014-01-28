%% Figures for Rachel's JFRC meeting

%*********************
handles.trial = load('C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoSine_Raw_131211_F1_C2_22.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\PiezoSine_131211_F1_C2.mat')
plotcanvas = figure;
handles.params = data(22);
handles.prtclData = data;
savetag = 'delete';
% see also AverageLikeSines

[handles.currentPrtcl,dateID,flynum,cellnum,trialnum,handles.dir,handles.trialStem] = extractRawIdentifiers(handles.trial.name);

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'displacement','freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

freqs_to_include = handles.trial.params.freqs([1 2 3 5 7]);
clear f
cnt = 1;
for bt = blocktrials;
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    if ~sum(freqs_to_include == handles.trial.params.freq)
        continue
    end
    f(cnt) = AverageLikeSines([],handles,savetag);
    cnt = cnt+1;
end
f = unique(f);
f = sort(f);
if ~isfield(handles.prtclData(bt),'displacements');
    handles.prtclData(bt).displacements = handles.prtclData(bt).displacement;
end
f = reshape(f,length(handles.prtclData(bt).displacements),length(freqs_to_include));
f = f';
tags = getTrialTags(blocktrials,handles.prtclData);

b = nan;
if isfield(handles.trial.params, 'trialBlock')
    b = handles.trial.params.trialBlock;
end
newfig = layout(f,...
    sprintf('%s Block %d: {%s}', [handles.currentPrtcl '.' dateID '.' flynum '.' cellnum],b,sprintf('%s; ',tags{:})),...
    'closeno');

title(ax,'PiezoSine trial 22, displacement=0.10, freq=50.00, 16:16:0')

%% 

%*********************
handles.trial = load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\PiezoSine_Raw_131015_F3_C1_1.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\PiezoSine_131015_F3_C1.mat')
plotcanvas = figure;
handles.params = data(22);
handles.prtclData = data;
savetag = 'delete';
% see also AverageLikeSines

[handles.currentPrtcl,dateID,flynum,cellnum,trialnum,handles.dir,handles.trialStem] = extractRawIdentifiers(handles.trial.name);

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'displacement','freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

%freqs_to_include = handles.trial.params.freqs([1 2 3 5 7]);
clear f
cnt = 1;
for bt = blocktrials;
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    f(cnt) = AverageLikeSines([],handles,savetag);
    cnt = cnt+1;
end
f = unique(f);
f = sort(f);
if ~isfield(handles.prtclData(bt),'displacements');
    handles.prtclData(bt).displacements = handles.prtclData(bt).displacement;
end
f = reshape(f,length(handles.prtclData(bt).displacements),length(handles.prtclData(bt).freqs));
f = f';
tags = getTrialTags(blocktrials,handles.prtclData);

b = nan;
if isfield(handles.trial.params, 'trialBlock')
    b = handles.trial.params.trialBlock;
end
newfig = layout(f,...
    sprintf('%s Block %d: {%s}', [handles.currentPrtcl '.' dateID '.' flynum '.' cellnum],b,sprintf('%s; ',tags{:})),...
    'closeno');

title(ax,'PiezoSine trial 22, displacement=0.10, freq=50.00, 16:16:0')

%%
%*********************
handles.trial = load('C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoSine_Raw_131126_F2_C2_7.mat');
load('C:\Users\Anthony Azevedo\Raw_Data\131126\131126_F2_C2\PiezoSine_131126_F2_C2.mat')

plotcanvas = figure;
handles.params = data(22);
handles.prtclData = data;
savetag = 'delete';
% see also AverageLikeSines

[handles.currentPrtcl,dateID,flynum,cellnum,trialnum,handles.dir,handles.trialStem] = extractRawIdentifiers(handles.trial.name);

blocktrials = findLikeTrials('name',handles.trial.name,'datastruct',handles.prtclData,'exclude',{'displacement','freq'});
t = 1;
while t <= length(blocktrials)
    trials = findLikeTrials('trial',blocktrials(t),'datastruct',handles.prtclData);
    blocktrials = setdiff(blocktrials,setdiff(trials,blocktrials(t)));
    t = t+1;
end

%freqs_to_include = handles.trial.params.freqs([1 2 3 5 7]);
clear f
cnt = 1;
for bt = blocktrials;
    handles.trial = load(fullfile(handles.dir,sprintf(handles.trialStem,bt)));
    f(cnt) = AverageLikeSines([],handles,savetag);
    cnt = cnt+1;
end
f = unique(f);
f = sort(f);
if ~isfield(handles.prtclData(bt),'displacements');
    handles.prtclData(bt).displacements = handles.prtclData(bt).displacement;
end
f = reshape(f,length(handles.prtclData(bt).displacements),length(handles.prtclData(bt).freqs));
f = f';
tags = getTrialTags(blocktrials,handles.prtclData);

b = nan;
if isfield(handles.trial.params, 'trialBlock')
    b = handles.trial.params.trialBlock;
end
newfig = layout(f,...
    sprintf('%s Block %d: {%s}', [handles.currentPrtcl '.' dateID '.' flynum '.' cellnum],b,sprintf('%s; ',tags{:})),...
    'closeno');

title(ax,'PiezoSine trial 22, displacement=0.10, freq=50.00, 16:16:0')
