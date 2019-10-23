% close all

T = T_iavChr;
DEBUG = 0;

% allocation of double and cell arrays
n = zeros(height(T),1); n_cell = cell(height(T),1);

% Addtional columns in table
Drug = n_cell; 
Ndf = n_cell; 
FlashDur = n_cell; 
FlashStrength = n; 
V_m = n; 
Peak_V = n; 
Trough_V = n; 
FR_rest = n;
Peak_FR = n;
Trough_FR = n;
Extenstion = n; 
Start_probe = n; 
Peak_probe = n; 
Trough_probe = n; 
ReleaseDuration  = n; 
T = addvars(T,Ndf,FlashDur,FlashStrength,Drug,V_m,Peak_V,Trough_V,FR_rest,Peak_FR,Trough_FR,Extenstion,Start_probe,Peak_probe,Trough_probe,ReleaseDuration);

% Preallocate Table
varTypes = varfun(@class,T,'OutputFormat','cell');
T_iavChrFlash = table('Size',[2000,size(T,2)],'VariableTypes',varTypes,'VariableNames',T.Properties.VariableNames);
Row_cnt = 0;

clrs = [0 0 0
    1 0 1
    0 .5 0];
lightclrs = [.8 .8 .8
    1 .7 1
    .7 1 .7];

%%

CellIDs = T.CellID;

if (DEBUG)
    fsfig = figure;
    fsfig.Position = [680 32 689 964];
end


for cidx = 1:length(CellIDs)
    T_row = T(cidx,:);
    trialStem = [T_row.Protocol{1} '_Raw_' T_row.CellID{1} '_%d.mat'];

    cellid = T_row.CellID{1};
    
    fprintf('Starting %s\n',cellid);
    
    Dir = fullfile('E:\Data',cellid(1:6),cellid);
    if ~exist(Dir,'dir')
        Dir = fullfile('F:\Acquisition',cellid(1:6),cellid);
    end
    cd(Dir);
    
    datafilename = fullfile(Dir);
    datafilename = fullfile(datafilename,[T.Protocol{cidx} '_' cellid '.mat']);
    data = load(datafilename); data = data.data;
    
    TP = datastruct2table(data,'DataStructFileName',datafilename);    
    % TP = addProbePositionToDataTable(TP,T.Positions{cidx});
    TP = addExcludeFlagToDataTable(TP,trialStem);
    [TP, drugs] = addDrugsToDataTable(TP);
    [TP] = addTrackingFlagsToDataTable(TP,trialStem);
    TP = TP(~TP.Excluded & TP.HasProbe,:);
        
    % get the trials for each flashstrength
    FlashStrength = round(TP.ndf.*TP.stimDurInSec *1E12)/1E12;
    TP = addvars(TP,FlashStrength);
    flashStrengths = unique(FlashStrength);

    if (DEBUG)
%         dbfig = figure;
%         dbfig.Position = [680 333 689 645];
%         ax1 = subplot(2,1,1,'parent',dbfig); ax1.NextPlot = 'add';
%         ax2 = subplot(2,1,2,'parent',dbfig); ax2.NextPlot = 'add';
    end

    for drug = [{[]}]%,drugs']
        if isempty(drug{1})
            condidx = TP.control;
        else
            condidx = TP.(drug{1});
        end
        
        for fs = flashStrengths'
            
            fsidx = TP.FlashStrength ==fs;
            
            % store static values in the Table row
            group = TP.trial(fsidx & condidx);
            ndf = unique(TP.ndf(fsidx & condidx));
            dur = unique(TP.stimDurInSec(fsidx & condidx));
            
            T_row.Trialnums = {group'};
            T_row.Ndf = {ndf'};
            T_row.FlashDur = {dur'};
            T_row.FlashStrength = fs;

            if isempty(group)
                continue
            end
            
            trial = load(sprintf(trialStem,group(1)));
            t = makeInTime(trial.params); t = t(:)';
            ft = makeFrameTime(trial);

            % where to look for V_m peak
            vp_win = t>0&t<.04;
            % where to look for V_m trough
            vt_win = t>0&t<.15;

            % where to look for probe peak
            pp_win = ft>0&ft<.04;
            % where to look for probe trough
            %pt_win = ft>0&ft<.04;

            v_ = nan(length(t),length(group));
            probe_ = nan(length(ft),length(group));
            
            if isfield(trial,'spikes')
                spikes = v_;
            end
            for cnt = 1:length(group)
                trial = load(sprintf(trialStem,group(cnt)));
                if isfield(trial,'excluded') && trial.excluded
                    continue
                end
                
                % Maybe there are differences in how long the trial is
                try v_(:,cnt) = trial.voltage_1(1:size(v_,1));
                catch e
                    if strcmp(e.identifier,'MATLAB:subsassigndimmismatch') || strcmp(e.identifier,'MATLAB:badsubscript')
                        if length(trial.voltage_1) < max(size(v_))
                            v_(1:length(trial.voltage_1),cnt) = trial.voltage_1;
                        else
                            rethrow(e)
                        end
                    else
                        rethrow(e)
                    end
                end
                % collect the probe minimum
                
                % Maybe there are small errors in the alignment
                CoM = trial.forceProbeStuff.CoM - trial.forceProbeStuff.ZeroForce;
                try probe_(:,cnt) = CoM;
                catch e
                    if strcmp(e.identifier,'MATLAB:subsassigndimmismatch')
                        if length(trial.forceProbeStuff.CoM) < max(size(probe_))
                            probe_(1:length(CoM),cnt) = CoM;
                        else
                            probe_(:,cnt) = CoM(1:max(size(probe_)));
                        end
                    else
                        rethrow(e)
                    end
                end
                
                if isfield(trial,'spikes')
                    spikes(:,cnt) = 0;
                    spikes(trial.spikes,cnt) = 1;
                end
                
            end
            if all(isnan(v_(:)))
                %continue
            end
            
            v = nanmean(v_,2);
            base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
            [peak_v,vttpk] = max(v(vp_win)-base); vttpk = vttpk+sum(t<=0);
            [trough_v,vtttr] = min(v(vt_win & t>t(vttpk))-base); vtttr = vtttr+sum(t<=t(vttpk));
            
            probe = nanmean(probe_,2);
            
            if isfield(trial,'spikes')
                DT = 10/300;
                fr = firingRate(t,spikes,10/300);
                Rest = mean(fr(t>-.1 &t<0));
                [peak_fr,frttpk] = max(fr(vp_win)); frttpk = frttpk+sum(t<=0);
                [trough_fr,frtttr] = min(fr(vt_win & t>t(frttpk))); frtttr = frtttr+sum(t<=t(frttpk));
            else
                Rest = NaN;
                peak_fr = NaN;
                trough_fr = NaN;
            end
            
            Start_probe = mean(probe(ft<0));
            area = cumtrapz(ft,probe - Start_probe); area = area-area(find(ft<=0,1,'last'));
            exttime = ft(find(area(ft>0)<-.05,1,'first')+sum(ft<0));
            extflag = ~isempty(exttime) && exttime < .1; % indicates the probe has gone negative
            if any(isnan(probe(find(ft>0,10))))
                extflag = 1;
            end
            
            % Decide if the fly lets go
            zthresh = 5;
            if min(probe) <= zthresh && sum(probe < zthresh) >= 2
                % the fly lets go of the probe
                
                [Trough_probe,ptttr] = min(probe(ft>0)); ptttr = ptttr + sum(ft<=0);
                releasePeriod = probe < min(probe)+zthresh;
                releaseSegment = ft(releasePeriod);
                ReleaseDuration = releaseSegment(end)-releaseSegment(1);
                
                [Peak_probe,pttpk] = max(probe(ft<ft(ptttr)&ft>=0)); pttpk = pttpk + sum(ft<=0);
                if isempty(Peak_probe) || Peak_probe <= probe(find(ft>0,1,'first'))
                    Peak_probe = nan; pttpk = nan;
                end
            elseif min(probe) > zthresh || sum(probe < zthresh) < 2
                % the fly does not let go of the probe
                ReleaseDuration = nan;
                if extflag
                    % the fly extends but does not let go of the probe
                    [Trough_probe,ptttr] = min(probe(ft>0)); ptttr = ptttr + sum(ft<=0);
                    % Get whatever peak is before the extension
                    [Peak_probe,pttpk] = max(probe(ft<ft(ptttr)&ft>0)); pttpk = pttpk + sum(ft<=0);
                    if Peak_probe <= probe(find(ft>0,1,'first'))
                        Peak_probe = nan; pttpk = nan;
                    end
                elseif ~extflag
                    % if the fly first flexes, I care about the peak
                    [Peak_probe,pttpk] = max(probe(ft>0&ft<.2)); pttpk = pttpk + sum(ft<=0);
                    Trough_probe = nan; ptttr = nan;
                end
            end
                
            if DEBUG
                
                if strcmp(T_row.Cell_label,'slow')
                    dbfig = figure;
                    dbfig.Position = [680 32 689 964];
                    ax1 = subplot(3,1,1,'parent',dbfig); ax1.NextPlot = 'add';
                    ax1_5 = subplot(3,1,2,'parent',dbfig); ax1_5.NextPlot = 'add';
                    ax2 = subplot(3,1,2,'parent',dbfig); ax2.NextPlot = 'add';
                    cla(ax1_5)
                    plot(ax1_5,t,fr,'color',[0 0 0]);
                    plot(ax1,t(vttpk),peak_v+base,'marker','o','color',[1 0 0]);
                    plot(ax1,t(vtttr),trough_v+base,'marker','o','color',[0 .6 0]);
                else
                    ax1 = subplot(2,1,1,'parent',dbfig); ax1.NextPlot = 'add';
                    ax2 = subplot(2,1,2,'parent',dbfig); ax2.NextPlot = 'add';
                end
                cla(ax1)
                cla(ax2)
                groupid = [cellid ' (' num2str(fs) ',', drug{1} '): [' sprintf('%d,',group)]; groupid = [groupid(1:end-1) ']'];
                title(ax1,regexprep(groupid,'\_','\\_'));
                plot(ax1,t,v_,'color',[1 .7 .7]);
                plot(ax1,t,v,'color',[.7 0 0]);
                plot(ax1,t(vttpk),peak_v+base,'marker','o','color',[1 0 0]);
                plot(ax1,t(vtttr),trough_v+base,'marker','o','color',[0 .6 0]);
                
                for cnt = 1:length(group)
                    plot(ax2,ft,probe_(:,cnt),'color',[.7 .7 1],'tag',num2str(group(cnt)));
                end
                plot(ax2,ft,probe,'color',[0 0 .7]);
                %plot(ax2,ft([1 length(ft)]),[0 0],'color',[.7 .7 .7]);
                                
                if ~isnan(Peak_probe)
                    plot(ax2,ft(pttpk),Peak_probe,'marker','o','color',[0 1 0]);
                end
                if ~isnan(Trough_probe)
                    plot(ax2,ft(ptttr),Trough_probe,'marker','o','color',[.6 .68 .1]);
                end
                if ~isnan(ReleaseDuration)
                    plot(ax2,ft(releasePeriod),probe(releasePeriod),'color',[1 0 0],'linewidth',2);
                end
                
                drawnow
                %pause
            end
            
            % Store calculated values in Table row
            T_row.Drug = drug;
            if isempty(drug{1})
                T_row.Drug = {''};
            end
            T_row.V_m = base;
            T_row.Peak_V = peak_v;
            T_row.Trough_V = trough_v;
            if isfield(trial,'spikes')
                T_row.FR_rest = Rest;
                T_row.Peak_FR = peak_fr;
                T_row.Trough_FR = trough_fr;
            else
                T_row.FR_rest = NaN;
                T_row.Peak_FR = NaN;
                T_row.Trough_FR = nan;
            end
            
            T_row.Extenstion = extflag;
            T_row.Start_probe = Start_probe;
            T_row.Peak_probe = Peak_probe;
            T_row.Trough_probe = Trough_probe;
            T_row.ReleaseDuration = ReleaseDuration;
            T_row.TableFile = {TP.Properties.Description};
            
            % Add these numbers to a new line in a new T_Ramp
            Row_cnt = Row_cnt+1;
            T_iavChrFlash(Row_cnt,:) = T_row(1,:);

        end
        
        % Build up the flashstrengths and responses
        if DEBUG
            T_current = T_iavChrFlash(1:Row_cnt,:);
            T_cell = T_current(contains(T_current.CellID,cellid)&strcmp(T_current.Drug,''),:);
            
            clridx = strcmp({'fast','intermediate','slow'},T_cell.Cell_label{1});
            clr = clrs(clridx,:);
            ltclr = lightclrs(clridx,:);
            
            ax = subplot(4,1,1,'parent',fsfig); ax.NextPlot = 'add';
            title(ax,regexprep(cellid,'\_','\\_'));
            plot(ax,T_cell.FlashStrength,T_cell.Peak_V,'color',clr,'tag',T_cell.CellID{1}); %,'color',[1 0 0]
            plot(ax,T_cell.FlashStrength,T_cell.Trough_V,'color',ltclr,'tag',T_cell.CellID{1}); %,'color',[1 0 0]
            ylabel(ax,'V_m peak')
            ax.XScale = 'log';
            %ax.XLim = [min(T_cell.FlashStrength) max(T_cell.FlashStrength)];

            ax = subplot(4,1,2,'parent',fsfig); ax.NextPlot = 'add';
            plot(ax,T_cell.FlashStrength,T_cell.Peak_FR,'color',clr,'tag',T_cell.CellID{1}); % ,'color',[0 0 1]
            plot(ax,T_cell.FlashStrength,T_cell.Trough_FR,'color',ltclr,'tag',T_cell.CellID{1}); % ,'color',[0 0 1]
            ylabel(ax,'Fr Rate')
            ax.XScale = 'log';
            %ax.XLim = [min(T_cell.FlashStrength) max(T_cell.FlashStrength)];

            ax = subplot(4,1,3,'parent',fsfig); ax.NextPlot = 'add';
            plot(ax,T_cell.FlashStrength,T_cell.Peak_probe,'color',clr,'tag',T_cell.CellID{1}); % ,'color',[0 0 1]
            plot(ax,T_cell.FlashStrength,T_cell.Trough_probe,'color',ltclr,'tag',T_cell.CellID{1}); % ,'color',[0 0 1]
            ylabel(ax,'ProbeMovement')
            ax.XScale = 'log';
            %ax.XLim = [min(T_cell.FlashStrength) max(T_cell.FlashStrength)];

            ax = subplot(4,1,4,'parent',fsfig); ax.NextPlot = 'add';
            plot(ax,T_cell.FlashStrength,T_cell.ReleaseDuration,'color',clr,'tag',T_cell.CellID{1}); % ,'color',[0 0 1]
            ylabel(ax,'Release duration')
            ax.XScale = 'log';
            %ax.XLim = [min(T_cell.FlashStrength) max(T_cell.FlashStrength)];

            drawnow
            figure(fsfig)
            %pause
        end

    end
end
T_iavChrFlash = T_iavChrFlash(1:Row_cnt,:);

if DEBUG 
    %close(ax1.Parent)
end

