function h = avi_clusterIntensity(h,varargin)
[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,dataFile] = extractRawIdentifiers(h.name);
figpath = [D 'figs']; 
if ~exist(figpath,'dir')
    mkdir(figpath)
end
set(0, 'DefaultAxesFontName', 'Arial');

% make movie and pdf of each data file
if ~isfield(h,'clmask')
    error('You need to run avi_kmeans first, or batch process')
end
checkdir = dir(fullfile(D,[protocol,'_Image_' num2str(h.params.trial) '_' datestr(h.timestamp,29) '*.avi']));

if ~length(checkdir)
    moviename = [regexprep(h.name, {'Acquisition','_Raw_'},{'Raw_Data','_Images_'}) '.avi'];
    foldername = regexprep(moviename, '.mat.avi','\');
    moviename = dir([foldername protocol '_Image_*']);
    moviename = [foldername moviename(1).name];
    fprintf(1,'Looking for a folder named %s\n',foldername);
else
    moviename = checkdir(1).name;
end
filename = [protocol '_Raw_' dateID '_' flynum '_' cellnum '_' trialnum '.mat'];

t = makeInTime(h.params);

t_win = [t(1) t(end)];
t_idx_win = [find(t>=t_win(1),1) find(t<=t_win(end),1,'last')];

% import movie
vid = VideoReader(moviename);
N = vid.Duration*vid.FrameRate;

vid = VideoReader(moviename);

kk = 0;

clusters = unique(h.clmask);
clusters = clusters(clusters~=0);
I_traces = nan(N,length(clusters));

br = waitbar(0,regexprep(sprintf(trialStem,h.params.trial),'_','\\_'));
br.Name = 'Frames';
while hasFrame(vid)
    kk = kk+1;
    waitbar(kk/N,br);
    mov3 = readFrame(vid);
    mov = mov3(:,:,1);
    for cl = 1:length(clusters)
        I_masked = mov;
        I_masked(h.clmask~=cl)=nan;
        I_trace = squeeze(nanmean(nanmean(I_masked,2),1));
        I_traces(kk,cl) = I_trace;
    end
end
close(br)

%% Save stuff in the trial

% It will be interesting to measure leg angles several times to measure
% variability in my detection

h.clustertraces = I_traces;
% h.legposition = legposition;
trial = h;
save(regexprep(trial.name,'Acquisition','Raw_Data'), '-struct', 'trial');

fprintf(1,'Saving %d avi cluster traces for %s %s trial %s\n', ...
    size(I_traces,2),...
    [dateID '_' flynum '_' cellnum], protocol,trialnum);


handles.trial = h;
handles.prtclData = load(dataFile);
handles.prtclData = handles.prtclData.data;
epiFlashFig = EpiFlash2TAviRoi([],handles,'');



