%% run through all the movies. Decide if there is a probe or not
% Assuming you're in the right folder
movies = dir('*.avi');

%% Find the force probe
figure
ax_mball = subplot(1,1,1); hold(ax_mball,'on');

mb_all = nan(length(movies),2);
tngnt_all = nan(length(movies),2);
hasBar = false(length(movies),1);
frcprbline = [];
for m_idx = 1:length(movies)
    m = movies(m_idx).name;
    
    trnm = regexprep(m,{'Image','_\d+T\d+.avi'},{'Raw','.mat'});
    trial = load(trnm);
    if ~strcmp(trial.imageFile,m)
        warning(['Movie ' m ' has an unidentified trial']);
        continue
    end 
    
    if m_idx <= 3
        [trial,mb,tngntpnt] = findForceProbe(trial,'PLOT',true);
    else
        [trial,mb,tngntpnt] = findForceProbe(trial);
    end
    % tangent point is reversed for now
    
    if ~isempty(mb)
        mb_all(m_idx,:) = mb;
        tngnt_all(m_idx,:) = tngntpnt;
        hasBar(m_idx) = true;
        plot(ax_mball,[0 10],mb(1)*([0 10])+mb(2))
        if isempty(frcprbline)
            frcprbline = trial.forceProbe_line;
        end
    else
        mb = 0;
        tngntpnt = 0;
    end
    
    if sum(~isnan(mb_all(:,1)))>12 && (nanstd(mb_all(:,1))/sqrt(sum(~isnan(mb_all(:,1)))))/nanmean(mb_all(:,1)) < .01
        break
    end
    fprintf('error: %g\n',(nanstd(mb_all(:,1))/sqrt(sum(~isnan(mb_all(:,1)))))/nanmean(mb_all(:,1)))
end
mb_all = mb_all(~isnan(mb_all(:,1)),:);
tngnt_all = tngnt_all(~isnan(tngnt_all(:,1)),:);
% Reverse tangent point
tngnt_all = fliplr(tngnt_all);

close all

%% calculate a common line
mb_line = mean(mb_all,1);

frcprbline(:,2) = mb_line(1)*frcprbline(:,1) + mb_line(2);
if frcprbline(1,2)<1
    frcprbline(1,2) = 1;
    frcprbline(1,1) = (frcprbline(1,2)-mb_line(2))/mb_line(1);
end

%% Calculate a common tangent point
tngntpnt = mean(tngnt_all,1);

showtrial = trial;
showtrial.forceProbe_line = frcprbline;
% showtrial.forceProbe_tangent = tngntpnt;

showProbeImage(showtrial);
% showProbeLocation(trial)

dispax = gca;
[l,p,l_r,R,p_,p_scalar,barbar] = probeCoordinates(trial);

line(showtrial.forceProbe_line(:,1),showtrial.forceProbe_line(:,2),'parent',dispax,'color',[1 0 0]);
line(showtrial.forceProbe_tangent(:,1),showtrial.forceProbe_tangent(:,2),'parent',dispax,'marker','o','markeredgecolor',[0 1 0],'tag','oldpoint');
line(l_r(:,1),l_r(:,2),'parent',dispax,'color',[1 .3 .3]);
line(p_(1),p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 1 1]);

p_crn_ur = [1280 0];
line(p_crn_ur(1),p_crn_ur(2),'parent',dispax,'marker','o','markeredgecolor',[.3 .6 1]);

p_crn_0 = p_crn_ur - mean(l,1);

p_crn_scalar_ur = barbar*p_crn_0';

p_crn_ = p_crn_scalar_ur*barbar+mean(l,1);

l_r_crn = [p_crn_; p_crn_ur];

line(p_crn_(1),p_crn_(2),'parent',dispax,'marker','o','markeredgecolor',[.3 .3 .3]);
line(l_r_crn(:,1),l_r_crn(:,2),'parent',dispax,'color',[.3 .3 .3]);
    
% Check that the end of the line doesn't cut off the other corner.

% find the corner projection onto y
p_crn_ll = [0 1024];
line(p_crn_ll(1),p_crn_ll(2),'parent',dispax,'marker','o','markeredgecolor',[.3 .6 1]);

p_crn_0 = p_crn_ll - mean(l,1);

p_crn_scalar_ll = barbar*p_crn_0';

p_crn_ = p_crn_scalar_ll*barbar+mean(l,1);

l_r_crn = [p_crn_; p_crn_ll];

line(p_crn_(1),p_crn_(2),'parent',dispax,'marker','o','markeredgecolor',[.3 .3 .3]);
line(l_r_crn(:,1),l_r_crn(:,2),'parent',dispax,'color',[.3 .3 .3]);

if p_scalar>p_crn_scalar_ll || p_scalar> p_crn_scalar_ur
    p_scalar = min([p_crn_scalar_ur, p_crn_scalar_ll]) - 10;

    tngntpnt = p_scalar*barbar+mean(l,1);
    l_r = l_r - repmat(mean(l_r,1),2,1) + repmat(tngntpnt,2,1);

    line(tngntpnt(1),tngntpnt(2),'parent',dispax,'marker','o','markeredgecolor',[1 .5 1]);
    line(l_r(:,1),l_r(:,2),'parent',dispax,'color',[.7 0 .3],'linewidth',3);

end


%% Or just use the good old probetrack line
movies = dir('*.avi');

for m_idx = 1:length(movies)
    m = movies(m_idx).name;
    
    trnm = regexprep(m,{'Image','_\d+T\d+.avi'},{'Raw','.mat'});
    trial = load(trnm);
    if ~strcmp(trial.imageFile,m)
        warning(['Movie ' m ' has an unidentified trial']);
        continue
    end 

    if m_idx <= 3
        [trial,response] = probeLineROI(trial);
        if strcmp(response,'Cancel')
            break
        end
        temp.forceProbe_line = trial.forceProbe_line;
        temp.forceProbe_tangent = trial.forceProbe_tangent;
    else        
        trial.forceProbe_line = temp.forceProbe_line;
        trial.forceProbe_tangent = temp.forceProbe_tangent;
        %         adjustProbeLineROI(trial);
        fprintf('Saving bar and tangent in trial %s\n',num2str(trial.params.trial))
        save(trial.name,'-struct','trial')
    end
    % temp.forceProbe_line = getacqpref('quickshowPrefs','forceProbeLine');
    % temp.forceProbe_tangent = getacqpref('quickshowPrefs','forceProbeTangent');
end


%% Now go back through and correct line and tangent
% run through all the movies. Decide if there is a probe or not
REWRITE = 0;
fprintf('Saving probes, if needed\n');
wt = 0;
for m_idx = 1:length(movies)
    m = movies(m_idx).name;    
    
    trnm = regexprep(m,{'Image','_\d+T\d+.avi'},{'Raw','.mat'});
    trial = load(trnm);
    if REWRITE || ...
            ~isfield(trial ,'forceProbe_line') || ...
            ~isfield(trial,'forceProbe_tangent')
        
        trial.forceProbe_tangent = tngntpnt;
        trial.forceProbe_line = frcprbline;
        fprintf('Saving common probe: %s - %d\n',trial.params.protocol,trial.params.trial);
        
        save(trial.name, '-struct', 'trial');
    else
        wt = wt+1;
    end

    if wt>10
        fprintf('Already saved\n');
        break
    end
end


%% The line and tangent are set, Now run the tracking

close all
movies = dir('*.avi');

br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

[fid,message] = fopen('ProbeTrackLog.txt','w');
fprintf(fid,'Tracking errors: %s\n',pwd);

for m_idx = 1:length(movies)
    m = movies(m_idx).name;    
    
    trnm = regexprep(m,{'Image','_\d+T\d+.avi'},{'Raw','.mat'});
    trial = load(trnm);
        
    waitbar((m_idx)/length(movies),br,sprintf('%s - %d\n',trial.params.protocol,trial.params.trial));
    if ...
            isfield(trial ,'forceProbe_line') && ...
            isfield(trial,'forceProbe_tangent') && ...
            (~isfield(trial,'excluded') || ~trial.excluded) ...&& ...
            %~isfield(trial,'forceProbeStuff')
        
        fprintf('Track probe: %s - %d\n',trial.params.protocol,trial.params.trial);
        try 
            probeTrackROI_2Bumps;
            % probeTrackROI_IR;
        catch e
            % rethrow(e);
            fprintf(fid,'Probe track failed: %s - %d (%s)\n',trial.params.protocol,trial.params.trial,e.message);
            fprintf('Probe track failed: %s - %d (%s)\n',trial.params.protocol,trial.params.trial,e.message);
            continue
        end
    elseif isfield(trial,'forceProbeStuff')
            fprintf('%s\n',trial.name);
            fprintf('\t*Has profile: passing over trial for now\n')
            
            % OR...
            % fprintf('\t*Has profile: redoing\n')
            % probeTrackROI_IR;

    else
        fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
        continue
    end
end
    
fclose(fid);
delete(br);

%% One more thing on the two bumps:
% the indices can switch some times, so just run through all the traces,
% find the big jumps and swtich them

close all
movies = dir('*.avi');

br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

[fid,message] = fopen('ProbeTrackLog.txt','w');
fprintf(fid,'Tracking errors: %s\n',pwd);

for m_idx = 1:length(movies)
    m = movies(m_idx).name;    
    
    trnm = regexprep(m,{'Image','_\d+T\d+.avi'},{'Raw','.mat'});
    trial = load(trnm);
        
    if isfield(trial,'forceProbeStuff')
        fprintf('%s\n',trial.name);
        
        CoM = trial.forceProbeStuff.CoM;
        % how big are changes, usually?
        DCoM1 = diff(CoM(1,:));
        DCoM2 = diff(CoM(2,:));

        wps = find(abs(DCoM1)>100); % likely a jump
        while ~isempty(wps)
            for i = 1:length(wps)
                if abs(CoM(2,wps(i)+1)-CoM(1,wps(i))) < 100 && abs(CoM(1,wps(i)+1)-CoM(2,wps(i))) < 100 % they should be switched
                    %switch em
                    temp = CoM(1,wps(i)+1);
                    CoM(1,wps(i)+1) = CoM(2,wps(i)+1);
                    CoM(2,wps(i)+1) = temp;
                    
                end
            end
            DCoM1 = diff(CoM(1,:));
            DCoM2 = diff(CoM(2,:));
            wps = find(abs(DCoM1)>100); % likely a jump
        end
                    
        trial.forceProbeStuff.CoM = CoM;
        save(trial.name,'-struct','trial');
            
    else
        fprintf('\t* Bad movie: No line or tangent: %s\n',trial.name);
        continue
    end
end
    
% fclose(fid);
delete(br);

