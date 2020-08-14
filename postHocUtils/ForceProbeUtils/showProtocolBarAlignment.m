function showProtocolBarAlignment(trial0,varargin)
%%
fprintf('\n\t***** Showing probe alignment for %s trials **** \n',trial0.params.protocol);
[~,~,~,~,~,D,trialStem,datastructfile] = extractRawIdentifiers(trial0.name);
data = load(datastructfile); data = data.data;
% Go through all trials

%%

f = figure;
ax1 = subplot(2,1,1,'parent',f); ax1.NextPlot = 'add';
ax2 = subplot(2,1,2,'parent',f); ax2.NextPlot = 'add';

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

    p_1 = kg.keimograph(:,4); % take the fourth frame, just 'cause
    CoM = trial.forceProbeStuff.CoM(4);

    if any(isnan(p_1))
        continue
    end
    p_1 = p_1 - quantile(p_1,.1);

    [r,lags] = xcorr(trial.forceProbeStuff.Template,p_1,length(trial.forceProbeStuff.EvalPnts_x)/2);
    [r1,x1] = max(r);
    shft = find(lags==0)-x1;
    new_com = CoM-shft;
    new_anchor = new_com;
    %new_anchor = new_com - trial.forceProbeStuff.movedComBy;

    % the template is already in the middle, so just move p_1
    plot(ax1,p_1/max(p_1(:)))
    plot(ax1, CoM*[1 1],[0 1]);

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
plot(ax2,trial.forceProbeStuff.Template,'k','linewidth',2)    
plot(ax2,trial.forceProbeStuff.Anchor*[1 1],[0 1],'c','linewidth',2)    
