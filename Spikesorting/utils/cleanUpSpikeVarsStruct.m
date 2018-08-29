function v = cleanUpSpikeVarsStruct(v)

if isfield(v,'lp_pos'),v = rmfield(v,{'lp_pos'}); end
if isfield(v,'hp_pos'),v = rmfield(v,{'hp_pos'}); end
if isfield(v,'thresh_pos'),v = rmfield(v,{'thresh_pos'}); end
if isfield(v,'locs'),v = rmfield(v,{'locs'}); end
if isfield(v,'spike_locs'),v = rmfield(v,{'spike_locs'}); end
if isfield(v,'filtered_data'),v = rmfield(v,{'filtered_data'}); end
if isfield(v,'unfiltered_data'), v = rmfield(v,{'unfiltered_data'}); end
if isfield(v,'lastfile'),v = rmfield(v,{'lastfile'}); end


