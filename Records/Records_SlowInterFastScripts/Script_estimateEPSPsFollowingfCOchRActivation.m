% In the T table are lines for each cell and the positions analyzed.
% Go through each cell and add lines for each displacement value at each
% position.

DEBUG =1;

CellID = T.CellID;
T_new = T(1,:);
T_new.CellID = 'placeholder';
Row_cnt = 0;

if (DEBUG)
    figure
    ax = subplot(1,1,1);
end

for cidx = 1:length(CellID)
    T_row = T(cidx,:);
    
    cid = CellID{cidx};
    
    fprintf('Starting %s\n',cid);
    
    Dir = fullfile('B:\Raw_Data',cid(1:6),cid);
    cd(Dir);
    
    datafilename = fullfile('B:\Raw_Data',cid(1:regexp(cid,'_')-1),cid);
    datafilename = fullfile(datafilename,[T.Protocol{cidx} '_' cid '.mat']);
    try data = load(datafilename); data = data.data;
    catch e
        if strcmp(e.identifier,'MATLAB:load:couldNotReadFile')
            fprintf(' --- Could not find PiezoStep Info for %s. Moving on\n',cid);
            continue
        else
            e.rethrow
        end
    end
    
    fprintf(1,'\tTablizing datastructure %s\n',datafilename);
    TP = datastruct2table(data,'DataStructFileName',datafilename);
    
    TP.FlashIntensity = TP.stimDurInSec.*TP.ndf;
    trialnums = T.Trialnums{cidx};
    trialname = fullfile(Dir,[T.Protocol{cidx} '_Raw_' cid '_' num2str(trialnums(1)) '.mat']);
    [~,~,~,~,~,~,trialStem] = extractRawIdentifiers(trialname);

    [tr_idx,~,TP_idx] = intersect(trialnums,TP.trial);
    TP_interesting = TP(TP_idx,:);
    
    spikenums = zeros(length(TP_spikes_position.trial));
    peak = nan(length(TP_spikes_position.trial));
    ttpk = nan(length(TP_spikes_position.trial));
    if DEBUG
        cla(ax)
        title(ax,cid); hold(ax,'on')
        ax.XLim = [0 .3];
        drawnow
    end

    for tr = 1:length(TP_spikes_position.trial)
        trial = load(fullfile(Dir,sprintf(trialStem,TP_spikes_position.trial(tr))));
        if isfield(trial,'excluded') && trial.excluded
            continue
        end
        fprintf(1,'%d\n',length(trial.spikes));
        spikenums(tr) = length(trial.spikes);

        if length(trial.spikes)==0
            continue
        end

        t = makeInTime(trial.params);
        ft = makeFrameTime(trial);
        ft_spike = ft-t(trial.spikes(1));
        
        twitch = trial.forceProbeStuff.CoM;
        twitch = twitch - twitch(find(ft_spike<0,1,'last'));
        
        [peak(tr),ttpk_i] = max(twitch(ft_spike>0));
        ttpk_i = ttpk_i+sum(ft_spike<=0);
        ttpk(tr) = ft_spike(ttpk_i);
        
        if DEBUG 
            plot(ax,ft_spike(ft_spike>0),twitch(ft_spike>0));
            plot(ax,ttpk(tr),twitch(ttpk_i),'ok');
        end

    end
end
T_new = T_new(~strcmp(T_new.CellID,'placeholder'),:);


