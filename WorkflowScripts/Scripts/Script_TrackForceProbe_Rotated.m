%% The "_Rotated" script assumes that the probes are oriented in a straight line down the image. 
% This is done by rotating the camera. This allows us to skip the step of
% remapping the images, and instead just averaging down the image. Every
% thing else should remain the same.

%% run through all the movies. Decide if there is a probe or not
% Assuming you're in the right folder

movies = dir('*.avi');

%% Find the force probe
% 
figure
ax_mball = subplot(1,1,1); hold(ax_mball,'on');

for m_idx = 1:length(movies)
    m = movies(m_idx).name;
    
    trnm = regexprep(m,{'Image','_\d+T\d+.avi'},{'Raw','.mat'});
    trial = load(trnm);
    if ~strcmp(trial.imageFile,m)
        warning(['Movie ' m ' has an unidentified trial']);
        continue
    end 
    
end


%% Assume a common vertical line
frcprbline = [536    0
  536  890];

% Just take the top 256 points, or the maximum along the y direction. This
% distinction will be made in probTrackVertical_2Bumps
tngntpnt = [536 256];

%% Calculate a common tangent point

showtrial = trial;
showtrial.forceProbe_line = frcprbline;
showtrial.forceProbe_tangent = tngntpnt;

showProbeImage(showtrial);
% showProbeLocation(showtrial)

dispax = gca;
[l,p,l_r,R,p_,p_scalar,barbar] = probeCoordinates(showtrial);

line(showtrial.forceProbe_line(:,1),showtrial.forceProbe_line(:,2),'parent',dispax,'color',[1 0 0]);
line(showtrial.forceProbe_tangent(:,1),showtrial.forceProbe_tangent(:,2),'parent',dispax,'marker','o','markeredgecolor',[0 1 0],'tag','oldpoint');
line(l_r(:,1),l_r(:,2),'parent',dispax,'color',[1 .3 .3]);
line(p_(1),p_(2),'parent',dispax,'marker','o','markeredgecolor',[0 1 1]);


%% Process of checking that corner is not overshot is obsolete


%% Run through the movies and add the line and tangent
% run through all the movies. Decide if there is a probe or not
REWRITE = 1;
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
            %probeTrackVertical_1Bump
            probeTrackVertical_2Bumps
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

% [fid,message] = fopen('ProbeTrackLog.txt','w');
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

