function b = postHocExposure(h,varargin)
if nargin>1
    N = round(varargin{1});
end
shift = 0;
use = 'skootched';
if nargin>2
    p = inputParser;
    p.addOptional('shift',0,@(x) rem(x,1)==0);
    p.addOptional('use','skootched',...
        @(x) any(validatestring(x,{'skootched','raw'})));
    parse(p,varargin{2:end});
end
if exist('p','var') && isfield(p.Results,'shift')
    shift = p.Results.shift;
end
if exist('p','var') && isfield(p.Results,'use')
    use = p.Results.use;
end
if ~islogical(h.exposure)
    start = find(h.exposure,1,'first');
    next = find(h.exposure(start+1:end)==0,1,'first');
    DF = find(h.exposure(next+1:end),1,'first')+next;
end

if (~islogical(h.exposure) && DF > start) || strcmp(use,'raw')
    if ~(h.exposure(1) == 1 || h.exposure(2) == 1)
       warning('Exposure vector is not well conditioned for current analysis\n1st true index (exp starts) = %d',start); 
    end
    exposure = h.exposure;
    if strcmp(use,'raw') && isfield(h,'exposure_raw')
        exposure = h.exposure_raw;
    end
    exposure_1_0 = zeros(size(exposure));
    
    % turn exposure into a vector where the end of the exposure -> 1
    exposure_1_0(1:end-1) = exposure(1:end-1)&~exposure(2:end); 
    
    
    % Missed some exposures, find the closest samples
    % but there are also more exposures taken after the end of the
    % video
    % so, first check some things
        
    exp_idx = find(exposure_1_0);
    samples = diff(exp_idx);
    fr = mode(samples); % standard frame rate
    
    % the second exposure often takes a bit longer
    delayedexp = 0;
    if samples(1)>fr*1.1 || samples(1)<fr*.9
        delayedexp = 1;
    end
    
    % Fill in the exposures that must have happend
    missed = find(samples>1.95*fr&samples<2.05*fr);
    
    if samples(1)>1.95*fr && samples(1)<2.05*fr
        missed = missed(2:end);
    end

    exposure_1_0(exp_idx(missed)+fr) = 1;
            
    if exist('N','var')
        exp_idx = find(exposure_1_0);
        if shift, exposure_1_0(exp_idx(1:shift)) = 0; end      
        exposure_1_0(exp_idx(N+shift+1:end)) = 0;
        if sum(exposure_1_0)~=N
            fprintf('\n**%d exposures, but %d frames - likely started triggering early**\n**',sum(exposure_1_0),N)
            error('Are there enough exposures to skootch this trial and maintain frame number?')
        end
    end
    b.exposure = logical(exposure_1_0);
elseif isfield(h,'exposure_raw') || strcmp(use,'skoootched')
    b.exposure = h.exposure;
    %fprintf(' * Exposure vector has been skootched!\n')
else
   error('Exposure vector is not well conditioned for current analysis\n1st true index (exp starts) = %d',find(h.exposure,1,'first')); 
end

if isfield(h,'exposure2') && ((h.exposure2(1) == 1 || h.exposure2(2) == 1) && ~islogical(h.exposure2))
    exposure2 = h.exposure2;
    exposure_1_0 = zeros(size(exposure2));
    
    % turn exposure into a vector where the end of the exposure -> 1
    exposure_1_0(1:end-1) = exposure2(1:end-1)&~exposure2(2:end); 
    b.exposure2 = logical(exposure_1_0);
end
