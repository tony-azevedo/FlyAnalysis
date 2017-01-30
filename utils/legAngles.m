function varargout = legAngles(lp,varargin)

units = 'rad';
if nargin>1
    units = varargin{1};
end
if any(~isreal(lp(:)));
    lpi = lp;
else
    lpi = squeeze(lp(:,1,:) + 1i*lp(:,2,:));
end

femurangle = unwrap(angle(lpi(2,:)-lpi(1,:)));
tibiaangle = unwrap(angle(lpi(3,:)-lpi(2,:)));
tarsangle = unwrap(angle(lpi(4,:)-lpi(3,:)));
tarsangle = (tarsangle-tibiaangle);
tibiaangle = (tibiaangle-femurangle);


% put it in range of -180 to 180
if sum(tarsangle<-pi);
    tarsangle = tarsangle + 2*pi;
elseif sum(tarsangle>pi)
    tarsangle = tarsangle - 2*pi;
end

if sum(tibiaangle<-pi);
    tibiaangle = tibiaangle + 2*pi;
elseif sum(tibiaangle>pi)
    tibiaangle = tibiaangle - 2*pi;
end

if sum(femurangle<-pi);
    femurangle = femurangle + 2*pi;
elseif sum(femurangle>pi)
    femurangle = femurangle - 2*pi;
end


switch units
    case 'deg'
        tarsangle = tarsangle/2/pi*360;
        tibiaangle = tibiaangle/2/pi*360;
        femurangle = femurangle/2/pi*360;
    otherwise
        
end


varargout = {femurangle,tibiaangle,tarsangle};