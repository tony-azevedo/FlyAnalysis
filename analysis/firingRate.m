function fr = firingRate(t,spike_counts,DT,varargin)

if nargin>3
    dim = varargin{1};
    % make it more columns (timebins) than rows (trials)
    if dim == 1
        goodcolumns = ~isnan(spike_counts(:,1));
        mid = 2;
    elseif dim == 2
        goodcolumns = ~isnan(spike_counts(1,:));
        mid = 1;
    end
else
    % make it more columns (timebins) than rows (trials)
    if size(spike_counts,1)<size(spike_counts,2)
        spike_counts = spike_counts';
    end
    dim = 2;
    mid = 1;
    goodcolumns = ~isnan(spike_counts(1,:));
end
% Calculate spike rate
% D(t)=1/dt n_K(t;t+dt) / K.
spikes = nansum(spike_counts,dim)/sum(goodcolumns); % K (some trials may not have spikes)
wind = sum(t<=t(1)+DT); 
nb = round(wind*7/8); 
nf = round(wind*1/8);
fr = movsum(spikes,[nb,nf],mid)/DT;
fr = smooth(fr,round(wind/4));
%fr = fr/size(spike_counts,dim);

