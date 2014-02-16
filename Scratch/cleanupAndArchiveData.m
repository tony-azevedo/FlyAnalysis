function status = cleanupAndArchiveData(data)

exmp_date = data(1).date;
curr_path = pwd;

%% error checking
if isempty(strfind(curr_path,exmp_date))
    error('Incorrect file path for the current data structure: %s',exmp_date)
end
if isempty(dir('data*'))
    error('Check the file path for the current data structure: %s',exmp_date)
end
if isempty(dir('archive*'))
    error('No current data_archive, what''s going on?: %s',exmp_date)
end

trial_vec_from_datastruct = nan(length(data),1);
cellnumber_vec_from_datastruct = nan(length(data),1);
flynumber_vec_from_datastruct = nan(length(data),1);


for t = 1:length(trial_vec_from_datastruct)
    trial_vec_from_datastruct(t) = data(t).trial;
    cellnumber_vec_from_datastruct(t) = data(t).cellnumber;
    flynumber_vec_from_datastruct(t) = data(t).flynumber;
end

%% get the file names, trial numbers, cell numbers, etc
a = dir('Raw*');
fnames = cell(length(a),1);
trial_vec_from_filename = zeros(length(a),1);
flynumber_vec_from_filename = zeros(length(a),1);
cellnumber_vec_from_filename = zeros(length(a),1);

for n = 1:length(a)
    fname = a(n).name;
    fnames{n} = fname;
    inds_ = regexp(fnames{n}, '_');
    trial_vec_from_filename(n) = str2double(fname(inds_(end)+1:end-4));
    cellnumber_vec_from_filename(n) = str2double(fname(inds_(end-1)+2:inds_(end)-1));
    flynumber_vec_from_filename(n) = str2double(fname(inds_(end-2)+2:inds_(end-1)-1));
end

[trial_vec_from_filename,order] = sort(trial_vec_from_filename);
fnames = fnames(order);
cellnumber_vec_from_filename = cellnumber_vec_from_filename(order);
flynumber_vec_from_filename = flynumber_vec_from_filename(order);


%% if the vectors are all the same length, check to make sure the numbers match
if length(trial_vec_from_datastruct) == length(trial_vec_from_filename)
    if isempty(setxor(trial_vec_from_datastruct,trial_vec_from_filename))
        if length(cellnumber_vec_from_filename) == length(cellnumber_vec_from_datastruct) &&...
                isempty(setxor(cellnumber_vec_from_filename,cellnumber_vec_from_datastruct)) &&...
                length(flynumber_vec_from_filename) == length(flynumber_vec_from_datastruct) &&...
                isempty(setxor(flynumber_vec_from_filename,flynumber_vec_from_datastruct))
            disp('Data structure matches waveform files present');
        else
            error('Trials match but fly numbers or cell numbers don''t!!')
        end
    else
        missing = setxor(trial_vec_from_datastruct,trial_vec_from_filename);
        missing = sprintf('%g,',missing(:));
        if isempty(intersect(trial_vec_from_filename,setxor(trial_vec_from_datastruct,trial_vec_from_filename)))
            error('Same number of trials, but Data structure has trial for which file is missing: [%s]',missing(1:end-1))
        elseif isempty(intersect(trial_vec_from_datastruct,setxor(trial_vec_from_datastruct,trial_vec_from_filename)))
            error('Same number of trials, but files exist for which Data structure has no trial: [%s]',missing(1:end-1))
        else
            % TODO: fix this, actually do something!
            missing_filename = intersect(trial_vec_from_filename,setxor(trial_vec_from_datastruct,trial_vec_from_filename));
            missing_datastruct = intersect(trial_vec_from_filename,setxor(trial_vec_from_datastruct,trial_vec_from_filename));
            restorefiles(data,fnames,missing_datastruct,missing_filename)
            error('Same number of trials, but trials don''t match (interesting case): [%s]',missing(1:end-1))
        end
    end
else
    % interesting case
    % find the trials that are missing
    missing = setxor(trial_vec_from_datastruct,trial_vec_from_filename);
    missing_filename = intersect(trial_vec_from_filename,setxor(trial_vec_from_datastruct,trial_vec_from_filename));
    missing_datastruct = intersect(trial_vec_from_filename,setxor(trial_vec_from_datastruct,trial_vec_from_filename));
    restorefiles(data,fnames,missing_datastruct,missing_filename)
    error('Trials don''t match (interesting case): [%s]',missing(1:end-1))
end

status = [];

function restorefiles(data,fnames,missing_datastruct,missing_filename)
disp('Fix the function cleanupAndArchiveData and')
mfilename
return
% use a dialog
if ~isempty(missing_filename)
    
end
