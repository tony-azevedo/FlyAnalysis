% Go through each cell, get the bar trials, find spikes, and collect the
% bar movements that result from the spikes
PLOT = 1;
DEBUG = 0;
PRINT = 0;

clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];

% close all

labels = unique(T_SM.Cell_label);
N_spikes = zeros(size(labels));
t_total = N_spikes;

% Create a figure and axes to plot all of the labels
% ppfig = figure; ppfig.Position = [546 32 1305 964];
% ppax11 = subplot(3,2,1,'parent',ppfig); ppax11.NextPlot = 'add';
% ppax12 = subplot(3,2,2,'parent',ppfig); ppax12.NextPlot = 'add';
% ppax21 = subplot(3,2,3,'parent',ppfig); ppax21.NextPlot = 'add';
% ppax22 = subplot(3,2,4,'parent',ppfig); ppax22.NextPlot = 'add';
% ppax31 = subplot(3,2,5,'parent',ppfig); ppax31.NextPlot = 'add';
% ppax32 = subplot(3,2,6,'parent',ppfig); ppax32.NextPlot = 'add';
% 
% pltcnt = 0;

%

prms.durSweep = 0.05;
prms.sampratein = 50000;
prms.preDurInSec = 0.035;

t5 = makeInTime(prms);
t5_presamp = sum(t5<0);
t5_pstsamp = sum(t5>=0);

prms.sampratein = 10000;

t1 = makeInTime(prms);
t1_presamp = sum(t1<0);
t1_pstsamp = sum(t1>=0);

[~,t5_idx] = intersect(t5,t1);
% start with an estimate of the number of spikes over kill!

Fast_v_intermediate = nan(5000,length(t5));
Fast_v_slow = nan(5000,length(t5));
Intermediate_v_slow = nan(5000,length(t5));

weirdspikes = {'empty','label','nan'};

% run through once and count spikes
for lblidx = 1:length(labels)
    label = labels(lblidx);
    T_label = T_SM(contains(T_SM.Cell_label,label),:);
        
    for cidx = 1:length(T_label.CellID)
        
        cellid = T_label.CellID{cidx};
        fprintf('Cell: %s\n',cellid);
        T_Cell = T_label(contains(T_label.CellID,cellid),:);
        group = T_Cell.spikes_trialnums{1};
        
        Dir = fullfile('E:\Data',cellid(1:6),cellid);
        cd(Dir);
        
        trialStem = [T_Cell.Protocol{1} '_Raw_' cellid '_%d.mat'];
        for tr = group
            spktrial = load(fullfile(Dir,sprintf(trialStem,tr)));
            flds = fieldnames(spktrial);
            if any(contains(flds,'EMGspikes'))
                break
            end
        end
        t = makeInTime(spktrial.params); t = t(:);

        flds = fieldnames(spktrial);
        emgspkfld = flds(contains(flds,'EMGspikes'));
        emgspkfld = emgspkfld{1};
        emgspkfld = emgspkfld(1:regexp(emgspkfld,'EMGspikes','end'));
        emgspkfl = emgspkfld(1:end-1);
        EMGlabel = emgspkfld(1:regexp(emgspkfld,'EMGspikes')-1);
        
        % choose the correct matrix to put the spike counts in;
        eval(['spkmat = ' EMGlabel '_v_' label{1} ';']);
        % find the latest line, put the spikes in there;
        row = find(~isnan(spkmat(:,1)),1); if isempty(row), row = 1; end

        spikes_ = nan(length(t),1);

        cnt = 0;
        
        for tr = group
            
            spktrial = load(sprintf(trialStem,tr));
            if ~any(contains(fieldnames(spktrial),'EMGspikes'))
                continue
            end

            if isfield(spktrial,'excluded') && spktrial.excluded
                continue
            end
            if ~isfield(spktrial,'spikes')
                error('This cell doesn''t have spikes for all trials')
                continue
            end
                                    
            spikes_(:) = 0;
            spikes_(spktrial.spikes) = 1;
            emgspks = spktrial.(emgspkfld);
            
            for spk = 1:length(emgspks)
                %emgspk = t(emgspks(spk));
                row = row+1;
                spkmat(row,:) = 0;
                switch spktrial.params.sampratein
                    case 10000
                        localspikes = spikes_(emgspks(spk)-t1_presamp+1:emgspks(spk)+t1_pstsamp);
                    case 50000
                        try localspikes = spikes_(emgspks(spk)-t5_presamp+1:emgspks(spk)+t5_pstsamp);
                        catch
                            if emgspks(spk)-t5_presamp+1<1
                                localspikes = spikes_(1:emgspks(spk)+t5_pstsamp);
                                localspikes = [zeros(length(t5)-length(localspikes),1);localspikes];
                            elseif emgspks(spk)+t5_pstsamp>length(t5)
                                localspikes = spikes_(emgspks(spk)-t5_presamp+1:end);
                                localspikes = [localspikes;zeros(length(t5)-length(localspikes),1)];
                            else
                                error('hmm')
                            end
                        end
                end
                if length(localspikes)==length(t1)
                    if sum(localspikes(t1>=-0.25 & t1<0))==0
                        weirdspikes(end+1,:) = {spktrial.name,EMGlabel, emgspks(spk)};
                    end
                    spkmat(row,t5_idx(logical(localspikes))) = 1;
                elseif length(localspikes) == length(t5)
                    if sum(localspikes(t5>-0.25 & t5<0))==0
                        weirdspikes(end+1,:) = {spktrial.name,EMGlabel, emgspks(spk)};
                    end
                    spkmat(row,logical(localspikes)) = 1;
                else
                    warning('Local spike vector doesn''t fit')
                end
            end
        end
        
        eval([EMGlabel '_v_' label{1} '= spkmat;']);

    end
end
%%
Fast_v_intermediate = Fast_v_intermediate(~isnan(Fast_v_intermediate(:,1)),:);
Fast_v_slow = Fast_v_slow(~isnan(Fast_v_slow(:,1)),:);
Intermediate_v_slow = Intermediate_v_slow(~isnan(Intermediate_v_slow(:,1)),:);

DT = 1/300;
Fast_v_intermediate_Hz = firingRate(t5,Fast_v_intermediate,DT,1);
Fast_v_slow_Hz = firingRate(t5,Fast_v_slow,DT,1);
Intermediate_v_slow_Hz = firingRate(t5,Intermediate_v_slow,DT,1);

%%
t_i = -.035;

Fast_2_intermediate = 0*Fast_v_intermediate(:,t5>t_i & t5<=0);
Fast_2_slow = 0*Fast_v_slow(:,t5>t_i & t5<=0); 
Intermediate_2_slow = 0*Intermediate_v_slow(:,t5>t_i & t5<=0);
for row = 1:size(Fast_2_intermediate,1)
    Fast_2_intermediate(row,find(Fast_v_intermediate(row,t5>t_i & t5<=0),1,'last')) = 1;
end
for row = 1:size(Fast_2_slow,1)
    Fast_2_slow(row,find(Fast_v_slow(row,t5>t_i & t5<=0),1,'last')) = 1;
end
for row = 1:size(Intermediate_2_slow,1)
    Intermediate_2_slow(row,find(Intermediate_v_slow(row,t5>t_i & t5<=0),1,'last')) = 1;
end
tshort = t5(t5>t_i & t5<=0);

DT = 0.001;
DR = round(DT/diff(t5(1:2)));
bins = length(tshort)/DR;
tbinned = 0*(1:bins);
Fast_2_intermediate_bnd = 0*(1:bins);
Fast_2_slow_bnd = 0*(1:bins);
Intermediate_2_slow_bnd = 0*(1:bins);
for b = 1:bins
    tbinned(b) = mean(tshort(DR*(b-1)+1:DR*(b)));
    Fast_2_intermediate_bnd(b) = sum(sum(Fast_2_intermediate(:,DR*(b-1)+1:DR*(b))));
    Fast_2_slow_bnd(b) = sum(sum(Fast_2_slow(:,DR*(b-1)+1:DR*(b))));
    Intermediate_2_slow_bnd(b) = sum(sum(Intermediate_2_slow(:,DR*(b-1)+1:DR*(b))));
end

Fast_2_intermediate_bnd = Fast_2_intermediate_bnd/size(Fast_2_intermediate,1);
Fast_2_slow_bnd = Fast_2_slow_bnd/size(Fast_2_slow,1);
Intermediate_2_slow_bnd = Intermediate_2_slow_bnd/size(Intermediate_2_slow,1);

%%


f = figure; f.Position = [680 201 782 777];
subplot(3,2,1)
plot(t5,Fast_v_intermediate_Hz);
ylim([0 150]);
xlim([-0.03 0.01]);
ylabel('Hz');
title('Fast vs Intermediate');

subplot(3,2,3)
plot(t5,Fast_v_slow_Hz);
ylim([0 150]);
xlim([-0.03 0.01]);
ylabel('Hz');
title('Fast vs Slow');

subplot(3,2,5)
plot(t5,Intermediate_v_slow_Hz);
ylim([0 150]);
xlim([-0.03 0.01]);
ylabel('Hz');
title('Inetermediate vs Slow');

subplot(3,2,2)
stairs(tbinned,Fast_2_intermediate_bnd/max(Fast_2_intermediate_bnd)); hold on;
plot(tbinned,cumsum(Fast_2_intermediate_bnd,'reverse'));
text(-.025,.2,'N = 186 spikes');
ylim([-.1 1.1]);
xlim([-0.03 0.005]);
ylabel('Hz');

subplot(3,2,4)
stairs(tbinned,Fast_2_slow_bnd/max(Fast_2_slow_bnd)); hold on;
plot(tbinned,cumsum(Fast_2_slow_bnd,'reverse'));
text(-.025,.2,'N = 640 spikes');
ylim([-.1 1.1]);
xlim([-0.03 0.005]);
ylabel('Hz');

subplot(3,2,6)
stairs(tbinned,Intermediate_2_slow_bnd/max(Intermediate_2_slow_bnd)); hold on;
plot(tbinned,cumsum(Intermediate_2_slow_bnd,'reverse'));
text(-.025,.2,'N = 3082 spikes');
ylim([-.1 1.1]);
xlim([-0.03 0.005]);
ylabel('Hz');


%% 
chckSpike = figure; chckSpike.Position = [680 258 998 720];
ax1 = subplot(3,1,1); %ax1.NextPlot = 'add';
ax2 = subplot(3,1,2);
ax3 = subplot(3,1,3);
linkaxes([ax1,ax2,ax3],'x');

% Possibles 
% 11 12 14 15 25
% 18 20 24 26 28 
% 29 31

% for ws = 2:size(weirdspikes,1)
    ws = 28;
    trial = weirdspikes{ws,1};
    %chckSpike.Name = sprintf('Wrd spk %d of %d: %s',ws,size(weirdspikes,1),trial);
    [~,tname] = fileparts(trial);
    
    D = fileparts(trial);
    cd (D)
    trial = load(trial);
    t = makeInTime(trial.params);
    plot(ax1,t,trial.voltage_1);
    raster(ax1,t(trial.spikes),max(trial.voltage_1)+[0 4]);
    plot(ax2,t,trial.current_2);
    raster(ax2,t(trial.([weirdspikes{ws,2} 'EMGspikes'])),max(trial.current_2)+0.05*diff([min(trial.current_2) max(trial.current_2)]));
    title(ax1,sprintf('%s',tname));

    if isfield(trial,'forceProbeStuff')
        ft = makeFrameTime(trial);
        plot(ax3,ft,trial.forceProbeStuff.CoM-trial.forceProbeStuff.ZeroForce);
    elseif isfield(trial,'legPositions')
        ft = makeFrameTime(trial);
        plot(ax3,ft,trial.legPositions.Tibia_Angle,'linewidth',2,'color',[0 .5 0]);
    else
        error('wrong fieldname');
    end
    
    xlim(ax1,t(weirdspikes{ws,3})+[-0.05 0.05]);
    

% Possibles 
% 11 12 14 15 25
% 18 20 24 26 28 
% 29 31

%%
nextSpike = figure; nextSpike.Position = [680 258 998 720];
ax1 = subplot(3,1,1); ax1.NextPlot = 'add';
ax2 = subplot(3,1,2); ax2.NextPlot = 'add';
ax3 = subplot(3,1,3); ax3.NextPlot = 'add';
% linkaxes([ax1,ax2,ax3],'x');

for ws = 2:size(weirdspikes,1)
    trial = weirdspikes{ws,1};
    % nextSpike.Name = sprintf('Wrd spk %d of %d: %s',ws,size(weirdspikes,1),trial);
    
    D = fileparts(trial);
    cd (D)
    trial = load(trial);
    t = makeInTime(trial.params);
    % plot(ax1,t,trial.voltage_1);
    
    nxtspk = find(trial.spikes>weirdspikes{ws,3},1,'first');
    raster(ax1,t(trial.spikes(max([nxtspk-2,1]):nxtspk))-t(weirdspikes{ws,3}),ws+[0 .95]);

    twin = t>t(weirdspikes{ws,3})-.04 & t<t(weirdspikes{ws,3})+.01;
    plot(ax2,t(twin)-t(weirdspikes{ws,3}),trial.voltage_1(twin)-trial.voltage_1(weirdspikes{ws,3}));
    plot(ax3,t(twin)-t(weirdspikes{ws,3}),trial.current_2(twin));
    
xlim(ax1,[-0.04 0.01]);
    
end
