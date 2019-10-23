function [y_or_no,imdir] = imageFileExist(trial)
% Look in one of two locations for the imageFile for a trial

imdir = [];
if ~isfield(trial,'imageFile') || isempty(trial.imageFile) 
    y_or_no = 0;
    return
end
D = trial.name(1:regexp(trial.name,trial.params.protocol)-1);
y_or_no = exist(fullfile(D,trial.imageFile),'file');

if ~y_or_no
    imname_ = trial.imageFile(regexp(trial.imageFile,trial.params.protocol):end);%,{'E:','tony\\Raw_Data_E'});
    y_or_no = exist(fullfile(D,imname_),'file');
    if y_or_no
        trial.imageFile = imname_;
        save(trial.name, '-struct', 'trial');
        fprintf(1,' * ImageFile field is now %s\n',fullfile(D,trial.imageFile))
    end
    fprintf(1,'Image file is at %s\n',fullfile(D,trial.imageFile))
end

if ~y_or_no
    D = regexprep(D,{'B:','Raw_Data'},{'E:','tony\\Raw_Data_E'});
    y_or_no = exist(fullfile(D,trial.imageFile),'file');
    fprintf(1,'Image File is at %s\n',fullfile(D,trial.imageFile))
end
if y_or_no
    imdir = fullfile(D,trial.imageFile);
else
    warning('No Image at %s\n',trial.imageFile)
    fprintf('No Image at %s\n',trial.imageFile)
end
