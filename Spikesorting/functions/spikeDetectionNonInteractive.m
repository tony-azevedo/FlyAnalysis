function [trial,vars_skeleton] = spikeDetectionNonInteractive(trial,inputToAnalyze,vars_initial)
%% For now this function only gets the spikes from a single electrode.
% I'll need to come up with a different version (spikeDetectionPairs) when
% I start looking at pairs of neurons. Alternatively the wrapper function
% could just cal this function on the two sets of spikes.

% if trial.params.gain_1==100 && strcmp(inputToAnalyze,'voltage_1')
%     unfiltered_data = trial.(inputToAnalyze);
% else
unfiltered_data = filterMembraneVoltage(trial.(inputToAnalyze),trial.params.sampratein);
% end% d1 = getacqpref('FlyAnalysis',['VoltageFilter_fs' num2str(trial.params.sampratein)]);
% unfiltered_data = filter(d1,unfiltered_data);


% clean up vars_initial
vars_initial = cleanUpSpikeVarsStruct(vars_initial);

% fprintf('** Spike Detection running with params:\n')
% disp(vars_initial);

global vars;
vars = vars_initial;

% max_len = 400000;
% if length(unfiltered_data) < max_len
    vars.len = length(unfiltered_data)-round(.01*trial.params.sampratein);
% else
%     vars.len = max_len -round(.01*trial.params.sampratein);
% end

start_point = round(.01*trial.params.sampratein);
stop_point = min([start_point+vars.len length(unfiltered_data)]);
unfiltered_data = unfiltered_data(start_point+1:stop_point);

vars.unfiltered_data = unfiltered_data;
vars.filtered_data = filterDataWithSpikes(vars);
[~,vars.lastfilename] = fileparts(trial.name);

%% run detection first, ask if you need to look again.
if isfield(vars,'spikeTemplate') && ~isempty(vars.spikeTemplate) 
    spikeTemplate = vars.spikeTemplate;
    [spikes_detected,uncorrectedSpikes] = detectSpikes();
end
    
vars = cleanUpSpikeVarsStruct(vars);
vars.lastfilename = trial.name;
vars_skeleton = vars;
if isempty(spikes_detected)
    trial.spikes = spikes_detected;
    trial.spikes_uncorrected = uncorrectedSpikes;
    trial.spikeDetectionParams = vars;
    trial.spikeSpotChecked = 0;
    
    save(trial.name, '-struct', 'trial');
    fprintf('Saved Spikes (0) and filter parameters saved: %s\n',trial.name);
    return
end
trial.spikes = spikes_detected + start_point;
trial.spikes_uncorrected = uncorrectedSpikes + start_point;
trial.spikeDetectionParams = vars;
trial.spikeSpotChecked = 0;
save(trial.name, '-struct', 'trial');
fstag = ['fs' num2str(vars.fs)];
setacqpref('FlyAnalysis',['Spike_params_' fstag],vars);

fprintf('Saved Spikes (%d) and filter parameters saved: %s\n',numel(trial.spikes),trial.name);

% fprintf('** Spike Detection was run with params:\n')
% disp(vars);
% fprintf('**----------------------**\n')
    
return


    function varargout = detectSpikes
        %% get all the spike locs using the correct filt and thresh cvalues
        % Amazingly, the filtering operation in the filter_slider GUI hear
        % below were using different values for the filter poles (4 here
        % and 2 in the filterGUI). This meant that if you chose a single
        % template seed example, you would get different spikeTemplate
        % waveforms and the DTW distance was somewhat large. Oddly, you'd
        % think it would go the opposite way, such that the template was smoother 
        % than the target spikes. I'm now using 3 poles as a happy medium               
             
        %% Now get details about the spike
        
        if vars.peak_threshold > 1E4*std(vars.filtered_data)
            error('weird part of the loop, does this really cause issues?')
            vars.peak_threshold = 3*std(vars.filtered_data);
        end
        spike_locs = findSpikeLocations(vars, vars.filtered_data);

        if any(spike_locs~=unique(spike_locs))
            error('Why are there multiple peak at the same time?')
        end
        
        norm_spikeTemplate = (spikeTemplate-min(spikeTemplate))/(max(spikeTemplate)-min(spikeTemplate));
        
        [detectedUFSpikeCandidates,...
            detectedSpikeCandidates,...
            norm_detectedSpikeCandidates,...
            targetSpikeDist,...
            spikeAmplitude,...
            window,...
            spikewindow] = ...
            getSquiggleDistanceFromTemplate(spike_locs,spikeTemplate,vars.filtered_data,vars.unfiltered_data,vars.spikeTemplateWidth,vars.fs);
        
        vars.locs = spike_locs;

        % This is useful feedback to see what has been detected thus far,
        % but if there are no spikes, stop here.
        if ~isempty(targetSpikeDist)
                                    
            % The threshold is finally set, get rid of spikes that are over
            % the threshold
            spikes = vars.locs;            
            suspect = targetSpikeDist<vars.Distance_threshold & spikeAmplitude > vars.Amplitude_threshold; % goodspikeamp
            spikes = spikes(suspect);
                                    
            
            spikeWaveforms = detectedUFSpikeCandidates-repmat(detectedUFSpikeCandidates(1,:),size(detectedUFSpikeCandidates,1),1);
            
            if length(spikes)>=1
                
                vars.locs = spikes;
                vars = estimateSpikeTimeFromInflectionPoint(vars,spikeWaveforms(:,suspect),targetSpikeDist(suspect));

                varargout = {vars.locs,vars.locs_uncorrected};
                
                return
                
            else % If there were no spikes at all
                
                spikes = [];
                spikes_uncorrected = spikes;
                varargout = {spikes,spikes_uncorrected};
                
                return
            end
        else
            spikes = [];
            spikes_uncorrected = spikes;
            varargout = {spikes,spikes_uncorrected};
        end
            
    end

end
