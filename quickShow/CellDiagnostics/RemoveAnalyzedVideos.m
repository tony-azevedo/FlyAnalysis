%% function to empty folders of videos.
% Once videos are analysed, either for the leg kinematics or for probe
% position, they can be deleted from B\:. QuickShow can then take you to
% the actual location, regardless of where they may be, but alerts you that
% the movie is in a different folder.
function varargout = RemoveAnalyzedVideos(trial,varargin)

newbutton = questdlg('Are you sure you want to remove videos?','Remove Videos','No');
if ~strcmp(newbutton,'Yes')
    varargout = {};
    return
end
newbutton = questdlg('Have you double checked that the videos are backed up in Raw_Data_E?','Remove Videos','No');
if ~strcmp(newbutton,'Yes')
    varargout = {};
    return
end
newbutton = questdlg('Have you corrected for the Red LED transient?','Remove Videos','No');
if ~strcmp(newbutton,'Yes')
    varargout = {};
    return
end

% check if the trial has a video file
Dir = trial.name(1:regexp(trial.name,trial.params.protocol)-1);
E = regexprep(Dir,{'B:','Raw_Data'},{'E:','tony\\Raw_Data_E'});

rawfiles = dir([Dir '*_Raw_*.mat']);
hasimagefile = false(1,length(rawfiles));
imagefileisonB = false(1,length(rawfiles));
imagefileisonE = false(1,length(rawfiles));
warning('off','MATLAB:load:variableNotFound')
for r_ind = 1:length(rawfiles)
    imagefilename = load(fullfile(Dir,rawfiles(r_ind).name),'imageFile');
    if length(fieldnames(imagefilename))
        imageFile = imagefilename.imageFile;
        hasimagefile(r_ind) = 1;
        imagefileisonB(r_ind) = exist(fullfile(Dir,imageFile),'file')==2;
        imagefileisonE(r_ind) = exist(fullfile(E,imageFile),'file')==2;
    end
end
warning('on','MATLAB:load:variableNotFound')

% now we know all the videos that are on B that are not on E
% Have to make sure that any videos that are on B are on E
if any(imagefileisonB~=imagefileisonE & imagefileisonB)
    rawfiles = rawfiles(imagefileisonB~=imagefileisonE & imagefileisonB);
    fprintf(1,'Stop! The following movies are on B, but not E:\n');
    for r_ind = 1:length(rawfiles)
        fprintf(1,[rawfiles(r_ind).name '\n']);
    end
    varargout = {};
    return
end

% now, if the same trial has a probe location, we maybe can move the
% file
rawfiles = rawfiles(imagefileisonB);

trialhasprobestuff = false(1,length(rawfiles));
excludedtrial = false(1,length(rawfiles));
notlookedat = false(1,length(rawfiles));
warning('off','MATLAB:load:variableNotFound')
for r_ind = 1:length(rawfiles)
    fprbStuff = load(fullfile(Dir,rawfiles(r_ind).name),'forceProbeStuff');
    if length(fieldnames(fprbStuff))
        trialhasprobestuff(r_ind) = 1;
    end
    excluded = load(fullfile(Dir,rawfiles(r_ind).name),'excluded');
    if ~length(fieldnames(excluded))
        notlookedat(r_ind) = 1;
    else
        excludedtrial(r_ind) = excluded.excluded;
    end
    
end
warning('on','MATLAB:load:variableNotFound')

% We also know trials that have not been looked at. Alert to those
if any(notlookedat)
    rawfiles = rawfiles(notlookedat);
    fprintf(1,'Stop! The following trials are neither in- nor excluded, are they interesting?:\n');
    for r_ind = 1:length(rawfiles)
        fprintf(1,[rawfiles(r_ind).name '\n']);
    end
    varargout = {};
    return
end

% Finally, we'll get rig or any videos for trials that have been
% excluded or already have a probe video.

% First, we'll just list the ones that are remaining, maybe because
% they were uninteresting in the first place, or haven't yet been
% analysed, or because they don't involve a probe, etc
if any(~excludedtrial & ~trialhasprobestuff)
    remainingfiles = rawfiles(~excludedtrial & ~trialhasprobestuff);
    fprintf(1,'The following movies will remain here:\n');
    for r_ind = 1:length(remainingfiles)
        fprintf(1,[remainingfiles(r_ind).name '\n']);
    end
    fprintf(1,'\n');
end

% Finally, remove the rest of the movies. But before you do that, just
% double check again.
newbutton = questdlg('Once last chance to cancel. Remove backedup videos?','Remove Videos','No');
if ~strcmp(newbutton,'Yes')
    varargout = {};
    return
end


removingfiles = rawfiles(excludedtrial | trialhasprobestuff);
fprintf(1,'Removing files:\n');
for r_ind = 1:length(removingfiles)
    imagefilename = load(fullfile(Dir,removingfiles(r_ind).name),'imageFile'); 
    imagefile = imagefilename.imageFile;
    fprintf(1,[imagefile '\n']);
    delete(fullfile(Dir,imagefile));
end


