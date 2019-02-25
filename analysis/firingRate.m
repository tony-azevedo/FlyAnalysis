function fr = firingRate(t,spike_counts,DT)

% assume more rows (timebins) than columns (trials)
if size(spike_counts,1)<size(spike_counts,2)
    spike_counts = spike_counts(:);
end
% Calculate spike rate
% ?(t)=1/?t n_K(t;t+?t) / K.
spikes = nansum(spike_counts,2)/sum(~isnan(spike_counts(1,:))); % K (some trials may not have spikes)
wind = sum(t>0&t<=DT); nb = round(wind/4); nf = round(wind*3/4);
fr = movsum(spikes,[nb,nf],1)/DT;
fr = smooth(fr,round(wind/4));

