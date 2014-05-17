% drag and drop a file into matlab

[prot,datestr,fly,cellnum,trial,D] = extractRawIdentifiers(name);
stem = regexprep(name,'Acquisition','Raw_Data');
stem = regexprep(stem,prot,'%s');
stem = regexprep(stem,['_' trial '\.'],'_%d.');
stem = regexprep(stem,'\\','\\\');
cd(D)
[dfn,dfns] = createDataFileFromRaw(name);
for ind = 1:length(dfns)
    dfn = dfns{ind};
    data = load(dfn); data = data.data;
    dataOverview(data);
end

%% SealAndLeak
prot = 'SealAndLeak';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
f = blocknums;
cnt = 1;
for b = blocknums
    trial = load(sprintf(stem,data(1).protocol,data(find(blocks==b,1)).trial));
    [~,~,fig] = calculateSealMeasurements(trial,trial.params);
    proplist =  getpref('AnalysisFigures','calculateSealMeasurements');
    f(cnt) = figure(proplist{:});
    set(f(cnt),'tag',num2str(b));
    ch = copyobj(get(fig,'children'),f(cnt));
    cnt = cnt+1;
end
layout(f',sprintf('Seal Measurements Blocks: %s',sprintf('%d ', blocknums)),'close');

%% Sweep
prot = 'Sweep';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
for b = blocknums
    clear f P
    blocktrials = trials(blocks==b);
    cnt = 1;
    for bt = blocktrials;
        obj.trial = load(sprintf(stem,data(1).protocol,bt));
        f(cnt) = figure(50+cnt);
        f(cnt) = quickShow_Sweep(f(cnt),obj,'');
        clusters(cnt) = 1;
        [~,F,T,p] = trialSpectrogram(obj.trial,obj.trial.params);
        if exist('P','var')
            P = P+p;
        else P = p;
        end
        cnt = cnt+1;
    end
    f(cnt) = figure(50+cnt);
    clusters(cnt) = 2;

    ax = subplot(1,1,1,'parent',f(cnt));
    colormap(ax,'Hot') % 'Hot'
    surf(ax,T, F, 10*log10(P),'edgecolor','none');
    %set(ax, 'YScale', 'log');
    view(ax,0,90);
    axis(ax,'tight');
    ch = get(f(1),'children');
    set(ax,'xlim',get(ch(1),'xlim'));
    
    xlabel(ax,'Time (Seconds)'); ylabel(ax,'Hz');
    tags = getTrialTags(blocktrials,data);
    %title(ax,sprintf('%s Block %d: \\{%s\\}', [prot '.' d '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})));
    layoutClusters(f',clusters,sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');

end

%% Resting Membrane comparisons
naConcentrations = {'130','90','50','27','TTX'};
cells = {};
Vm_rest_cell = {};

% cells = {'131014.F3.C1'};
% load('C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\Sweep_Raw_131014_F3_C1_9.mat');
% Vm_rest = [mean(voltage),nan,nan,nan,nan];
% load('C:\Users\Anthony Azevedo\Raw_Data\131014\131014_F3_C1\Sweep_Raw_131014_F3_C1_31.mat');
% Vm_rest(3) = mean(voltage);
% Vm_rest_cell = {Vm_rest};

% ***********
cells = {cells{:},'131015.F1.C1'};
Vm_rest_v = nan(1,5);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_1.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_2.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_3.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_4.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_5.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(1) = Vm_rest/5;

% 50mM
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_16.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_17.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_18.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_19.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_20.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(3) = Vm_rest/5;

% TTX
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_41.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_42.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_43.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_44.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F1_C1\Sweep_Raw_131015_F1_C1_45.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(5) = Vm_rest/5;

Vm_rest_cell = {Vm_rest_cell{:},Vm_rest_v};

% ***********
cells = {cells{:},'131015.F3.C1'};
Vm_rest_v = nan(1,5);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_1.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_2.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_3.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_4.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_5.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(1) = Vm_rest/5;

% 50mM
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_11.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_12.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_13.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_14.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_15.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(3) = Vm_rest/5;

% 90mM
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_21.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_22.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_23.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_24.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_25.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(2) = Vm_rest/5;


% TTX
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_46.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_47.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_48.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_49.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131015\131015_F3_C1\Sweep_Raw_131015_F3_C1_50.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(5) = Vm_rest/5;

Vm_rest_cell = {Vm_rest_cell{:},Vm_rest_v};

% ***********
cells = {cells{:},'131016.F1.C1'};
Vm_rest_v = nan(1,4);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_1.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_2.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_3.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_4.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_5.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(1) = Vm_rest/5;

% 90mM
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_26.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_27.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_28.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_29.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_30.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(2) = Vm_rest/5;

% 50mM
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_36.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_37.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_38.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_39.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_40.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(3) = Vm_rest/5;

% 27 mM
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_51.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_52.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_53.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_54.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_55.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(4) = Vm_rest/5;

% TTX
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_71.mat');
Vm_rest = mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_72.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_73.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_74.mat');
Vm_rest = Vm_rest+mean(voltage);
load('C:\Users\Anthony Azevedo\Raw_Data\131016\131016_F1_C1\Sweep_Raw_131016_F1_C1_75.mat');
Vm_rest = Vm_rest+mean(voltage);

Vm_rest_v(5) = Vm_rest/5;

Vm_rest_cell = {Vm_rest_cell{:},Vm_rest_v};


figure
a = subplot(1,1,1); hold on
co = get(a,'colorOrder');
x = (5:-1:1);
for i = 1:length(Vm_rest_cell)
    y = Vm_rest_cell{i};
    l(i) = plot(x(~isnan(y)),y(~isnan(y)),'-o','color',co(mod(i,size(co,1)),:));
end
legend(l,cells,'location','NorthWest')
legend boxoff;
set(a,'XtickLabel',fliplr(naConcentrations),'xtick',(1:5));

xlabel('Na Concentrations or conditions')
ylabel('Resting potential (mV)')

ax = a;
set(ax,'fontsize',18)
set(findall(ax,'type','text'),'fontsize',18)
set(ax,'position',[0.2 0.2 0.75 0.7]);

set(gcf,'FileName','Na Exchange Experiments');


%% PiezoStep
prot = 'PiezoStep';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);
h.dir = D(1:end); h.prtclData = data; 
h.trialStem = [sprintf('%s_Raw_%s_%s_%s_',prot,datestr,fly,cellnum) '%d.mat']; 
h.currentPrtcl = prot;

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
for b = blocknums
    clear f
    blocktrials = trials(blocks==b);
    cnt = 1;
    for bt = blocktrials;
        h.trial = load(sprintf(stem,data(1).protocol,bt));
        f(cnt) = AverageLikeSteps([],h,'');
        cnt = cnt+1;
    end
    f = unique(f);
    f = sort(f);
    f = reshape(f,3,2)';
    tags = getTrialTags(blocktrials,data);
    layout(f,...
        sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');
end

%% PiezoSquareWave
prot = 'PiezoSquareWave';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);
h.dir = D(1:end); h.prtclData = data; 
h.trialStem = [sprintf('%s_Raw_%s_%s_%s_',prot,datestr,fly,cellnum) '%d.mat']; 
h.currentPrtcl = prot;

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
for b = blocknums
    clear f
    blocktrials = trials(blocks==b);
    cnt = 1;
    for bt = blocktrials;
        h.trial = load(sprintf(stem,data(1).protocol,bt));
        f(cnt) = AverageLikeSquareWaves([],h,'');
        cnt = cnt+1;
    end
    f = unique(f);
    f = sort(f);
    f = reshape(f,1,length(data(bt).displacements))';
    tags = getTrialTags(blocktrials,data);
    layout(f,...
        sprintf('%s Block %d: {%s}',[prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');
end

%% PiezoSine
prot = 'PiezoSine';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);
h.dir = D(1:end); h.prtclData = data; 
h.trialStem = [sprintf('%s_Raw_%s_%s_%s_',prot,datestr,fly,cellnum) '%d.mat']; 
h.currentPrtcl = prot;

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
for b = blocknums
    clear f
    blocktrials = trials(blocks==b);
    cnt = 1;
    for bt = blocktrials;
        h.trial = load(sprintf(stem,data(1).protocol,bt));
        f(cnt) = AverageLikeSines([],h,'');
        cnt = cnt+1;
    end
    f = unique(f);
    f = sort(f);
    f = reshape(f,length(data(bt).displacements),length(data(bt).freqs))';
    tags = getTrialTags(blocktrials,data);
    layout(f,...
        sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');
end

%% PiezoCourtshipSong
prot = 'PiezoCourtshipSong';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);
h.dir = D(1:end); h.prtclData = data; 
h.trialStem = [sprintf('%s_Raw_%s_%s_%s_',prot,datestr,fly,cellnum) '%d.mat']; 
h.currentPrtcl = prot;

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
for b = blocknums
    clear f
    blocktrials = trials(blocks==b);
    cnt = 1;
    for bt = blocktrials;
        h.trial = load(sprintf(stem,data(1).protocol,bt));
        f(cnt) = AverageLikeSongs([],h,'');
        cnt = cnt+1;
    end
    f = unique(f);
    f = sort(f);
    f = reshape(f,1,length(data(bt).displacements))';
    tags = getTrialTags(blocktrials,data);
    layout(f,...
        sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');
end

%% PiezoBWCourtshipSong
prot = 'PiezoBWCourtshipSong';
dfn = [D prot '_' datestr '_' fly '_' cellnum];
data = load(dfn); data = data.data;
dataOverview(data);
h.dir = D(1:end); h.prtclData = data; 
h.trialStem = [sprintf('%s_Raw_%s_%s_%s_',prot,datestr,fly,cellnum) '%d.mat']; 
h.currentPrtcl = prot;

[blocks,trials] = findTrialBlocks(data);
blocknums = unique(blocks);
for b = blocknums
    clear f
    blocktrials = trials(blocks==b);
    cnt = 1;
    for bt = blocktrials;
        h.trial = load(sprintf(stem,data(1).protocol,bt));
        f(cnt) = AverageLikeSongs([],h,'');
        cnt = cnt+1;
    end
    f = unique(f);
    f = sort(f);
    f = reshape(f,1,length(data(bt).displacements))';
    tags = getTrialTags(blocktrials,data);
    layout(f,...
        sprintf('%s Block %d: {%s}', [prot '.' datestr '.' fly '.' cellnum],b,sprintf('%s; ',tags{:})),...
        'close');
end
