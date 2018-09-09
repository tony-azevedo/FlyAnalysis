function v = cleanUpSpikeVarsStruct(v)

if isfield(v,'lp_pos'),v = rmfield(v,{'lp_pos'}); end
if isfield(v,'hp_pos'),v = rmfield(v,{'hp_pos'}); end
if isfield(v,'thresh_pos'),v = rmfield(v,{'thresh_pos'}); end
if isfield(v,'locs'),v = rmfield(v,{'locs'}); end
if isfield(v,'spike_locs'),v = rmfield(v,{'spike_locs'}); end
if isfield(v,'filtered_data'),v = rmfield(v,{'filtered_data'}); end
if isfield(v,'unfiltered_data'), v = rmfield(v,{'unfiltered_data'}); end
if isfield(v,'lastfile'),v = rmfield(v,{'lastfile'}); end
if isfield(v,'spikeWaveform'),v = rmfield(v,{'spikeWaveform'}); end
if isfield(v,'spikeWaveform_'),v = rmfield(v,{'spikeWaveform_'}); end

if ~isfield(v,'peak_threshold');v.peak_threshold = 5;end %%initial threshold for finding peaks
if ~isfield(v,'polarity'),v.polarity = 1; end

