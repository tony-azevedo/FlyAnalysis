function h = postHocExposureRaw(h,varargin)
if nargin>1
    N = varargin{1};
end
if isfield(h,'exposure_raw')
    exposure = h.exposure_raw;
    fprintf(' * Exposure skootched, using original exposure!\n')
elseif h.exposure(1) == 1 && ~islogical(h.exposure)
    exposure = h.exposure;
else
   error('Exposure vector is not well conditioned for current analysis'); 
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
    exposure_1_0(exp_idx(N+1:end)) = 0;
end
h.exposure = logical(exposure_1_0);

