function varargout = legPositions(lp,varargin)

units = 'delta';
if nargin>1
    units = varargin{1};
end
if any(~isreal(lp(:)));
    lpi = lp;
else
    lpi = squeeze(lp(:,1,:) + 1i*lp(:,2,:));
end

femurpos = abs(lpi(2,:)-lpi(1,:));
tibiapos = abs(lpi(3,:)-lpi(2,:));
tarspos = abs(lpi(4,:)-lpi(3,:));

switch units
    case 'delta'
        tarspos = tarspos-mean(tarspos);
        tibiapos = tibiapos-mean(tibiapos);
        femurpos = femurpos-mean(femurpos);
    otherwise
        
end


varargout = {femurpos,tibiapos,tarspos};