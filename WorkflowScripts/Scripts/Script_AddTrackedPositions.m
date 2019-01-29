%% Script_CorrectAndAddTrackedPostitions
DEBUG_PLOT = 0;
REMOVE_ANALYSIS = 1;
RESET_POSITIONS = 1;

[~,~,~,~,~,D,trialStem] = extractRawIdentifiers(trial.name);
cd(D);

if ~exist(fullfile(D,'csv'),'dir')
    mkdir(fullfile(D,'csv'))
end

DOUBLE_CHECK_LABELING = 1;
cnt = 0;

br = waitbar(0,'Batch');
br.Position =  [1050    251    270    56];

for tr_idx = trialnumlist
    cnt = cnt+1;
    trial = load(sprintf(trialStem,tr_idx));
    waitbar((tr_idx-trialnumlist(1))/length(trialnumlist),br,regexprep(trial.name,{regexprep(D,'\\','\\\'),'_'},{'','\\_'}));
    
    % Skip it if there is already a field
    if isfield(trial ,'legPositions') && ~RESET_POSITIONS
        fprintf('%d: Positions already extracted from csv;\n',trial.params.trial)
        
        if REMOVE_ANALYSIS 
            fprintf('\tRemovingOldAnalyses\n')
            trial = removeAnalysis(trial);
            save(trial.name, '-struct', 'trial')

        end

        
    elseif ~isfield(trial,'legPositions') || RESET_POSITIONS
        
        % look for the image 1 .csv file, add the raw data to the trial
        % file, then move the file
        csvname = dir(regexprep(trial.imageFile,'.avi','DeepCut_*_FemurTibiaJoint*.csv'));
        try trial.legPositions.filename = csvname.name;
        catch e
            if strcmp(e.identifier,'MATLAB:needMoreRhsOutputs')
                csvname = dir(fullfile('csv',regexprep(trial.imageFile,'.avi','DeepCut_*_FemurTibiaJoint*.csv')));
                trial.legPositions.filename = fullfile('csv',csvname.name);
            end
        end

        h5name = dir(regexprep(trial.imageFile,'.avi','DeepCut_*_FemurTibiaJoint*.h5'));
        if ~isempty(h5name)
            movefile(fullfile(D,h5name.name),fullfile(D,'csv'))
            picklename = dir(regexprep(trial.imageFile,'.avi','DeepCut_*_FemurTibiaJoint*.pickle'));
            movefile(fullfile(D,picklename.name),fullfile(D,'csv'))
        end
        opts = detectImportOptions(trial.legPositions.filename);
        T = readtable(trial.legPositions.filename);
        bodyparts = T{1,:};
        coordvals = T{2,:};
        bdprtcrds = bodyparts;
        
        for s_idx = 1:length(bodyparts)
            bdprtcrds{s_idx} = [bodyparts{s_idx} '_' coordvals{s_idx}];
        end
        T_0 = preview(trial.legPositions.filename,opts);
        T2 = readtable(trial.legPositions.filename,opts);
        
        T2.Properties.VariableNames = bdprtcrds;
        
        % strip down the table to Femur and Tibia XY points (and index)
        trial.legPositions.Positions = T2(:,[1 find(contains(bdprtcrds,{'Femur','Tibia'}) & contains(bdprtcrds,{'_x','_y'}))]) ;
        bodyparts = bodyparts(contains(bdprtcrds,{'Femur','Tibia'}) & contains(bdprtcrds,{'_x','_y'}));
        bodyparts = unique(bodyparts(2:end));
        
        imgidx = 1;
        if DEBUG_PLOT || DOUBLE_CHECK_LABELING
            %% Proofread csv file to make sure positions are correct.
            vid = VideoReader(trial.imageFile);
            I = vid.readFrame;
            I = double(squeeze(I(:,:,1)));
            
            displayf = figure;
            displayf.Position = [120 10 fliplr(size(I))]+[0 0 0 10];
            displayf.Tag = 'big_fig';
            displayf.MenuBar = 'none';
            displayf.ToolBar = 'none';
            
            dispax = axes('parent',displayf,'units','pixels','position',[0 0 fliplr(size(I))]);
            dispax.Box = 'off';
            dispax.XTick = [];
            dispax.YTick = [];
            dispax.Tag = 'dispax';
            colormap(dispax,'gray')
            
            clear pnt
            
            im = imshow(I,[0 1.6*quantile(I(:),0.975)],'parent',dispax);
            % ask to label each point static point in turn
            txt = text(dispax,size(I,2)/3,20,'TXT');
            txt.Position = [20 10 0]*size(I,2)/640;
            txt.VerticalAlignment = 'top';
            txt.Color = [1 1 1];
            txt.FontSize = 18;
            txt.FontName = 'Ariel';
            
            % put each body part on the image
            clrs = distinguishable_colors(length(bodyparts));
            
            try delete(pnt); catch e, end
            for bdidx = 1:length(bodyparts)
                T_X = trial.legPositions.Positions.([bodyparts{bdidx} '_x']);
                T_Y = trial.legPositions.Positions.([bodyparts{bdidx} '_y']);
                xy = [T_X(imgidx,1) T_Y(imgidx,1)];
                pnt(bdidx) = impoint(dispax,xy);
                pnt(bdidx).setColor(clrs(bdidx,:));
                pnt(bdidx).setString(bodyparts{bdidx});
            end
            
            button = questdlg('Are points correctly labeled?','Correct Labels?','Yes');
            %uiwait();
            switch button
                case 'No'
                    error('Ahhhhh! Where did I go wrong on this one?');
                    
                case 'Cancel'
                    return
                case 'Yes'
                    fprintf('Continuing, saving positions')
                    DOUBLE_CHECK_LABELING = 0;
            end
        end

        % save file (adds another 98 KB to file, not bad)
        save(trial.name, '-struct', 'trial')
        if ~startsWith(trial.legPositions.filename,'csv')
            movefile(fullfile(D,trial.legPositions.filename),fullfile(D,'csv'))
        end
        
        fprintf('%s: %d of %d body part coords\n',sprintf(trialStem,trial.params.trial),width(trial.legPositions.Positions),width(T2));
    end
    
end

delete(br)

%%

function trial = removeAnalysis(trial)

legPositions.filename = trial.legPositions.filename;
legPositions.Positions = trial.legPositions.Positions;
legPositions.PositionsChanged = trial.legPositions.PositionsChanged;
if sum(any(isnan(legPositions.Positions{:,:}),2))
    fprintf('Trial %d has %d weird frames\n',trial.params.trial,sum(any(isnan(legPositions.Positions{:,:}),2)));
end
trial.legPositions = legPositions;

end
