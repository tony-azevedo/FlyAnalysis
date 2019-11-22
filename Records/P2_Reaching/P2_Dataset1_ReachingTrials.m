%% Cells with steps and ramps 
varNames = {'CellID','Genotype','Cell_label','Protocol','TableFile'};

sz = [1 length(varNames)];
data = cell(sz);
T = cell2table(data);
T.Properties.VariableNames = varNames;

T{1,:} = {'191107_F1_C1', 'WT_berlin',            'pilot', 'EpiFlash2T','empty'}; 
% T{2,:} = {'171102_F2_C1', '81A07/ChR',            'fast', 'PiezoRamp2T','empty',0}; 
% T{end+1,:} = {'171103_F1_C1', '81A07/ChR',            'fast', 'PiezoRamp2T','empty',0};

T_Reach = T;

% Script_tableOfReachData

%% Create a plot aligning trials according to light duration on
% Then color force through out trials

CellID = T.CellID;

for cidx = 1:length(CellID)
    T_row = T(cidx,:);
    
    cid = CellID{cidx};
fprintf('Starting %s\n',cid);

Dir = fullfile('E:\Data',cid(1:6),cid);
cd(Dir);

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(trial.name);
DataStruct = load(datastructfile); TP = datastruct2table(DataStruct.data);
bartrials = {TP.trial(:)'};

end

%% Create a plot ordering trials normally
% Then color force through out trials

CellID = T.CellID;

for cidx = 1:length(CellID)
    T_row = T_Reach(cidx,:);
    
    cid = CellID{cidx};
    fprintf('Starting %s\n',cid);

    Dir = fullfile('E:\Data',cid(1:6),cid);
    cd(Dir);
    
    datastructfile = fullfile(Dir);
    datastructfile = fullfile(datastructfile,[T.Protocol{cidx} '_' cid '.mat']);
    DataStruct = load(datastructfile); 
    TP = datastruct2table(DataStruct.data,'DataStructFileName',datastructfile,'rewrite','yes');
    
    TP = addArduinoDurationToDataTable(TP);
    
    figure
    % for now just make a matrix of the correct size, and imshow it in
    % parula
    trials = TP.trial(~isnan(TP.ArduinoDuration));
    trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(trials(1)) '.mat']));
    forceProbe = zeros(length(trial.forceProbeStuff.CoM),length(trials));
    ft = makeFrameTime(trial);
    for t = 1:length(trials)
        tr = trials(t);
        trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
        forceProbe(:,t) = trial.forceProbeStuff.CoM - trial.forceProbeStuff.ZeroForce;
    end
    figure;
    ax1 = subplot(1,1,1);
    s1 = pcolor(ax1,ft,trials,forceProbe');
    s1.EdgeColor = 'flat';
    colormap(ax1,'parula')
    clrbr = colorbar(ax1);
    xlabel(ax1,'Time (s)');
    ylabel(ax1,'Trial #');

    ax1.NextPlot = 'add';
    ad = TP.ArduinoDuration(~isnan(TP.ArduinoDuration));
    plot(ax1,ad,trials,'.','color',[1,1,1])
    
    ax1.Parent.Color = [0 0 0];
    ax1.YColor = [1 1 1];
    ax1.XColor = [1 1 1];
    clrbr.Color = [1 1 1];
    clrbr.Label.String = '\Delta (\mum)';
end











