% Do stuff with the trial image or decimated data

rawfiles = dir([protocol '_Raw_*']);

h = load(rawfiles(1).name);

[protocol,dateID,flynum,cellnum,trialnum,D,trialStem,datastructfile] = extractRawIdentifiers(h.name);
data = load(datastructfile); data = data.data;

D_shortened = [D 'compressed' filesep];

displayf = figure;
set(displayf,'position',[40 10 1280 1024]);
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
set(dispax,'box','off','xtick',[],'ytick',[],'tag','dispax');
colormap(dispax,'gray')

for tr_idx = 1:length(data)

    h = load(sprintf(trialStem,data(tr_idx).trial));
    
    % look for movie file
    checkdir = dir(fullfile(D,[protocol,'_Image_' num2str(h.params.trial) '_' datestr(h.timestamp,29) '*.avi']));   
    moviename = checkdir(1).name;
    
    filename = [protocol '_Raw_' dateID '_' flynum '_' cellnum '_' trialnum '.mat'];
            
    downsampledDataPath = regexprep(h.name,regexprep(D,'\\','\\\'),regexprep(D_shortened,'\\','\\\'));
    if ~exist(downsampledDataPath ,'file')
        tic
        fprintf('\t ** %s already deleted!\n',downsampledDataPath)
        continue
        toc
    else
        trial = load(downsampledDataPath); % ~1 sec
        if isfield(trial,'trial')
            trial = trial.trial;
        end
        
        smooshedframe = mean(trial.downsampledImage,3);
        smooshedframe(1,1:4) = mean(smooshedframe(:));
        smooshedImagePath = regexprep(h.name,{'_Raw_','.mat'},{'_smooshed_', '.mat'});
        save(smooshedImagePath,'smooshedframe');

        smooshedframe = smooshedframe-min(smooshedframe(:));
        smooshedframe = smooshedframe/max(smooshedframe(:));        
        im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax); drawnow
        smooshedImagePath = regexprep(h.name,{'_Raw_','.mat'},{'_smooshed_', '.png'});
        imwrite(smooshedframe,smooshedImagePath,'png')

    end
end
