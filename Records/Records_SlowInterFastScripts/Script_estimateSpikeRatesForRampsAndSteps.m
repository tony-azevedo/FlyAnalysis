% Do stuff with the spike rate of slow neurons

DEBUG =0;

SlowRampRows = T_Ramp(strcmp(T_Ramp.Cell_label,'slow'),:);
cids = unique(SlowRampRows.CellID);

% SlowRampRows.Properties.VariableNames{11} = 'Peak';
SlowRampRows.Properties.VariableNames{12} = 'Rest';
SlowRampRows.Rest(:) = num2cell(nan(height(SlowRampRows),1));
SlowRampRows.Properties.VariableNames{13} = 'frXv_corr';
SlowRampRows.frXv_corr(:) = num2cell(nan(height(SlowRampRows),1));

if (DEBUG)
    figure
    ax = subplot(1,1,1);
end

for c = 1:length(cids)
    cid = cids{c};
    fprintf(1,'Cell %s\n',cid);
    cidx = strcmp(SlowRampRows.CellID,cid);
    positions = unique(cell2mat(SlowRampRows.Position(cidx)));

    for position = positions(:)'
        % get the trials for each speed and displacement, average and calculate amplitude, area, time
        % to peak
        fprintf(1,'Position %d\n',position);
        pidx = cell2mat(SlowRampRows.Position(:)) == position;

        displacements = unique(cell2mat(SlowRampRows.Displacement(cidx&pidx)));
        speeds = unique(cell2mat(SlowRampRows.Speed(cidx&pidx)));
        for displacement = displacements(:)'
            
            fprintf(1,'\tDisplacement %d\n',displacement);
            didx = cell2mat(SlowRampRows.Displacement(:))==displacement;
            
            for speed = speeds(:)'
                fprintf(1,'\t\tSpeed %d\n',speed);
                sidx = cell2mat(SlowRampRows.Speed(:))==speed;
                
                ridx = cidx & pidx & sidx & didx;
                
                % sum(ridx)
                Row = SlowRampRows(ridx,:);
                group = Row.Trialnums{:};
                if isempty(group)
                    continue
                end
                trialStem = fullfile(fileparts(Row.TableFile{:}),[Row.Protocol{:} '_Raw_' Row.CellID{:} '_%d.mat']); trialStem = regexprep(trialStem,'\\','\\\');
                trial = load(sprintf(trialStem,group(1)));
                t = makeInTime(trial.params); t = t(:)';
                v_ = nan(length(t),length(group));
                spikes_ = v_;

                for cnt = 1:length(group)
                    trial = load(sprintf(trialStem,group(cnt)));
                    if isfield(trial,'excluded') && trial.excluded
                        continue
                    end
                    if ~isfield(trial,'spikes') || isempty(trial.spikes)
                        continue
                    end
                    v_(:,cnt) = trial.voltage_1;
                    
                    spikes_(:,cnt) = 0;
                    spikes_(trial.spikes,cnt) = 1;
                    
                end
                if all(isnan(v_(:)))
                    continue
                end
                % ignore the prepulse
                twind = t>-trial.params.preDurInSec+.06;

                % Calculate spike rate
                % ?(t)=1/?t n_K(t;t+?t) / K.
                spikes = nansum(spikes_,2)/sum(~isnan(spikes_(1,:))); % K (some trial may not have spikes)
                DT = 10/300; % max displacment/max speed
                wind = sum(t>0&t<=DT); nb = round(wind/4); nf = round(wind*3/4);
                fr = movsum(spikes,[nb,nf],1)/DT;
                fr = smooth(fr,round(wind/4));

                SlowRampRows.Rest{ridx} = mean(fr(twind & t<0));
                % look for the peak response, either hyperpolarization or
                % depolarization, following the stimulus, before the off
                % step
                dt_resp = trial.params.stimDurInSec - abs(trial.params.displacement)/trial.params.speed;
                switch sign(displacement)
                    case -1 % extension
                        [SlowRampRows.Peak{ridx},idx] = max(fr(t>0 & t<dt_resp)); idx = idx+sum(t<=0);
                    case 1 % flexion
                        [SlowRampRows.Peak{ridx},idx] = min(fr(t>0 & t<dt_resp)); idx = idx+sum(t<=0);
                end
                                
                v = nanmean(v_,2);
                base = mean(v(t<0 &t>-trial.params.preDurInSec+.1));
                v = v-mean(v(t<0 &t>-trial.params.preDurInSec+.1));
                
                R = corrcoef(fr(twind)-mean(fr(twind)),v(twind)-mean(v(twind)));
                if R(1,2)>1
                   stop; 
                end
                SlowRampRows.frXv_corr{ridx} = R(1,2);
                
                if DEBUG %%&& -10==displacement(D) && (strcmp(cid,'180404_F1_C1') || strcmp(cid,'180703_F3_C1'))
                    cla(ax); ax.NextPlot = 'add';
                    groupid = [cid]; % ': [' sprintf('%d,',group)]; groupid = [groupid(1:end-1) ']'];
                    title(ax,groupid); hold(ax,'on')
                    plot(ax,t,v); 
                    plot(ax,[t(1) t(find(t<0,1,'last'))],SlowRampRows.Rest{ridx}*[1 1],'Color',[.8 .8 .8]);
                    plot(ax,t,fr);
                    plot(ax,t(idx),SlowRampRows.Peak{ridx},'o');
                    
                    ax.XLim = [t(1) t(end)];
                    drawnow
                    %pause();
                    pause(.02)
                end
            end
        end
    end
end

% if DEBUG 
%     close(ax.Parent)
% end

