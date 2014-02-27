% All Cells recorded in VT30609/ArcLight line
'131203_F1_C1';
'131203_F1_C2';
'131203_F2_C1';

'131211_F1_C1'; % Rogue Cell (al PN)
'131211_F1_C2'; % 
'131211_F2_C1'; % First cell that looked good, not great calibration

'131212_F1_C1';  % Not Green

'131217_F1_C1';  
'131217_F2_C1';
'131217_F2_C2';

'140114_F1_C1';
'140114_F2_C1';

'140115_F1_C1';
'140115_F1_C2';
'140115_F2_C1';

'140117_F2_C1';

'140121_F1_C1';
'140121_F2_C1';

'140122_F1_C1';
'140122_F2_C1';
'140122_F2_C2';

% MakeOutTime change

'140128_F1_C1';

'140131_F1_C1';
'140131_F3_C1';

% New Internal

'140205_F1_C1';

'140206_F1_C1';
'140206_F3_C1';

'140207_F1_C2';

%% Rejected cells
% Cells were rejected if: 
% # the cell was clearly not a B1 cell (al PN or confirmed not green)
% # images were lost because of bugs in the code
% # patching failed
% # fluorescence changes in response to voltage steps were not imaged
% # the cell was not isolated from the surrounding cells

cnt = 0;

cnt = cnt+1;
reject_cells(cnt).name = '131203_F1_C1';
reject_cells(cnt).reason = 'No images, lost cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F1_C1\Sweep_131217_F1_C1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '131203_F1_C2';
reject_cells(cnt).reason = 'No Images! Not imaging break in';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131203_F2_C1';
reject_cells(cnt).reason = 'Not imaging break-in, no responses';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131211_F1_C1';
reject_cells(cnt).reason = 'Rogue Cell (al PN)';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131211_F1_C2';
reject_cells(cnt).reason = 'No voltage clamp steps (no calibration). Cell Moved during CurrentPlateau';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\CurrentPlateau_Raw_131211_F1_C2_2.mat';
reject_cells(cnt).evidencecalls = 'fluorescence(trial,trial.params)';

cnt = cnt+1;
reject_cells(cnt).name = '131212_F1_C1';
reject_cells(cnt).reason = 'Not a green cell';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '131217_F1_C2';
reject_cells(cnt).reason = 'Single bad sweep';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F2_C1\Sweep_Raw_131217_F2_C1_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '131217_F2_C2';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F2_C2\Sweep_Raw_131217_F2_C2_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140114_F1_C1';
reject_cells(cnt).reason = 'Break in in I=0 Mode, and blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140114\140114_F1_C1\Sweep_Raw_140114_F1_C1_4.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140114_F2_C1';
reject_cells(cnt).reason = 'Wrong Cell, image not zoomed in';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140114\140114_F2_C1\Sweep_Raw_140114_F2_C1_1.mat';


cnt = cnt+1;
reject_cells(cnt).name = '140115_F1_C1';
reject_cells(cnt).reason = 'Current Clamp Breakin, but only went to 5mV from 10, not inside cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140115\140115_F1_C1\Sweep_Raw_140115_F1_C1_2.mat';


cnt = cnt+1;
reject_cells(cnt).name = '140115_F1_C2';
reject_cells(cnt).reason = 'Couldn''t break in, weird voltage values';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140115\140115_F1_C2\Sweep_Raw_140115_F1_C2_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140115_F2_C1';
reject_cells(cnt).reason = 'Good Motion example! Not good access, ran out of saline, no cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140115\140115_F2_C1\CurrentPlateau_Raw_140115_F2_C1_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140121_F1_C1';
reject_cells(cnt).reason = 'Blew up the cell while patching';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F1_C1\Sweep_Raw_140121_F1_C1_2.mat';


cnt = cnt+1;
reject_cells(cnt).name = '140122_F2_C1';
reject_cells(cnt).reason = 'Moving a lot! Not a clear deliniation of the cell';
reject_cells(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\Sweep_Raw_140122_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_12.mat';...
    };
reject_cells(cnt).evidencecalls = {...
    };


cnt = cnt+1;
reject_cells(cnt).name = '140122_F2_C2';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C2\Sweep_Raw_140122_F2_C2_1.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140128_F1_C1';
reject_cells(cnt).reason = 'Cell was up against some others, not clearly isolated';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140128\140128_F1_C1\Sweep_Raw_140128_F1_C1_5.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140131_F1_C1';
reject_cells(cnt).reason = 'Blew up the cell, couldn''t patch it';
reject_cells(cnt).exampletrial = '';

cnt = cnt+1;
reject_cells(cnt).name = '140206_F2_C1';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F2_C1\Sweep_Raw_140206_F2_C1_2.mat';

cnt = cnt+1;
reject_cells(cnt).name = '140206_F3_C1';
reject_cells(cnt).reason = 'Blew up the cell';
reject_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F3_C1\Sweep_Raw_140206_F3_C1_2.mat';

for c_ind = 1:length(reject_cells)
    fprintf('Cell ID: %s\n', reject_cells(c_ind).name);
    fprintf('Comment: %s\n\n', reject_cells(c_ind).reason);
end


%% Cells to Analyze


analysis_cell(1).name = '140117_F2_C1';
analysis_cell(1).comment = {'Bright, isolated','Prepoints on Voltage Plateau too few to get good dFoverF relationship'};
analysis_cell(1).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\Sweep_Raw_140117_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
analysis_cell(1).evidencecalls = {...
    'fluorescence(trial,trial.params)';...
    'DFoverFoverDV(trial,trial.params)';...
    };

analysis_cell(2).name = '140121_F2_C1';
analysis_cell(2).comment = {'Banner Cell, sound responsive, spiking, just great!'};
analysis_cell(2).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\Sweep_Raw_140121_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
analysis_cell(2).evidencecalls = {...
    'fluorescence(trial,trial.params)';...
    'DFoverFoverDV(trial,trial.params)';...
    };

analysis_cell(3).name = '140122_F1_C1';
analysis_cell(3).comment = {'Moving, not a typical auditory Neuron, slight decrease in fluorescence?'};
analysis_cell(3).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F1_C1\Sweep_Raw_140122_F1_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F1_C1\VoltagePlateau_Raw_140122_F1_C1_3.mat';...
    };
analysis_cell(3).evidencecalls = {...
    };


analysis_cell(4).name = '140131_F3_C1';
analysis_cell(4).comment = {'Moving.  Nice bright cell, not sound responsive, otherwise classic B1'};
analysis_cell(4).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\Sweep_Raw_140131_F3_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\VoltagePlateau_Raw_140131_F3_C1_1.mat';...
    };
analysis_cell(4).evidencecalls = {...
    };


% New Internal

analysis_cell(5).name = '140205_F1_C1';
analysis_cell(5).comment = {'Not a B1 cell, some spikes, smaller DF/F / DV'};
analysis_cell(5).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140205\140205_F1_C1\Sweep_Raw_140205_F1_C1_3.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140205\140205_F1_C1\VoltagePlateau_Raw_140205_F1_C1_2.mat';...
    };
analysis_cell(5).evidencecalls = {...
    };

analysis_cell(6).name = '140206_F1_C1';
analysis_cell(6).comment = {'Movement, Not sound responsive.  Good looking cell'};
analysis_cell(6).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\VoltagePlateau_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\PiezoSine_Raw_140206_F1_C1_26.mat';...
    };
analysis_cell(6).evidencecalls = {...
    };

analysis_cell(7).name = '140207_F1_C2';
analysis_cell(7).comment = {'Moving a lot!  Should be able to fix, Not sound responsive. Cell is pressed against others'};
analysis_cell(7).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\Sweep_Raw_140207_F1_C2_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\VoltagePlateau_Raw_140207_F1_C2_5.mat';...
    };
analysis_cell(7).evidencecalls = {...
    };


fprintf('Currently analyzing %d cells.\n\n',length(analysis_cell))
for c_ind = 1:length(analysis_cell)
    fprintf('Cell %d ID: %s\n', c_ind,analysis_cell(c_ind).name);
    fprintf('Comment: %s\n\n', analysis_cell(c_ind).comment{1});
end


%% Motion minimization
% These cells are used to test the image correlation methods

moving_cell(1).name = '140131_F3_C1';
moving_cell(1).comment = {'Moving.  Nice bright cell, not sound responsive, otherwise classic B1'};
moving_cell(1).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\Sweep_Raw_140131_F3_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140131\140131_F3_C1\VoltagePlateau_Raw_140131_F3_C1_1.mat';...
    };
moving_cell(1).evidencecalls = {...
    };


moving_cell(2).name = '140206_F1_C1';
moving_cell(2).comment = {'Movement, Not sound responsive.  Good looking cell'};
moving_cell(2).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\VoltagePlateau_Raw_140206_F1_C1_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\PiezoSine_Raw_140206_F1_C1_26.mat';...
    };
moving_cell(2).evidencecalls = {...
    };


moving_cell(3).name = '140207_F1_C2';
moving_cell(3).comment = {'Cell is pressed against others. Moving a lot!  Should be able to fix, Not sound responsive.'};
moving_cell(3).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\Sweep_Raw_140207_F1_C2_1.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\Sweep_Raw_140207_F1_C2_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140207\140207_F1_C2\VoltagePlateau_Raw_140207_F1_C2_5.mat';...
    };
moving_cell(3).evidencecalls = {...
    };


for c_ind = 3:length(moving_cell)
    for t_ind = 1:length(moving_cell(c_ind).exampletrials)
        trial = load(moving_cell(c_ind).exampletrials{t_ind});
        [protocol,dateID,flynum,cellnum,trialnum,D,trialStem] = extractRawIdentifiers(trial.name);

        afterCorrectionFig = figure;
        set(afterCorrectionFig,'name',[moving_cell(c_ind).name ' - ' protocol '_' trialnum]);
        roiFluoTrace(trial,trial.params,'NewROI','Yes','dFoFfig',afterCorrectionFig,'MotionCorrection',true,'ShowMovies',true);
    end
end

% http://www.mathworks.com/matlabcentral/answers/98217
% The ability to include AVI-files in the HTML-file generated by the
% PUBLISH command is not currently available in MATLAB. To work around this
% issue, you can modify your HTML-file manually to include an AVI file
% (created using MOVIE2AVI) that shows your movie. To do this, follow these
% steps:    
% 
% 1. Create an AVI file using MOVIE2AVI. Place this file in the "html"
% subdirectory created when you used the "Publish to HTML" option. (The
% subdirectory will be in the same directory as the original MATLAB file
% that you published.)   
% 
% 2. Open the MATLAB-generated HTML-file with the MATLAB Editor/Debugger or
% another text editor. This file will be in the "html" subdirectory and
% will have the same name as the original program file, but with the
% extension ".html" instead of ".m".   
% 
% 3. Find the place where the movie command appears in the HTML. After the
% "movie(...)" text, there will be an image in the HTML which contains the
% last frame of the movie. Remove the image and /image tags and everything
% in between.   
% 
% 4. In the spot in the HTML-file where the image was, add an AVI object to
% the HTML-file using the "object" tag, as in:    
% 
%  <object data="mymovie.avi" type="video/avi">
%  Text to Display if the Browser Doesn't Support AVI files.
%  </object>
% This will include the AVI file in your HTML-file. Please note that many
% browsers do not support AVI objects, and the security options in your
% browser may also prevent the display of AVI objects.  

%%
% The subpixel registration works well to align images that have shifted in
% x and y.  However, most of the movement produced by beating of the brain
% is stretching of the cell in x and y.  This is a fundamental limitation
% on how much motion artifact can be eliminated from the \Delta F/F trace.
% Motion correction (such as it is) has been implemented in all following
% analysis.

%% No Effect of Internal pH
% We thought briefly that low pH of the initial batch of internal was
% causing the rapid decline in the the fluorescence following break-in.
% The pH of the final 4 aliquots was measured with pH paper.  Initially the
% paper indicated a pH of 6. The colors have faded.  The next batch of
% Internal was pH'd to 7.18.  However, the decline in fluorescence
% remained.

trial = load(analysis_cell(2).exampletrials{1});
roiFluoTrace(trial,trial.params,'NewROI','No','MotionCorrection',true);

trial = load(analysis_cell(6).exampletrials{1});
roiFluoTrace(trial,trial.params,'NewROI','No','MotionCorrection',true);

%% Fluorescence Changes at Break-in
% Look for a strong change in the statistics of the current trace (-7X
% std).  That is the point of break in.  Then plot the change in
% fluorescence of 4 frames before and after.

for c_ind = 1:length(analysis_cell)
    
    trial = load(analysis_cell(c_ind).exampletrials{1});
    t = makeInTime(trial);
    current = trial.current(1:length(t));
    baseline = t<.5;
    current_baseline_std = std(trial.current(baseline));
    threshold = 7;
    
    break_in = find(abs(current-current_baseline_std) > threshold*current_baseline_std);
    break_in_frame = find(abs(trial.exposure_time-break_in)==min(abs(trial.exposure_time-break_in)),1);
    
    dFrame = 5;
    frame_window = exposure_time(break_in_frame-dFrame:break_in_frame+dFrame);
    time_window = t >= exposure_time(frame_window(1)) & t<= frame_window(end);
    
    figure
    quickShow_Sweep(gcf,trial,'No Save');
        
    gcf
    subplot(3,1,1), hold on
    plot(t,ones(size(t)) * threshold*current_baseline_std,'k:');

    axs = get(gcf,'children');
    for ax = axs
        set(ax,'xlim',[time_window(1) time_window(end)]);
    end
    
    subplot(3,1,1), hold on
    plot(t,ones(size(t)) * threshold*current_baseline_std,'k:');

end

%% Current Plateau cells
cnt = 0;

cnt = cnt+1;
curInj_cells(cnt).name = '131211_F1_C2';
curInj_cells(cnt).reason = 'Current Plateau, not voltage plateau';
curInj_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\Sweep_Raw_131211_F1_C2_1.mat';

cnt = cnt+1;
curInj_cells(cnt).name = '131211_F2_C1';
curInj_cells(cnt).reason = 'Current Plateau, not voltage plateau';
curInj_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F2_C1\Sweep_Raw_131211_F2_C1_1.mat';

%% Current Clamp Break-in Cells

cnt = 0;

cnt = cnt+1;
iClampBreakin_cells(cnt).name = '131217_F1_C1';
iClampBreakin_cells(cnt).reason = 'Broke-in in Current Clamp';
iClampBreakin_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131217\131217_F1_C1\Sweep_Raw_131217_F1_C1_1.mat';



%% HTML Markup Example
% This is a table:
%
% <html>
% <table border=1><tr><td>one</td><td>two</td></tr>
% <tr><td>three</td><td>four</td></tr></table>
% </html>
%
disp('<html><table><tr><td>1</td><td>2</td></tr></table></html>')

%% Changes in Flourescence at Break-in.

cnt = 0;

cnt = cnt+1;
analyze_cells(cnt).name = '140206_F1_C1';
analyze_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\140206\140206_F1_C1\Sweep_Raw_140206_F1_C1_2.mat';

analyze_cells(cnt).name = '131211_F1_C2';
analyze_cells(cnt).exampletrial = 'C:\Users\Anthony Azevedo\Raw_Data\131211\131211_F1_C2\Sweep_Raw_131211_F1_C2_1.mat';


%%
% One thing that is wierd is that fluorescence changes in responses to
% current injection are not as large as those in response to voltage
% changes, though the changes in voltage should be enough drive some change




%%
% Analyze a cell further if it has
% * V-Clamp break in,
% * Voltage plateau

% Separate further those cells that have sound responses

cnt = cnt+1;
auditory_cell(cnt).name = '140117_F2_C1';
auditory_cell(cnt).comment = {'Bright, isolated','Prepoints on Voltage Plateau too few to get good dFoverF relationship'};
auditory_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\Sweep_Raw_140117_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
auditory_cell(cnt).evidencecalls = {...
    'fluorescence(trial,trial.params)';...
    'DFoverFoverDV(trial,trial.params)';...
    };

cnt = cnt+1;
auditory_cell(cnt).name = '140121_F2_C1';
auditory_cell(cnt).comment = {'Banner Cell, sound responsive, spiking, just great!'};
auditory_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140121\140121_F2_C1\Sweep_Raw_140121_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140117\140117_F2_C1\VoltagePlateau_Raw_140117_F2_C1_3.mat';...
    };
auditory_cell(cnt).evidencecalls = {...
    'fluorescence(trial,trial.params)';...
    'DFoverFoverDV(trial,trial.params)';...
    };

cnt = cnt+1;
auditory_cell(cnt).name = '140122_F2_C1';
auditory_cell(cnt).comment = {'Moving a lot! Sound responsive, step responsive, not a big change in fluorescence, either the decline or the breakin'};
auditory_cell(cnt).exampletrials = {...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\Sweep_Raw_140122_F2_C1_2.mat';...
    'C:\Users\Anthony Azevedo\Raw_Data\140122\140122_F2_C1\PiezoSine_Raw_140122_F2_C1_12.mat';...
    };
auditory_cell(cnt).evidencecalls = {...
    };

