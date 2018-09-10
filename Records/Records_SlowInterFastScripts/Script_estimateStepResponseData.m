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
    fprintf(1,'\tFinding tagged positions: [');
    fprintf(1,'%d\t',T.Positions{cidx});
    fprintf(1,']\n');
    
    TP = addProbePositionToDataTable(TP,T.Positions{cidx});

    % for pos = T.Positions
    pos = 0;
    % get the trials for each step, average and calculate amplitude, area, time
    % to peak
    displacement = unique(TP.displacement);
    for D = 1:length(displacement)
        group = TP.trial(TP.displacement==displacement(D) & TP.ProbePosition==pos);
        trial = load(fullfile(Dir,[T.Protocol{cidx} '_Raw_' cid '_' num2str(group(1)) '.mat']));
        [~,~,~,~,~,~,trialStem] = extractRawIdentifiers(trial.name);
        t = makeInTime(trial.params); t = t(:)';
        v_ = nan(length(group),length(t));
        for cnt = 1:length(group)
            trial = load(sprintf(trialStem,group(cnt)));
            if isfield(trial,'excluded') && trial.excluded
                continue
            end
            v_(cnt,:) = trial.voltage_1;
        end
        v = nanmean(v_,1);
        base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
        v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));
        
        area = trapz(t(t>0&t<trial.params.stimDurInSec),v(t>0&t<trial.params.stimDurInSec));

        % assume depolarization with negative steps, and hyperpolarization
        % with positive steps
        v_flipped = -sign(displacement(D))*v;
        
        [peak,ttpk] = max(v_flipped(t>=0&t<.05));
        ttpk = t(ttpk+sum(t<0));
        l1070 = t(:)'>0&t(:)'<ttpk & v_flipped>peak*.1 & v_flipped<peak*.7;
        v1070 = v_flipped(l1070);
        t1070 = t(l1070);
        coef = polyfit(t1070,v1070,1);
        delay = -coef(2)/coef(1);
        
        if DEBUG && -10==displacement(D) && (strcmp(cid,'180404_F1_C1') || strcmp(cid,'180703_F3_C1')) 
            cla(ax)
            groupid = [cid ': [' sprintf('%d,',group)]; groupid = [groupid(1:end-1) ']'];
            title(ax,groupid); hold(ax,'on')
            plot(ax,t(t>-.03&t<0.2),v_(:,t>-.03&t<0.2),'color',[1 .7 .7]); hold(ax,'on')
            plot(ax,t(t>-.03&t<.1),v(t>-.03&t<.1)+base,'color',[.7 0 0]); hold(ax,'on')
            plot(ax,t1070,(coef(1)*t1070+coef(2))+base,'color',[0 0 0],'LineWidth',2)
            plot(ax,ttpk,v(t==ttpk)+base,'bo');
            ax.YLim = base+[-10 10];
            ax.XLim = [-.03 0.2];
            drawnow
            % pause();
        end

        T_row.Position = pos;
        T_row.Trialnums = {group'};
        T_row.Peak = peak;
        T_row.TimeToPeak = ttpk;
        T_row.Area = area;
        T_row.Delay = delay;
        T_row.Step = displacement(D);
        T_row.TableFile = TP.Properties.Description;
            
        
        % Add these numbers to a new line in a new T
        Row_cnt = Row_cnt+1;
        T_new = [T_new;T_row];
    end 
end
T_new = T_new(~strcmp(T_new.CellID,'placeholder'),:);






e = R_pulse;