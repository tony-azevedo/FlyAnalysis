% Do the skootching of the data

rawfiles = dir([protocol '_Raw_*']);

h = load(rawfiles(1).name);

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(h.name);
data = load(datastructfile); data = data.data;

skootchedFrames = nan(size(1:length(data)));

for tr_idx = 11:length(data)
    
    trial = load(sprintf(trialStem,data(tr_idx).trial));
    fprintf('%s\n',trial.name);
    
    [protocol,dateID,flynum,cellnum,trialnum,D,trialStem,dataFile] = extractRawIdentifiers(trial.name);
    if isfield(trial,'badmovie')
        fprintf('\t ** Bad movie, moving on\n');
        continue
    end
    if isfield(trial,'exposure_raw')
        fprintf('\t -- Already skootched, moving on\n');
        continue
    end


    if isfield(trial,'clustertraces');
        tn = 'clustertraces';
    else
        tn = 'roitraces';
    end
    
    figure
    N = size(trial.(tn),1);
    exp=postHocExposure(trial,N);
    t = makeInTime(trial.params);
    frame_times = t(exp.exposure);
    try plot(frame_times,trial.(tn),'k');
    catch 
        plot(frame_times,trial.(tn)(1:length(frame_times)),'k');
    end
   
    hold on
    l_ = frame_times>=-7*(mean(diff(frame_times))) & frame_times<=3*(mean(diff(frame_times)));
    ylims = [min(min(trial.(tn)(l_,:))) max(max(trial.(tn)(l_,:)))];
    axis('tight')
    
    plot(t,diff(ylims)*exp.exposure+min(ylims));
    xlim([-12*(mean(diff(frame_times))) 12*(mean(diff(frame_times)))])
    set(gca,'ylim',ylims);
    title(regexprep(sprintf(trialStem,data(tr_idx).trial),'_','\\_'));
    
    % select frames around 0
    light_on = trial.(tn)(frame_times>=-12*(mean(diff(frame_times))) & frame_times<=5*(mean(diff(frame_times))),:);
    % normalize
    for cl = 1:size(light_on,2)
        light_on(:,cl) = light_on(:,cl)/mean(light_on(end-5:end,cl));
    end
    % find where the jump happens
    flash = diff(mean(light_on,2));
    [~,idx] = max(flash);
    
    % if the flash induces a small increas in the previous frame, take that
    % one instead
    if all(flash(idx-1) > flash(1:length(flash)~=idx & 1:length(flash)~=idx-1))
        idx = idx-1;
    end
    % don't forget to add back the first element, missing after diff
    shift = 13-(idx+1);
    skootchedFrames(tr_idx) = shift;    
    
    exp=postHocExposure(trial,N+shift);
    exp.exposure(find(exp.exposure,shift,'first')) = 0;
    
    frame_times = t(exp.exposure);
    
    try plot(frame_times(1:size(trial.(tn),1)),trial.(tn),'r');
    catch 
        plot(frame_times,trial.(tn)(1:length(frame_times)),'r');
    end

    trial.exposure_raw = trial.exposure;
    trial.exposure = exp.exposure;
    
    save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
    pause(1)
    close(gcf);
end
