close all
DEBUG = 0;
comfig = figure('color',[1 1 1],'units','inches','position',[4 2 8 6]);
comax = subplot(1,1,1,'parent',comfig); comax.NextPlot = 'add';
% 
% panl = panel(N_spikes_fi);
% panl.pack('h',{1/2 1/2})  % phase plot on top
% panl(1).pack('v',{1/2 1/2})  % phase plot at left
% panl(2).pack('v',{1/2 1/2})  % two examples
% panl(1,1).pack('v',{1/2 1/2})  % spikes, emg, bar 1
% panl(1,2).pack('v',{1/2 1/2})  % spikes, emg, bar 2
% 
% panl.margin = [18 16 10 10];
% panl.descendants.margin = [8 8 8 8];
% 
% t_i_f = [-0.006 0.02];
% t_i_f = [-0.02 .13];

T_0Spikes = T_FperSpike_0(T_FperSpike_0.NumSpikes==0 & T_FperSpike_0.Position==0,:);
cellIDs = T_0Spikes.CellID;

t_i_f = [-0.02 .25];

cidx = 1;
% for cidx = 1:length(cellIDs)
    
    cellid = cellIDs{cidx};
    T_cell = T_0Spikes(contains(T_0Spikes.CellID,cellid),:);
    trials = T_cell.Trialnums{1};
    
    trialStem = [T_cell.Protocol{1} '_Raw_' cellid '_%d.mat'];
    trial = load(['E:\Data\' cellid(1:6) '\' cellid '\' sprintf(trialStem,trials(1))]);
    t = makeInTime(trial.params);
    sp_win = t>=t_i_f(1) & t <=t_i_f(2);
    ft = makeFrameTime(trial);
    frame_win = ft>=t_i_f(1) & ft <=t_i_f(2);

    v_ = nan(sum(sp_win), length(trials));
    emg_ = nan(sum(sp_win), length(trials));
    CoM_ = nan(sum(frame_win), length(trials));
    comt_ = CoM_;

    cnt = 0;
    
    for tr = trials'
        cnt = cnt+1;
        trial = load(['E:\Data\' cellid(1:6) '\' cellid '\' sprintf(trialStem,tr)]);
        if trial.excluded
            continue;
        end                
        ft = makeFrameTime(trial);
        
        trjct_t = t_i_f;
        
        trjct_twin = t>=trjct_t(1)&t<=trjct_t(2);
        if sum(trjct_twin) > size(v_,1)
            trjct_twin = t>=trjct_t(1)&t<trjct_t(2);
        end
        if sum(trjct_twin) < size(v_,1)
            trjct_twin = t>=trjct_t(1)&t<=trjct_t(2)+0.5*1/trial.params.sampratein;
        end

        v_(:,cnt) = trial.voltage_1(trjct_twin);
        emg_(:,cnt) = trial.current_2(trjct_twin);
        
        com = trial.forceProbeStuff.CoM;
        origin = mean(com(find(ft<0,4,'last')));
        com = com - origin;

        trjct_win = ft>=trjct_t(1)&ft<=trjct_t(2);
        trjct = com(trjct_win);
        trjct_ft = ft(trjct_win);
        if length(trjct) >= size(CoM_,1)
            CoM_(:,cnt) = trjct(1:size(CoM_,1));
            comt_(:,cnt) = trjct_ft(1:size(CoM_,1));
        elseif length(trjct) < size(CoM_,1)
            CoM_(1:length(trjct),cnt) = trjct;
            comt_(1:length(trjct),cnt) = trjct_ft;
        end        
    end
    v = nanmean(v_,2);
    emg = nanmean(emg_,2);
    
    comt = comt_(:);
    CoM = CoM_(:);
    [comt,o] = sort(comt);
    CoM = CoM(o);
            

    % plot the max
    if any(contains({'170921_F1_C1','180807_F1_C1'},cellid)) % 171102_F1_C1
        figure
        ax1 = subplot(4,1,1); ax1.NextPlot = 'add';
        title(ax1,cellid)
        %plot(ax1,t(sp_win),v_,'color',[1 .7 .7]);
        plot(ax1,t(sp_win),v-nanstd(v_,[],2)/sqrt(size(v_,2)),'color',[.5 .5 .5]);
        plot(ax1,t(sp_win),v+nanstd(v_,[],2)/sqrt(size(v_,2)),'color',[.5 .5 .5]);
        plot(ax1,t(sp_win),v,'color',[0 0 0]);
        
        ax2 = subplot(4,1,2); ax2.NextPlot = 'add';
        %plot(ax2,t(sp_win),emg_,'color',[1 .7 .7]);
        plot(ax2,t(sp_win),emg-nanstd(emg_,[],2)/sqrt(size(emg_,2)),'color',[.9 .9 .9]);
        plot(ax2,t(sp_win),emg+nanstd(emg_,[],2)/sqrt(size(emg_,2)),'color',[.9 .9 .9]);
        plot(ax2,t(sp_win),emg,'color',[.5 .5 .5]);
        ax2.YLim = [-25 25];
        
        ax3 = subplot(4,1,3:4); ax3.NextPlot = 'add';
        plot(ax3,comt_,CoM_,'color',[0 0 .7],'linestyle','-');
        %plot(ax3,comt,CoM,'color',[0 0 .7],'marker','.','markersize',2,'linestyle','none');
        %plot(ax3,rise_t(rise_l),riseline(rise_l),'color',[0 0 .2]);
        %plot(ax3,[0 t_halfmax(cidx)],max_CoM*0.5*[1 1],'color',[0 0 0]);
        
        linkaxes([ax1,ax2,ax3],'x')
        ax3.XLim = [-.02 .12];
        %if contains({'170921_F1_C1'},cellid)
            ax3.YLim = [-20 90];
        %elseif contains({'180807_F1_C1'},cellid)
            ax3.YLim = [-5 20];
        %end
        
        export_fig(gcf,[figureoutputfolder '\ForcePerspike0_' cellid '.pdf'], '-pdf','-nocrop', '-r600' , '-painters', '-rgb');
    end
    plot(comax,comt,CoM,'marker','.','markersize',2,'linestyle','none','tag',cellid);
    
% end

%T_0Spikes = addvars(T_0Spikes,t_halfmax,conductiondelay);

% Currently 171102_F1_C1 is weird, inserting a new value
%T_0Spikes.t_halfmax(strcmp(T_0Spikes.CellID,'171102_F1_C1')) = 0.0077;
