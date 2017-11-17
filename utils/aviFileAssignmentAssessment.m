function varargout = aviFileAssignmentAssessment(dfn,varargin)

dfn = regexprep(dfn,'Acquisition','Raw_Data');
[protocol,~,~,~,~,D,trialStem] = extractRawIdentifiers(dfn);
cd(D);

if length(dir(fullfile(D,'archive')))==0
    mkdir(fullfile(D,'archive'));
end
notesFileName = fullfile(D,'archive',['aviFileNotes_' protocol]);
notesFileID = fopen(notesFileName,'w');

rawfiles = dir([D protocol '_Raw_*']);

trial = load([D rawfiles(1).name]);

savedirmat = ls(D)';
savedirconts = savedirmat(:)';

% Find all the matched avis, their trial nums, and their size
pattern = [trial.params.protocol,'_Image_(\d+)_' datestr(trial.timestamp,29) '-(\d+)-\d+.avi'];
matchedavifiles = regexp(savedirconts,pattern,'match');

mavitimestamp = zeros(size(matchedavifiles));
mavitrialnum = zeros(size(matchedavifiles));
mavisize = zeros(size(matchedavifiles));
for im = 1:length(matchedavifiles)
    timestr = regexp(matchedavifiles{im},pattern,'tokens');
    mavitimestamp(im) = datenum([datestr(trial.timestamp,'yyyymmdd') 'T' timestr{1}{2}],'yyyymmddTHHMMSS');
    mavitrialnum(im) = str2double(timestr{1}{1});
    d = dir(fullfile(D,matchedavifiles{im}));
    mavisize(im) = d.bytes;
end

[mavitimestamp,o] = sort(mavitimestamp);
mavitrialnum = mavitrialnum(o);
mavisize = mavisize(o);
matchedavifiles = matchedavifiles(o);

unpattern = [trial.params.protocol,'_Image_' datestr(trial.timestamp,29) '-(\d+)-\d+.avi'];
rawtimestamp = nan(size(rawfiles));
rawtrialnum = nan(size(rawfiles));
rawim = cell(size(rawfiles));
rawim_unmatched = nan(size(rawfiles));
for f = 1:length(rawfiles)
    trial = load([D rawfiles(f).name]);
    
    if isfield(trial,'exposure') && isfield(trial,'imageFile')  
        rawtimestamp(f) = trial.timestamp;
        rawtrialnum(f) = trial.params.trial;
        if exist(regexprep(trial.imageFile,'Acquisition','Raw_Data'),'file')==2
            rawim{f} = regexprep(trial.imageFile,'Acquisition','Raw_Data');
            rawim_unmatched(f) = ~isempty(regexp(rawim{f},unpattern,'once'));
        end
    end
end

rawfiles = rawfiles(~isnan(rawtimestamp));
rawim = rawim(~isnan(rawtimestamp));
rawtrialnum = rawtrialnum(~isnan(rawtimestamp));
rawim_unmatched = rawim_unmatched(~isnan(rawtimestamp));
rawtimestamp = rawtimestamp(~isnan(rawtimestamp));

[rawtimestamp,raw_o] = sort(rawtimestamp);
rawtrialnum = rawtrialnum(raw_o);
rawim = rawim(raw_o);
rawfiles = rawfiles(raw_o);
rawim_unmatched =  rawim_unmatched(raw_o);

if sum(~isnan(rawim_unmatched))~=length(rawim_unmatched)
    warning('Check for empty/unmatched image files')
    keyboard
end

%% it's possible that the images are matched
% But the name was not changed to the new trial, rather it keeps just the
% timestep. This is the new way, better. Test for this and run the old
% assessment if this is not the case.

if ~isempty(matchedavifiles) && ~sum(isnan(rawim_unmatched))
    aviFileAssignmentAssessment_1(dfn,varargin);
    return
end

%% Just go through and match files first, then deal with the rest

fprintf(' - Renaming image files that have been matched already \n')
fprintf(notesFileID,' - Renaming image files that have been matched already \n');
for f = 1:length(rawfiles)
    trial = load([D rawfiles(f).name]);

    if isempty(trial.imageFile)
        fprintf('Trial %d imagFile field is empty. Misplaced? %s\n', trial.params.trial, datestr(trial.timestamp,29))
        fprintf(notesFileID,'Trial %d imagFile field is empty. Misplaced? %s\n', trial.params.trial, datestr(trial.timestamp,29));
        trial.exclude = 1;
        trial.badmovie = 1;
        save(trial.name, '-struct', 'trial');
        continue
    end
    if ~strcmp(rawim{f},trial.imageFile); error('WTF!!'); end

    oldname = rawim{f};
    ext = regexp(oldname,'-(\d+)-\d+.avi','match');
    newname = [trial.params.protocol '_Image_' num2str(trial.params.trial) '_' datestr(trial.timestamp,29) ext{1}];
    
    trial.imageFile = newname;

    [success,m,~] = movefile(fullfile(D,oldname),fullfile(D,newname));
    if ~success
        warning('Unable to rename file %s', oldname);
    end
    save(trial.name, '-struct', 'trial');

end

%%

savedirmat = ls(D)';
savedirconts = savedirmat(:)';

% Find all the unmatched avis
unpattern = [trial.params.protocol,'_Image_' datestr(trial.timestamp,29) '-(\d+)-\d+.avi'];
unmatchedavifiles = regexp(savedirconts,unpattern,'match');

umavitimestamp = zeros(size(unmatchedavifiles));
umavisize = zeros(size(umavitimestamp));
for im = 1:length(unmatchedavifiles)
    timestr = regexp(unmatchedavifiles{im},unpattern,'tokens');
    umavitimestamp(im) = datenum([datestr(trial.timestamp,'yyyymmdd') 'T' timestr{1}{1}],'yyyymmddTHHMMSS');
    d = dir(fullfile(D,unmatchedavifiles{im}));
    umavisize(im) = d.bytes;
end
umavitrialnum = nan(size(umavitimestamp));

for untr_idx = 1:length(umavitimestamp)
    timestr = regexp(unmatchedavifiles{untr_idx},unpattern,'tokens');
    fprintf('Unmatched: Avi at %s - %s\n',timestr{1}{1},unmatchedavifiles{untr_idx});
    fprintf(notesFileID,'Unmatched: Avi at %s - %s\n',datestr(trial.timestamp,29),unmatchedavifiles{untr_idx});
    if umavisize(untr_idx)>2000
        oldname = unmatchedavifiles{untr_idx};
        
        [success,m,~] = movefile(fullfile(D,oldname),fullfile(D,'archive',oldname));
        if success
            fprintf('Moved unmatched Avi %s\n',unmatchedavifiles{untr_idx});
            fprintf(notesFileID,'Moved unmatched Avi %s\n',unmatchedavifiles{untr_idx});
        end
    elseif umavisize(untr_idx)<2000
        oldname = unmatchedavifiles{untr_idx};
        delete(fullfile(D,oldname));     
        fprintf('Deleted tiny Avi %s\n',unmatchedavifiles{untr_idx});
        fprintf(notesFileID,'Deleted tiny Avi %s\n',unmatchedavifiles{untr_idx});
    end
end
    
