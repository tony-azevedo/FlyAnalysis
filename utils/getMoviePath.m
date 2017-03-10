function [moviename,rawname] = getMoviePath(rawpath,varargin)

p = inputParser;
p.PartialMatching = 0;
p.addParameter('dir','',@ischar);
p.addParameter('filename','',@ischar);
p.addParameter('path','',@ischar);

parse(p,varargin{:});

[protocol,dateID,flynum,cellnum,trialnum,D] = extractRawIdentifiers(rawpath);
moviename = [regexprep(rawpath, {'Acquisition','_Raw_'},{'Raw_Data','_Images_'}) '.avi'];
checkdir = dir(moviename);
if ~length(checkdir)
    foldername = regexprep(moviename, '.mat.avi','\');
    moviename = dir([foldername protocol '_Image_*']);
    moviename = [foldername moviename(1).name];
    fprintf(1,'Looking for a folder named %s\n',foldername);
end
rawname = [protocol '_Raw_' dateID '_' flynum '_' cellnum '_' trialnum '.mat'];
