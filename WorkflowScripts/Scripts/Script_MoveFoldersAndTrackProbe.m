%% Go through the F:\Directories, move folders with small movies

cd F:\Acquisition\
error('cd to new folder');
% cd 200101
% %% How to know they are small?
% 
% movies = dir('*.avi');
% m_size = nan(length(movies),1);
% m_dur = m_size;
% for m = 1:length(movies)
%     vid = VideoReader(movies(m).name);
%     m_dur(m) = vid.Duration;
%     m_size(m) = movies(m).bytes;
% end
% %%
% figure
% plot(m_size,m_dur)
% mb = polyfit(m_dur,m_size,1);
% 
%%
Dir = pwd()
[datedir,celldir] = fileparts(Dir);

%% Choose the first movie. Has it been shrunk?
movies = dir('*.avi');
vid = VideoReader(movies(1).name);
size2dur = 3E7; % an over estimate

if movies(1).bytes > size2dur*vid.Duration 
    delete(vid);
%     error('Need to run compression code') 
    % Or edit the python file and run it.
    [fid,mes] = fopen('C:\Users\tony\Code\PythonUtils\CompressAvisToh264.py','r');
    i = 1;
    tline = fgetl(fid);
    while ischar(tline)
        if contains(tline,'r''F:/Acquisition/191204/191204_F3_C1')
            tline = regexprep(tline,'F:/Acquisition/191204/191204_F3_C1',regexprep(Dir,'\\','/'));
        end
        A{i} = tline;
        tline = fgetl(fid);
        i = i+1;
    end
    A{i} = tline;
    fclose(fid);

    
    [fid,mes] = fopen('C:\Users\tony\Code\PythonUtils\CompressAvisToh264_ML.py','w');
    for i = 1:numel(A)
        if A{i+1} == -1
            fprintf(fid,'%s', A{i});
            break
        else
            fprintf(fid,'%s\n', A{i});
        end
    end
    fclose(fid)
    
%     system('C:\Users\tony\Anaconda3\python C:\Users\tony\Code\PythonUtils\CompressAvisToh264_ML.py')
end

%% Move the folder
cd ..
newdir = regexprep(Dir,'F:\\Acquisition','E:\\Data');

copyfile(Dir,newdir)

%% Move to the folder
% analysisdir = pwd;
analysisdir = newdir;
cd(analysisdir);

movies = dir('*.avi');
m = movies(1).name;

trnm = regexprep(m,{'Image','_\d+T\d+.avi'},{'Raw','.mat'});
trial = load(trnm);

if ~contains(trial.name,analysisdir)
    
    rawfiles = dir(fullfile(analysisdir,'*_Raw*.mat'));
    fprintf('Changing trialnames for %d trials in %s\n',length(rawfiles),analysisdir);
    for f = 1:length(rawfiles)
        trial = load(fullfile(analysisdir,rawfiles(f).name));
        trial.name = fullfile(analysisdir,rawfiles(f).name);
        % trial = setRawFilePath(trial);
        save(trial.name,'-struct','trial');
        
        if mod(f,20)==0
            fprintf('%d: Saving %s\n',f,trial.name);
        end
    end
    
end

%% Run the probe tracking
Script_TrackForceProbe


