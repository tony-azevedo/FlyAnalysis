% In the T table are lines for each cell and the positions analyzed.
% Go through each cell and add lines for each displacement value at each
% position.

T = T_StepCells;
n = zeros(height(T),1); 
Position = n; Trialnums = n_cell; Displacement = n; Speed = n; V_m = n; Peak = n; Peak_step = n; Peak_return = n; TimeToPeak = n; Area = n; Delay = n; mla = n;
T = addvars(T,Position,Trialnums,Displacement,Speed,V_m,Peak,Peak_step,Peak_return,TimeToPeak,Area,Delay,mla);
varTypes = varfun(@class,T_row,'OutputFormat','cell');
T_Step = table('Size',[2000,size(T,2)],'VariableTypes',varTypes,'VariableNames',T.Properties.VariableNames);
Row_cnt = 0;

DEBUG = 0;

CellID = T.CellID;

if (DEBUG)
    figure
    ax = subplot(1,1,1);
end

for cidx = 1:length(CellID)
    T_row = T(cidx,:);

    cid = CellID{cidx};

    fprintf('Starting %s\n',cid);

    Dir = fullfile('E:\Data',cid(1:6),cid);
    if ~exist(Dir,'dir')
        Dir = fullfile('F:\Acquisition',cid(1:6),cid);
    end
    cd(Dir);
    
    datafilename = fullfile(Dir);
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
    fprintf(1,'\tFinding tagged positions: [');
    fprintf(1,'%d\t',T.Positions{cidx});
    fprintf(1,']\n');
    
    TP = addProbePositionToDataTable(TP,T.Positions{cidx});
    [TP, drugs] = addDrugsToDataTable(TP);
    TP.ProbePosition(TP.caffeine | TP.mla | TP.atropine | TP.ttx | TP.serotonin) = Inf;

    displacement = unique(TP.displacement);
    positions = unique(TP.ProbePosition);
    positions = positions(~isnan(positions));
    for pos = positions'
        % get the trials for each step, average and calculate amplitude, area, time
        % to peak
        T_row.mla = false;
        fprintf(1,'Position %d\n',pos);
        for D = 1:length(displacement)
            if pos < Inf
                group = TP.trial(TP.displacement==displacement(D) & TP.ProbePosition==pos);
            else
                % for now just look at MLA
                group = TP.trial(TP.displacement==displacement(D) & TP.ProbePosition==pos & TP.mla);
            end
            if isempty(group)
                continue
            end
            trial = load(fullfile(Dir,[T.Protocol{cidx} '_Raw_' cid '_' num2str(group(1)) '.mat']));
            [~,~,~,~,~,~,trialStem] = extractRawIdentifiers(trial.name);
            t = makeInTime(trial.params); t = t(:)';

            v_ = nan(length(group),length(t));
            sgs_ = v_;
            for cnt = 1:length(group)
                trial = load(sprintf(trialStem,group(cnt)));
                if isfield(trial,'excluded') && trial.excluded
                    continue
                end
                v_(cnt,:) = trial.voltage_1;
                sgs_(cnt,:) = trial.sgsmonitor;
            end
            if all(isnan(v_(:)))
                continue
            end

            sgs = nanmean(sgs_,1);
            velocity = diff(sgs(t>0&t<.01))/diff(t(1:2));
            speed = smooth(velocity);
            speed = max(speed*sign(displacement(D)));
            DT_step = abs(trial.params.displacement)/speed;
            DT_step = round((DT_step+trial.params.preDurInSec)*trial.params.sampratein)+1;
            DT_halfstep = trial.params.stimDurInSec/4; % the step time is too short, give it a sec before measuring area
            DT_halfstep = round((DT_halfstep+trial.params.preDurInSec)*trial.params.sampratein)+1;
            DT_return = trial.params.stimDurInSec-trial.params.stimDurInSec/4;
            DT_return = round((DT_return+trial.params.preDurInSec)*trial.params.sampratein)+1;

            v = nanmean(v_,1);
            % base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
            base = mean(v(t<0 &t>-.02));
            % v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));
            v = v-mean(v(t<0 &t>-.02));
            
            area = cumtrapz(t,v); area = area-area(find(t<=0,1,'last'));
            
            switch sign(displacement(D))
                case 1 % flexion, decide if there is a peak or trough
                    if area(DT_halfstep)>0 % depolarization
                        [~,ttpk] = max(v(t>=0&t<t(DT_return)));
                        ttpk = ttpk+sum(t<0);
                        peak = mean(v(ttpk-5:ttpk+5));
                    else % hyperpolarization, only look during step
                        [~,ttpk] = min(v(t>=0&t<t(DT_return)));
                        ttpk = ttpk+sum(t<0);
                        peak = mean(v(ttpk-5:ttpk+5));
                    end
                case -1 % resistance relex, just get the max
                    [~,ttpk] = max(v(t>=0&t<t(DT_return)));
                    ttpk = ttpk+sum(t<0);
                    peak = mean(v(ttpk-5:ttpk+5));
                    l1070 = t(:)'>0&t(:)'<t(ttpk) & v>peak*.1 & v<peak*.7;
                    v1070 = v(l1070);
                    t1070 = t(l1070);
                    coef = polyfit(t1070,v1070,1);
                    delay = -coef(2)/coef(1);
            end
                        
            T_row.Position = pos;
            if pos == Inf
                T_row.mla = true;
            end

            T_row.Trialnums = {group'};
            T_row.V_m = base;
            T_row.Peak = peak;
            T_row.Peak_step = mean(v(DT_step+(-10:10)));
            T_row.Peak_return = mean(v(DT_return+(-10:10)));
            T_row.TimeToPeak = t(ttpk);
            T_row.Area = area(DT_return);
            T_row.Delay = delay;
            T_row.Displacement = displacement(D);
            T_row.Speed = speed;
            T_row.TableFile = {TP.Properties.Description};
            
            % Add these numbers to a new line in a new T_Ramp
            Row_cnt = Row_cnt+1;
            T_Step(Row_cnt,:) = T_row(1,:);

            if DEBUG && -10==displacement(D) %&& strcmp(T.Cell_label{cidx},'intermediate') % && strcmp(cid,'180821_F1_C1')
                cla(ax)
                groupid = [cid ': [' sprintf('%d,',group)]; groupid = [groupid(1:end-1) ']'];
                title(ax,groupid); hold(ax,'on')
                plot(ax,t(t>-.03&t<0.2),v_(:,t>-.03&t<0.2),'color',[1 .7 .7]); hold(ax,'on')
                plot(ax,t(t>-.03&t<.1),v(t>-.03&t<.1)+base,'color',[.7 0 0]); hold(ax,'on')
                plot(ax,t1070,(coef(1)*t1070+coef(2))+base,'color',[0 0 0],'LineWidth',2)
                plot(ax,[.001 0.012],(coef(1)*([.001 0.012])+coef(2))+base,'color',[1 1 1]*.5)
                plot(ax,[-.01 0.02],[1 1]*base,'color',[1 1 1]*.5)
                plot(ax,t(ttpk),T_row.Peak+base,'bo');
                plot(ax,t(DT_step),T_row.Peak_step+base,'co');
                plot(ax,T_row.Delay,base,'ko');
                ax.YLim = base+[-2 6];
                ax.XLim = [-.01 0.02];
                drawnow
                % pause();
            end

        end
    end
end
T_Step = T_Step(1:Row_cnt,:);

if DEBUG 
    close(ax.Parent)
end
