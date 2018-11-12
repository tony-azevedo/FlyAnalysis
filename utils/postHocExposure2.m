function h = postHocExposure2(h,varargin)
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

if isfield(h,'exposure2') && ((h.exposure2(1) == 1 || h.exposure2(2) == 1) && ~islogical(h.exposure2))
    exposure2 = h.exposure2;
    exposure_1_0 = zeros(size(exposure2));
    
    % turn exposure into a vector where the end of the exposure -> 1
    exposure_1_0(1:end-1) = exposure2(1:end-1)&~exposure2(2:end); 
    if exist('N','var')
        exp_idx = find(exposure_1_0);
        if shift, exposure_1_0(exp_idx(1:shift)) = 0; end      
        exposure_1_0(exp_idx(N+shift+1:end)) = 0;
        if sum(exposure_1_0)~=N
            fprintf('\n**%d exposures, but %d frames - likely started triggering early**\n**',sum(exposure_1_0),N)
            error('Are there enough exposures to skootch this trial and maintain frame number?')
        end
    end

    h.exposure2 = logical(exposure_1_0);
else
   error('Exposure vector is not well conditioned for current analysis\n1st true index (exp starts) = %d',find(h.exposure,1,'first')); 
end

