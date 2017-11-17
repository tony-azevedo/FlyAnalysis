% Do stuff with the trial image or decimated data

[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);

D_shortened = [D 'compressed' filesep];

displayf = figure;
displayf.Position = [40 10 1280 1024];
dispax = axes('parent',displayf,'units','pixels','position',[0 0 1280 1024]);
dispax.Box = 'off';
dispax.XTick = [];
dispax.YTick = [];
dispax.Tag = 'dispax';

colormap(dispax,'gray')

for tr_idx = trialnumlist

    trial = load(sprintf(trialStem,tr_idx));
    
    moviename = trial.imageFile;    
            
    downsampledDataPath = regexprep(trial.name,regexprep(D,'\\','\\\'),regexprep(D_shortened,'\\','\\\'));
    smooshedImagePath = regexprep(trial.name,{'_Raw_','.mat'},{'_smooshed_', '.png'});
    if exist(smooshedImagePath,'file')
        fprintf('\t ** %s already created!\n',smooshedImagePath)
        continue

    end
        
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
        smooshedImagePath = regexprep(trial.name,{'_Raw_','.mat'},{'_smooshed_', '.mat'});
        save(smooshedImagePath,'smooshedframe');

        smooshedframe = smooshedframe-min(smooshedframe(:));
        smooshedframe = smooshedframe/max(smooshedframe(:));        
        im = imshow(smooshedframe,[0 2*quantile(smooshedframe(:),0.975)],'parent',dispax); drawnow
        smooshedImagePath = regexprep(trial.name,{'_Raw_','.mat'},{'_smooshed_', '.png'});
        imwrite(smooshedframe,smooshedImagePath,'png')

    end
end
