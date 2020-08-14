function alignBarForAllProtocolTrials(trial0)

fprintf('\n\t***** Aligning probe for %s trials **** \n',trial0.params.protocol);
[~,~,~,~,~,D,trialStem,datastructfile] = extractRawIdentifiers(trial0.name);
data = load(datastructfile); data = data.data;
% Go through all trials

%% First go through and find where CoM is located on the barprofile

kg = load(regexprep(trial0.name,'Raw','Keimograph'));
im_w = size(kg.keimograph,1);
profiles = nan(length(data),im_w);
CoMs = nan(length(data),1);

for tidx = 1:length(data)
    tnum = data(tidx).trial;
    
    trial = load(fullfile(D,sprintf(trialStem,tnum)));
    if ~isfield(trial,'imageFile')
        continue
    end
    if isfield(trial,'excluded') && trial.excluded
        continue
    end
    if ~isfield(trial,'forceProbeStuff') 
        continue
    end
    fprintf('%s: kg with com added\n',trial.name)
    kg = load(regexprep(trial.name,'Raw','Keimograph'));
    profiles(tidx,:) = kg.keimograph(:,4); % take the fourth frame, just 'cause
    CoMs(tidx) = trial.forceProbeStuff.CoM(4);
end


%% Now go through and align all the kg frames
% Start with one profile, align it to the next and average
% keep going down the line, shifting the profiles.
shfts = nan(size(CoMs));
p_0 = profiles(1,:);
com_0 = CoMs(1,:);
cnt = 1;
while any(isnan(p_0))
    cnt = cnt+1;
    p_0 = profiles(cnt,:);
    com_0 = CoMs(cnt,:);
end

% zero out p_0
p_0 = p_0 - quantile(p_0,.1);
p_1 = p_0;

% reduce by the current number of trials
cnt = 1;

f = figure;
ax = subplot(1,1,1,'parent',f);
p_0_line = plot(ax,p_0,'linewidth',2,'color',[0 0 0]); hold on
p_1_line = plot(ax,p_1);

for tidx = 2:size(profiles,1)
    p_1 = profiles(tidx,:);
    if any(isnan(p_1))
        continue
    end
    p_1 = p_1 - quantile(p_1(1:round(im_w/2)),.1);
    [r,lags] = xcorr(p_0,p_1,im_w/2);
    [r1,x1] = max(r);
    shft = find(lags==0)-x1;
    
    p_0_line.YData = p_0;
    p_1_line.YData = p_1;
    drawnow;
    
    shfts(tidx) = shft;
    % move next profile to the middle
    if abs(CoMs(tidx)-im_w/2) >= abs(com_0-im_w/2)
        if shft >= 0
            % move p_1 left
            p_0(1:end-shft) = p_0(1:end-shft)*cnt + p_1(shft+1:end);
        elseif shft < 0
            % move p_1 right
            shft = -shft;
            p_0(shft+1:end) = p_0(shft+1:end)*cnt + p_1(1:end-shft);
        end
        % keep com the same

    % move previous profile to the middle
    elseif abs(CoMs(tidx)-im_w/2) < abs(com_0-im_w/2)
        if shft < 0
            % move p_0 left
            shft = -shft;
            p_1(1:end-shft) = p_1(1:end-shft) + p_0(shft+1:end)*cnt;
        elseif shft >= 0 
            % move p_0 right
            p_1(shft+1:end) = p_1(shft+1:end) + p_0(1:end-shft)*cnt;
        end       
        % update p_0 and the current com_0
        p_0 = p_1;
        com_0 = CoMs(tidx,:);
    end
    cnt = cnt+1;
    p_0 = p_0/cnt;
    
    p_0 = p_0 - quantile(p_0,.1);
    p_0_line.YData = p_0;
    drawnow;

end

%% Find a single anchor point

p_0 = p_0/max(p_0);
% find com of points greater than 10%
p_0(p_0<.1) = 0;
anchor = (1:im_w)*p_0'/sum(p_0);

%% then difference between the anchor and CoM for each trial
deltas = nan(size(CoMs));

close all
f = figure;
ax = subplot(1,1,1,'parent',f);
p_0_line = plot(ax,p_0,'linewidth',2,'color',[0 0 0]); hold on

p_1 = profiles(1,:);
p_1 = p_1 - quantile(p_1(1:round(im_w/2)),.1);
p_1_line = plot(ax,p_1/max(p_1));
anchorline = plot(anchor * [1 1],[0 1]);
comline = plot(CoMs(1) * [1 1],[0 1]);
diffline = plot(CoMs(1) * [1 1.02],[.5 .5]);
drawnow;

for tidx = 1:size(profiles,1)
    p_1 = profiles(tidx,:);
    if any(isnan(p_1))
        continue
    end
    p_1 = p_1 - quantile(p_1,.1);

    [r,lags] = xcorr(p_0,p_1,im_w/2);
    [r1,x1] = max(r);
    shft = find(lags==0)-x1;
    new_com = CoMs(tidx)-shft;
    deltas(tidx) = new_com-anchor;
    if deltas(tidx)<80
        p_1_line.YData = p_1/max(p_1(:));
        comline.XData =  CoMs(tidx)*[1 1];
        drawnow;
    end
    % the template is already in the middle, so just move p_1
    if shft >= 0 
        % move p_1 left
        p_1(1:end-shft) = p_1(shft+1:end);
        p_1(end-shft+1:end) = 0;
    elseif shft < 0
        % move p_1 right
        shft = -shft;
        p_1(shft+1:end) = p_1(1:end-shft);
        p_1(1:shft) = 0;
    end
    % move current com
    comline.XData = new_com*[1 1];
    diffline.XData = [anchor, anchor + deltas(tidx)];
    p_1_line.YData = p_1/max(p_1(:));
    drawnow;

end
%%
spba(profiles,CoMs,deltas,p_0,anchor)

%% Finally, go back and add the difference to CoM for each trial. 
fprintf('\n\t***** Saving aligned probe for %s trials **** \n',trial0.params.protocol);

for tidx = 1:size(profiles,1)
    delta = deltas(tidx);
    if isnan(delta)
        continue
    end
    tnum = data(tidx).trial;
    trial = load(fullfile(D,sprintf(trialStem,tnum)));
    if ~isfield(trial,'imageFile')
        continue
    end
    if isfield(trial,'excluded') && trial.excluded
        continue
    end

    fprintf('Shifting trial %d CoM by %.1f pixels\n',tnum,delta)
    trial.forceProbeStuff.Template = p_0;
    trial.forceProbeStuff.Anchor = anchor;
    trial.forceProbeStuff.movedComBy = -delta;
    trial.forceProbeStuff.CoM = trial.forceProbeStuff.CoM - delta;
    save(trial.name, '-struct', 'trial');
end

%%
fprintf('Done moving coms for each trial\nTo see how it moved, load the trial and do showProtocolBarAlignment()\n')

function spba(profiles,CoMs,deltas,p_0,anchor)
%%
f = figure;
ax1 = subplot(2,1,1,'parent',f); ax1.NextPlot = 'add';
ax2 = subplot(2,1,2,'parent',f); ax2.NextPlot = 'add';
for tidx = 1:size(profiles,1)
    p_1 = profiles(tidx,:);
    if any(isnan(p_1))
        continue
    end
    p_1 = p_1 - quantile(p_1(1:round(length(p_0)/2)),.1);

    [r,lags] = xcorr(p_0,p_1,length(p_0)/2);
    [r1,x1] = max(r);
    shft = find(lags==0)-x1;
    new_com = CoMs(tidx)-shft;
    new_anchor = new_com - deltas(tidx);
    %deltas(tidx) = new_com-anchor;

    % the template is already in the middle, so just move p_1
    plot(ax1,p_1/max(p_1(:)))
    plot(ax1, CoMs(tidx)*[1 1],[0 1]);

    if shft >= 0 
        % move p_1 left
        p_1(1:end-shft) = p_1(shft+1:end);
        p_1(end-shft+1:end) = 0;
    elseif shft < 0
        % move p_1 right
        shft = -shft;
        p_1(shft+1:end) = p_1(1:end-shft);
        p_1(1:shft) = 0;
    end
    % move current com
    plot(ax2,p_1/max(p_1(:)))
    plot(ax2, new_anchor*[1 1],[0 1]);

    drawnow;

end
plot(ax2,p_0,'k','linewidth',2)    
plot(ax2,anchor*[1 1],[0 1],'c','linewidth',2)    
