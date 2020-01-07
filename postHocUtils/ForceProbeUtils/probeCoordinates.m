function [l,p,l_r,R,p_,p_scalar,barbar,x] = probeCoordinates(trial)

l = trial.forceProbe_line;
p = trial.forceProbe_tangent;

% probe_eval_points = turnLineIntoEvalPnts(l,p);
% recenter
l_0 = l - repmat(mean(l,1),2,1);
p_0 = p - mean(l,1);

% for my purposes, get the line equation (m,b)
m = diff(l(:,2))/diff(l(:,1));
b = l(1,2)-m*l(1,1);

% find y vector
barbar = l_0(2,:)/norm(l_0(2,:));

% project tangent point
p_scalar = barbar*p_0';

% find intercept, recenter
p_ = p_scalar*barbar+mean(l,1);

% rotate coordinates
R = [cos(pi/2) -sin(pi/2);
    sin(pi/2) cos(pi/2)];
l_r = (R*l_0')'/4;
upperright_ind = find(l_r(:,1)>l_r(:,2));
x = l_r(upperright_ind,:)/norm(l_r(upperright_ind,:));
l_r = l_r + repmat(p_,2,1);

if 0
    displayf = findobj('type','figure','tag','big_fig');
    if isempty(displayf)
        displayf = figure;
        displayf.Position = [40 2 640 530];
        displayf.Tag = 'big_fig';
    end
    dispax = findobj(displayf,'type','axes','tag','dispax');
    if isempty(dispax)
        dispax = axes('parent',displayf,'units','pixels','position',[0 0 640 512],'tag','dispax');
        dispax.Box = 'off'; dispax.XTick = []; dispax.YTick = []; dispax.Tag = 'dispax';
        colormap(dispax,'gray')
    end
    hold(dispax,'off')
    im = imshow(frame,[0 2*quantile(frame(:),0.975)],'parent',dispax);
    hold(dispax,'on');
    % find limits projected along x
    line(trial.forceProbe_line(:,1),trial.forceProbe_line(:,2),'parent',dispax,'color',[1 0 0]);
    % line(p_(1),p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 1 1]);
    line(l_r(:,1),l_r(:,2),'parent',dispax,'color',[1 .3 .3]);
end


