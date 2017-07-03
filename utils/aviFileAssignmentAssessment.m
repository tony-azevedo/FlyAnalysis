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

% Find all the unmatched avis
pattern = [trial.params.protocol,'_Image_' datestr(trial.timestamp,29) '-(\d+)-\d+.avi'];
unmatchedavifiles = regexp(savedirconts,pattern,'match');

umavitimestamp = zeros(size(unmatchedavifiles));
umavisize = zeros(size(umavitimestamp));
for im = 1:length(unmatchedavifiles)
    timestr = regexp(unmatchedavifiles{im},pattern,'tokens');
    umavitimestamp(im) = datenum([datestr(trial.timestamp,'yyyymmdd') 'T' timestr{1}{1}],'yyyymmddTHHMMSS');
    d = dir(fullfile(D,unmatchedavifiles{im}));
    umavisize(im) = d.bytes;
end
umavitrialnum = nan(size(umavitimestamp));

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

weird_mavis = abs(mavisize-median([umavisize mavisize]))/std([umavisize mavisize]) > 2;
weird_umavis = abs(umavisize-median([umavisize mavisize]))/std([umavisize mavisize]) > 2;

rawtimestamp = zeros(size(rawfiles));
rawtrialnum = zeros(size(rawfiles));
rawim = cell(size(rawfiles));
for f = 1:length(rawfiles)
    trial = load([D rawfiles(f).name]);
    
    rawtimestamp(f) = trial.timestamp;
    rawtrialnum(f) = trial.params.trial;
    if isfield(trial,'exposure') && isfield(trial,'imageFile')  && exist(regexprep(trial.imageFile,'Acquisition','Raw_Data'),'file')==2
        rawim{f} = regexprep(trial.imageFile,'Acquisition','Raw_Data');
    end
end

[rawtimestamp,raw_o] = sort(rawtimestamp);
rawtrialnum = rawtrialnum(raw_o);
rawim = rawim(raw_o);
rawfiles = rawfiles(raw_o);

% now find the optimal ordering,

umavi = 3*ones(size(umavitimestamp));
mavi = 2*ones(size(mavitimestamp));
raw = 1*ones(size(rawtimestamp));

% the optimal ordering is this:
% files with sizes <1KB are unmatched
% raw trials are matched to the avi with timestamp < raw timestamp but
% > the raw timestamp of the previous trial
% if the trial with a

% check whether the current ordering of the files is correct

all_timstamps = [rawtimestamp(:);mavitimestamp(:);umavitimestamp(:)];
all_groupnums = [raw(:);mavi(:);umavi(:)];
all_trialnums = [rawtrialnum(:);mavitrialnum(:);umavitrialnum(:)];

[all_timstamps,o] = sort(all_timstamps);
all_groupnums = all_groupnums(o);
all_trialnums = all_trialnums(o);

figure(101);clf; 
plot(rawtimestamp,rawtrialnum,'.')
hold on
plot(mavitimestamp,mavitrialnum,'.')
plot([umavitimestamp;umavitimestamp],repmat([1; rawtrialnum(end)],size(umavitrialnum)),'g')


%% Go through and find matched avi nums that are out of order, unmatch them

fprintf(notesFileID,'\n*********\nAre matched AVIs out of order?\n');
fprintf('\n*********\nAre matched AVIs out of order?\n');
oofo = find(diff(mavitrialnum)<0);
for i = 1:length(oofo)
    idx = oofo(i);
    tidx = [find(rawtimestamp < mavitimestamp(idx),1,'last') find(rawtimestamp > mavitimestamp(idx),1)];
    fprintf('\tAvi %d with time %s belongs between \n\t\ttrial %d with time %s and\n\t\ttrial %d with time %s\n',...
        mavitrialnum(idx),datestr(mavitimestamp(idx),13),...
        rawtrialnum(tidx(1)),datestr(rawtimestamp(tidx(1)),13),...
        rawtrialnum(tidx(2)),datestr(rawtimestamp(tidx(2)),13))
    fprintf(notesFileID,'\tAvi %d with time %s belongs between \n\t\ttrial %d with time %s and\n\t\ttrial %d with time %s\n',...
        mavitrialnum(idx),datestr(mavitimestamp(idx),13),...
        rawtrialnum(tidx(1)),datestr(rawtimestamp(tidx(1)),13),...
        rawtrialnum(tidx(2)),datestr(rawtimestamp(tidx(2)),13));
        
    if sum(mavitimestamp > rawtimestamp(tidx(1)) & mavitimestamp < rawtimestamp(tidx(2)))==1
        fprintf('\tNo other avi in same gap.\n\tAvi %s should be unmatched from trial %d\n\tand matched to trial %d\n',...
            datestr(mavitimestamp(idx),13),mavitrialnum(idx),rawtrialnum(tidx(2)))
        fprintf('\n\tRun the commands: unmatch\ntrial = load(''%s'')\ntrial.imageFile = '''';\nsave(regexprep(trial.name,''Acquisition'',''Raw_Data''), ''-struct'', ''trial'');\n',...
            sprintf(trialStem,mavitrialnum(idx)));
        fprintf('\n\tRun the commands: match\ntrial = load(''%s'')\ntrial.imageFile = ''%s'';\ntrial.imageMatch  = ''matched avis were out of order''\nsave(regexprep(trial.name,''Acquisition'',''Raw_Data''), ''-struct'', ''trial'');\n',...
            sprintf(trialStem,rawtrialnum(tidx(2))), regexprep(rawim{mavitrialnum(idx)},num2str(mavitrialnum(idx)),num2str(rawtrialnum(tidx(2)))));
        fprintf('\n\tRename the avi %d to %d: %s\n',...
            mavitrialnum(idx),rawtrialnum(tidx(2)),regexprep(rawim{mavitrialnum(idx)},num2str(mavitrialnum(idx)),num2str(rawtrialnum(tidx(2)))));
    %regexprep(rawim{mavitrialnum(idx)},num2str(mavitrialnum(idx)),num2str(rawtrialnum(tidx(2)))));
    elseif sum(mavitimestamp > rawtimestamp(tidx(1)) & mavitimestamp < rawtimestamp(tidx(2)))>1
        fprintf('\tAnother avi in same gap. Avi %s should be unmatched from %d\n',...
            datestr(mavitimestamp(idx),13),mavitrialnum(idx))
        fprintf(notesFileID, '\tAnother avi in same gap. Avi %s should be unmatched from %d\n',...
            datestr(mavitimestamp(idx),13),mavitrialnum(idx));
    end
    
    % Quit out, cause this needs to be handled
    fclose(notesFileID);
    error('Handle this case!')
end
fprintf(notesFileID,'\nAre matched AVIs are in order\n*********\n');
fprintf('\nAre matched AVIs are in order\n*********\n');

%% Go through unmatched avis and ask whether they should obviously be matched

fprintf('\n*********\nCan unmatched AVIs be matched?\n');
fprintf(notesFileID, '\n*********\nCan unmatched AVIs be matched?\n');

idx_l = true(size(umavitimestamp));
for idx = 1:length(umavitimestamp)
    tidx = [find(rawtimestamp < umavitimestamp(idx),1,'last') find(rawtimestamp > umavitimestamp(idx),1)];
    if numel(tidx)==1 && tidx(1)==1
        tidx = [0 1];
    end
    if numel(tidx)~=2
        keyboard
        fprintf('\tUnmatched AVI at %s recorded after raw file %d\n',datestr(umavitimestamp(idx),13),tidx(1));
        fprintf(notesFileID,'\tUnmatched AVI at %s recorded after raw file %d\n',datestr(umavitimestamp(idx),13),tidx(1));
        fprintf('\tArchiving AVI %s\n',unmatchedavifiles{idx});
        fprintf(notesFileID,'\tArchiving AVI %s\n',unmatchedavifiles{idx});
        [success,m,~] = movefile(fullfile(D,unmatchedavifiles{idx}),fullfile(D,'archive',unmatchedavifiles{idx}));
        idx_l(idx) = false;
        
        continue
    end
    trial = load(sprintf(trialStem,rawtrialnum(tidx(2))));
    if any(mavitrialnum==tidx(2)) && exist(regexprep(trial.imageFile,'Acquisition','Raw_Data'),'file')==2 && ~weird_umavis(idx)
        fprintf('\tUnmatched AVI at %s belongs to file %d that already has matched avi, coming back to this\n',datestr(umavitimestamp(idx),13),tidx(2));
        fprintf(notesFileID,'\tUnmatched AVI at %s belongs to file %d that already has matched avi, coming back to this\n',datestr(umavitimestamp(idx),13),tidx(2));
        continue
    elseif (~any(mavitrialnum==tidx(2)) || ~isfield(trial,'imageFile')) && ~weird_umavis(idx)
        fprintf('\tMatching Unmatched AVI at %s to raw file %d\n',datestr(umavitimestamp(idx),13),tidx(2));
        fprintf(notesFileID,'\tMatching Unmatched AVI at %s to raw file %d\n',datestr(umavitimestamp(idx),13),tidx(2));
                
        oldname = unmatchedavifiles{idx};
        ext = regexp(oldname,'-(\d+)-\d+.avi','match');
        newname = [protocol '_Image_' num2str(tidx(2)) '_' datestr(trial.timestamp,29) ext{1}];
        newname = fullfile(D,newname);

        trial.imageFile = newname;
        trial.imageMatch = 'previously unmatched';
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');

        [success,m,~] = movefile(fullfile(D,oldname),newname);
        idx_l(idx) = false;
    elseif weird_umavis(idx)
        fprintf('\tUnmatched AVI at %s is weird\n',datestr(umavitimestamp(idx),13));
        fprintf(notesFileID,'\tUnmatched AVI at %s is weird\n',datestr(umavitimestamp(idx),13));
    end
end

unmatchedavifiles = unmatchedavifiles(idx_l);
umavitrialnum = umavitrialnum(idx_l);
umavitimestamp = umavitimestamp(idx_l);
umavisize = umavisize(idx_l);
weird_umavis = weird_umavis(idx_l);
fprintf('\nUnmatched AVIs are matched\n*********\n');
fprintf(notesFileID,'\nUnmatched AVIs are matched\n*********\n');

%% Go through the remaining unmatched AVIs and ask whether they should be matched instead.
fprintf('\n*********\nTrading unmatched AVIs with weird matched AVIs?\n');
fprintf(notesFileID,'\n*********\nTrading unmatched AVIs with weird matched AVIs?\n');

idx_l = true(size(umavitimestamp));
for idx = 1:length(umavitimestamp)
    tidx = [find(rawtimestamp < umavitimestamp(idx),1,'last') find(rawtimestamp > umavitimestamp(idx),1)];
    if numel(tidx)==1 && tidx(1)==1
        tidx = [0 1];
    end
    trial = load(sprintf(trialStem,rawtrialnum(tidx(2))));
    
    if any(mavitrialnum==tidx(2)) && exist(regexprep(trial.imageFile,'Acquisition','Raw_Data'),'file')==2 && ~weird_umavis(idx) && weird_mavis(mavitrialnum==tidx(2))
        oldname = unmatchedavifiles{idx};
        ext = regexp(oldname,'-(\d+)-\d+.avi','match');
        newname = [protocol '_Image_' num2str(tidx(2)) '_' datestr(trial.timestamp,29) ext{1}];

        fprintf('\tUnmatched AVI at %s is normal, but matched avi %d at %s is weird (size %d KB)\n\t\tMoving weird avi to %s\n\t\tMoving good avi to %s\n',...
            datestr(umavitimestamp(idx),13),...
            tidx(2),...
            datestr(mavitimestamp(mavitrialnum==tidx(2)),13),...
            mavisize(mavitrialnum==tidx(2)),...
            datestr(mavitimestamp(mavitrialnum==tidx(2)),13),... 
            newname)
        fprintf(notesFileID,'\tUnmatched AVI at %s is normal, but matched avi %d at %s is weird (size %d KB)\n\t\tMoving weird avi to %s\n\t\tMoving good avi to %s\n',...
            datestr(umavitimestamp(idx),13),...
            tidx(2),...
            datestr(mavitimestamp(mavitrialnum==tidx(2)),13),...
            mavisize(mavitrialnum==tidx(2)),...
            datestr(mavitimestamp(mavitrialnum==tidx(2)),13),... 
            newname);

        newname = fullfile(D,newname);
        trial.imageFile = newname;
        trial.imageMatch = 'switched out weird/short avi files for a normal one';
        save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
        
        weirdavi_name = matchedavifiles{mavitrialnum==tidx(2)};
        weirdavi_newname = regexprep(weirdavi_name,'Image_(\d+)_','Image_');
        weirdavi_newname = fullfile(D,'archive',weirdavi_newname);

        [success,m,~] = movefile(fullfile(D,oldname),newname);
        [success,m,~] = movefile(fullfile(D,weirdavi_name),weirdavi_newname);

        weird_mavis(mavitrialnum==tidx(2)) = 0;
        idx_l(idx) = false;
    end
end

unmatchedavifiles = unmatchedavifiles(idx_l);
umavitrialnum = umavitrialnum(idx_l);
umavitimestamp = umavitimestamp(idx_l);
umavisize = umavisize(idx_l);
weird_umavis = weird_umavis(idx_l);

fprintf('\nWeird AVIs are traded out\n*********\n');
fprintf(notesFileID,'\nWeird AVIs are traded out\n*********\n');

%% Finally, go through the final unmatched videos and move to archive

fprintf('\n*********\nMoving leftover unmatched AVIs\n');
fprintf(notesFileID,'\n*********\nMoving leftover unmatched AVIs\n');

idx_l = true(size(umavitimestamp));
for idx = 1:length(umavitimestamp)
    tidx = [find(rawtimestamp < umavitimestamp(idx),1,'last') find(rawtimestamp > umavitimestamp(idx),1)];
    if numel(tidx)==1 && tidx(1)==1
        tidx = [0 1];
    end
    trial = load(sprintf(trialStem,rawtrialnum(tidx(2))));
    if weird_umavis(idx)
        fprintf('\tArchiving weird AVI (size %d KB) %s\n',umavisize(idx),unmatchedavifiles{idx})
        fprintf(notesFileID,'\tArchiving weird AVI (size %d KB) %s\n',umavisize(idx),unmatchedavifiles{idx});
        [success,m,~] = movefile(fullfile(D,unmatchedavifiles{idx}),fullfile(D,'archive',unmatchedavifiles{idx}));
        idx_l(idx) = false;
    else
        fprintf('\tArchiving NORMAL BUT UNMATCHED AVI %s\n',unmatchedavifiles{idx})
        fprintf(notesFileID,'\tArchiving NORMAL BUT UNMATCHED AVI %s\n',unmatchedavifiles{idx});
        [success,m,~] = movefile(fullfile(D,unmatchedavifiles{idx}),fullfile(D,'archive',unmatchedavifiles{idx}));
        idx_l(idx) = false;
    end
end

unmatchedavifiles = unmatchedavifiles(idx_l);
umavitrialnum = umavitrialnum(idx_l);
umavitimestamp = umavitimestamp(idx_l);
umavisize = umavisize(idx_l);
weird_umavis = weird_umavis(idx_l);

fprintf('\n\nWeird AVIs are archived\n*********\n');
fprintf(notesFileID,'\n\nWeird AVIs are archived\n*********\n');

%% Report which matched avis are still weird.
fprintf('\n*********\nWeird matched AVIs\n');
fprintf(notesFileID,'\n*********\nWeird matched AVIs\n');

for idx = find(weird_mavis)
    fprintf('\tMatched AVI %d at %s is weird (size %d KB)\n',...
        mavitrialnum(idx),...
        datestr(mavitimestamp(idx),13),...
        mavisize(idx))
    fprintf(notesFileID,'\tMatched AVI %d at %s is weird (size %d KB)\n',...
        mavitrialnum(idx),...
        datestr(mavitimestamp(idx),13),...
        mavisize(idx));
end
fprintf('\nWeird matched AVIs stay in the folder\n*********\n');
fprintf(notesFileID,'\nWeird matched AVIs stay in the folder\n*********\n');

%% Finally, go through raw files and report which are unmatched
fprintf('\n*********\nUnmatched Raw files AVIs\n');
fprintf(notesFileID,'\n*********\nUnmatched Raw files AVIs\n');

rawfiles = dir([D protocol '_Raw_*']);
rawfiles = rawfiles(raw_o);

unmatched = false(size(rawfiles));
problem = false(size(rawfiles));
for f = 1:length(rawfiles)
    trial = load([D rawfiles(f).name]);
    if isfield(trial,'exposure') 
        if ~isfield(trial,'imageFile') || isempty(trial.imageFile)
            fprintf(notesFileID,'\tTrial %d has exposures but no avi\n',...
                trial.params.trial);
            fprintf('\tTrial %d has exposures but no avi\n',...
                trial.params.trial);
            unmatched(f) = true;
        elseif exist(regexprep(trial.imageFile,'Acquisition','Raw_Data'),'file')~=2
            fprintf('\tTrial %d has exposures but linked avi doesn''t exist - %s\n\t\tSaving file with empty imageFile link\n',...
                trial.params.trial,trial.imageFile);
            fprintf(notesFileID,'\tTrial %d has exposures but linked avi doesn''t exist - %s\n\t\tSaving file with empty imageFile link\n',...
                trial.params.trial,trial.imageFile);
            trial.imageFile = '';
            trial.imageMatch = 'missing avi';
            save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
            problem(f) = true;
        end
    end
end

fprintf('\nUnmatched Raw files AVIs\n*********\n');
fprintf(notesFileID,'\nUnmatched Raw files AVIs\n*********\n');


savedirmat = ls(D)';
savedirconts = savedirmat(:)';

% Find all the matched avis, their trial nums, and their size
pattern = [protocol,'_Image_(\d+)_' datestr(trial.timestamp,29) '-(\d+)-\d+.avi'];
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

weird_mavis = abs(mavisize-median([umavisize mavisize]))/std([umavisize mavisize]) > 2;

figure(101);clf; 
plot(rawtimestamp,rawtrialnum,'.')
hold on
plot(mavitimestamp,mavitrialnum,'.')
plot(rawtimestamp(unmatched),rawtrialnum(unmatched),'s')
plot(rawtimestamp(problem),rawtrialnum(problem),'o')
plot(mavitimestamp(weird_mavis),mavitrialnum(weird_mavis),'d')
% plot([umavitimestamp;umavitimestamp],repmat([1; 60],size(umavitrialnum)),'g')


%%
fclose(notesFileID);


%%
% start at the end,
% if the end is not a trial, throw an error and kill the project
% else
% look for a

% go through the unmatched avi files.
% is there a matched avi at a similar time?

% for rr = 1:length(rawtimestamp)
%     if rr==1
%         if rawtimestamp(rr)<=mavitimestamp(mavitrialnum==rawtimestamp(rr))
%             error('First avi is out of order!');
%         else
%             fprintf('\tTrial %d was skipped\n',...
%                 rawtrialnum(ii)+jj)
%         end
%     else
%         if rawtimestamp(rr)<=mavitimestamp(mavitrialnum==rawtimestamp(rr))
%             error('First avi is out of order!');
%         end
%         
%         
%         
%         %     skippedtrials = diff(mavitrialnum)-1;
%         %
%         %     fprintf('Filename: %s\n',...
%         %                     matchedavifiles{1})
%         %     for ii = 1:length(skippedtrials)
%         %
%         %         if skippedtrials(ii)>0;
%         %             for jj = 1:skippedtrials(ii)
%         %                 fprintf('\tTrial %d was skipped\n',...
%         %                     mavitrialnum(ii)+jj)
%         %             end
%         %         elseif skippedtrials(ii)<0
%         %             fprintf('\tMAJOR PROBLEM\n',...
%         %                 mavitrialnum(ii))
%         %
%         %         end
%         %     end
%         
%         
%         
%         tifn = regexprep(trial.imageFile,'Acquisition','Raw_Data');
%         
%         ind = find(mavitrialnum==trial.params.trial);
%         fprintf('\tTrial %d at %s is matched with avi at time %s\n',...
%             trial.params.trial,datestr(trial.timestamp,13), datestr(mavitimestamp(ind),13));
%         
%         d = dir(regexprep(trial.imageFile,'Acquisition','Raw_Data'));
%         if d.bytes<1000
%             fprintf('Avi is tiny: %s\n',regexprep(tifn,regexprep(D,'\\','\\\'),''));
%             if
%             end
%             
%             if mavitimestamp(ind)>trial.timestamp
%                 fprintf('Avi %d is later than trial %d\n',...
%                     datestr(mavitrialnum(ind),13),...
%                     trial.params.trial);
%             end
%             
%             if any(mavitimestamp>mavitimestamp(ind)&mavitimestamp<trial.timestamp)
%                 badind = find(mavitimestamp>mavitimestamp(ind)&mavitimestamp<trial.timestamp,1,'last');
%                 fprintf('Avi at %s is between matched avi and trial %s\n',...
%                     datestr(mavitimestamp(badind),13));
%             end
%         elseif isfield(trial,'exposure') && (~isfield(trial,'imageFile') || exist(regexprep(trial.imageFile,'Acquisition','Raw_Data'),'file')~=2)
%             % add an exposure time vector to the trial, and adjust images
%             % and exposure vector to include only times associated
%             % with images
%             
%             % first, delete any videos with no data
%             d = dir(fullfile(D,[trial.params.protocol,'_Image_' datestr(trial.timestamp,29) '*.avi']));
%             for ii = 1:length(d)
%                 if d(ii).bytes<1000
%                     delete(fullfile(D,d(ii).name));
%                 end
%             end
%             
%             % then look for avifiles and they
%             pattern = [trial.params.protocol,'_Image_' datestr(trial.timestamp,29) '-(\d+)-\d+.avi'];
%             
%             savedirmat = ls(D)';
%             savedirconts = savedirmat(:)';
%             avifiles = regexp(savedirconts,pattern,'match');
%             
%             avitimestamp = zeros(size(avifiles));
%             for im = 1:length(avifiles)
%                 timestr = regexp(avifiles{im},pattern,'tokens');
%                 avitimestamp(im) = datenum([datestr(trial.timestamp,'yyyymmdd') 'T' timestr{1}{1}],'yyyymmddTHHMMSS');
%             end
%             % get the closest movie
%             curravi = find(avitimestamp<trial.timestamp,1,'last');
%             
%             % if there is no movie occuring before the trial (why?)
%             if isempty(curravi)
%                 fprintf('\t%s trial %d has no video files before the trial\n',trial.params.protocol,trial.params.trial)
%                 trial.imageFile = '';
%                 trial.imageMatch = 'post-hoc match, unable to find trial';
%                 save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
%                 continue
%             end
%             dur = trial.params.durSweep;
%             
%             % if the movie and the trial are just too far apart
%             if abs(avitimestamp(curravi)-trial.timestamp)>datenum(0,0,0,0,0,6*dur)
%                 fprintf('\t%s trial %d matched with video outside reasonable time frame, (%d sec)\n',trial.params.protocol,trial.params.trial,6*dur)
%                 trial.imageFile = '';
%                 trial.imageMatch = 'post-hoc match, unable to find trial close enough';
%                 save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
%                 continue
%             end
%             oldname = avifiles{curravi};
%             ext = regexp(oldname,'-(\d+)-\d+.avi','match');
%             newname = [trial.params.protocol '_Image_' num2str(trial.params.trial) '_' datestr(trial.timestamp,29) ext{1}];
%             newname = fullfile(D,newname);
%             
%             movefile(fullfile(D,oldname),newname);
%             
%             trial.imageFile = newname;
%             trial.imageMatch = 'post-hoc match, probably stopped trial before done saving';
%             save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');
%             fprintf('\tConnecting trial %d (time %s) with image %s (time %s)\n',...
%                 trial.params.trial,...
%                 datestr(trial.timestamp),...
%                 ext{1},...
%                 datestr(avitimestamp(curravi)));
%             
%         end
%     end
%     for f = 1:length(rawfiles)
%         data(f).tags = tags(f).tags;
%     end
%     [~,order] = sort(trialnums);
%     data = data(order);
%     dfns{p} = regexprep(dfn,curprotocol,protocols{p});
%     save(dfns{p},'data');
%     fprintf('\t%s\n',protocols{p});
% end
% fprintf('Done creating and renaming raw files: %s',D)
% toc
% varargout = {dfn,dfns};