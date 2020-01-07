function [trial,response] = probeLineROI(trial)
%% Set an ROI that avoids the leg, just gets the probe
% I think I only need 1 for now, but I'll keep the option for multiple
% (storing in cell vs matrix)

displayf = findobj('type','figure','tag','big_fig');
if isempty(displayf)
    displayf = figure;
    displayf.Position = [600 2 1280 1048];
    displayf.Tag = 'big_fig';
    displayf.MenuBar = 'none';
end
dispax = findobj('type','axes','tag','dispax');
if isempty(dispax)
    dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
    dispax.Box = 'off'; dispax.XTick = []; dispax.YTick = []; dispax.Tag = 'dispax';
    colormap(dispax,'gray')
end

%%

vid = VideoReader(trial.imageFile);
% N = vid.Duration*vid.FrameRate;
% h2 = postHocExposure(trial,N);

smooshedframe = double(readFrame(vid));
smooshedframe = squeeze(smooshedframe(:,:,1));

for jj = 1:10
    mov3 = double(readFrame(vid));
    smooshedframe = smooshedframe+mov3(:,:,1);
end
smooshedframe = smooshedframe/11;

im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax);
hold(dispax,'on');

%%
if ~isfield(trial,'forceProbe_line')
    if ~isacqpref('quickshowPrefs','forceProbeLine')
        setacqpref('quickshowPrefs','forceProbeLine',[601 626;64 36]);
    end
    temp.forceProbe_line = getacqpref('quickshowPrefs','forceProbeLine');
    trial.forceProbe_line = temp.forceProbe_line;
end

if ~isfield(trial,'forceProbe_tangent')
    if ~isacqpref('quickshowPrefs','forceProbeTangent')
        setacqpref('quickshowPrefs','forceProbeTangent',[236 508]);
    end
    temp.forceProbe_tangent = getacqpref('quickshowPrefs','forceProbeTangent');
    line(temp.forceProbe_tangent(:,1),temp.forceProbe_tangent(:,2),'parent',dispax,'marker','o','markeredgecolor',[0 1 0],'tag','oldbar');
    trial.forceProbe_tangent = temp.forceProbe_tangent;
end
line(trial.forceProbe_line(:,1),trial.forceProbe_line(:,2),'parent',dispax,'color',[0 1 0],'tag','oldbar');
line(trial.forceProbe_tangent(:,1),trial.forceProbe_tangent(:,2),'parent',dispax,'marker','o','markeredgecolor',[0 1 0],'tag','oldpoint');

% Draw the stuff
l = trial.forceProbe_line;
p = trial.forceProbe_tangent;

% recenter
l_0 = l - repmat(mean(l,1),2,1);
p_0 = p - mean(l,1);

% find y vector
y = l_0(2,:)/norm(l_0(2,:));

% project tangent point - how far along line is tangent from center?
p_scalar = y*p_0';

% find intercept, recenter - add projection to center point.
p_ = p_scalar*y+mean(l,1);

% rotate coordinates
R = [cos(pi/2) -sin(pi/2);
    sin(pi/2) cos(pi/2)];
l_r = (R*l_0')'/4;
l_r = l_r + repmat(p_,2,1);

line(p_(1),p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 1 1],'tag','intercept');
line(l_r(:,1),l_r(:,2),'parent',dispax,'color',[1 .3 .3],'tag','intercept');

%% Check that the end of the line doesn't cut off the corner.

% find the corner projection onto y
p_crn_ur = [1280 0];
line(p_crn_ur(1),p_crn_ur(2),'parent',dispax,'marker','o','markeredgecolor',[.3 .6 1]);

p_crn_0 = p_crn_ur - mean(l,1);

p_crn_scalar = y*p_crn_0';

p_crn_ = p_crn_scalar*y+mean(l,1);

l_r_crn = [p_crn_; p_crn_ur];

line(p_crn_(1),p_crn_(2),'parent',dispax,'marker','o','markeredgecolor',[.3 .3 .3]);
line(l_r_crn(:,1),l_r_crn(:,2),'parent',dispax,'color',[.3 .3 .3]);
    

%% Check that the end of the line doesn't cut off the other corner.

% find the corner projection onto y
p_crn_ll = [0 1024];
line(p_crn_ll(1),p_crn_ll(2),'parent',dispax,'marker','o','markeredgecolor',[.3 .6 1]);

p_crn_0 = p_crn_ll - mean(l,1);

p_crn_scalar = y*p_crn_0';

p_crn_ = p_crn_scalar*y+mean(l,1);

l_r_crn = [p_crn_; p_crn_ll];

line(p_crn_(1),p_crn_(2),'parent',dispax,'marker','o','markeredgecolor',[.3 .3 .3]);
line(l_r_crn(:,1),l_r_crn(:,2),'parent',dispax,'color',[.3 .3 .3]);
    

%%
figure(displayf)
newbutton = questdlg('Make new probe bar and tangent?','Probe ROI','No');

if strcmp(newbutton,'Yes')
    
    button = questdlg('Make new forceProbe_line?','forceProbe_line','No');
    if strcmp(button,'Yes')
        roihand = imline(dispax);
        roi_temp = wait(roihand);
        delete(findobj(dispax,'type','line','tag','oldbar'))
        trial.forceProbe_line = roi_temp;
        setacqpref('quickshowPrefs','forceProbeLine',trial.forceProbe_line)
    elseif strcmp(button,'No')
    elseif strcmp(button,'Cancel')
        fprintf('Not setting tangent in trial\n')
        close(displayf)
        
        return
    end
    
    button = questdlg('Make new forceProbeTangent?','forceProbeTangent','No');
    
    if strcmp(button,'Yes')
        roihand = impoint(dispax);
        roi_temp = wait(roihand);
        delete(findobj(dispax,'type','line','tag','oldpoint'))
        trial.forceProbe_tangent = roi_temp;
        setacqpref('quickshowPrefs','forceProbeTangent',trial.forceProbe_tangent)
    elseif strcmp(button,'No')
        response = 'No';
    elseif strcmp(button,'Cancel')
        fprintf('Not setting tangent in trial\n')
        close(displayf)
        response = 'Cancel';
        return
    end
        
    % Do a little transform so I can draw the line either way
    if trial.forceProbe_line(1,1)>trial.forceProbe_line(2,1)
        trial.forceProbe_line = flipud(trial.forceProbe_line);
    end
    
    % Draw the stuff
    l = trial.forceProbe_line;
    p = trial.forceProbe_tangent;
    
    % probe_eval_points = turnLineIntoEvalPnts(l,p);
    % recenter
    l_0 = l - repmat(mean(l,1),2,1);
    p_0 = p - mean(l,1);
    
    % find y vector
    y = l_0(2,:)/norm(l_0(2,:));
    
    % project tangent point
    p_scalar = y*p_0';
    
    % find intercept, recenter
    p_ = p_scalar*y+mean(l,1);
    
    % rotate coordinates
    R = [cos(pi/2) -sin(pi/2);
        sin(pi/2) cos(pi/2)];
    l_r = (R*l_0')'/4;
    l_r = l_r + repmat(p_,2,1);
    
    delete(findobj(dispax,'tag','intercept'));
    
    line(p_(1),p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 1 1]);
    line(l_r(:,1),l_r(:,2),'parent',dispax,'color',[1 .3 .3]);
    
    
    % Check that the end of the line doesn't cut off the corner.
    
    % find the corner projection onto y
    p_crn = [1280 0];
    line(p_crn(1),p_crn(2),'parent',dispax,'marker','o','markeredgecolor',[.3 .6 1]);
    
    p_crn_0 = p_crn - mean(l,1);
    
    p_crn_scalar = y*p_crn_0';
    
    
    if p_crn_scalar<p_scalar
        trial.forceProbe_tangent = p_crn_scalar*.95*y+mean(l,1);
        p_crn_ = p_crn_scalar*.95*y+mean(l,1);
        
        l_r_crn = (R*l_0')'/4 + repmat(p_crn_,2,1);
        
        line(p_crn_(1),p_crn_(2),'parent',dispax,'marker','o','markeredgecolor',[.3 .6 1]);
        line(l_r_crn(:,1),l_r_crn(:,2),'parent',dispax,'color',[.3 .6 1]);

    end

    setacqpref('quickshowPrefs','forceProbeTangent',trial.forceProbe_tangent)
    setacqpref('quickshowPrefs','forceProbeLine',trial.forceProbe_line)

%%
    
    % one more check,
    % go through the other frames of the image and ask if they look good too
    
%     for fr = 1:size(smpd.sampledImage,3)
%         im.CData = smpd.sampledImage(:,:,fr);
%         pause(.05)
%     end
    button = questdlg('All good? Movie, good bar AND tangent?','forceProbeTangent','Yes');
    switch button
        case 'Yes'
            trial = trial;
            fprintf('Saving bar and tangent in trial\n')
            save(trial.name,'-struct','trial')
        case  'No'
            trial = trial;
            trial.exclude = 1;
            trial.badmovie = 1;
            fprintf('Bad movie: Not setting tangent in trial\n')
            save(trial.name,'-struct','trial')
        case 'Cancel'
            fprintf('Not setting tangent in trial\n')
            return
    end
    response = 'Yes';
elseif strcmp(newbutton,'No')
    fprintf('Saving bar and tangent in trial\n')
        % Do a little transform so I can draw the line either way
    if trial.forceProbe_line(1,1)>trial.forceProbe_line(2,1)
        trial.forceProbe_line = flipud(trial.forceProbe_line);
    end
    response = 'No';
    save(trial.name,'-struct','trial')
    setacqpref('quickshowPrefs','forceProbeTangent',trial.forceProbe_tangent)
    setacqpref('quickshowPrefs','forceProbeLine',trial.forceProbe_line)

elseif strcmp(newbutton,'Cancel')
    fprintf('Not setting tangent in trial\n')
    response = 'Cancel';
    return
end


