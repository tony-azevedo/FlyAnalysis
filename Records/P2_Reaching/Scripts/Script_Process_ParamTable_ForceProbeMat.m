%% Script_Process_ParamTable_ForceProbeMat

%% downsample force probe at Pyas frame rate, save the matrix

forceprobematname = regexprep(T_params.Properties.Description,'Table.','ForceProbe.');

if exist(forceprobematname,'file')
    fbstruct = load(forceprobematname);
    if isfield(fbstruct,'forceProbe')
        ft = fbstruct.forceProbeTime;
        forceProbe = fbstruct.forceProbe;
    end
else
    trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(T_params.trial(1)) '.mat']));
    
    dsmp = round(quantile(diff(find(diff(trial.probe_position)>0)),.1));
    fprintf('Probe comb frames = %d; rate = %g\n',dsmp,trial.params.sampratein/dsmp)
    if dsmp>300
        dsmp = 246; %
        fprintf('Probe comb default = %d; rate = %g\n',dsmp,trial.params.sampratein/dsmp)
    end
    
    % Find the shortest duration
    dur = min(T_params.durSweep)*T_params.sampratein(1);
    
    probe_comb = 1:dsmp:dur; % length(trial.probe_position);
    
    forceProbe = nan(length(probe_comb),length(T_params.trial));    
    t = makeInTime(trial.params);
    ft = t(probe_comb);
    for t = 1:length(T_params.trial)
        tr = T_params.trial(t);
        trial = load(fullfile(Dir,[T_row.Protocol{1} '_Raw_' cid '_' num2str(tr) '.mat']));
        try forceProbe(:,t) = trial.probe_position(probe_comb);
        catch e
            if contains(e.message,'Reference')
                fprintf('No probe_position for trial %d\n',t);
                continue
            end
        end
        if rem(t,50)==0
            fprintf('Getting trial %d\n',t)
        end
    end
    fbstrct.forceProbe = forceProbe;
    fbstrct.forceProbeTime = ft;
    save(forceprobematname, '-struct', 'fbstrct');
end

%% Finds blocks at the rest trials

% assume some rest trials
resttrialstart = find(diff(T_params.ndf==0)>0)+1;
resttrialend = find(diff(T_params.ndf==0)<0);
% check if there are some rest trials to begin
if T_params.ndf(1)==0
    resttrialstart = [1;resttrialstart];
    if length(resttrialend) == length(resttrialstart)
        blocks_idx = [[1; resttrialend + 1],[resttrialstart-1;length(T_params.ndf)]];
    else
        blocks_idx = [[resttrialend + 1],resttrialstart(2:end)-1];
    end 
else
    if length(resttrialend) == length(resttrialstart)
        blocks_idx = [[1; resttrialend + 1],[resttrialstart-1;length(T_params.ndf)]];
    else
        blocks_idx = [[1; resttrialend + 1],resttrialstart-1];
    end 
end

blocks = blocks_idx;
for r = 1:size(blocks_idx,1)
    for c = 1:size(blocks_idx,2)
        blocks(r,c) = T_params.trial(blocks_idx(r,c));
    end
end

bT = array2table(blocks,'VariableNames',{'b_start','b_end'});

%% Find which block are high force vs low force
btrgts_x = zeros(size(blocks(:,1)));
btrgts_x2 = btrgts_x;
for bidx = 1:length(blocks)
    bl = blocks(bidx,:);
    tgt1 = T_params.target1(T_params.trial>=bl(1) & T_params.trial<=bl(2));
    tgt2 = T_params.target2(T_params.trial>=bl(1) & T_params.trial<=bl(2));
    % check they are unique
    [tgtmin,~,IC] = unique(tgt1);
    if length(tgtmin)>1
        tgtmin = tgtmin(mode(IC));
    end
    [tgtmax,~,IC] = unique(tgt2);
    if length(tgtmax)>1
        tgtmax = tgtmax(mode(IC));
    end
    btrgts_x(bidx) = tgtmin;
    btrgts_x2(bidx) = tgtmax;
end

[lolim,~] = max([btrgts_x;btrgts_x2]);
[hilim,~] = min([btrgts_x;btrgts_x2]);
dist = [btrgts_x-hilim,lolim-btrgts_x2];

[~,minidx] = min([dist] ,[],2);
hiforcetarget = minidx==1;

bT.Target_min = btrgts_x(:);
bT.Target_max = btrgts_x2(:);
bT.HiForce = hiforcetarget(:);


%% Edit the tags and save data
for tr = 1:size(T_params,1)
    fprintf('Trial %d: \t',tr);
    blck_idx = find(T_params.trial(tr)>=blocks(:,1) & T_params.trial(tr)<=blocks(:,2));
    if isempty(blck_idx)
        if any(strcmp(T_params.tags{tr},'rest'))
            fprintf('Already have a rest tag\n');
        elseif T_params.ndf==0
            fprintf('Tagging as rest\n');
            trtags = T_params.tags{tr};
            trtags{end+1} = 'rest';
            T_params.tags{tr} = trtags;
        else
            fprintf('Trial %s: what is this case?\n')
            error
        end
    elseif any(strcmp(T_params.tags{tr},'out of control'))
        if T_params.ArduinoDuration(tr) >= 4 && T_params.arduino_duration(tr) < 4.001
            fprintf('Found a probe trial\n')
        else
            fprintf('This is not a probe trial!\n')
            error
        end
    elseif T_params.arduino_duration(tr) >= 4 && T_params.arduino_duration(tr) < 4.001
        fprintf('This might have been a control trial!\n')
        error
    elseif bT.HiForce(blck_idx)
        trtags = T_params.tags{tr};
        flxidx = find(contains(trtags,'flex'));
        if isempty(flxidx)
            fprintf('No current tag.\t');
            flxidx = length(trtags)+1;
        end
        trtags{flxidx} = 'hi force';
        T_params.tags{tr} = trtags;
        fprintf('Replacing trial tags with hi force\n');
    elseif ~bT.HiForce(blck_idx)
        trtags = T_params.tags{tr};
        flxidx = find(contains(trtags,'extend'));
        if isempty(flxidx)
            flxidx = find(contains(trtags,'flex'));
            if isempty(flxidx)
                fprintf('No current tag.\t');
                flxidx = length(trtags)+1;
            end
        end
        trtags{flxidx} = 'lo force';
        T_params.tags{tr} = trtags;
        fprintf('Replacing trial tags with lo force\n');
    end        
end

%% Add to T_params whether its a high force, low force or rest trial
block = zeros(size(T_params.arduino_duration));
hiforce = false(size(T_params.arduino_duration));
rest = hiforce;
for tr = 1:size(T_params,1)
    blck_idx = find(T_params.trial(tr)>=bT.b_start & T_params.trial(tr)<=bT.b_end);
    
    if isempty(blck_idx)
        if any(strcmp(T_params.tags{tr},'rest'))
            rest(tr) = true;
        end
    else
        hiforce(tr) = bT(blck_idx,:).HiForce;
        block(tr) = blck_idx;
    end
end
T_params.rest = rest;
T_params.hiforce = hiforce;
T_params.block = block;

%% get rid of excluded trials or bad trials
idx = ~T_params.excluded & ~isnan(T_params.arduino_duration);
fp = forceProbe(:,idx);
if ~isempty(T)
    warning('Clear variable T if you want to reprocess forceProbe and table')
    trials = T.trial;
else
    T = T_params(idx,:);
    T.Properties.Description = measuretblname;
end

%% See if fly ever lets go

extremes = max(fp,[],1);
% the leg_go point is unlikely the most extreme, but is likely often seen
figure
H = histogram(extremes);
% If there are bins in which the histogram of maxes is 0, throw any higher
% values out, the point at which the fly lets go is likely lower
bins = H.BinEdges(1:end-1)+H.BinWidth/2;
bins = bins(1:find(bins>bins(find(H.Values==max(H.Values),1)) & H.Values==0 & [diff(H.Values)==0 0],1,'first'));
if ~isempty(bins)
    fplims = [min([bins(1) min(bT.Target_min)-30]) bins(end)];
else
    fplims = [min(bT.Target_min-30), H.BinEdges(end)];
end
xlabel(H.Parent,'Extreme values in each trial');


%% forceprobe Heat Map
fpHm(ft,T.trial,fp,T.arduino_duration,bT,fplims);

%% measureTable stuff
T.Properties.UserData.trialStem = trialStem;
T.Properties.UserData.Dir = Dir;

%% Tagging trials with the outcome

% 1: Leg in target - no stim - fly does not move
% 2: Leg in target - no stim - fly moves
% 3: Leg not in target - fly moves to target - turns off stim
%       3: within trial time
%       4: after "trial" is over
% 5: Leg not in target - fly moves - does not turn off stim
% 6: Leg not in target - fly does not move
if any(contains(T.Properties.VariableNames,'outcome'))
    error('Clear variable T if you want to reprocess forceProbe and table')
end

outcomes = {'no punishment - static';
    'no punishment - moved';
    'punishment - off';
    'punishment - late';
    'timeout - static';
    'timeout - fail'};
outcome_id = zeros(size(T.block));
arduino_duration = zeros(size(T.block));

ft_0i = find(ft(1:end-1)>0,1,'first');

fprintf('Sorting trials\n')
for tr = 1:size(T,1)
    fprintf('Trial %d: \t',T.trial(tr));
    T_row = T(tr,:);
    if T_row.rest
        fprintf('rest\n');
        continue
    end
    
    blck_row = bT(T_row.block,:);
    f_init = fp(ft_0i,tr);

    if T_row.arduino_duration==0
        % double check that f_init is correct
        if f_init >= blck_row.Target_max || f_init <= blck_row.Target_min
            % This means that the arduino never turned on but that the
            % probe was out of the target
            fprintf('Handle this case')
            error('Handle this case')
        end
        
        outcome_id(tr) = 1;
    else % leg not in target. What now?
        
        % trtags{end+1} = 'in target';
        if T_row.arduino_duration < T_row.stimDurInSec+T_row.postDurInSec - 2/T_row.sampratein
            % fly moved and turned off light
            outcome_id(tr) = 3;
        elseif (T_row.arduino_duration - (T_row.stimDurInSec+T_row.postDurInSec))<=2/T_row.sampratein
            % Didn't turn off in time
            trial = load(fullfile(Dir,sprintf(trialStem,T_row.trial)));
            x = cat(1,makeInTime(trial.params),makeInterTime(trial));
            y = cat(2,trial.arduino_output,trial.intertrial.arduino_output);
            off = find(y,1,'last');
            arduino_duration(tr) = x(find(y,1,'last'));
            inter_fp = cat(2,trial.probe_position,trial.intertrial.probe_position);
            % find the closest next valuse of inter_fp
            fp_off(1) = inter_fp(off); 
            fp_next = inter_fp(off+(1:min([500,length(inter_fp)-off])))~= fp_off(1);
            if any(fp_next)
                fp_off(2) = inter_fp(find(fp_next,1,'first')+off);
            else
                fp_off(2) = fp_off(1);
            end
            
            
            if any(fp_off<=blck_row.Target_max & fp_off>=blck_row.Target_min)
                outcome_id(tr) = 4;
            else
                outcome_id(tr) = 5;
            end
        end
    end
    fprintf(' outcome %d - %s\n',outcome_id(tr),outcomes{outcome_id(tr)});
end

T.outcome = outcome_id;

%%
T.Properties.UserData.trialStem = trialStem;
T.Properties.UserData.Dir = Dir;

save(T.Properties.Description,'T')