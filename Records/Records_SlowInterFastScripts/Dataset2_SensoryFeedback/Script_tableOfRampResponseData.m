% In the T table are lines for each cell and the positions analyzed.
% Go through each cell and add lines for each displacement value at each
% position.

T = T_RampCells;
n = zeros(height(T),1); n_cell = cell(height(T),1);
Position = n; Trialnums = n_cell; Displacement = n; Speed = n; V_m = n; Peak = n; Peak_step = n; Peak_return = n; TimeToPeak = n; Area = n; Delay = n; mla = n;
T = addvars(T,Position,Trialnums,Displacement,Speed,V_m,Peak,Peak_step,Peak_return,TimeToPeak,Area,Delay,mla);
varTypes = varfun(@class,T,'OutputFormat','cell');
T_Ramp = table('Size',[2000,size(T,2)],'VariableTypes',varTypes,'VariableNames',T.Properties.VariableNames);
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
    TP = datastruct2table(data,'DataStructFileName',datafilename,'rewrite','no');
    fprintf(1,'\tFinding tagged positions: [');
    fprintf(1,'%d\t',T.Positions{cidx});
    fprintf(1,']\n');
    
    TP = addProbePositionToDataTable(TP,T.Positions{cidx});
    [TP, drugs] = addDrugsToDataTable(TP);
    TP.ProbePosition(TP.caffeine | TP.mla | TP.atropine | TP.ttx | TP.serotonin) = Inf;
        
    % get the trials for each speed and displacement, average and calculate amplitude, area, time
    % to peak
    displacement = unique(TP.displacement);
    speed = unique(TP.speed);
    positions = unique(TP.ProbePosition);
    positions = positions(~isnan(positions));
    
    for pos = positions'
        T_row.mla = false;
        fprintf(1,'Position %d\n',pos);
        for D = 1:length(displacement)
            fprintf(1,'\tDisplacement %d\n',displacement(D));
            for S = 1:length(speed)
                fprintf(1,'\t\tSpeed %d\n',speed(S));
                if pos < Inf
                    group = TP.trial(TP.displacement==displacement(D) & TP.ProbePosition==pos & TP.speed ==speed(S));
                else
                    % for now just look at MLA
                    group = TP.trial(TP.displacement==displacement(D) & TP.ProbePosition==pos & TP.speed ==speed(S) & TP.mla);
                end
                if isempty(group)
                    continue
                end
                trial = load(fullfile(Dir,[T.Protocol{cidx} '_Raw_' cid '_' num2str(group(1)) '.mat']));
                [~,~,~,~,~,~,trialStem] = extractRawIdentifiers(trial.name);
                t = makeInTime(trial.params); t = t(:)';
                DT_step = abs(trial.params.displacement)/trial.params.speed;
                DT_step = round((DT_step+trial.params.preDurInSec)*trial.params.sampratein)+1;
                DT_return = trial.params.stimDurInSec-abs(trial.params.displacement)/trial.params.speed;
                DT_return = round((DT_return+trial.params.preDurInSec)*trial.params.sampratein)+1;

                v_ = nan(length(group),length(t));
                for cnt = 1:length(group)
                    trial = load(sprintf(trialStem,group(cnt)));
                    if isfield(trial,'excluded') && trial.excluded
                        continue
                    end
                    v_(cnt,:) = trial.voltage_1;
                    
                end
                if all(isnan(v_(:)))
                    continue
                end
                
                v = nanmean(v_,1);
                base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
                v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));
                
                %area = cumtrapz(t(t>0&t<trial.params.stimDurInSec),v(t>0&t<trial.params.stimDurInSec));
                area = cumtrapz(t,v); area = area-area(find(t<=0,1,'last'));
                                
                switch sign(displacement(D))
                    case 1 % flexion, decide if there is a peak or trough
                        if area(DT_step)>0 % depolarization
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
                T_row.Displacement = displacement(D);
                T_row.Speed = speed(S);
                T_row.TableFile = {TP.Properties.Description};
                
                % Add these numbers to a new line in a new T_Ramp
                Row_cnt = Row_cnt+1;
                T_Ramp(Row_cnt,:) = T_row(1,:);
                
                if DEBUG %%&& -10==displacement(D) && (strcmp(cid,'180404_F1_C1') || strcmp(cid,'180703_F3_C1'))
                    cla(ax)
                    groupid = [cid ': [' sprintf('%d,',group)]; groupid = [groupid(1:end-1) ']'];
                    title(ax,groupid); hold(ax,'on')
                    plot(ax,t(t>-.05&t<trial.params.stimDurInSec),v_(:,t>-.05&t<trial.params.stimDurInSec),'color',[1 .7 .7]); hold(ax,'on')
                    if pos ~= Inf
                        plot(ax,t(t>-.05&t<trial.params.stimDurInSec),v(t>-.05&t<trial.params.stimDurInSec)+base,'color',[.7 0 0]); hold(ax,'on')
                    else
                        plot(ax,t(t>-.05&t<trial.params.stimDurInSec),v(t>-.05&t<trial.params.stimDurInSec)+base,'color',[0 .7 0]); hold(ax,'on')
                    end
                    plot(ax,t(ttpk),peak+base,'bo');
                    plot(ax,t(DT_step),T_row.Peak_step+base,'co');
                    plot(ax,t(DT_return),T_row.Peak_return+base,'ro');
                    ax.YLim = base+[-10 10];
                    ax.XLim = [-.1 trial.params.stimDurInSec+.1];
                    drawnow
                end

            end
        end
    end
end
T_Ramp = T_Ramp(1:Row_cnt,:);

if DEBUG 
    close(ax.Parent)
end

